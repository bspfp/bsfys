import 'package:shared_preferences/shared_preferences.dart';

import 'yamlstore.dart';

class YamlstoreWeb extends YamlStore {
  YamlstoreWeb(super.filename);

  @override
  Future<String> loadFile() async {
    final prefs = await SharedPreferences.getInstance();
    String yamlString = prefs.getString(filename) ?? "";
    if (yamlString.isEmpty) {
      yamlString = "{}";
      await prefs.setString(filename, '{}');
    }
    return yamlString;
  }

  @override
  Future<void> saveFile({required String yamlString, String? backupFilename}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(backupFilename ?? filename, yamlString);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
