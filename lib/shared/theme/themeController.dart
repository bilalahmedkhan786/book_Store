import 'package:get/get.dart';
import 'package:hive/hive.dart';

enum ThemeMode { light, dark }

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    // Load the theme mode from Hive on initialization
    final savedThemeMode = Hive.box('bookstore').get('themeMode', defaultValue: ThemeMode.light.toString());
    themeMode.value = ThemeMode.values.firstWhere((mode) => mode.toString() == savedThemeMode);
  }

  void toggleThemeMode() {
    themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // Save the current theme mode to Hive
    Hive.box('bookstore').put('themeMode', themeMode.value.toString());
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    // Save the mode to Hive
    Hive.box('bookstore').put('themeMode', mode.toString());
  }
}
