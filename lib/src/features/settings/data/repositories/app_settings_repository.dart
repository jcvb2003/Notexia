import 'package:notexia/src/core/storage/local_database/database_service.dart';

import 'package:sqflite/sqflite.dart';

class AppSettingsRepository {
  final DatabaseService _databaseService;

  AppSettingsRepository(this._databaseService);

  Future<void> saveSetting(String key, String value) async {
    final db = await _databaseService.database;
    await db.insert(
        'app_settings',
        {
          'setting_key': key,
          'setting_value': value,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getSetting(String key) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'app_settings',
      where: 'setting_key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first['setting_value'] as String;
    }
    return null;
  }
}
