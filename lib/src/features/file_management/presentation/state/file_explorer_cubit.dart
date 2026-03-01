import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/data/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/features/settings/data/repositories/app_settings_repository.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class FileExplorerCubit extends Cubit<FileExplorerState> {
  final FileRepository _fileRepository;
  final AppSettingsRepository _settingsRepository;

  FileExplorerCubit(this._fileRepository, this._settingsRepository)
      : super(const FileExplorerState());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final savedPath = await _settingsRepository.getSetting('vault_path');
      final savedSortModeRaw =
          await _settingsRepository.getSetting('explorer_sort_mode');
      final savedSortDirRaw =
          await _settingsRepository.getSetting('explorer_sort_dir');

      final initSortMode = SortMode.values.firstWhere(
        (e) => e.name == savedSortModeRaw,
        orElse: () => SortMode.name,
      );
      final initSortDir = SortDirection.values.firstWhere(
        (e) => e.name == savedSortDirRaw,
        orElse: () => SortDirection.ascending,
      );

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
            sortMode: initSortMode,
            sortDir: initSortDir,
          ),
        );
        return;
      }

      final rootItemsResult = await _fileRepository.listItems(savedPath);
      final statsResult = await _fileRepository.getVaultStats(savedPath);

      if (rootItemsResult.isFailure || statsResult.isFailure) {
        emit(state.copyWith(
          isLoading: false,
          error:
              'Erro ao inicializar vault: ${rootItemsResult.failure?.message ?? statsResult.failure?.message}',
          sortMode: initSortMode,
          sortDir: initSortDir,
        ));
        return;
      }

      final rootItems =
          _sorted(rootItemsResult.data!, mode: initSortMode, dir: initSortDir);
      final stats = statsResult.data!;

      emit(
        state.copyWith(
          treeCache: {savedPath: rootItems},
          expandedPaths: const {},
          vaultPath: savedPath,
          vaultName: p.basename(savedPath),
          stats: stats,
          isLoading: false,
          error: null,
          sortMode: initSortMode,
          sortDir: initSortDir,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao inicializar: $e'));
    }
  }

  Future<void> setSortMode(SortMode mode) async {
    final newDir =
        (state.sortMode == mode && state.sortDir == SortDirection.ascending)
            ? SortDirection.descending
            : SortDirection.ascending;

    emit(state.copyWith(sortMode: mode, sortDir: newDir));

    await _settingsRepository.saveSetting('explorer_sort_mode', mode.name);
    await _settingsRepository.saveSetting('explorer_sort_dir', newDir.name);

    final updatedCache = <String, List<FileItem>>{};
    for (final entry in state.treeCache.entries) {
      updatedCache[entry.key] = _sorted(entry.value);
    }

    emit(state.copyWith(treeCache: updatedCache));
  }

  List<FileItem> _sorted(List<FileItem> items,
      {SortMode? mode, SortDirection? dir}) {
    final m = mode ?? state.sortMode;
    final d = dir ?? state.sortDir;

    final sorted = [...items];
    sorted.sort((a, b) {
      if (a.isFolder && !b.isFolder) return -1;
      if (!a.isFolder && b.isFolder) return 1;

      final cmp = switch (m) {
        SortMode.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        SortMode.createdAt => a.createdAt.compareTo(b.createdAt),
        SortMode.updatedAt => a.updatedAt.compareTo(b.updatedAt),
      };
      return d == SortDirection.ascending ? cmp : -cmp;
    });
    return sorted;
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
      final itemsResult = await _fileRepository.listItems(path);
      if (itemsResult.isFailure) {
        emit(state.copyWith(
            isLoading: false,
            error: 'Erro ao carregar pasta: ${itemsResult.failure?.message}'));
        return;
      }

      final items = _sorted(itemsResult.data!);
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
      final createResult = await _fileRepository.createItem(
        name: name,
        parentPath: target,
        type: FileItemType.folder,
      );

      if (createResult.isFailure) {
        emit(state.copyWith(
            isLoading: false, error: createResult.failure?.message));
        return;
      }

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
      final createResult = await _fileRepository.createItem(
        name: name,
        parentPath: target,
        type: FileItemType.file,
      );

      if (createResult.isFailure) {
        emit(state.copyWith(
            isLoading: false, error: createResult.failure?.message));
        return;
      }

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
      final result = await _fileRepository.readFile(path);
      if (result.isSuccess) {
        return result.data;
      } else {
        emit(state.copyWith(
            error: 'Erro ao ler arquivo: ${result.failure?.message}'));
        return null;
      }
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao ler arquivo: $e'));
      return null;
    }
  }

  Future<void> renameItem(String path, String newName) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedItemResult = await _fileRepository.renameItem(path, newName);
      if (updatedItemResult.isFailure) {
        emit(state.copyWith(
            isLoading: false,
            error: 'Erro ao renomear: ${updatedItemResult.failure?.message}'));
        return;
      }
      final updatedItem = updatedItemResult.data!;

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
      final deleteResult = await _fileRepository.deleteItem(path);
      if (deleteResult.isFailure) {
        emit(state.copyWith(
            isLoading: false,
            error: 'Erro ao excluir: ${deleteResult.failure?.message}'));
        return;
      }

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

  Future<void> showInFolder(String path) async {
    try {
      final parentDir = p.dirname(path);
      final uri = Uri.directory(parentDir);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        emit(state.copyWith(
            error: 'Não foi possível abrir a localização do arquivo'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao abrir no sistema: $e'));
    }
  }

  Future<void> searchInFolder(String path) async {
    // Placeholder para futura feature de busca
    // Idealmente, emitiria um estado para focar o file explorer
    // e configurar o escopo de busca.
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
    final itemsResult = await _fileRepository.listItems(path);
    if (itemsResult.isFailure) return;
    final items = itemsResult.data!;

    final metadata = await _loadMetadata();

    final enrichedItems = items.map((item) {
      final data = metadata[item.path];
      if (data != null) {
        return item.copyWith(
          customIcon: data['icon'],
          customColor:
              data['color'] != null ? int.tryParse(data['color']!) : null,
        );
      }
      return item;
    }).toList();

    final updatedCache = Map<String, List<FileItem>>.from(state.treeCache)
      ..[path] = _sorted(enrichedItems);
    emit(state.copyWith(treeCache: updatedCache));
  }

  Future<void> _refreshStats() async {
    if (state.vaultPath.isEmpty) return;
    final statsResult = await _fileRepository.getVaultStats(state.vaultPath);
    if (statsResult.isSuccess) {
      emit(state.copyWith(stats: statsResult.data!));
    }
  }
}
