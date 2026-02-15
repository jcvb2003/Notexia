import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class MockFileRepository extends Mock implements FileRepository {}

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  late FileExplorerCubit cubit;
  late MockFileRepository mockFileRepository;
  late MockAppSettingsRepository mockSettingsRepository;

  final now = DateTime.now();
  final testFile = FileItem(
    id: '1',
    name: 'file.ntx',
    path: '/path/to/vault/file.ntx',
    type: FileItemType.file,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockFileRepository = MockFileRepository();
    mockSettingsRepository = MockAppSettingsRepository();
    cubit = FileExplorerCubit(mockFileRepository, mockSettingsRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('FileExplorerCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const FileExplorerState());
    });

    test('initialize loads vault path and items', () async {
      const vaultPath = '/path/to/vault';
      final items = [testFile];
      const stats =
          VaultStats(fileCount: 1, folderCount: 0, totalSizeBytes: 1024);

      when(() => mockSettingsRepository.getSetting('vault_path'))
          .thenAnswer((_) async => vaultPath);
      when(() => mockFileRepository.listItems(vaultPath))
          .thenAnswer((_) async => items);
      when(() => mockFileRepository.getVaultStats(vaultPath))
          .thenAnswer((_) async => stats);
      when(() => mockSettingsRepository.getSetting('explorer_metadata'))
          .thenAnswer((_) async => null);

      await cubit.initialize();

      expect(cubit.state.vaultPath, vaultPath);
      expect(cubit.state.vaultName, 'vault');
      expect(cubit.state.treeCache[vaultPath], items);
      expect(cubit.state.stats, stats);
      expect(cubit.state.isLoading, isFalse);
    });

    test('initialize handles empty vault path', () async {
      when(() => mockSettingsRepository.getSetting('vault_path'))
          .thenAnswer((_) async => '');

      await cubit.initialize();

      expect(cubit.state.vaultPath, '');
      expect(cubit.state.isLoading, isFalse);
    });

    test('toggleFolder expands and collapses folders', () async {
      const folderPath = '/path/to/folder';
      final items = [testFile.copyWith(path: '$folderPath/file.ntx')];

      when(() => mockFileRepository.listItems(folderPath))
          .thenAnswer((_) async => items);
      when(() => mockSettingsRepository.getSetting('explorer_metadata'))
          .thenAnswer((_) async => null);

      // Expand
      await cubit.toggleFolder(folderPath);
      expect(cubit.state.isExpanded(folderPath), isTrue);
      expect(cubit.state.treeCache[folderPath], items);

      // Collapse
      await cubit.toggleFolder(folderPath);
      expect(cubit.state.isExpanded(folderPath), isFalse);
    });

    test('createFile calls repository and reloads directory', () async {
      const vaultPath = '/path/to/vault';
      const fileName = 'new_file.ntx';

      // Setup state
      when(() => mockSettingsRepository.getSetting('vault_path'))
          .thenAnswer((_) async => vaultPath);
      when(() => mockFileRepository.listItems(any()))
          .thenAnswer((_) async => []);
      when(() => mockFileRepository.getVaultStats(any())).thenAnswer(
          (_) async => const VaultStats(
              fileCount: 0, folderCount: 0, totalSizeBytes: 0));
      when(() => mockSettingsRepository.getSetting('explorer_metadata'))
          .thenAnswer((_) async => null);
      await cubit.initialize();

      when(() => mockFileRepository.createItem(
                name: fileName,
                parentPath: vaultPath,
                type: FileItemType.file,
              ))
          .thenAnswer((_) async =>
              testFile.copyWith(name: fileName, path: '$vaultPath/$fileName'));

      await cubit.createFile(fileName);

      verify(() => mockFileRepository.createItem(
            name: fileName,
            parentPath: vaultPath,
            type: FileItemType.file,
          )).called(1);
    });

    test('deleteItem calls repository and updates state', () async {
      const filePath = '/path/to/vault/file.ntx';
      when(() => mockSettingsRepository.getSetting('explorer_metadata'))
          .thenAnswer((_) async => null);
      when(() => mockFileRepository.deleteItem(filePath))
          .thenAnswer((_) async {});
      when(() => mockFileRepository.listItems(any()))
          .thenAnswer((_) async => []);
      when(() => mockFileRepository.getVaultStats(any())).thenAnswer(
          (_) async => const VaultStats(
              fileCount: 0, folderCount: 0, totalSizeBytes: 0));

      await cubit.deleteItem(filePath);

      verify(() => mockFileRepository.deleteItem(filePath)).called(1);
    });
  });
}
