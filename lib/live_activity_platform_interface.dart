import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'live_activity_method_channel.dart';
import 'model/live_activity_property.dart';

abstract class LiveActivityPlatform extends PlatformInterface {
  /// Constructs a LiveActivitiesPlatform.
  LiveActivityPlatform() : super(token: _token);
  static final Object _token = Object();
  static LiveActivityPlatform _instance = LiveActivityMethodChannel();

  /// The default instance of [LiveActivitiesPlatform] to use.
  ///
  /// Defaults to [MethodChannelLiveActivities].
  static LiveActivityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LiveActivitiesPlatform] when
  /// they register themselves.
  static set instance(LiveActivityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isActivitySupported() {
    throw UnimplementedError('isActivitySupported() has not been implemented.');
  }

  Future init({required String appGroupId}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool> isActivityExecutable() {
    throw UnimplementedError(
        'isActivityExecutable() has not been implemented.');
  }

  Future<String?> createActivity({
    required Map<String, dynamic> data,
    double? relevanceScore,
    int durationHours = 0,
    int durationMinutes = 0,
  }) {
    throw UnimplementedError('isActivitySupported() has not been implemented.');
  }

  Future updateActivity({
    required String activityId,
    required Map<String, dynamic> data,
    bool alert = false,
    String? alertTitle,
    String? alertBody,
  }) {
    throw UnimplementedError('updateActivity() has not been implemented.');
  }

  Future endActivity(String activityId) {
    throw UnimplementedError('endActivity() has not been implemented.');
  }

  Future endAllActivities() {
    throw UnimplementedError('endAllActivities() has not been implemented.');
  }

  Future<List<String>> getAllActivityIds() {
    throw UnimplementedError('getAllActivityIds() has not been implemented.');
  }

  Future<LiveActivityState> getActivityState(String activityId) {
    throw UnimplementedError('getActivityState() has not been implemented.');
  }

  Stream<LiveActivityProperty> get activityChangeNotifier =>
      throw UnimplementedError('onActivityUpdate() has not been implemented.');

  Future<void> clearImagesInAppGroupFolder() {
    throw UnimplementedError(
        'clearImagesInAppGroupFolder() has not been implemented.');
  }
}
