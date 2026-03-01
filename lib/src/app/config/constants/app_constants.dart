/// Global constants for the Notexia application.
class AppConstants {
  // App Info
  static const String appName = 'Notexia';
  static const String appVersion = '1.0.0';

  // UI - Layout
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 8.0;

  // UI - Animation
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Storage
  static const String prefsThemeKey = 'theme_mode';
  static const String prefsLanguageKey = 'app_language';
  static const String prefsAngleSnapEnabledKey = 'angle_snap_enabled';
  static const String prefsAngleSnapStepKey = 'angle_snap_step';

  // Drawing Defaults
  static const double defaultStrokeWidth = 2.0;
  static const double defaultRoughness = 1.0;
  static const double defaultOpacity = 1.0;

  // Element Sizes
  static const double minElementSize = 1.0;
  static const double defaultFontSize = 16.0;

  // Canvas
  static const double maxZoom = 20.0;
  static const double minZoom = 0.1;
  static const double zoomStep = 0.1;
  static const double angleSnapStep = 0.2617993877991494; // math.pi / 12

  // Grid
  static const double gridSize = 20.0;

  // Animation
  static const Duration canvasRefreshRate = Duration(milliseconds: 16);
}
