import 'dart:io';

import 'package:window_manager/window_manager.dart';

import 'package:flutter/material.dart';
import 'package:notexia/src/app/app.dart';
import 'package:notexia/src/app/di/service_locator/service_locator.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize dependency injection
  await initServiceLocator();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1024, 768),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    NotexiaApp(
      documentRepository: sl<DocumentRepository>(),
      fileRepository: sl<FileRepository>(),
      appSettingsRepository: sl<AppSettingsRepository>(),
    ),
  );
}
