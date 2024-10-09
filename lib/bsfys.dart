library bsfys;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

import 'yamlstore.dart';
import 'yamlstore_default.dart';
import 'yamlstore_web.dart';

class YamlStorage {
  late Map<String, dynamic> _dataMap;
  late YamlStore _store;

  dynamic operator [](String key) => _dataMap[key];
  void operator []=(String key, dynamic value) => _dataMap[key] = value;

  void remove(String key) => _dataMap.remove(key);

  void forEach(Function(String key, dynamic value) f) {
    _dataMap.forEach((key, value) => f(key, value));
  }

  bool findIf(bool Function(String key, dynamic value) f) {
    for (var v in _dataMap.entries) {
      if (f(v.key, v.value)) {
        return true;
      }
    }
    return false;
  }

  Future<void> load(String filename) async {
    _store = kIsWeb ? YamlstoreWeb(filename) : YamlstoreDefault(filename);
    var yaml = await _store.loadFile();
    final yamlMap = loadYaml(yaml);
    _dataMap = yamlMap.map<String, dynamic>((key, value) => MapEntry(key.toString(), value));
  }

  Future<void> save({String? newFilename}) async {
    String yamlString = json2yaml(_dataMap);
    await _store.saveFile(yamlString: yamlString, newFilename: newFilename);
  }
}