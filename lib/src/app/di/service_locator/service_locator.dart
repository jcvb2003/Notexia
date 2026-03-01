import 'package:get_it/get_it.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';
import 'package:notexia/src/features/drawing/data/repositories/asset_repository.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/file_management/data/repositories/file_repository.dart';
import 'package:notexia/src/features/settings/data/repositories/app_settings_repository.dart';
import 'package:notexia/src/features/settings/domain/services/user_colors_storage.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';

final sl = GetIt.instance;

/// Setup the service locator for dependency injection.
/// This should be called in main.dart before runApp.
Future<void> initServiceLocator() async {
  // --- Services ---
  sl.registerLazySingleton<GeometryService>(() => GeometryService());
  sl.registerLazySingleton<TransformationService>(
    () => TransformationService(),
  );
  sl.registerLazySingleton<CanvasManipulationService>(
    () => CanvasManipulationService(sl<TransformationService>()),
  );
  sl.registerLazySingleton<DrawingService>(
    () => DrawingService(
        canvasManipulationService: sl<CanvasManipulationService>()),
  );
  sl.registerLazySingleton<CanvasInteractionDelegate>(
    () => CanvasInteractionDelegate(
      sl<CanvasManipulationService>(),
      sl<TransformationService>(),
    ),
  );
  sl.registerLazySingleton<TextEditingDelegate>(
      () => const TextEditingDelegate());
  sl.registerLazySingleton<ViewportDelegate>(() => const ViewportDelegate());

  sl.registerLazySingleton<DrawingDelegate>(() => const DrawingDelegate());
  sl.registerLazySingleton<EraserDelegate>(() => const EraserDelegate());
  sl.registerLazySingleton<SnapDelegate>(() => const SnapDelegate());

  // --- Core / Infrastructure ---
  final dbService = DatabaseService();
  sl.registerLazySingleton<DatabaseService>(() => dbService);

  // --- Feature Modules ---

  // Drawing Feature
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepository(sl<DatabaseService>()),
  );
  sl.registerLazySingleton<PersistenceService>(
    () => PersistenceService(sl<DocumentRepository>()),
  );
  sl.registerLazySingleton<AssetRepository>(() => AssetRepository());

  // File Management Feature
  sl.registerLazySingleton<FileRepository>(() => FileRepository());

  // Settings Feature
  sl.registerLazySingleton<AppSettingsRepository>(
    () => AppSettingsRepository(sl<DatabaseService>()),
  );
  sl.registerLazySingleton<UserColorsStorage>(() => UserColorsStorage());

  // Undo Redo Feature
  sl.registerLazySingleton<CommandStackService>(() => CommandStackService());
  sl.registerLazySingleton<UndoRedoCubit>(
    () => UndoRedoCubit(sl<CommandStackService>()),
  );
}
