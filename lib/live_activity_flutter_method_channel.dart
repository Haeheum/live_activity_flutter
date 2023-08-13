import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'live_activity_flutter_platform_interface.dart';

class MethodChannelLiveActivityFlutter extends LiveActivityFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('live_activity_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
