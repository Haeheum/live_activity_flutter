
import 'live_activity_flutter_platform_interface.dart';

class LiveActivityFlutter {
  Future<String?> getPlatformVersion() {
    return LiveActivityFlutterPlatform.instance.getPlatformVersion();
  }
}
