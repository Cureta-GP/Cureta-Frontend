import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/records_error_view.dart';
import 'package:cureta/features/medical_records/widgets/shimmer_record_card.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              padding: EdgeInsets.all(spacing.xl),
              child: Text(
                'No records found',
                style: context.typography.medicalRecordHelper.copyWith(
                  color: colors.textSecondary,
                ),
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
                child: UserRecordCard(key: ValueKey(record.id), record: record),
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
