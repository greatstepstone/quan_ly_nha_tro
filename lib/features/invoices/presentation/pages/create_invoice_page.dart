import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/service_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/meter_reading_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/pages/invoice_export_page.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/widgets/invoice_form_widgets.dart';
class CreateInvoicePage extends ConsumerStatefulWidget {
  final String roomId;
  const CreateInvoicePage({super.key, required this.roomId});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _electricOldCtrl = TextEditingController();
  final _electricNewCtrl = TextEditingController();
  final _waterOldCtrl = TextEditingController();
  final _waterNewCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  bool _isSaving = false;

  // Loaded from DB
  Room? _room;
  Tenant? _tenant;
  Property? _property;
  List<Service> _services = [];
  Invoice? _existingInvoice;

  bool _isLoading = true;

  String get _currentMonth {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final roomRepo = ref.read(roomRepositoryProvider);
      final tenantRepo = ref.read(tenantRepositoryProvider);
      final propertyRepo = ref.read(propertyRepositoryProvider);
      final serviceRepo = ref.read(serviceRepositoryProvider);
      final meterReadingRepo = ref.read(meterReadingRepositoryProvider);
      final invoiceRepo = ref.read(invoiceRepositoryProvider);

      final room = await roomRepo.getRoomById(widget.roomId);
      if (room == null) {
        setState(() => _isLoading = false);
        return;
      }
      _room = room;

      // Load tenant if any
      if (room.tenantId != null) {
        _tenant = await tenantRepo.getTenantById(room.tenantId!);
      }

      // Load property
      _property = await propertyRepo.getPropertyById(room.propertyId);

      // Load services for this property
      _services = await serviceRepo.getServicesByProperty(room.propertyId);

      // Load latest meter reading for this room
      final readings = await meterReadingRepo.getMeterReadingsByRoom(widget.roomId);
      if (readings.isNotEmpty) {
        final reading = readings.first; // Assuming first is latest or we need a specific month
        // In the original, it was looking for a specific month or just the latest?
        // Let's try to find for the CURRENT month or latest.
        final currentMonthReading = readings.where((r) => r.month == _currentMonth).firstOrNull;
        if (currentMonthReading != null) {
          _electricOldCtrl.text = currentMonthReading.electricOld.toString();
          _electricNewCtrl.text = (currentMonthReading.electricNew ?? 0).toString();
          _waterOldCtrl.text = currentMonthReading.waterOld.toString();
          _waterNewCtrl.text = (currentMonthReading.waterNew ?? 0).toString();
        } else {
          // Fallback to latest reading's "new" as "old"
          final latest = readings.first;
          _electricOldCtrl.text = (latest.electricNew ?? latest.electricOld).toString();
          _waterOldCtrl.text = (latest.waterNew ?? latest.waterOld).toString();
        }
      }

      // Load existing invoice for this room/month (to allow update)
      final invoices = await invoiceRepo.getInvoicesByRoom(widget.roomId);
      _existingInvoice = invoices.where((i) => i.month == _currentMonth).firstOrNull;
      
      if (_existingInvoice != null) {
        // Fill data if editing
        // (Note: Invoice model doesn't store individual costs, we recalculate or we should have stored them)
      }
    } catch (e) {
      debugPrint('Error loading invoice data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _electricOld => int.tryParse(_electricOldCtrl.text) ?? 0;
  int get _electricNew => int.tryParse(_electricNewCtrl.text) ?? 0;
  int get _waterOld => int.tryParse(_waterOldCtrl.text) ?? 0;
  int get _waterNew => int.tryParse(_waterNewCtrl.text) ?? 0;

  double get _electricCost =>
      (_electricNew - _electricOld).clamp(0, 99999) *
      (_property?.electricityPrice ?? 3500);

  double get _waterCost =>
      (_waterNew - _waterOld).clamp(0, 99999) *
      (_property?.waterPrice ?? 15000);

  double get _rentPrice => _room?.rentPrice ?? 0;

  double get _servicesTotalCost =>
      _services.fold(0.0, (sum, s) => sum + s.price);

  double get _total => _electricCost + _waterCost + _rentPrice + _servicesTotalCost;

  Future<void> _saveInvoice() async {
    if (_isSaving) return;
    
    final ownerId = ref.watch(currentUserProvider)?.id;
    if (ownerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng đăng nhập lại')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final meterReadingRepo = ref.read(meterReadingRepositoryProvider);
      
      final now = DateTime.now();
      final dueDate =
          '${now.day.toString().padLeft(2, '0')}/${(now.month + 1).clamp(1, 12).toString().padLeft(2, '0')}/${now.year}';

      // 1. Save or Update Meter Reading first
      final readingId = const Uuid().v4();
      await meterReadingRepo.saveMeterReading(MeterReading(
        id: readingId,
        ownerId: ownerId,
        roomId: widget.roomId,
        month: _currentMonth,
        electricOld: _electricOld,
        electricNew: _electricNew,
        waterOld: _waterOld,
        waterNew: _waterNew,
        isRecorded: true,
      ));

      // 2. Save or Update Invoice
      final invoice = Invoice(
        id: _existingInvoice?.id ?? const Uuid().v4(),
        ownerId: ownerId,
        roomId: widget.roomId,
        month: _currentMonth,
        totalAmount: _total,
        status: InvoiceStatus.waitingPayment,
        dueDate: dueDate,
      );
      
      await invoiceRepo.saveInvoice(invoice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã lưu hóa đơn ${_room?.name ?? ''} tháng $_currentMonth!'),
            backgroundColor: AppColors.emerald,
          ),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('Error saving invoice: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _electricOldCtrl.dispose();
    _electricNewCtrl.dispose();
    _waterOldCtrl.dispose();
    _waterNewCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Lập hóa đơn'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _room == null
              ? Center(
                  child: Text('Không tìm thấy phòng.',
                      style: GoogleFonts.manrope(
                          fontSize: 16, color: AppColors.textSecondary)),
                )
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Room info card ──
        Container(
          decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF1a2a3a),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(
                    child: Icon(Icons.apartment_rounded,
                        color: Colors.white24, size: 60)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('THÔNG TIN PHÒNG',
                        style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    Text(_room!.name,
                        style: GoogleFonts.manrope(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    if (_property != null)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: AppColors.textSecondary),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(_property!.name,
                                style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    if (_tenant != null)
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 14, color: AppColors.textSecondary),
                          SizedBox(width: 4),
                          Text('Khách thuê: ${_tenant!.name}',
                              style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Tháng $_currentMonth',
                        style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // ── Electric & Water ──
        InvoiceCard(
          icon: Icons.bolt,
          iconColor: AppColors.primary,
          title: 'Điện & Nước',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: InvoiceInputField(
                          'Chỉ số điện cũ', _electricOldCtrl,
                          suffix: 'kWh')),
                  SizedBox(width: 12),
                  Expanded(
                      child: InvoiceInputField(
                          'Chỉ số điện mới', _electricNewCtrl,
                          suffix: 'kWh')),
                ],
              ),
              SizedBox(height: 8),
              InvoiceCostRow(
                label:
                    'Tiền điện (${fmtDouble(_property?.electricityPrice ?? 3500)}/kWh)',
                value: _electricCost,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: InvoiceInputField(
                          'Chỉ số nước cũ', _waterOldCtrl,
                          suffix: 'm³')),
                  SizedBox(width: 12),
                  Expanded(
                      child: InvoiceInputField(
                          'Chỉ số nước mới', _waterNewCtrl,
                          suffix: 'm³')),
                ],
              ),
              SizedBox(height: 8),
              InvoiceCostRow(
                label:
                    'Tiền nước (${fmtDouble(_property?.waterPrice ?? 15000)}/m³)',
                value: _waterCost,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // ── Rent + Services ──
        InvoiceCard(
          icon: Icons.layers_outlined,
          iconColor: AppColors.emerald,
          title: 'Tiền phòng & Dịch vụ',
          child: Column(
            children: [
              InvoiceServiceRow(
                icon: Icons.bed_outlined,
                label: 'Tiền phòng tháng $_currentMonth',
                value: _rentPrice,
                isHighlight: true,
              ),
              if (_services.isNotEmpty) ...[
                Divider(height: 16, color: AppColors.surface),
                ..._services.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InvoiceServiceRow(
                        icon: serviceIcon(s.name),
                        label: s.name,
                        value: s.price,
                      ),
                    )),
              ],
            ],
          ),
        ),
        SizedBox(height: 16),

        // ── Notes ──
        InvoiceCard(
          icon: Icons.edit_note_rounded,
          iconColor: AppColors.textSecondary,
          title: 'Ghi chú',
          child: TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập ghi chú cho hóa đơn này...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
          ),
        ),
        SizedBox(height: 16),

        // ── Total ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryLight, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng số tiền cần thanh toán',
                        style: GoogleFonts.manrope(
                            fontSize: 13, color: AppColors.textSecondary)),
                    SizedBox(height: 4),
                    StatefulBuilder(
                      builder: (context, setState) => Text(
                        fmtDouble(_total),
                        style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12)),
                child:
                    Icon(Icons.receipt_long_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: const Text('Xuất hóa đơn'),
                onPressed: () {
                  if (_existingInvoice == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng lưu hóa đơn trước khi xuất!')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoiceExportPage(
                        invoice: _existingInvoice!,
                        room: _room!,
                        property: _property,
                        tenant: _tenant,
                        services: _services,
                        electricOld: _electricOld,
                        electricNew: _electricNew,
                        waterOld: _waterOld,
                        waterNew: _waterNew,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  side: BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: _isSaving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Icon(Icons.save_outlined),
                label: Text(_existingInvoice != null
                    ? 'Cập nhật hóa đơn'
                    : 'Lưu hóa đơn'),
                onPressed: _isSaving ? null : _saveInvoice,
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
