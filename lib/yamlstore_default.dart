import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import 'yamlstore.dart';

class YamlstoreDefault extends YamlStore {
  YamlstoreDefault(super.filename);

  @override
  Future<String> loadFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.yaml');
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
  Future<void> saveFile({required String yamlString, String? newFilename}) async {
    newFilename ??= filename;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$newFilename.yaml');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(yamlString);
  }
}
