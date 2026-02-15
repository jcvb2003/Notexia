abstract class AppSettingsRepository {
  Future<void> saveSetting(String key, String value);
  Future<String?> getSetting(String key);
}
