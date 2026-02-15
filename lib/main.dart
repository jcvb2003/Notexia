import 'dart:io';

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

  runApp(
    NotexiaApp(
      documentRepository: sl<DocumentRepository>(),
      fileRepository: sl<FileRepository>(),
      appSettingsRepository: sl<AppSettingsRepository>(),
    ),
  );
}
