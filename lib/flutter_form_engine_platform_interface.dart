import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_form_engine_method_channel.dart';

abstract class FlutterFormEnginePlatform extends PlatformInterface {
  /// Constructs a FlutterFormEnginePlatform.
  FlutterFormEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFormEnginePlatform _instance = MethodChannelFlutterFormEngine();

  /// The default instance of [FlutterFormEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFormEngine].
  static FlutterFormEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFormEnginePlatform] when
  /// they register themselves.
  static set instance(FlutterFormEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
