import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:notexia/src/features/drawing/domain/repositories/asset_repository.dart';
import 'package:uuid/uuid.dart';

class AssetRepositoryImpl implements AssetRepository {
  static const String _assetsFolder = 'assets';
  final _uuid = const Uuid();

  Future<String> _getAssetsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _assetsFolder);
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  @override
  Future<String> saveAsset(Uint8List data, String extension) async {
    final assetsPath = await _getAssetsPath();
    final id = _uuid.v4();
    final fileName = '$id.$extension';
    final file = File(p.join(assetsPath, fileName));

    await file.writeAsBytes(data);
    return id;
  }

  @override
  Future<Uint8List?> getAsset(String id) async {
    final assetsPath = await _getAssetsPath();

    // Como não sabemos a extensão, procuramos pelo arquivo que começa com o ID
    final dir = Directory(assetsPath);
    final List<FileSystemEntity> entities = await dir.list().toList();

    for (var entity in entities) {
      if (entity is File && p.basenameWithoutExtension(entity.path) == id) {
        return await entity.readAsBytes();
      }
    }

    return null;
  }

  @override
  Future<void> deleteAsset(String id) async {
    final assetsPath = await _getAssetsPath();
    final dir = Directory(assetsPath);
    final List<FileSystemEntity> entities = await dir.list().toList();

    for (var entity in entities) {
      if (entity is File && p.basenameWithoutExtension(entity.path) == id) {
        await entity.delete();
        break;
      }
    }
  }
}
