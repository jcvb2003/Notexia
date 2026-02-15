import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:notexia/src/app/app.dart';
import 'package:notexia/src/features/drawing/presentation/pages/drawing_page.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_widget.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockFileRepository extends Mock implements FileRepository {}

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

class DrawingDocumentFake extends Fake implements DrawingDocument {}

class CanvasElementFake extends Fake implements CanvasElement {}

final sl = GetIt.instance;

void main() {
  late MockDocumentRepository mockDocRepo;
  late MockFileRepository mockFileRepo;
  late MockAppSettingsRepository mockSettingsRepo;

  setUpAll(() async {
    registerFallbackValue(DrawingDocumentFake());
    registerFallbackValue(CanvasElementFake());

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

    mockDocRepo = MockDocumentRepository();
    mockFileRepo = MockFileRepository();
    mockSettingsRepo = MockAppSettingsRepository();

    when(
      () => mockSettingsRepo.getSetting(any()),
    ).thenAnswer((_) async => null);
    when(() => mockDocRepo.saveDocument(any())).thenAnswer((_) async {});
    when(() => mockDocRepo.saveElement(any(), any())).thenAnswer((_) async {});
  });

  testWidgets('Smoke test: NotexiaApp renders MainLayout and DrawingPage', (
    WidgetTester tester,
  ) async {
    // ForÃ§a um tamanho de tela de desktop para garantir que a sidebar apareÃ§a
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      NotexiaApp(
        documentRepository: mockDocRepo,
        fileRepository: mockFileRepo,
        appSettingsRepository: mockSettingsRepo,
      ),
    );
    await tester.pump(); // Aguarda a renderizaÃ§Ã£o inicial

    // Verifica se a DrawingPage (conteÃºdo) estÃ¡ presente
    expect(find.byType(DrawingPage), findsOneWidget);

    // Verifica se a SidebarWidget estÃ¡ presente
    expect(find.byType(SidebarWidget), findsOneWidget);

    // Limpa a configuraÃ§Ã£o de tela apÃ³s o teste
    addTearDown(tester.view.resetPhysicalSize);
  });
}
