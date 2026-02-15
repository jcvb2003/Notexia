import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/app/config/themes/notexia_colors.dart';
import 'package:notexia/src/app/config/routes/app_router.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class NotexiaApp extends StatelessWidget {
  final DocumentRepository documentRepository;
  final FileRepository fileRepository;
  final AppSettingsRepository appSettingsRepository;

  const NotexiaApp({
    super.key,
    required this.documentRepository,
    required this.fileRepository,
    required this.appSettingsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DocumentRepository>.value(value: documentRepository),
        RepositoryProvider<FileRepository>.value(value: fileRepository),
        RepositoryProvider<AppSettingsRepository>.value(
          value: appSettingsRepository,
        ),
      ],
      child: MaterialApp(
        title: 'Notexia',
        debugShowCheckedModeBanner: false,
        theme: NotexiaTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.initialRoute,
      ),
    );
  }
}
