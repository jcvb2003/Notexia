import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';

/// Implementação concreta do FileRepository usando I/O de sistema de arquivos.
class FileRepositoryImpl implements FileRepository {
  final Uuid _uuid = const Uuid();

  @override
  Future<Result<List<FileItem>>> listItems(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return Result.success([]);
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
          // Ignora itens com erro de leitura (ex: permissão negada) para não falhar a listagem completa
          debugPrint('Erro ao ler item ${entity.path}: $e');
        }
      }
    } catch (e) {
      return Result.failure(
          FileSystemFailure('Erro ao listar diretório $directoryPath: $e'));
    }

    // Ordena: pastas primeiro, depois arquivos alfabeticamente
    items.sort((a, b) {
      if (a.isFolder && !b.isFolder) return -1;
      if (!a.isFolder && b.isFolder) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return Result.success(items);
  }

  @override
  Future<Result<FileItem?>> getItem(String path) async {
    try {
      final entity = FileSystemEntity.typeSync(path);
      if (entity == FileSystemEntityType.notFound) {
        return Result.success(null);
      }

      final stat = await FileStat.stat(path);
      final name = p.basename(path);
      final parentPath = p.dirname(path);

      final item = FileItem(
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

      return Result.success(item);
    } catch (e) {
      return Result.failure(FileSystemFailure('Erro ao obter item $path: $e'));
    }
  }

  String _uniqueName(String parentPath, String name) {
    final ext = p.extension(name);
    final base = p.basenameWithoutExtension(name);
    var candidate = name;
    var counter = 2;
    while (File(p.join(parentPath, candidate)).existsSync() ||
        Directory(p.join(parentPath, candidate)).existsSync()) {
      candidate = '$base $counter$ext';
      counter++;
    }
    return candidate;
  }

  @override
  Future<Result<FileItem>> createItem({
    required String name,
    required String parentPath,
    required FileItemType type,
  }) async {
    final uniqueName = _uniqueName(parentPath, name);
    final itemPath = p.join(parentPath, uniqueName);

    try {
      if (type == FileItemType.folder) {
        await Directory(itemPath).create(recursive: true);
      } else {
        await File(itemPath).create(recursive: true);
      }

      final stat = await FileStat.stat(itemPath);
      final item = FileItem(
        id: _uuid.v4(),
        name: uniqueName,
        path: itemPath,
        type: type,
        createdAt: stat.changed,
        updatedAt: stat.modified,
        parentId: parentPath,
      );
      return Result.success(item);
    } catch (e) {
      return Result.failure(
          FileSystemFailure('Erro ao criar item $itemPath: $e'));
    }
  }

  @override
  Future<Result<FileItem>> renameItem(String path, String newName) async {
    try {
      final entity = _getEntity(path);
      final newPath = p.join(p.dirname(path), newName);
      await entity.rename(newPath);

      final itemResult = await getItem(newPath);
      if (itemResult is Success<FileItem?> && itemResult.value != null) {
        return Result.success(itemResult.value!);
      } else {
        return Result.failure(FileSystemFailure(
            'Item renomeado mas falhou ao ler atributos de $newPath'));
      }
    } catch (e) {
      return Result.failure(FileSystemFailure('Erro ao renomear $path: $e'));
    }
  }

  @override
  Future<Result<FileItem>> moveItem(
      String sourcePath, String destinationPath) async {
    try {
      final entity = _getEntity(sourcePath);
      final newPath = p.join(destinationPath, p.basename(sourcePath));
      await entity.rename(newPath);

      final itemResult = await getItem(newPath);
      if (itemResult is Success<FileItem?> && itemResult.value != null) {
        return Result.success(itemResult.value!);
      } else {
        return Result.failure(FileSystemFailure(
            'Item movido mas falhou ao ler atributos de $newPath'));
      }
    } catch (e) {
      return Result.failure(FileSystemFailure('Erro ao mover $sourcePath: $e'));
    }
  }

  @override
  Future<Result<void>> deleteItem(String path) async {
    try {
      final entity = _getEntity(path);
      if (entity is Directory) {
        await entity.delete(recursive: true);
      } else {
        await entity.delete();
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure(FileSystemFailure('Erro ao excluir $path: $e'));
    }
  }

  @override
  Future<Result<bool>> exists(String path) async {
    try {
      final result =
          FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
      return Result.success(result);
    } catch (e) {
      return Result.failure(
          FileSystemFailure('Erro ao checar se $path existe: $e'));
    }
  }

  @override
  Future<Result<VaultStats>> getVaultStats(String vaultPath) async {
    final rootDir = Directory(vaultPath);
    if (!await rootDir.exists()) {
      return Result.success(
          const VaultStats(fileCount: 0, folderCount: 0, totalSizeBytes: 0));
    }

    int fileCount = 0;
    int folderCount = 0;
    int totalSize = 0;

    Future<void> traverse(Directory dir) async {
      await for (final entity in dir.list()) {
        if (entity is File) {
          fileCount++;
          totalSize += await entity.length();
        } else if (entity is Directory) {
          folderCount++;
          await traverse(entity);
        }
      }
    }

    try {
      await traverse(rootDir);
      return Result.success(VaultStats(
        fileCount: fileCount,
        folderCount: folderCount,
        totalSizeBytes: totalSize,
      ));
    } catch (e) {
      return Result.failure(
          FileSystemFailure('Erro ao obter estatísticas de $vaultPath: $e'));
    }
  }

  @override
  Future<Result<String?>> readFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        return Result.success(content);
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure(FileSystemFailure('Erro ao ler arquivo $path: $e'));
    }
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
