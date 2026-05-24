import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:screenshot/screenshot.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quan_ly_nha_tro/core/services/export_service.dart'; // conditional import: web=dart:html, mobile=share_plus

import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class InvoiceExportPage extends StatefulWidget {
  final Invoice invoice;
  final Room room;
  final Property? property;
  final Tenant? tenant;
  final List<Service> services;
  final int electricOld;
  final int electricNew;
  final int waterOld;
  final int waterNew;

  const InvoiceExportPage({
    super.key,
    required this.invoice,
    required this.room,
    required this.property,
    required this.tenant,
    required this.services,
    required this.electricOld,
    required this.electricNew,
    required this.waterOld,
    required this.waterNew,
  });

  @override
  State<InvoiceExportPage> createState() => _InvoiceExportPageState();
}

class _InvoiceExportPageState extends State<InvoiceExportPage> {
  final _screenshotController = ScreenshotController();
  bool _isExporting = false;

  double get _electricPrice => widget.property?.electricityPrice ?? 3500;
  double get _waterPrice => widget.property?.waterPrice ?? 15000;
  double get _electricCost =>
      (widget.electricNew - widget.electricOld).clamp(0, 99999) *
      _electricPrice;
  double get _waterCost =>
      (widget.waterNew - widget.waterOld).clamp(0, 99999) * _waterPrice;
  double get _rentPrice => widget.room.rentPrice;
  double get _servicesCost =>
      widget.services.fold(0.0, (sum, s) => sum + s.price);
  double get _total => _electricCost + _waterCost + _rentPrice + _servicesCost;

