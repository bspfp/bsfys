# bsfys

(BS) (F)lutter (Y)AML (S)torage

BS가 만든 Flutter 프로젝트를 위한 YAML 저장소

(A simple YAML storage for Flutter projects created by BS.)

간단한 앱을 작성할 때 DB 대용으로 사용할 용도로 만들었습니다.

(The purpose of using this as a DB when writing a simple app.)

## 사용법 (Usage)

아래 내용을 `pubspec.yaml` 파일에 추가하세요.

(Adds the following dependencies to the Flutter project's `pubspec.yaml` file)

```yaml
dependencies:
  flutter:
    sdk: flutter

  bsfys:
    git:
      url: https://github.com/bspfp/bsfys.git
      ref: main
```

패키지를 가져오기 위해 아래 명령어를 실행하세요.

(Run the following command to import the package)

```bash
$ flutter pub get
```

## 기능 설명 (Description)

```dart
class YamlStorage {
  // key에 해당하는 값을 반환합니다.
  // Returns the value corresponding to the key.
  dynamic operator [](String key);

  // key에 해당하는 값을 설정합니다.
  // Sets the value corresponding to the key.
  void operator []=(String key, dynamic value);

  // 데이터 전체를 반환합니다.
  // Returns all data.
  Map<String, dynamic> get doc;

  // key에 해당하는 값을 삭제합니다.
  // Deletes the value corresponding to the key.
  void remove(String key);

  // 파일에서 읽기 (Load from file)
  Future<void> load(String filename) async;

  // 파일에 저장합니다.
  // backupFilename이 지정되면 백업 파일에 저장합니다.
  // Saves to the file.
  // If backupFilename is specified, save to the backup file.
  Future<void> save({String? backupFilename}) async;

  // 모든 데이터를 삭제합니다. 이 기능은 Web 플랫폼에서만 작동합니다.
  // Clears all data. This function only works on the Web platform.
  static Future<void> clearAll() async;
}
```

## 예제 (Example)

```dart
  test('load-get-set-del-save-load', () async {
    // 저장소를 생성 (Create a storage)
    final ys = YamlStorage();

    // 파일에서 읽기 (Load from file)
    await ys.load('test');

    // 값 가져오기 (Get a value)
    expect(ys['key1'], null);

    // 값 설정하기 (Set a value)
    ys['key1'] = 'value1';
    expect(ys['key1'], 'value1');
    ys['key1'] = 'value2';
    expect(ys['key1'], 'value2');
    ys['key2'] = 1234;
    expect(ys['key2'], 1234);

    // 값 삭제
    ys.remove('key2');
    expect(ys['key2'], null);

    // 파일에 저장 (Save to file)
    await ys.save();

    final ys2 = YamlStorage();
    await ys2.load('test');
    expect(ys2['key1'], 'value2');
  });
```