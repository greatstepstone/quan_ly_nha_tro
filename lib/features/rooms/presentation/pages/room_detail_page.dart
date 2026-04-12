import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

class RoomDetailPage extends StatelessWidget {
  final String roomId;
  const RoomDetailPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final room = MockData.rooms.firstWhere((r) => r.id == roomId, orElse: () => MockData.rooms.first);
    final tenant = room.tenantId != null
        ? MockData.tenants.firstWhere((t) => t.id == room.tenantId, orElse: () => MockData.tenants.first)
        : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Chi tiết phòng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Room header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: room.status == RoomStatus.rented ? AppColors.redLight : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.door_front_door_outlined,
                    color: room.status == RoomStatus.rented ? AppColors.red : AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(room.name, style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800)),
                Text(room.floor, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: room.status == RoomStatus.rented ? AppColors.redLight : AppColors.emeraldLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(room.status.label,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: room.status == RoomStatus.rented ? AppColors.red : AppColors.emerald,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Room info section
          _Section(
            title: 'THÔNG TIN PHÒNG',
            child: Column(
              children: [
                _InfoRow(icon: Icons.payments_outlined, label: 'Giá thuê', value: '${_fmt(room.rentPrice)}/tháng', valueColor: AppColors.primary),
                const Divider(height: 1, color: AppColors.surface),
                _InfoRow(icon: Icons.home_outlined, label: 'Tòa nhà', value: MockData.properties.firstWhere((p) => p.id == room.propertyId, orElse: () => MockData.properties.first).name),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (tenant != null) ...[
            _Section(
              title: 'KHÁCH THUÊ HIỆN TẠI',
              child: GestureDetector(
                onTap: () => context.push('/tenants/${tenant.id}'),
                child: Column(
                  children: [
                    _InfoRow(icon: Icons.person_outline, label: 'Họ tên', value: tenant.name),
                    const Divider(height: 1, color: AppColors.surface),
                    _InfoRow(icon: Icons.phone_outlined, label: 'Điện thoại', value: tenant.phone),
                    const Divider(height: 1, color: AppColors.surface),
                    _InfoRow(icon: Icons.calendar_today_outlined, label: 'Ngày bắt đầu', value: tenant.startDate),
                    const Divider(height: 1, color: AppColors.surface),
                    _InfoRow(icon: Icons.savings_outlined, label: 'Tiền cọc', value: _fmt(tenant.deposit), valueColor: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Meter readings shortcut
          _Section(
            title: 'ĐIỆN NƯỚC',
            child: GestureDetector(
              onTap: () => context.push('/meter-readings/$roomId'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.bolt, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Ghi chỉ số điện nước tháng này',
                          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Chỉnh sửa'),
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
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Lập hóa đơn'),
                  onPressed: () => context.push('/invoices/create?roomId=$roomId'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(title,
                style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5)),
          ),
          const Divider(height: 0, color: AppColors.surface),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary))),
          Text(value, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
        ],
      ),
    );
  }
}
