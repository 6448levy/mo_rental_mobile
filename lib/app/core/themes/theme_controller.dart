import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Observable for UI updates
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load the saved theme preference on startup
    isDarkMode.value = _loadThemeFromBox();
  }

  // Get current theme mode
  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // Load from storage
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // Save to storage
  _saveThemeToBox(bool isDark) => _box.write(_key, isDark);

  // Toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(theme);
    _saveThemeToBox(isDarkMode.value);
  }
}
