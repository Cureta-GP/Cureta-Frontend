import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/qr/data/models/qr_share_filters.dart';
import 'package:cureta/features/qr/data/models/qr_share_token_request.dart';
import 'package:cureta/features/qr/view/qr_share_result_view.dart';
import 'package:cureta/features/qr/view_model/qr_categories_cubit.dart';
import 'package:cureta/features/qr/view_model/qr_generate_token_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/category_dropdown_card.dart';
import 'widgets/date_range_card.dart';
import 'widgets/record_types_card.dart';
import 'widgets/extra_options_card.dart';
import 'widgets/generate_share_button.dart';
import 'widgets/share_result_sheet.dart';

class FilterDataView extends StatelessWidget {
  final String profileId;

  const FilterDataView({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<QrCategoriesCubit>()..fetchCategories(profileId: profileId),
        ),
        BlocProvider(create: (_) => getIt<QrGenerateTokenCubit>()),
      ],
      child: _FilterDataViewBody(profileId: profileId),
    );
  }
}

class _FilterDataViewBody extends StatefulWidget {
  final String profileId;
  const _FilterDataViewBody({required this.profileId});

  @override
  State<_FilterDataViewBody> createState() => _FilterDataViewBodyState();
}

class _FilterDataViewBodyState extends State<_FilterDataViewBody> {
  String? selectedCategory;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  bool includeHistory = false;
  int expiryMinutes = 15;

  final List<String> availableTypes = const [
    'X-ray',
    'Lab_Test',
    'Prescription',
    'Report',
    'Other',
  ];

  final Set<String> selectedTypes = {};

  void _onApply() {
    final request = QrShareTokenRequest(
      profileId: widget.profileId,
      filters: QrShareFilters(
        types: selectedTypes.isNotEmpty ? selectedTypes.toList() : null,
        category: selectedCategory,
        startDate: startDate,
        endDate: endDate,
        includeHistory: includeHistory,
      ),
      expiryMinutes: expiryMinutes,
    );

    context.read<QrGenerateTokenCubit>().generate(request);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: const Text('Filter data'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CategoryDropdownCard(
                      selectedCategory: selectedCategory,
                      onChanged: (value) =>
                          setState(() => selectedCategory = value),
                    ),
                    SizedBox(height: spacing.md),
                    DateRangeCard(
                      startDate: startDate,
                      endDate: endDate,
                      onStartChanged: (date) =>
                          setState(() => startDate = date),
                      onEndChanged: (date) => setState(() => endDate = date),
                    ),
                    SizedBox(height: spacing.md),
                    RecordTypesCard(
                      availableTypes: availableTypes,
                      selectedTypes: selectedTypes,
                      onChanged: (updated) => setState(() {
                        selectedTypes
                          ..clear()
                          ..addAll(updated);
                      }),
                    ),
                    SizedBox(height: spacing.md),
                    ExtraOptionsCard(
                      includeHistory: includeHistory,
                      expiryMinutes: expiryMinutes,
                      onIncludeHistoryChanged: (value) =>
                          setState(() => includeHistory = value),
                      onExpiryChanged: (value) =>
                          setState(() => expiryMinutes = value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.md),
              GenerateShareButton(
                onPressed: _onApply,
                onTokenGenerated: (shareUrl) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QrShareResultView(shareUrl: shareUrl),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
