import 'dart:typed_data';

/// Contrato para gerenciamento de assets binários (essencialmente imagens).
abstract class AssetRepository {
  /// Salva um asset binário e retorna seu ID único.
  Future<String> saveAsset(Uint8List data, String extension);

  /// Recupera os dados binários de um asset pelo ID.
  Future<Uint8List?> getAsset(String id);

  /// Remove um asset pelo ID.
  Future<void> deleteAsset(String id);
}
