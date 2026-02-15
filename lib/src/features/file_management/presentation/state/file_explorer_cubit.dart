import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:path/path.dart' as p;

class FileExplorerCubit extends Cubit<FileExplorerState> {
  final FileRepository _fileRepository;
  final AppSettingsRepository _settingsRepository;

  FileExplorerCubit(this._fileRepository, this._settingsRepository)
    : super(const FileExplorerState());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final savedPath = await _settingsRepository.getSetting('vault_path');

      if (savedPath == null || savedPath.isEmpty) {
        emit(
          state.copyWith(
            treeCache: const {},
            expandedPaths: const {},
            vaultPath: '',
            vaultName: '',
            stats: null,
            isLoading: false,
            error: null,
          ),
        );
        return;
      }

      final rootItems = await _fileRepository.listItems(savedPath);
      final stats = await _fileRepository.getVaultStats(savedPath);

      emit(
        state.copyWith(
          treeCache: {savedPath: rootItems},
          expandedPaths: const {},
          vaultPath: savedPath,
          vaultName: p.basename(savedPath),
          stats: stats,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao inicializar: $e'));
    }
  }

  Future<void> pickVaultDirectory() async {
    try {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Selecionar pasta do Vault (Notexia)',
      );

      if (selectedDirectory == null) return;

      await _settingsRepository.saveSetting('vault_path', selectedDirectory);
      await initialize();
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao selecionar pasta: $e'));
    }
  }

  Future<void> toggleFolder(String path) async {
    if (state.isExpanded(path)) {
      final updatedExpanded = Set<String>.from(state.expandedPaths)
        ..remove(path);
      emit(state.copyWith(expandedPaths: updatedExpanded));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final items = await _fileRepository.listItems(path);
      final updatedCache = Map<String, List<FileItem>>.from(state.treeCache)
        ..[path] = items;
      final updatedExpanded = Set<String>.from(state.expandedPaths)..add(path);

      emit(
        state.copyWith(
          treeCache: updatedCache,
          expandedPaths: updatedExpanded,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Erro ao carregar pasta: $e'),
      );
    }
  }

  Future<void> createFolder(String name, {String? parentPath}) async {
    if (state.vaultPath.isEmpty) {
      emit(
        state.copyWith(
          error: 'Defina uma pasta do Vault antes de criar pastas',
        ),
      );
      return;
    }

    final target = parentPath ?? state.vaultPath;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _fileRepository.createItem(
        name: name,
        parentPath: target,
        type: FileItemType.folder,
      );

      await _reloadDirectory(target);
      await _refreshStats();

      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao criar pasta: $e'));
    }
  }

  Future<void> createFile(String name, {String? parentPath}) async {
    if (state.vaultPath.isEmpty) {
      emit(
        state.copyWith(
          error: 'Defina uma pasta do Vault antes de criar arquivos',
        ),
      );
      return;
    }

    final target = parentPath ?? state.vaultPath;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _fileRepository.createItem(
        name: name,
        parentPath: target,
        type: FileItemType.file,
      );

      await _reloadDirectory(target);
      await _refreshStats();

      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Erro ao criar arquivo: $e'),
      );
    }
  }

  Future<String?> readFile(String path) async {
    try {
      return await _fileRepository.readFile(path);
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao ler arquivo: $e'));
      return null;
    }
  }

  Future<void> renameItem(String path, String newName) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedItem = await _fileRepository.renameItem(path, newName);

      // Migrar metadata se existir
      final metadata = await _loadMetadata();
      if (metadata.containsKey(path)) {
        final itemData = metadata[path]!;
        metadata.remove(path);
        metadata[updatedItem.path] = itemData;
        await _saveMetadata(metadata);
      }

      await _reloadDirectory(p.dirname(path));
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao renomear: $e'));
    }
  }

  Future<void> deleteItem(String path) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _fileRepository.deleteItem(path);

      // Remover metadata
      final metadata = await _loadMetadata();
      if (metadata.containsKey(path)) {
        metadata.remove(path);
        await _saveMetadata(metadata);
      }

      await _reloadDirectory(p.dirname(path));
      await _refreshStats();
      emit(state.copyWith(isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao excluir: $e'));
    }
  }

  Future<void> updateItemMetadata(
    String path, {
    String? icon,
    int? color,
  }) async {
    try {
      final metadata = await _loadMetadata();
      final current = metadata[path] ?? {};

      if (icon != null) current['icon'] = icon;
      if (color != null) current['color'] = color.toString();

      metadata[path] = current;
      await _saveMetadata(metadata);

      await _reloadDirectory(p.dirname(path));
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao atualizar metadata: $e'));
    }
  }

  Future<Map<String, Map<String, String>>> _loadMetadata() async {
    final raw = await _settingsRepository.getSetting('explorer_metadata');
    if (raw == null || raw.isEmpty) return {};
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return data.map(
        (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveMetadata(Map<String, Map<String, String>> metadata) async {
    await _settingsRepository.saveSetting(
      'explorer_metadata',
      jsonEncode(metadata),
    );
  }

  Future<void> _reloadDirectory(String path) async {
    final items = await _fileRepository.listItems(path);
    final metadata = await _loadMetadata();

    final enrichedItems = items.map((item) {
      final data = metadata[item.path];
      if (data != null) {
        return item.copyWith(
          customIcon: data['icon'],
          customColor: data['color'] != null
              ? int.tryParse(data['color']!)
              : null,
        );
      }
      return item;
    }).toList();

    final updatedCache = Map<String, List<FileItem>>.from(state.treeCache)
      ..[path] = enrichedItems;
    emit(state.copyWith(treeCache: updatedCache));
  }

  Future<void> _refreshStats() async {
    if (state.vaultPath.isEmpty) return;
    final stats = await _fileRepository.getVaultStats(state.vaultPath);
    emit(state.copyWith(stats: stats));
  }
}
