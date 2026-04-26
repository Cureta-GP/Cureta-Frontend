import 'dart:convert';
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

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
    );
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
  }

  Future<void> update(MedicineModel medicine) async {
    await _db!.update(
      _tableMedicines,
      _toMap(medicine),
      where: '$colId = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> delete(String id) async {
    await _db!.delete(_tableMedicines, where: '$colId = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
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
