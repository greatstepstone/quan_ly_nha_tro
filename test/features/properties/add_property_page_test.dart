import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/pages/add_property_page.dart';

void main() {
  testWidgets('AddPropertyPage - should show error if fields are empty', (WidgetTester tester) async {
    // 1. Build the widget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddPropertyPage(),
        ),
      ),
    );

    // 2. Click Save without entering anything
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // 3. Verify SnackBar appears
    expect(find.text('Vui lòng nhập tên và địa chỉ nhà trọ'), findsOneWidget);
  });

  testWidgets('AddPropertyPage - inputs should update controllers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddPropertyPage(),
        ),
      ),
    );

    // Điền tên nhà trọ
    await tester.enterText(find.byType(TextFormField).first, 'Nhà trọ test');
    expect(find.text('Nhà trọ test'), findsOneWidget);
  });
}
