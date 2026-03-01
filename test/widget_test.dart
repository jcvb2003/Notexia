import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:notexia/src/app/app.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/presentation/pages/drawing_page.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_widget.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/file_management/data/repositories/file_repository.dart';
import 'package:notexia/src/features/settings/data/repositories/app_settings_repository.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:mocktail/mocktail.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockFileRepository extends Mock implements FileRepository {}

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

class DrawingDocumentFake extends Fake implements DrawingDocument {}

class MsgDrawingService extends Mock implements DrawingService {}

class MockPersistenceService extends Mock implements PersistenceService {}

class MockCanvasInteractionDelegate extends Mock
    implements CanvasInteractionDelegate {}

final sl = GetIt.instance;

void main() {
  late MockDocumentRepository mockDocRepo;
  late MockFileRepository mockFileRepo;
  late MockAppSettingsRepository mockSettingsRepo;

  setUpAll(() async {
    registerFallbackValue(DrawingDocumentFake());
    registerFallbackValue(RectangleElement(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    ));

    if (!sl.isRegistered<TransformationService>()) {
      sl.registerLazySingleton<TransformationService>(
        () => TransformationService(),
      );
    }
    if (!sl.isRegistered<CommandStackService>()) {
      sl.registerLazySingleton<CommandStackService>(
        () => CommandStackService(),
      );
    }
    if (!sl.isRegistered<UndoRedoCubit>()) {
      sl.registerLazySingleton<UndoRedoCubit>(
        () => UndoRedoCubit(sl<CommandStackService>()),
      );
    }

    // Register missing services required by MainLayout
    if (!sl.isRegistered<DrawingService>()) {
      sl.registerLazySingleton<DrawingService>(() => MsgDrawingService());
    }
    if (!sl.isRegistered<PersistenceService>()) {
      sl.registerLazySingleton<PersistenceService>(
          () => MockPersistenceService());
    }
    if (!sl.isRegistered<CanvasInteractionDelegate>()) {
      sl.registerLazySingleton<CanvasInteractionDelegate>(
        () => MockCanvasInteractionDelegate(),
      );
    }
    if (!sl.isRegistered<TextEditingDelegate>()) {
      sl.registerLazySingleton<TextEditingDelegate>(
        () => const TextEditingDelegate(),
      );
    }
    if (!sl.isRegistered<ViewportDelegate>()) {
      sl.registerLazySingleton<ViewportDelegate>(
        () => const ViewportDelegate(),
      );
    }
    if (!sl.isRegistered<DrawingDelegate>()) {
      sl.registerLazySingleton<DrawingDelegate>(
        () => const DrawingDelegate(),
      );
    }
    if (!sl.isRegistered<EraserDelegate>()) {
      sl.registerLazySingleton<EraserDelegate>(
        () => const EraserDelegate(),
      );
    }
    if (!sl.isRegistered<SnapDelegate>()) {
      sl.registerLazySingleton<SnapDelegate>(
        () => const SnapDelegate(),
      );
    }

    mockDocRepo = MockDocumentRepository();
    mockFileRepo = MockFileRepository();
    mockSettingsRepo = MockAppSettingsRepository();

    if (!sl.isRegistered<DocumentRepository>()) {
      sl.registerLazySingleton<DocumentRepository>(() => mockDocRepo);
    }
    if (!sl.isRegistered<FileRepository>()) {
      sl.registerLazySingleton<FileRepository>(() => mockFileRepo);
    }
    if (!sl.isRegistered<AppSettingsRepository>()) {
      sl.registerLazySingleton<AppSettingsRepository>(() => mockSettingsRepo);
    }

    when(
      () => mockSettingsRepo.getSetting(any()),
    ).thenAnswer((_) async => null);
    when(() => mockDocRepo.saveDocument(any()))
        .thenAnswer((_) async => Result.success(null));
    when(() => mockDocRepo.saveElement(any(), any()))
        .thenAnswer((_) async => Result.success(null));
  });

  testWidgets('Smoke test: NotexiaApp renders MainLayout and DrawingPage', (
    WidgetTester tester,
  ) async {
    // Força um tamanho de tela de desktop para garantir que a sidebar apareça
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      NotexiaApp(
        documentRepository: mockDocRepo,
        fileRepository: mockFileRepo,
        appSettingsRepository: mockSettingsRepo,
      ),
    );
    await tester.pump(); // Aguarda a renderização inicial

    // Verifica se a DrawingPage (conteúdo) está presente
    expect(find.byType(DrawingPage), findsOneWidget);

    // Verifica se a SidebarWidget está presente
    expect(find.byType(SidebarWidget), findsOneWidget);

    // Limpa a configuração de tela após o teste
    addTearDown(tester.view.resetPhysicalSize);
  });
}