  Future<void> _downloadAsImage() async {
    setState(() => _isExporting = true);
    try {
      final Uint8List? bytes = await _screenshotController.capture(
        pixelRatio: 2.5,
      );
      if (bytes == null) return;

      final fileName =
          'hoa_don_${widget.room.name}_${widget.invoice.month.replaceAll('/', '-')}.png';
      final shareText =
          'Hóa đơn tiền phòng ${widget.room.name} - Tháng ${widget.invoice.month}';

      if (kIsWeb) {
        await downloadBytes(bytes, fileName, 'image/png');
      } else {
        await shareBytes(bytes, fileName, 'image/png', shareText);
      }

      if (mounted) {
        final msg =
            kIsWeb
                ? 'Đã tải xuống hóa đơn dạng ảnh!'
                : 'Đã mở danh sách chia sẻ!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportAsPdf() async {
    setState(() => _isExporting = true);
    try {
      final pdf = pw.Document();
      final fontData = await PdfGoogleFonts.notoSansRegular();
      final fontBold = await PdfGoogleFonts.notoSansBold();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#0066FF'),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'HÓA ĐƠN TIỀN PHÒNG',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 18,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Tháng ${widget.invoice.month}',
                            style: pw.TextStyle(
                              font: fontData,
                              fontSize: 13,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        _fmt(_total),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 22,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Room info
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _pdfInfoBox(
                        fontData,
                        fontBold,
                        'PHÒNG',
                        widget.room.name,
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: _pdfInfoBox(
                        fontData,
                        fontBold,
                        'NHÀ TRỌ',
                        widget.property?.name ?? '-',
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: _pdfInfoBox(
                        fontData,
                        fontBold,
                        'KHÁCH THUÊ',
                        widget.tenant?.name ?? '-',
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Line items
                _pdfSection(fontData, fontBold, 'CHI TIẾT HÓA ĐƠN', [
                  _pdfRow(fontData, fontBold, 'Tiền phòng', _rentPrice),
                  _pdfRow(
                    fontData,
                    fontBold,
                    'Điện (${widget.electricOld}→${widget.electricNew} kWh × ${_fmt(_electricPrice)})',
                    _electricCost,
                  ),
                  _pdfRow(
                    fontData,
                    fontBold,
                    'Nước (${widget.waterOld}→${widget.waterNew} m³ × ${_fmt(_waterPrice)})',
                    _waterCost,
                  ),
                  ...widget.services.map(
                    (s) => _pdfRow(fontData, fontBold, s.name, s.price),
                  ),
                ]),
                pw.SizedBox(height: 16),

                // Total
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EBF3FF'),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        AppStrings.invoiceTotal,
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 14,
                          color: PdfColor.fromHex('#0066FF'),
                        ),
                      ),
                      pw.Text(
                        _fmt(_total),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 20,
                          color: PdfColor.fromHex('#0066FF'),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),

                // Footer
                pw.Center(
                  child: pw.Text(
                    AppStrings.invoicePdfFooter,
                    style: pw.TextStyle(
                      font: fontData,
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final fileName =
          '${AppStrings.invoicePdfFileName}_${widget.room.name}_${widget.invoice.month.replaceAll('/', '-')}.pdf';
      final shareText =
          '${AppStrings.invoicePdfShareText} ${widget.room.name} - ${AppStrings.monthSuffix} ${widget.invoice.month}';

      if (kIsWeb) {
        await downloadBytes(bytes, fileName, 'application/pdf');
      } else {
        await shareBytes(bytes, fileName, 'application/pdf', shareText);
      }

      if (mounted) {
        final msg =
            kIsWeb
                ? AppStrings.invoiceExportPdfSuccess
                : AppStrings.invoiceExportPdfShare;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.invoiceExportPdfError}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  pw.Widget _pdfInfoBox(
    pw.Font fontData,
    pw.Font fontBold,
    String label,
    String value,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8F9FA'),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 9,
              color: PdfColors.grey,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(font: fontBold, fontSize: 13)),
        ],
      ),
    );
  }

  pw.Widget _pdfSection(
    pw.Font fontData,
    pw.Font fontBold,
    String title,
    List<pw.Widget> rows,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromHex('#E5E7EB')),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
          pw.Divider(color: PdfColor.fromHex('#E5E7EB')),
          ...rows,
        ],
      ),
    );
  }

  pw.Widget _pdfRow(
    pw.Font fontData,
    pw.Font fontBold,
    String label,
    double value,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: fontData, fontSize: 12)),
          pw.Text(
            _fmt(value),
            style: pw.TextStyle(font: fontBold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Xuất hóa đơn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _ExportButton(
                    icon: Icons.image_outlined,
                    label: kIsWeb ? 'Tải ảnh PNG' : 'Chia sẻ ảnh',
                    sublabel:
                        kIsWeb ? 'Tải về máy tính' : 'Zalo / Messenger / Gmail',
                    color: AppColors.primary,
                    onTap: _isExporting ? null : _downloadAsImage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ExportButton(
                    icon: Icons.picture_as_pdf_outlined,
                    label: kIsWeb ? 'Xuất PDF' : 'Chia sẻ PDF',
                    sublabel:
                        kIsWeb ? 'Lưu & in hóa đơn' : 'In qua ứng dụng khác',
                    color: AppColors.red,
                    onTap: _isExporting ? null : _exportAsPdf,
                  ),
                ),
              ],
            ),
          ),

          // Hint text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Xem trước hóa đơn bên dưới. Nhấn nút trên để tải xuống.',
                  style: manrope(fontSize: 12, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Invoice preview (captured by screenshot)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Screenshot(
                controller: _screenshotController,
                child: _InvoiceCard(
                  invoice: widget.invoice,
                  room: widget.room,
                  property: widget.property,
                  tenant: widget.tenant,
                  services: widget.services,
                  electricOld: widget.electricOld,
                  electricNew: widget.electricNew,
                  waterOld: widget.waterOld,
                  waterNew: widget.waterNew,
                  electricPrice: _electricPrice,
                  waterPrice: _waterPrice,
                  electricCost: _electricCost,
                  waterCost: _waterCost,
                  rentPrice: _rentPrice,
                  servicesCost: _servicesCost,
                  total: _total,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Beautiful invoice render widget ────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final Room room;
  final Property? property;
  final Tenant? tenant;
  final List<Service> services;
  final int electricOld, electricNew, waterOld, waterNew;
  final double electricPrice, waterPrice;
  final double electricCost, waterCost, rentPrice, servicesCost, total;

  const _InvoiceCard({
    required this.invoice,
    required this.room,
    required this.property,
    required this.tenant,
    required this.services,
    required this.electricOld,
    required this.electricNew,
    required this.waterOld,
    required this.waterNew,
    required this.electricPrice,
    required this.waterPrice,
    required this.electricCost,
    required this.waterCost,
    required this.rentPrice,
    required this.servicesCost,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header gradient
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HÓA ĐƠN TIỀN PHÒNG',
                          style: manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tháng ${invoice.month}',
                          style: manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        invoice.status.label,
                        style: manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _HeaderChip(Icons.meeting_room_outlined, room.name),
                    const SizedBox(width: 8),
                    if (tenant != null)
                      _HeaderChip(Icons.person_outline, tenant!.name),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property info
                if (property != null) ...[
                  _InfoRow(
                    Icons.apartment_outlined,
                    property!.name,
                    AppColors.textSecondary,
                  ),
                  if (property!.address.isNotEmpty)
                    _InfoRow(
                      Icons.location_on_outlined,
                      property!.address,
                      AppColors.textTertiary,
                    ),
                  const SizedBox(height: 16),
                ],

                // Divider
                Container(height: 1, color: AppColors.surface),
                const SizedBox(height: 16),

                // Line items
                _SectionLabel('TIỀN PHÒNG & DỊCH VỤ'),
                const SizedBox(height: 10),
                _LineItem(
                  'Tiền phòng',
                  rentPrice,
                  icon: Icons.bed_outlined,
                  highlight: true,
                ),
                if (services.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...services.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _LineItem(
                        s.name,
                        s.price,
                        icon: Icons.miscellaneous_services_outlined,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Container(height: 1, color: AppColors.surface),
                const SizedBox(height: 16),

                _SectionLabel('ĐIỆN & NƯỚC'),
                const SizedBox(height: 10),
                _LineItem(
                  'Điện ($electricOld → $electricNew kWh)',
                  electricCost,
                  subtitle:
                      '${(electricNew - electricOld).clamp(0, 99999)} kWh × ${_fmt(electricPrice)}',
                  icon: Icons.bolt,
                ),
                const SizedBox(height: 8),
                _LineItem(
                  'Nước ($waterOld → $waterNew m³)',
                  waterCost,
                  subtitle:
                      '${(waterNew - waterOld).clamp(0, 99999)} m³ × ${_fmt(waterPrice)}',
                  icon: Icons.water_drop_outlined,
                ),

                const SizedBox(height: 20),

                // Total
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TỔNG CỘNG',
                            style: manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          if (invoice.dueDate != null)
                            Text(
                              'Hạn thanh toán: ${invoice.dueDate}',
                              style: manrope(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        _fmt(total),
                        style: manrope(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Phần mềm Quản lý Nhà Trọ - Azure Clarity',
                    style: manrope(fontSize: 11, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeaderChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow(this.icon, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: manrope(fontSize: 13, color: color)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: manrope(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  final String label;
  final double value;
  final String? subtitle;
  final IconData? icon;
  final bool highlight;
  const _LineItem(
    this.label,
    this.value, {
    this.subtitle,
    this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: manrope(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: manrope(fontSize: 11, color: AppColors.textTertiary),
                ),
            ],
          ),
        ),
        Text(
          _fmt(value),
          style: manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: highlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback? onTap;
  const _ExportButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                sublabel,
                style: manrope(fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────────────
String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}${AppStrings.currencySymbol}';
}
