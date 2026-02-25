import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/pages/drawing_page.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

import 'package:notexia/src/app/di/service_locator/service_locator.dart';

import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';

enum ContentView { drawing, text, pdf }

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSidebarVisible = true;
  ContentView _currentView = ContentView.drawing;

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  // ignore: unused_element
  void _switchView(ContentView view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final initialDoc = DrawingDocument(
              id: 'default-doc',
              title: 'Drawing ${DateTime.now().toString().split(' ')[0]}',
              elements: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            final cubit = CanvasCubit(
              sl<DocumentRepository>(),
              sl<CommandStackService>(),
              sl<DrawingService>(),
              sl<PersistenceService>(),
              sl<ElementManipulationDelegate>(),
              sl<SelectionDelegate>(),
              sl<TextEditingDelegate>(),
              sl<ViewportDelegate>(),
              sl<DrawingDelegate>(),
              sl<EraserDelegate>(),
              sl<SnapDelegate>(),
              initialDoc,
              appSettingsRepository: sl<AppSettingsRepository>(),
            );
            cubit.loadAngleSnapSettings();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => sl<UndoRedoCubit>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 640;

          return Scaffold(
            key: _scaffoldKey,
            drawer: !isDesktop ? const SidebarWidget(isMobile: true) : null,
            body: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    padding: EdgeInsets.only(
                      left: isDesktop && _isSidebarVisible
                          ? AppSizes.sidebarWidth
                          : 0,
                    ),
                    child: _buildCurrentView(isDesktop),
                  ),
                ),
                if (isDesktop)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    top: 0,
                    bottom: 0,
                    left: _isSidebarVisible ? 0 : -AppSizes.sidebarWidth,
                    width: AppSizes.sidebarWidth,
                    child: SidebarWidget(
                        // Pass view switching callbacks if/when Sidebar is updated
                        ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentView(bool isDesktop) {
    switch (_currentView) {
      case ContentView.drawing:
        return DrawingPage(
          onOpenMenu: isDesktop
              ? _toggleSidebar
              : () => _scaffoldKey.currentState?.openDrawer(),
          isSidebarOpen: isDesktop ? _isSidebarVisible : false,
        );
      case ContentView.text:
        return Center(
          child: Text(
            'Text Editor (Coming Soon)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
      case ContentView.pdf:
        return Center(
          child: Text(
            'PDF Reader (Coming Soon)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }
  }
}
