library bsfys;

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

import 'yamlstore.dart';
import 'yamlstore_default.dart';
import 'yamlstore_web.dart';

const _encryptKey = 'T04pIB/8kdQf43avzLLz607wfSfWDKZPjrd0hS1FAyU=';
const _encryptIV = 'B6zH1TrNZbxsw7PTaQ6nVg==';
const _encryptPrefix = 'encrypted';

class YamlStorage {
  Map<String, dynamic> _dataMap = {};
  late YamlStore _store;

  dynamic operator [](String key) => _dataMap[key];
  void operator []=(String key, dynamic value) => _dataMap[key] = value;
  Map<String, dynamic> get doc => _dataMap;

  void remove(String key) => _dataMap.remove(key);

  Future<void> load(String filename) async {
    _store = _openStore(filename);
    var yaml = await _store.loadFile();
    if (yaml.startsWith(_encryptPrefix)) {
      final encrypted = yaml.substring(_encryptPrefix.length);
      final key = Key.fromBase64(_encryptKey);
      final iv = IV.fromBase64(_encryptIV);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
      yaml = decrypted;
    }
    final yamlMap = loadYaml(yaml);
    _dataMap = _convertMapValue(yamlMap);
  }

  Future<void> save({String? backupFilename, bool encrypt = false}) async {
    var store = backupFilename != null ? _openStore(backupFilename) : _store;
    String yamlString = json2yaml(_dataMap);
    if (encrypt) {
      final key = Key.fromBase64(_encryptKey);
      final iv = IV.fromBase64(_encryptIV);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(yamlString, iv: iv);
      yamlString = '$_encryptPrefix${encrypted.base64}';
    }
    await store.saveFile(yamlString: yamlString, backupFilename: backupFilename);
  }

  static Future<void> clearAll() async {
    if (!kIsWeb) throw UnsupportedError('clearAll() is not supported on this platform');
    await YamlstoreWeb.clearAll();
  }

  YamlStore _openStore(String filename) => kIsWeb ? YamlstoreWeb(filename) : YamlstoreDefault(filename);

  dynamic _convertMapValue(dynamic value) {
    if (value is YamlMap) {
      return value.map<String, dynamic>((key, value) {
        return MapEntry(key.toString(), _convertMapValue(value));
      });
    }
    return value;
  }
}
