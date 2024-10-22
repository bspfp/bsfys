library bsfys;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

import 'yamlstore.dart';
import 'yamlstore_default.dart';
import 'yamlstore_web.dart';

class YamlStorage {
  Map<String, dynamic> _dataMap = {};
  late YamlStore _store;

  dynamic operator [](String key) => _dataMap[key];
  void operator []=(String key, dynamic value) => _dataMap[key] = value;
  Map<String, dynamic> get doc => _dataMap;

  void remove(String key) => _dataMap.remove(key);

  Future<void> load(String filename) async {
    _store = kIsWeb ? YamlstoreWeb(filename) : YamlstoreDefault(filename);
    var yaml = await _store.loadFile();
    final yamlMap = loadYaml(yaml);
    _dataMap = _convertMapValue(yamlMap);
  }

  Future<void> save({String? backupFilename}) async {
    String yamlString = json2yaml(_dataMap);
    await _store.saveFile(yamlString: yamlString, backupFilename: backupFilename);
  }

  static Future<void> clearAll() async {
    if (!kIsWeb) throw UnsupportedError('clearAll() is not supported on this platform');
    await YamlstoreWeb.clearAll();
  }

  dynamic _convertMapValue(dynamic value) {
    if (value is YamlMap) {
      return value.map<String, dynamic>((key, value) {
        return MapEntry(key.toString(), _convertMapValue(value));
      });
    }
    return value;
  }
}
