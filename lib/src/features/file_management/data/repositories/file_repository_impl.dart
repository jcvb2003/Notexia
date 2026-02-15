import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';

/// Implementação concreta do FileRepository usando I/O de sistema de arquivos.
class FileRepositoryImpl implements FileRepository {
  final Uuid _uuid = const Uuid();

  @override
  Future<List<FileItem>> listItems(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return [];
    }

    final items = <FileItem>[];
    try {
      final stream = dir.list();
      await for (final entity in stream) {
        try {
          final stat = await entity.stat();
          final name = p.basename(entity.path);

          items.add(
            FileItem(
              id: _uuid.v4(),
              name: name,
              path: entity.path,
              type: entity is Directory
                  ? FileItemType.folder
                  : _getFileType(name),
              createdAt: stat.changed,
              updatedAt: stat.modified,
              sizeBytes: entity is File ? stat.size : null,
              parentId: directoryPath,
            ),
          );
        } catch (e) {
          // Ignora itens individuais que falham (ex: acesso negado em um arquivo específico)
          debugPrint('Aviso: Falha ao processar item ${entity.path}: $e');
        }
      }
    } catch (e) {
      // Erro crítico na listagem do diretório em si
      debugPrint('Erro ao listar diretório $directoryPath: $e');
    }

    // Ordena: pastas primeiro, depois arquivos alfabeticamente
    items.sort((a, b) {
      if (a.isFolder && !b.isFolder) return -1;
      if (!a.isFolder && b.isFolder) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return items;
  }

  @override
  Future<FileItem?> getItem(String path) async {
    final entity = FileSystemEntity.typeSync(path);
    if (entity == FileSystemEntityType.notFound) {
      return null;
    }

    final stat = await FileStat.stat(path);
    final name = p.basename(path);
    final parentPath = p.dirname(path);

    return FileItem(
      id: _uuid.v4(),
      name: name,
      path: path,
      type: entity == FileSystemEntityType.directory
          ? FileItemType.folder
          : _getFileType(name),
      createdAt: stat.changed,
      updatedAt: stat.modified,
      sizeBytes: entity == FileSystemEntityType.file ? stat.size : null,
      parentId: parentPath,
    );
  }

  @override
  Future<FileItem> createItem({
    required String name,
    required String parentPath,
    required FileItemType type,
  }) async {
    final itemPath = p.join(parentPath, name);

    if (type == FileItemType.folder) {
      await Directory(itemPath).create(recursive: true);
    } else {
      await File(itemPath).create(recursive: true);
    }

    final stat = await FileStat.stat(itemPath);
    return FileItem(
      id: _uuid.v4(),
      name: name,
      path: itemPath,
      type: type,
      createdAt: stat.changed,
      updatedAt: stat.modified,
      parentId: parentPath,
    );
  }

  @override
  Future<FileItem> renameItem(String path, String newName) async {
    final entity = _getEntity(path);
    final newPath = p.join(p.dirname(path), newName);
    await entity.rename(newPath);

    return (await getItem(newPath))!;
  }

  @override
  Future<FileItem> moveItem(String sourcePath, String destinationPath) async {
    final entity = _getEntity(sourcePath);
    final newPath = p.join(destinationPath, p.basename(sourcePath));
    await entity.rename(newPath);

    return (await getItem(newPath))!;
  }

  @override
  Future<void> deleteItem(String path) async {
    final entity = _getEntity(path);
    if (entity is Directory) {
      await entity.delete(recursive: true);
    } else {
      await entity.delete();
    }
  }

  @override
  Future<bool> exists(String path) async {
    return FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
  }

  @override
  Future<VaultStats> getVaultStats(String vaultPath) async {
    final rootDir = Directory(vaultPath);
    if (!await rootDir.exists()) {
      return const VaultStats(fileCount: 0, folderCount: 0, totalSizeBytes: 0);
    }

    int fileCount = 0;
    int folderCount = 0;
    int totalSize = 0;

    Future<void> traverse(Directory dir) async {
      try {
        await for (final entity in dir.list()) {
          try {
            if (entity is File) {
              fileCount++;
              totalSize += await entity.length();
            } else if (entity is Directory) {
              folderCount++;
              await traverse(entity);
            }
          } catch (e) {
            // Ignora erros em arquivos/pastas específicos (ex: permissão)
            debugPrint('Aviso: Falha ao ler estatística de ${entity.path}: $e');
          }
        }
      } catch (e) {
        // Erro ao listar o diretório em si (ex: acesso negado ao abrir a pasta)
        debugPrint('Aviso: Acesso negado ao listar subpasta ${dir.path}: $e');
      }
    }

    await traverse(rootDir);

    return VaultStats(
      fileCount: fileCount,
      folderCount: folderCount,
      totalSizeBytes: totalSize,
    );
  }

  @override
  Future<String?> readFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  FileSystemEntity _getEntity(String path) {
    final type = FileSystemEntity.typeSync(path);
    if (type == FileSystemEntityType.directory) {
      return Directory(path);
    }
    return File(path);
  }

  FileItemType _getFileType(String name) {
    final ext = p.extension(name).toLowerCase();
    if (['.excalidraw', '.notexia', '.drawing'].contains(ext)) {
      return FileItemType.drawing;
    }
    return FileItemType.file;
  }
}
