import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:notexia/src/core/storage/queries.dart';

class DatabaseService {
  static const String _dbName = 'notexia.db';
  static const int _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Documentos
    // Tabela de Documentos
    await db.execute(Queries.createDocumentsTable);

    // Tabela de Elementos do Canvas
    // Tabela de Elementos do Canvas
    await db.execute(Queries.createCanvasElementsTable);

    // Tabela de Configurações (ex: caminho do Vault)
    // Tabela de Configurações (ex: caminho do Vault)
    await db.execute(Queries.createAppSettingsTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(Queries.upgradeToV2AppSettings);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
