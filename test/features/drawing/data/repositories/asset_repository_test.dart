import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/data/repositories/asset_repository.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;
  late AssetRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('asset_repository_test_');
    repository = AssetRepository();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveAsset persists bytes and getAsset returns the same payload',
      () async {
    final payload = Uint8List.fromList([10, 20, 30, 40]);

    final id = await repository.saveAsset(payload, 'png');
    final savedPath = p.join(tempDir.path, 'assets', '$id.png');

    expect(await File(savedPath).exists(), isTrue);
    expect(await repository.getAsset(id), payload);
  });

  test('getAsset returns null when id does not exist', () async {
    final result = await repository.getAsset('missing-id');
    expect(result, isNull);
  });

  test('deleteAsset removes saved file', () async {
    final payload = Uint8List.fromList([1, 2, 3]);
    final id = await repository.saveAsset(payload, 'jpg');
    final savedPath = p.join(tempDir.path, 'assets', '$id.jpg');

    expect(await File(savedPath).exists(), isTrue);

    await repository.deleteAsset(id);

    expect(await File(savedPath).exists(), isFalse);
    expect(await repository.getAsset(id), isNull);
  });
}
