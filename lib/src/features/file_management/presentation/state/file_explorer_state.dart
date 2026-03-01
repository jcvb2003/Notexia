import 'package:equatable/equatable.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';

enum SortMode { name, createdAt, updatedAt }

enum SortDirection { ascending, descending }

class FileExplorerState extends Equatable {
  final Map<String, List<FileItem>> treeCache;
  final Set<String> expandedPaths;
  final String vaultPath;
  final String vaultName;
  final VaultStats? stats;
  final bool isLoading;
  final String? error;
  final SortMode sortMode;
  final SortDirection sortDir;

  const FileExplorerState({
    this.treeCache = const {},
    this.expandedPaths = const {},
    this.vaultPath = '',
    this.vaultName = '',
    this.stats,
    this.isLoading = false,
    this.error,
    this.sortMode = SortMode.name,
    this.sortDir = SortDirection.ascending,
  });

  List<FileItem> get rootItems => treeCache[vaultPath] ?? const [];

  List<FileItem> childrenOf(String path) => treeCache[path] ?? const [];

  bool isExpanded(String path) => expandedPaths.contains(path);

  FileExplorerState copyWith({
    Map<String, List<FileItem>>? treeCache,
    Set<String>? expandedPaths,
    String? vaultPath,
    String? vaultName,
    VaultStats? stats,
    bool? isLoading,
    String? error,
    SortMode? sortMode,
    SortDirection? sortDir,
  }) {
    return FileExplorerState(
      treeCache: treeCache ?? this.treeCache,
      expandedPaths: expandedPaths ?? this.expandedPaths,
      vaultPath: vaultPath ?? this.vaultPath,
      vaultName: vaultName ?? this.vaultName,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sortMode: sortMode ?? this.sortMode,
      sortDir: sortDir ?? this.sortDir,
    );
  }

  @override
  List<Object?> get props => [
        treeCache,
        expandedPaths,
        vaultPath,
        vaultName,
        stats,
        isLoading,
        error,
        sortMode,
        sortDir,
      ];
}
