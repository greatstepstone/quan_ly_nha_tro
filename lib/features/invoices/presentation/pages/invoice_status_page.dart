import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_property_selector.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/widgets/invoice_status_widgets.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class InvoiceStatusPage extends ConsumerWidget {
  const InvoiceStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.invoiceStatusTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: AppPropertySelector(
              selectedPropertyId: ref.watch(invoiceSelectedPropertyIdProvider),
              onPropertySelected:
                  (id) =>
                      ref
                          .read(invoiceSelectedPropertyIdProvider.notifier)
                          .state = id,
            ),
          ),
          const InvoiceFilterBar(),
          const SizedBox(height: AppHeight.h12),
          const InvoiceHeaderSection(),
          const SizedBox(height: AppHeight.h12),
          const Expanded(child: InvoiceListSection()),
        ],
      ),
    );
  }
}
