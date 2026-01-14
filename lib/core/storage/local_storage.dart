/// Abstract interface for local storage operations
abstract class LocalStorage {
  /// Save a string value with the given key
  Future<void> saveString(String key, String value);

  /// Get a string value by key, returns null if not found
  Future<String?> getString(String key);

  /// Save an integer value with the given key
  Future<void> saveInt(String key, int value);

  /// Get an integer value by key, returns null if not found
  Future<int?> getInt(String key);

  /// Save a boolean value with the given key
  Future<void> saveBool(String key, bool value);

  /// Get a boolean value by key, returns null if not found
  Future<bool?> getBool(String key);

  /// Remove a value by key
  Future<void> remove(String key);

  /// Clear all stored values
  Future<void> clear();

  /// Check if a key exists
  Future<bool> containsKey(String key);
}
