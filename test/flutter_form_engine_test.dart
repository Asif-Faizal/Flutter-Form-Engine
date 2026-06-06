import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';
import 'package:flutter_form_engine/flutter_form_engine_platform_interface.dart';
import 'package:flutter_form_engine/flutter_form_engine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFormEnginePlatform
    with MockPlatformInterfaceMixin
    implements FlutterFormEnginePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFormEnginePlatform initialPlatform = FlutterFormEnginePlatform.instance;

  test('$MethodChannelFlutterFormEngine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFormEngine>());
  });

  test('getPlatformVersion', () async {
    FlutterFormEngine flutterFormEnginePlugin = FlutterFormEngine();
    MockFlutterFormEnginePlatform fakePlatform = MockFlutterFormEnginePlatform();
    FlutterFormEnginePlatform.instance = fakePlatform;

    expect(await flutterFormEnginePlugin.getPlatformVersion(), '42');
  });
}
