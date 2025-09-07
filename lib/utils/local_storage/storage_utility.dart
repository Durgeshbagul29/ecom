import 'package:get_storage/get_storage.dart';

class AppLocalStorage {
  // Singleton instance of AppLocalStorage
  static final AppLocalStorage _instance = AppLocalStorage._internal();

  // Factory constructor to return the same instance (singleton pattern)
  factory AppLocalStorage() {
    return _instance;
  }

  // Private constructor to restrict object creation from outside
  AppLocalStorage._internal();

  // Instance of GetStorage (local storage)
  final _storage = GetStorage();

  // Generic method to save data with a key
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generic method to read data using a key
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Generic method to remove data by key
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Method to clear all stored data
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
