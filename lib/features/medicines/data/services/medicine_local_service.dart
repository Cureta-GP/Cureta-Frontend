import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/medicine_model.dart';
import '../models/medicine_enums.dart';

class MedicineLocalService {
  static const _dbName = 'cureta_medicines.db';
  static const _dbVersion = 2;
  static const _table = 'medicines';

  static const colId = 'id';
  static const colName = 'name';
  static const colDoseForm = 'dose_form';
  static const colDoseAmount = 'dose_amount';
  static const colDoseUnit = 'dose_unit';
  static const colFrequency = 'frequency';
  static const colAlarmTimes = 'alarm_times';
  static const colStartDate = 'start_date';
  static const colNotes = 'notes';
  static const colIsActive = 'is_active';
  static const colSyncStatus = 'sync_status';
  static const colRemoteId = 'remote_id';
  static const colCreatedAt = 'created_at';
  static const colUpdatedAt = 'updated_at';
  static const colProfileId = 'profile_id';
  static const colImagePath = 'image_path';

  Database? _db;
  final _controller = StreamController<List<MedicineModel>>.broadcast();

  Future<void> init() async {
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _create, onUpgrade: _upgrade);
    await _emitAll('');
  }

  Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        $colId TEXT PRIMARY KEY,
        $colProfileId TEXT NOT NULL,
        $colName TEXT NOT NULL,
        $colDoseForm TEXT NOT NULL,
        $colDoseAmount TEXT NOT NULL,
        $colDoseUnit TEXT NOT NULL,
        $colFrequency TEXT NOT NULL,
        $colAlarmTimes TEXT NOT NULL,
        $colStartDate TEXT NOT NULL,
        $colNotes TEXT,
        $colImagePath TEXT,
        $colIsActive INTEGER NOT NULL DEFAULT 1,
        $colSyncStatus TEXT NOT NULL DEFAULT 'pending',
        $colRemoteId TEXT,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_table ADD COLUMN $colProfileId TEXT NOT NULL DEFAULT \'\'');
      await db.execute('ALTER TABLE $_table ADD COLUMN $colImagePath TEXT');
    }
  }

  Future<void> insert(MedicineModel m) async {
    await _db!.insert(_table, _toMap(m), conflictAlgorithm: ConflictAlgorithm.replace);
    await _emitAll(m.profileId);
  }

  Stream<List<MedicineModel>> watchAll(String profileId) async* {
    yield await getAll(profileId);
    yield* _controller.stream;
  }

  Future<List<MedicineModel>> getAll(String profileId) async {
    final maps = await _db!.query(_table, where: '$colProfileId = ?', whereArgs: [profileId]);
    return maps.map(_fromMap).toList();
  }

  Future<MedicineModel?> getById(String id) async {
    final maps = await _db!.query(_table, where: '$colId = ?', whereArgs: [id]);
    return maps.isEmpty ? null : _fromMap(maps.first);
  }

  Future<List<MedicineModel>> getPending(String profileId) async {
    final maps = await _db!.query(
      _table,
      where: '$colSyncStatus = ? AND $colProfileId = ?',
      whereArgs: [SyncStatus.pending.toJson(), profileId],
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> updateSyncStatus(String id, SyncStatus status, {String? remoteId}) async {
    final v = <String, dynamic>{colSyncStatus: status.toJson(), colUpdatedAt: DateTime.now().toIso8601String()};
    if (remoteId != null) v[colRemoteId] = remoteId;
    final m = await getById(id);
    await _db!.update(_table, v, where: '$colId = ?', whereArgs: [id]);
    if (m != null) await _emitAll(m.profileId);
  }

  Future<void> update(MedicineModel m) async {
    await _db!.update(_table, _toMap(m), where: '$colId = ?', whereArgs: [m.id]);
    await _emitAll(m.profileId);
  }

  Future<void> upsertFromRemote(MedicineModel remote) async {
    if (remote.remoteId == null || remote.remoteId!.isEmpty) {
      await insert(remote);
      return;
    }
    final matches = await _db!.query(
      _table,
      where: '$colRemoteId = ? AND $colProfileId = ?',
      whereArgs: [remote.remoteId, remote.profileId],
    );
    if (matches.isNotEmpty) {
      final existing = _fromMap(matches.first);
      if (existing.syncStatus == SyncStatus.pending || existing.syncStatus == SyncStatus.failed) {
        return; // Preserve local unsynced changes
      }
      if (existing.updatedAt.isAfter(remote.updatedAt)) {
        return; // Preserve newer local changes against cached/laggy server responses
      }
      final preserved = remote.copyWith(
        id: existing.id,
        imagePath: existing.imagePath,
        isActive: existing.isActive,
        createdAt: existing.createdAt,
        doseForm: existing.doseForm,
        doseAmount: remote.doseAmount.isEmpty ? existing.doseAmount : remote.doseAmount,
        doseUnit: remote.doseUnit.isEmpty ? existing.doseUnit : remote.doseUnit,
        alarmTimes: remote.alarmTimes.isEmpty ? existing.alarmTimes : remote.alarmTimes,
        notes: (remote.notes == null || remote.notes!.isEmpty) ? existing.notes : remote.notes,
      );
      await _db!.update(_table, _toMap(preserved), where: '$colId = ?', whereArgs: [existing.id]);
      await _emitAll(remote.profileId);
      return;
    }
    await insert(remote);
  }

  Future<void> delete(String id) async {
    final m = await getById(id);
    await _db!.delete(_table, where: '$colId = ?', whereArgs: [id]);
    if (m != null) await _emitAll(m.profileId);
  }

  Future<void> close() async {
    await _controller.close();
    await _db?.close();
    _db = null;
  }

  Future<void> _emitAll(String profileId) async {
    if (_db == null || _controller.isClosed) return;
    final items = profileId.isNotEmpty ? await getAll(profileId) : <MedicineModel>[];
    if (!_controller.isClosed) _controller.add(items);
  }

  Map<String, dynamic> _toMap(MedicineModel m) => {
        colId: m.id, colProfileId: m.profileId, colName: m.name,
        colDoseForm: m.doseForm.toJson(), colDoseAmount: m.doseAmount,
        colDoseUnit: m.doseUnit, colFrequency: m.frequency.toJson(),
        colAlarmTimes: jsonEncode(m.alarmTimes),
        colStartDate: m.startDate.toIso8601String(), colNotes: m.notes,
        colImagePath: m.imagePath, colIsActive: m.isActive ? 1 : 0,
        colSyncStatus: m.syncStatus.toJson(), colRemoteId: m.remoteId,
        colCreatedAt: m.createdAt.toIso8601String(), colUpdatedAt: m.updatedAt.toIso8601String(),
      };

  MedicineModel _fromMap(Map<String, dynamic> m) => MedicineModel(
        id: m[colId] as String, profileId: m[colProfileId] as String,
        name: m[colName] as String, doseForm: DoseForm.fromJson(m[colDoseForm] as String),
        doseAmount: m[colDoseAmount] as String, doseUnit: m[colDoseUnit] as String,
        frequency: Frequency.fromJson(m[colFrequency] as String),
        alarmTimes: _decodeAlarmTimes(m[colAlarmTimes] as String),
        startDate: DateTime.parse(m[colStartDate] as String), notes: m[colNotes] as String?,
        imagePath: m[colImagePath] as String?,
        isActive: (m[colIsActive] as int) == 1,
        syncStatus: SyncStatus.fromJson(m[colSyncStatus] as String),
        remoteId: m[colRemoteId] as String?,
        createdAt: DateTime.parse(m[colCreatedAt] as String), updatedAt: DateTime.parse(m[colUpdatedAt] as String),
      );

  List<String> _decodeAlarmTimes(String json) {
    final decoded = jsonDecode(json);
    return decoded is List ? decoded.map((e) => e.toString()).toList() : [];
  }
}
