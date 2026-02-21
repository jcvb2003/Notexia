import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';

/// Interface abstrata para operações de gerenciamento de arquivos.
///
/// Seguindo Clean Architecture: esta interface fica no domain layer
/// e a implementação concreta fica no data layer.
abstract class FileRepository {
  /// Lista todos os itens em um diretório.
  Future<Result<List<FileItem>>> listItems(String directoryPath);

  /// Obtém um item específico pelo caminho.
  Future<Result<FileItem?>> getItem(String path);

  /// Cria um novo arquivo ou pasta.
  Future<Result<FileItem>> createItem({
    required String name,
    required String parentPath,
    required FileItemType type,
  });

  /// Renomeia um item.
  Future<Result<FileItem>> renameItem(String path, String newName);

  /// Move um item para outro local.
  Future<Result<FileItem>> moveItem(String sourcePath, String destinationPath);

  /// Deleta um item (arquivo ou pasta).
  Future<Result<void>> deleteItem(String path);

  /// Verifica se um caminho existe.
  Future<Result<bool>> exists(String path);

  /// Obtém estatísticas do cofre (vault).
  Future<Result<VaultStats>> getVaultStats(String vaultPath);

  /// Lê o conteúdo de um arquivo em texto puro.
  Future<Result<String?>> readFile(String path);
}

/// Estatísticas de um cofre (vault) de arquivos.
class VaultStats {
  final int fileCount;
  final int folderCount;
  final int totalSizeBytes;

  const VaultStats({
    required this.fileCount,
    required this.folderCount,
    required this.totalSizeBytes,
  });

  String get formattedFileCount => '$fileCount arquivos';
  String get formattedFolderCount => '$folderCount pastas';
  String get summary => '$fileCount arquivos, $folderCount pastas';
}
