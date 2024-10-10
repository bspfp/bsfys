import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import 'yamlstore.dart';

class YamlstoreDefault extends YamlStore {
  YamlstoreDefault(super.filename);

  @override
  Future<String> loadFile() async {
    final file = await _makeFile(filename);
    if (await file.exists()) {
      final str = await file.readAsString();
      if (str.isNotEmpty) {
        return str;
      }
    } else {
      await file.create(recursive: true);
    }
    await file.writeAsString('{}');
    return '{}';
  }

  @override
  Future<void> saveFile({required String yamlString, String? backupFilename}) async {
    final file = await _makeFile(backupFilename ?? filename);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(yamlString);
  }

  static Future<File> _makeFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$filename.yaml');
  }
}
