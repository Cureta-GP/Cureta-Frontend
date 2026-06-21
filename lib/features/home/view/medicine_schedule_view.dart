import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/home/view_model/medicine_schedule_cubit.dart';
import 'package:cureta/features/home/view_model/medicine_schedule_state.dart';
import 'package:cureta/features/home/widgets/schedule_date_strip.dart';
import 'package:cureta/features/home/widgets/schedule_med_card.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MedicineScheduleView extends StatefulWidget {
  const MedicineScheduleView({super.key});

  @override
  State<MedicineScheduleView> createState() => _MedicineScheduleViewState();
}

class _MedicineScheduleViewState extends State<MedicineScheduleView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedule());
  }

  Future<void> _loadSchedule({DateTime? date}) async {
    final profileId = await _resolveProfileId();
    if (profileId != null && mounted) {
      await context.read<MedicineScheduleCubit>().load(profileId, date: date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return BlocConsumer<MedicineScheduleCubit, MedicineScheduleState>(
      listener: (context, state) {
        if (state is MedicineScheduleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final selectedDate = switch (state) {
          MedicineScheduleLoaded(:final selectedDate) => selectedDate,
          _ => DateTime.now(),
        };

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            ),
            title: Text(
              'home.schedule_title'.tr(),
              style: typography.homeSectionTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing.sm),
              ScheduleDateStrip(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  context.read<MedicineScheduleCubit>().selectDate(date);
                },
              ),
              SizedBox(height: spacing.lg),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MedicineScheduleState state) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

    return switch (state) {
      MedicineScheduleInitial() || MedicineScheduleLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      MedicineScheduleLoaded(:final entries, :final updatingEntryKey) =>
        entries.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(spacing.xl),
                  child: Text(
                    'home.schedule_no_meds'.tr(),
                    textAlign: TextAlign.center,
                    style: typography.body.copyWith(color: colors.textHint),
                  ),
                ),
              )
            : RefreshIndicator(
                color: colors.primary,
                onRefresh: () => _loadSchedule(date: state.selectedDate),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final key = MedicineScheduleCubit.entryKey(entry);

                    return ScheduleMedCard(
                      entry: entry,
                      isUpdating: updatingEntryKey == key,
                      onMarkTaken: () => _updateStatus(
                        context,
                        entry,
                        DoseStatus.taken,
                      ),
                      onMarkMissed: () => _updateStatus(
                        context,
                        entry,
                        DoseStatus.missed,
                      ),
                      onMarkPending: () => _updateStatus(
                        context,
                        entry,
                        DoseStatus.pending,
                      ),
                    );
                  },
                ),
              ),
      MedicineScheduleError(:final message) => Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: typography.label.copyWith(color: colors.error),
          ),
        ),
      ),
    };
  }

  void _updateStatus(
    BuildContext context,
    ScheduleEntry entry,
    DoseStatus status,
  ) {
    if (entry.status == status) return;
    context.read<MedicineScheduleCubit>().updateStatus(entry, status);
  }

  Future<String?> _resolveProfileId() async {
    final repo = getIt<ProfileRepository>();
    final profiles = await repo.getProfiles();
    if (profiles.isEmpty) return null;

    final cachedId = await repo.getCachedProfileId();
    if (cachedId != null && profiles.any((p) => p.id == cachedId)) {
      return cachedId;
    }

    return profiles
        .firstWhere((p) => p.isPrimary, orElse: () => profiles.first)
        .id;
  }
}
