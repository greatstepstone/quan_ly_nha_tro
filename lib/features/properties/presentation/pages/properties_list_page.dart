import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';

import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_add_card.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/widgets/property_card.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/widgets/property_stats_banner.dart';





class PropertiesListPage extends ConsumerStatefulWidget {
  const PropertiesListPage({super.key});

  @override
  ConsumerState<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends ConsumerState<PropertiesListPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allPropertiesAsync = ref.watch(allPropertiesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.propertiesListTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: allPropertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(allPropertiesProvider),
        ),


        data: (properties) {
          final filtered = properties
              .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(AppPadding.p16),
            children: [
              // Search
              TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: AppStrings.searchPropertyHint,
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                ),
              ),
              const SizedBox(height: AppHeight.h16),

              // Property list
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p32),
                  child: Center(
                    child: Text(AppStrings.noPropertyFound, 
                      style: GoogleFonts.manrope(
                        color: AppColors.textSecondary,
                        fontSize: FontSize.s14,
                        fontWeight: FontWeightManager.medium,
                      )),
                  ),
                )
              else
                ...filtered.map((p) => PropertyCard(property: p)),

              // Add new
              const SizedBox(height: AppHeight.h12),
              AppAddCard(
                title: AppStrings.addNewPropertyTitle,
                description: AppStrings.addNewPropertyDesc,
                buttonLabel: AppStrings.addNowBtn,
                onTap: () => context.pushNamed(AppRoutes.propertyAdd),
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: AppHeight.h16),

              // Stats banner
              PropertyStatsBanner(properties: properties),
              const SizedBox(height: AppHeight.h24),
            ],
          );
        },
      ),
    );
  }
}


