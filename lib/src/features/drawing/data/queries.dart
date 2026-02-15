/// Centraliza as queries SQL usadas no aplicativo.
class Queries {
  Queries._();

  /// Tabela de Documentos
  static const String createDocumentsTable = '''
    CREATE TABLE documents (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      isFavorite INTEGER DEFAULT 0,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
  ''';

  /// Tabela de Elementos do Canvas
  static const String createCanvasElementsTable = '''
    CREATE TABLE canvas_elements (
      id TEXT PRIMARY KEY,
      documentId TEXT NOT NULL,
      type TEXT NOT NULL,
      x REAL NOT NULL,
      y REAL NOT NULL,
      width REAL NOT NULL,
      height REAL NOT NULL,
      angle REAL DEFAULT 0,
      strokeColor INTEGER NOT NULL,
      fillColor INTEGER,
      strokeWidth REAL DEFAULT 1.0,
      strokeStyle TEXT NOT NULL,
      fillType TEXT NOT NULL,
      opacity REAL DEFAULT 1.0,
      roughness REAL DEFAULT 1.0,
      zIndex INTEGER DEFAULT 0,
      isDeleted INTEGER DEFAULT 0,
      version INTEGER DEFAULT 1,
      versionNonce INTEGER DEFAULT 0,
      updatedAt TEXT NOT NULL,
      customData TEXT,
      FOREIGN KEY (documentId) REFERENCES documents (id) ON DELETE CASCADE
    )
  ''';

  /// Tabela de Configurações
  static const String createAppSettingsTable = '''
    CREATE TABLE app_settings (
      setting_key TEXT PRIMARY KEY,
      setting_value TEXT NOT NULL
    )
  ''';

  /// Query de upgrade para v2 (criação de app_settings se não existir)
  static const String upgradeToV2AppSettings = '''
    CREATE TABLE IF NOT EXISTS app_settings (
      setting_key TEXT PRIMARY KEY,
      setting_value TEXT NOT NULL
    )
  ''';
}
