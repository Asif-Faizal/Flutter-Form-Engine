
import 'flutter_form_engine_platform_interface.dart';

class FlutterFormEngine {
  Future<String?> getPlatformVersion() {
    return FlutterFormEnginePlatform.instance.getPlatformVersion();
  }
}
