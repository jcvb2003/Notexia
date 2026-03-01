import 'package:equatable/equatable.dart';

/// Entidade representando um item no sistema de arquivos (arquivo ou pasta).
class FileItem extends Equatable {
  final String id;
  final String name;
  final String path;
  final FileItemType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? sizeBytes;
  final String? parentId;
  final String? customIcon;
  final int? customColor;

  const FileItem({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.sizeBytes,
    this.parentId,
    this.customIcon,
    this.customColor,
  });

  bool get isFolder => type == FileItemType.folder;
  bool get isFile => type == FileItemType.file;

  FileItem copyWith({
    String? id,
    String? name,
    String? path,
    FileItemType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sizeBytes,
    String? parentId,
    String? customIcon,
    int? customColor,
  }) {
    return FileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      parentId: parentId ?? this.parentId,
      customIcon: customIcon ?? this.customIcon,
      customColor: customColor ?? this.customColor,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        path,
        type,
        createdAt,
        updatedAt,
        sizeBytes,
        parentId,
        customIcon,
        customColor,
      ];
}

/// Tipos de itens no sistema de arquivos.
enum FileItemType { file, folder, drawing }

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
