import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/medicine_model.dart';
import '../models/medicine_enums.dart';

class MedicineLocalService {
  static const String _dbName = 'cureta_medicines.db';
  static const int _dbVersion = 1;
  static const String _tableMedicines = 'medicines';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colDoseForm = 'dose_form';
  static const String colDoseAmount = 'dose_amount';
  static const String colDoseUnit = 'dose_unit';
  static const String colFrequency = 'frequency';
  static const String colAlarmTimes = 'alarm_times';
  static const String colStartDate = 'start_date';
  static const String colNotes = 'notes';
  static const String colIsActive = 'is_active';
  static const String colSyncStatus = 'sync_status';
  static const String colRemoteId = 'remote_id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  Database? _db;
  final StreamController<List<MedicineModel>> _medicinesController =
      StreamController<List<MedicineModel>>.broadcast();

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
    );
    await _emitAll();
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableMedicines (
        $colId TEXT PRIMARY KEY,
        $colName TEXT NOT NULL,
        $colDoseForm TEXT NOT NULL,
        $colDoseAmount TEXT NOT NULL,
        $colDoseUnit TEXT NOT NULL,
        $colFrequency TEXT NOT NULL,
        $colAlarmTimes TEXT NOT NULL,
        $colStartDate TEXT NOT NULL,
        $colNotes TEXT,
        $colIsActive INTEGER NOT NULL DEFAULT 1,
        $colSyncStatus TEXT NOT NULL DEFAULT 'pending',
        $colRemoteId TEXT,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> insert(MedicineModel medicine) async {
    await _db!.insert(
      _tableMedicines,
      _toMap(medicine),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _emitAll();
  }

  Stream<List<MedicineModel>> watchMedicines() async* {
    yield await getAll();
    yield* _medicinesController.stream;
  }

  Future<List<MedicineModel>> getAll() async {
    final maps = await _db!.query(_tableMedicines);
    return maps.map(_fromMap).toList();
  }

  Future<MedicineModel?> getById(String id) async {
    final maps = await _db!.query(
      _tableMedicines,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<List<MedicineModel>> getPending() async {
    final maps = await _db!.query(
      _tableMedicines,
      where: '$colSyncStatus = ?',
      whereArgs: [SyncStatus.pending.toJson()],
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> updateSyncStatus(
    String id,
    SyncStatus status, {
    String? remoteId,
  }) async {
    final values = <String, dynamic>{
      colSyncStatus: status.toJson(),
      colUpdatedAt: DateTime.now().toIso8601String(),
    };
    if (remoteId != null) {
      values[colRemoteId] = remoteId;
    }
    await _db!.update(
      _tableMedicines,
      values,
      where: '$colId = ?',
      whereArgs: [id],
    );
    await _emitAll();
  }

  Future<void> update(MedicineModel medicine) async {
    await _db!.update(
      _tableMedicines,
      _toMap(medicine),
      where: '$colId = ?',
      whereArgs: [medicine.id],
    );
    await _emitAll();
  }

  Future<void> upsertFromRemote(MedicineModel remoteModel) async {
    final remoteId = remoteModel.remoteId;
    if (remoteId == null || remoteId.isEmpty) {
      await insert(remoteModel);
      return;
    }

    final matches = await _db!.query(
      _tableMedicines,
      where: '$colRemoteId = ?',
      whereArgs: [remoteId],
    );

    if (matches.isNotEmpty) {
      final existing = _fromMap(matches.first);
      final updated = remoteModel.copyWith(
        id: existing.id,
        isActive: existing.isActive,
        createdAt: existing.createdAt,
      );
      for (final duplicate in matches.skip(1)) {
        final duplicateId = duplicate[colId] as String;
        await _db!.delete(
          _tableMedicines,
          where: '$colId = ?',
          whereArgs: [duplicateId],
        );
      }
      await _db!.update(
        _tableMedicines,
        _toMap(updated),
        where: '$colId = ?',
        whereArgs: [existing.id],
      );
      await _cleanupLocalGhostCopies(updated, keepId: existing.id);
      await _emitAll();
      return;
    }

    final localCandidates = await _findLocalCandidatesWithoutRemoteId(
      remoteModel,
    );
    if (localCandidates.isNotEmpty) {
      final candidate = _fromMap(localCandidates.first);
      for (final duplicate in localCandidates.skip(1)) {
        final duplicateId = duplicate[colId] as String;
        await _db!.delete(
          _tableMedicines,
          where: '$colId = ?',
          whereArgs: [duplicateId],
        );
      }
      final linked = remoteModel.copyWith(
        id: candidate.id,
        isActive: candidate.isActive,
        createdAt: candidate.createdAt,
      );
      await _db!.update(
        _tableMedicines,
        _toMap(linked),
        where: '$colId = ?',
        whereArgs: [candidate.id],
      );
      await _emitAll();
      return;
    }

    await insert(remoteModel);
  }

  Future<List<Map<String, dynamic>>> _findLocalCandidatesWithoutRemoteId(
    MedicineModel model,
  ) async {
    final rows = await _db!.query(
      _tableMedicines,
      where: '$colRemoteId IS NULL',
    );
    return rows.where((row) {
      final local = _fromMap(row);
      return _isLikelySameMedicine(local, model);
    }).toList();
  }

  bool _isLikelySameMedicine(MedicineModel local, MedicineModel remote) {
    final sameDose =
        local.doseAmount.trim() == remote.doseAmount.trim() &&
        local.doseUnit.trim().toLowerCase() ==
            remote.doseUnit.trim().toLowerCase();
    final doseMissingOnOneSide =
        local.doseAmount.trim().isEmpty || remote.doseAmount.trim().isEmpty;

    return local.name.trim().toLowerCase() ==
            remote.name.trim().toLowerCase() &&
        local.frequency == remote.frequency &&
        _sameDate(local.startDate, remote.startDate) &&
        _sameAlarmTimes(local.alarmTimes, remote.alarmTimes) &&
        (sameDose || doseMissingOnOneSide);
  }

  bool _sameDate(DateTime a, DateTime b) {
    final left = DateTime.utc(a.year, a.month, a.day);
    final right = DateTime.utc(b.year, b.month, b.day);
    final dayDiff = left.difference(right).inDays.abs();
    return dayDiff <= 1;
  }

  bool _sameAlarmTimes(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final left = a.map(_normalizeTime).toList()..sort();
    final right = b.map(_normalizeTime).toList()..sort();
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }

  String _normalizeTime(String raw) {
    final value = raw.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(value);
    if (match == null) return value;
    final hour = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minute = int.tryParse(match.group(2) ?? '0') ?? 0;
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _cleanupLocalGhostCopies(
    MedicineModel model, {
    required String keepId,
  }) async {
    final ghosts = await _findLocalCandidatesWithoutRemoteId(model);
    for (final ghost in ghosts) {
      final ghostId = ghost[colId] as String;
      if (ghostId == keepId) continue;
      await _db!.delete(
        _tableMedicines,
        where: '$colId = ?',
        whereArgs: [ghostId],
      );
    }
    await _emitAll();
  }

  Future<void> delete(String id) async {
    await _db!.delete(_tableMedicines, where: '$colId = ?', whereArgs: [id]);
    await _emitAll();
  }

  Future<void> close() async {
    await _medicinesController.close();
    await _db?.close();
    _db = null;
  }

  Future<void> _emitAll() async {
    if (_db == null || _medicinesController.isClosed) return;
    final all = await getAll();
    if (!_medicinesController.isClosed) {
      _medicinesController.add(all);
    }
  }

  Map<String, dynamic> _toMap(MedicineModel medicine) {
    return {
      colId: medicine.id,
      colName: medicine.name,
      colDoseForm: medicine.doseForm.toJson(),
      colDoseAmount: medicine.doseAmount,
      colDoseUnit: medicine.doseUnit,
      colFrequency: medicine.frequency.toJson(),
      colAlarmTimes: jsonEncode(medicine.alarmTimes),
      colStartDate: medicine.startDate.toIso8601String(),
      colNotes: medicine.notes,
      colIsActive: medicine.isActive ? 1 : 0,
      colSyncStatus: medicine.syncStatus.toJson(),
      colRemoteId: medicine.remoteId,
      colCreatedAt: medicine.createdAt.toIso8601String(),
      colUpdatedAt: medicine.updatedAt.toIso8601String(),
    };
  }

  MedicineModel _fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map[colId] as String,
      name: map[colName] as String,
      doseForm: DoseForm.fromJson(map[colDoseForm] as String),
      doseAmount: map[colDoseAmount] as String,
      doseUnit: map[colDoseUnit] as String,
      frequency: Frequency.fromJson(map[colFrequency] as String),
      alarmTimes: _decodeAlarmTimes(map[colAlarmTimes] as String),
      startDate: DateTime.parse(map[colStartDate] as String),
      notes: map[colNotes] as String?,
      isActive: (map[colIsActive] as int) == 1,
      syncStatus: SyncStatus.fromJson(map[colSyncStatus] as String),
      remoteId: map[colRemoteId] as String?,
      createdAt: DateTime.parse(map[colCreatedAt] as String),
      updatedAt: DateTime.parse(map[colUpdatedAt] as String),
    );
  }

  List<String> _decodeAlarmTimes(String json) {
    final decoded = jsonDecode(json);
    if (decoded is List) {
      return decoded.map((e) => e.toString()).toList();
    }
    return [];
  }
}
