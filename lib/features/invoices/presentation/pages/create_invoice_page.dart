import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';

class CreateInvoicePage extends StatefulWidget {
  final String roomId;
  const CreateInvoicePage({super.key, required this.roomId});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _electricOld = TextEditingController(text: '1,240');
  final _electricNew = TextEditingController(text: '1,315');
  final _waterOld = TextEditingController(text: '450');
  final _waterNew = TextEditingController(text: '458');
  final _note = TextEditingController();

  double get electricCost => (1315 - 1240) * 3500;
  double get waterCost => (458 - 450) * 15000;
  double get internet => 100000;
  double get trash => 30000;
  double get rent => 3500000;
  double get total => electricCost + waterCost + internet + trash + rent;

  @override
  Widget build(BuildContext context) {
    final room = MockData.rooms.firstWhere((r) => r.id == widget.roomId, orElse: () => MockData.rooms.first);
    final tenant = room.tenantId != null
        ? MockData.tenants.where((t) => t.id == room.tenantId).firstOrNull
        : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Lập hóa đơn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Room info card
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a2a3a),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(child: Icon(Icons.apartment_rounded, color: Colors.white24, size: 60)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('THÔNG TIN PHÒNG',
                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text(room.name, style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800)),
                      if (tenant != null)
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('Khách thuê: ${tenant.name}',
                                style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Electric & Water
          _Card(
            icon: Icons.bolt,
            iconColor: AppColors.primary,
            title: 'Điện & Nước',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _InputField('Chỉ số điện cũ', _electricOld)),
                    const SizedBox(width: 12),
                    Expanded(child: _InputField('Chỉ số điện mới', _electricNew)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _InputField('Chỉ số nước cũ', _waterOld)),
                    const SizedBox(width: 12),
                    Expanded(child: _InputField('Chỉ số nước mới', _waterNew)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fixed services
          _Card(
            icon: Icons.layers_outlined,
            iconColor: AppColors.emerald,
            title: 'Dịch vụ cố định',
            child: Column(
              children: [
                _ServiceRow(icon: Icons.wifi, label: 'Phí Internet', value: internet),
                const Divider(height: 16, color: AppColors.surface),
                _ServiceRow(icon: Icons.delete_outline, label: 'Phí Rác', value: trash),
                const Divider(height: 16, color: AppColors.surface),
                _ServiceRow(icon: Icons.grid_view_outlined, label: 'Tiền phòng (Tháng 10)', value: rent, isHighlight: true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          _Card(
            icon: Icons.edit_note_rounded,
            iconColor: AppColors.textSecondary,
            title: 'Ghi chú',
            child: TextField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nhập ghi chú cho hóa đơn này...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Total
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
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(_fmtDouble(total),
                          style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('In hóa đơn'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('Xuất hóa đơn'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã xuất hóa đơn!')),
                    );
                    context.pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  const _Card({required this.icon, required this.iconColor, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _InputField(this.label, this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final bool isHighlight;
  const _ServiceRow({required this.icon, required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 14))),
        Text(_fmtDouble(value),
            style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700,
                color: isHighlight ? AppColors.primary : AppColors.textPrimary)),
      ],
    );
  }
}

String _fmtDouble(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}
