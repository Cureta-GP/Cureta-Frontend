import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/animated_sliver_record_item.dart';
import 'package:cureta/features/medical_records/widgets/records_error_view.dart';
import 'package:cureta/features/medical_records/widgets/shimmer_record_card.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
class RecordsLoadingScroll extends StatelessWidget {
  const RecordsLoadingScroll({super.key, required this.topSection});

  final Widget topSection;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return CustomScrollView(
      key: const PageStorageKey('userRecordsScrollLoading'),
      slivers: [
        SliverToBoxAdapter(child: topSection),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxl * 2,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing.lg),
                child: const ShimmerRecordCard(),
              );
            }, childCount: 4),
          ),
        ),
      ],
    );
  }
}

class RecordsErrorScroll extends StatelessWidget {
  const RecordsErrorScroll({
    super.key,
    required this.topSection,
    required this.errorText,
    required this.profileId,
  });

  final Widget topSection;
  final String errorText;
  final String? profileId;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('userRecordsScrollError'),
      slivers: [
        SliverToBoxAdapter(child: topSection),
        SliverFillRemaining(
          hasScrollBody: false,
          child: RecordsErrorView(
            error: errorText,
            onRetry: profileId != null
                ? () => context.read<MedicalRecordsCubit>().fetchRecords(
                    profileId: profileId!,
                    forceRefresh: true,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class RecordsEmptyScroll extends StatelessWidget {
  const RecordsEmptyScroll({super.key, required this.topSection});

  final Widget topSection;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return CustomScrollView(
      key: const PageStorageKey('userRecordsScrollEmpty'),
      slivers: [
        SliverToBoxAdapter(child: topSection),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(spacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.folder_open_outlined,
                      size: 60,
                      color: colors.primary,
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  Text(
                    'medical_records.list.empty_records_title'.tr(),
                    style: context.typography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    'medical_records.list.empty_records_subtitle'.tr(),
                    style: context.typography.label.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.medicalRecordsStepOne);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.background,
                        padding: EdgeInsets.symmetric(vertical: spacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.radius.xxl),
                        ),
                      ),
                      child: Text(
                        'medical_records.list.add_your_first_record'.tr(),
                        style: context.typography.medicalRecordButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecordsSuccessScroll extends StatelessWidget {
  const RecordsSuccessScroll({
    super.key,
    required this.topSection,
    required this.records,
  });

  final Widget topSection;
  final List<MedicalRecordModel> records;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return CustomScrollView(
      key: const PageStorageKey('userRecordsScrollSuccess'),
      slivers: [
        SliverToBoxAdapter(child: topSection),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxl * 2,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final record = records[index];
              return Padding(
                padding: EdgeInsets.only(bottom: spacing.lg),
                child: AnimatedSliverRecordItem(
                  key: ValueKey('record_anim_${record.id}_$index'),
                  index: index,
                  child: UserRecordCard(record: record),
                ),
              );
            }, childCount: records.length),
          ),
        ),
      ],
    );
  }
}

class RecordsInitialScroll extends StatelessWidget {
  const RecordsInitialScroll({super.key, required this.topSection});

  final Widget topSection;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return CustomScrollView(
      key: const PageStorageKey('userRecordsScrollInitial'),
      slivers: [
        SliverToBoxAdapter(child: topSection),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xxl * 2,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing.lg),
                child: const ShimmerRecordCard(),
              );
            }, childCount: 4),
          ),
        ),
      ],
    );
  }
}
