import 'package:quan_ly_nha_tro/core/models/models.dart';

class InvoiceCalculator {
  /// Tính tổng tiền hóa đơn
  static double calculateTotal({
    required double rentPrice,
    required double electricFee,
    required double waterFee,
    required double serviceFee,
  }) {
    return rentPrice + electricFee + waterFee + serviceFee;
  }

  /// Tính tiền điện dựa trên chỉ số mới/cũ
  static double calculateElectricFee(int oldIndex, int? newIndex, double price) {
    if (newIndex == null || newIndex < oldIndex) return 0;
    return (newIndex - oldIndex) * price;
  }

  /// Tính tiền nước dựa trên loại hình thanh toán
  static double calculateWaterFee({
    required BillingType type,
    required int oldIndex,
    required int? newIndex,
    required double price,
    required int tenantCount,
  }) {
    switch (type) {
      case BillingType.byMeter:
        if (newIndex == null || newIndex < oldIndex) return 0;
        return (newIndex - oldIndex) * price;
      case BillingType.perPerson:
        return tenantCount * price;
      case BillingType.fixed:
        return price;
    }
  }

  /// Tính phí dịch vụ đi kèm
  static double calculateServiceFee({
    required BillingType type,
    required double price,
    required int tenantCount,
  }) {
    switch (type) {
      case BillingType.perPerson:
        return tenantCount * price;
      case BillingType.fixed:
        return price;
      case BillingType.byMeter:
        return 0; // Dịch vụ khác thường không dùng đồng hồ riêng lẻ ở cấp độ này
    }
  }
}
