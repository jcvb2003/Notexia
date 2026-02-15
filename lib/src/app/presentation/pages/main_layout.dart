import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
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

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSidebarVisible = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
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
                      left: isDesktop && _isSidebarVisible ? 280 : 0,
                    ),
                    child: DrawingPage(
                      onOpenMenu: isDesktop
                          ? _toggleSidebar
                          : () => _scaffoldKey.currentState?.openDrawer(),
                      isSidebarOpen: isDesktop ? _isSidebarVisible : false,
                    ),
                  ),
                ),
                if (isDesktop)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    top: 0,
                    bottom: 0,
                    left: _isSidebarVisible ? 0 : -280,
                    width: 280,
                    child: const SidebarWidget(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
