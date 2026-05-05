import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/data/models/dose_log_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';
import 'package:flutter/material.dart';

class MedicineDetailsVeiw extends StatefulWidget {
  const MedicineDetailsVeiw({super.key, required this.medicineId});

  final String medicineId;

  @override
  State<MedicineDetailsVeiw> createState() => _MedicineDetailsVeiwState();
}

class _MedicineDetailsVeiwState extends State<MedicineDetailsVeiw> {
  final MedicineRepository _repository = getIt<MedicineRepository>();
  bool _loading = true;
  MedicineModel? _medicine;
  List<DoseLogModel> _logs = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final medicine = await _repository.getMedicineById(widget.medicineId);
    final logs = await _repository.getDoseLogs(widget.medicineId);
    if (!mounted) return;
    setState(() {
      _medicine = medicine;
      _logs = logs;
      _loading = false;
    });
  }

  Future<void> _setActive(bool value) async {
    if (_medicine == null) return;
    await _repository.setMedicineActive(_medicine!.id, value);
    if (value) {
      await NotificationService.instance.scheduleMedicineAlarms(_medicine!);
    } else {
      await NotificationService.instance.cancelMedicineAlarms(
        _medicine!.id,
        profileId: _medicine!.profileId,
      );
    }
    await _load();
  }

  Future<void> _setPaused(bool value) async {
    if (_medicine == null) return;
    await _repository.setMedicinePaused(_medicine!.id, value);
    if (value) {
      await NotificationService.instance.cancelMedicineAlarms(
        _medicine!.id,
        profileId: _medicine!.profileId,
      );
    } else if (_medicine!.isActive) {
      await NotificationService.instance.scheduleMedicineAlarms(_medicine!);
    }
    await _load();
  }

  List<_DailyLog> _buildDailyLogs(MedicineModel medicine) {
    final start = DateUtils.dateOnly(medicine.startDate);
    final end = DateUtils.dateOnly(DateTime.now());
    final grouped = <DateTime, List<DoseLogModel>>{};

    for (final log in _logs) {
      final day = DateUtils.dateOnly(log.scheduledAt);
      grouped.putIfAbsent(day, () => []).add(log);
    }

    final result = <_DailyLog>[];
    for (
      DateTime day = start;
      !day.isAfter(end);
      day = day.add(const Duration(days: 1))
    ) {
      final dayLogs = grouped[day] ?? const <DoseLogModel>[];
      final taken = dayLogs.where((l) => l.status == DoseStatus.taken).length;
      final missed = dayLogs.where((l) => l.status == DoseStatus.missed).length;
      final skipped =
          dayLogs.where((l) => l.status == DoseStatus.skipped).length;
      result.add(
        _DailyLog(
          day: day,
          taken: taken,
          missed: missed,
          skipped: skipped,
          hasLogs: dayLogs.isNotEmpty,
        ),
      );
    }
    return result.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Medicine details')),
      backgroundColor: colors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _medicine == null
              ? const Center(child: Text('Medicine not found'))
              : ListView(
                  padding: EdgeInsets.all(spacing.lg),
                  children: [
                    _SummaryCard(medicine: _medicine!),
                    SizedBox(height: spacing.md),
                    _ControlsCard(
                      medicine: _medicine!,
                      onActiveChanged: _setActive,
                      onPausedChanged: _setPaused,
                    ),
                    SizedBox(height: spacing.md),
                    Text(
                      'Dose log history',
                      style: context.typography.medicalRecordChoice.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    ..._buildDailyLogs(_medicine!).map(
                      (day) => _DailyLogTile(dayLog: day),
                    ),
                  ],
                ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.medicine});

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicine.name,
            style: context.typography.medicalRecordChoice.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            '${medicine.doseAmount} ${medicine.doseUnit}',
            style: context.typography.medicalRecordDetailLabel.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.xs,
            children: medicine.alarmTimes
                .map((time) => Chip(label: Text(time)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ControlsCard extends StatelessWidget {
  const _ControlsCard({
    required this.medicine,
    required this.onActiveChanged,
    required this.onPausedChanged,
  });

  final MedicineModel medicine;
  final ValueChanged<bool> onActiveChanged;
  final ValueChanged<bool> onPausedChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Alarm enabled'),
            subtitle: const Text('Turn reminders on or off completely'),
            value: medicine.isActive,
            onChanged: onActiveChanged,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pause reminders'),
            subtitle: Text(
              medicine.isActive
                  ? 'Temporarily pause without deleting medicine'
                  : 'Enable alarm first to use pause',
            ),
            trailing: Switch(
              value: medicine.isPaused,
              onChanged: medicine.isActive ? onPausedChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyLog {
  _DailyLog({
    required this.day,
    required this.taken,
    required this.missed,
    required this.skipped,
    required this.hasLogs,
  });

  final DateTime day;
  final int taken;
  final int missed;
  final int skipped;
  final bool hasLogs;
}

class _DailyLogTile extends StatelessWidget {
  const _DailyLogTile({required this.dayLog});

  final _DailyLog dayLog;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = MaterialLocalizations.of(context).formatMediumDate(dayLog.day);
    final subtitle = dayLog.hasLogs
        ? 'Taken: ${dayLog.taken} | Missed: ${dayLog.missed} | Skipped: ${dayLog.skipped}'
        : 'No logs yet';

    return Card(
      color: colors.surface,
      child: ListTile(
        title: Text(date),
        subtitle: Text(subtitle),
      ),
    );
  }
}
