import 'package:bsfys/bsfys.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_io/io.dart';

void main() async {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return './';
        }
        return null;
      },
    );

    final file = File('./test.yaml');
    if (await file.exists()) {
      await file.delete();
    }
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );

    final file = File('./test.yaml');
    if (await file.exists()) {
      await file.delete();
    }
  });

  test('load-get-set-del-save-load', () async {
    final ys = YamlStorage();
    await ys.load('test');
    expect(ys['key1'], null);
    ys['key1'] = 'value1';
    expect(ys['key1'], 'value1');
    ys['key1'] = 'value2';
    expect(ys['key1'], 'value2');
    ys['key2'] = 1234;
    expect(ys['key2'], 1234);
    ys.remove('key2');
    expect(ys['key2'], null);
    await ys.save();

    final ys2 = YamlStorage();
    await ys2.load('test');
    expect(ys2['key1'], 'value2');
  });
}
