import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_nha_tro/core/services/invoice_calculator.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

void main() {
  group('InvoiceCalculator Tests', () {
    test('calculateElectricFee should compute correctly', () {
      final oldIndex = 100;
      final newIndex = 150;
      final price = 3000.0;

      final result = InvoiceCalculator.calculateElectricFee(
        oldIndex,
        newIndex,
        price,
      );

      expect(result, equals(150000.0)); // (150-100) * 3000
    });

    test(
      'calculateElectricFee should return 0 if newIndex is null or smaller than old',
      () {
        expect(
          InvoiceCalculator.calculateElectricFee(100, null, 3000.0),
          equals(0.0),
        );
        expect(
          InvoiceCalculator.calculateElectricFee(100, 50, 3000.0),
          equals(0.0),
        );
      },
    );

    test('calculateWaterFee - BillingType.byMeter', () {
      final result = InvoiceCalculator.calculateWaterFee(
        type: BillingType.byMeter,
        oldIndex: 10,
        newIndex: 15,
        price: 10000.0,
        tenantCount: 2,
      );
      expect(result, equals(50000.0));
    });

    test('calculateWaterFee - BillingType.perPerson', () {
      final result = InvoiceCalculator.calculateWaterFee(
        type: BillingType.perPerson,
        oldIndex: 10,
        newIndex: 15,
        price: 50000.0,
        tenantCount: 3,
      );
      expect(result, equals(150000.0)); // 3 * 50000
    });

    test('calculateWaterFee - BillingType.fixed', () {
      final result = InvoiceCalculator.calculateWaterFee(
        type: BillingType.fixed,
        oldIndex: 0,
        newIndex: 0,
        price: 100000.0,
        tenantCount: 5,
      );
      expect(result, equals(100000.0));
    });

    test('calculateServiceFee - perPerson', () {
      expect(
        InvoiceCalculator.calculateServiceFee(
          type: BillingType.perPerson,
          price: 20000.0,
          tenantCount: 4,
        ),
        equals(80000.0),
      );
    });

    test('calculateTotal should sum all components', () {
      final result = InvoiceCalculator.calculateTotal(
        rentPrice: 2000000.0,
        electricFee: 150000.0,
        waterFee: 50000.0,
        serviceFee: 30000.0,
      );
      expect(result, equals(2230000.0));
    });
  });
}
