import 'package:flutter/services.dart';

import 'live_activity_image_service.dart';
import 'live_activity_platform_interface.dart';
import 'model/live_activity_property.dart';

/// An implementation of [LiveActivityPlatform] that uses method channels.
class LiveActivityMethodChannel extends LiveActivityPlatform {
  /// The method channel used to interact with the native platform.

  final LiveActivityImageService _liveActivityImageService =
  LiveActivityImageService();
  final methodChannel = const MethodChannel('live_activity');
  final activityListenableChannel = const EventChannel('live_activity/listen');
  /// Whether [init] has been completed.
  bool _initComplete = false;

  @override
  Future<bool> isActivitySupported() async {
    return await methodChannel.invokeMethod<bool>('isActivitySupported') ??
        false;
  }

  @override
  Future init({required String appGroupId}) async {
    _liveActivityImageService.init(appGroupId);
    await methodChannel.invokeMethod('init', {
      'appGroupId': appGroupId,
    });
    _initComplete = true;
  }

  @override
  Future<bool> isActivityExecutable() async {
    assert(_initComplete, 'init required');
    return await methodChannel.invokeMethod<bool>('isActivityExecutable') ??
        false;
  }

  @override
  Future<String?> createActivity(
      {required Map<String, dynamic> data,
        int durationHours = 0,
        int durationMinutes = 0,
        double? relevanceScore}) async {
    assert(_initComplete, 'init required');
    await _liveActivityImageService.addImageToAppGroup(data);
    int? durationSumInMinutes = (durationHours * 60) + durationMinutes;

    // Maximum 480 minutes(8 hours).
    if (durationSumInMinutes > 480) durationSumInMinutes = 480;
    // If the durationSumInMinutes is less than or equal to 0, null value is passed.
    if (durationSumInMinutes <= 0) durationSumInMinutes = null;

    return methodChannel.invokeMethod<String>('createActivity', {
      'data': data,
      'durationSumInMinutes': durationSumInMinutes,
      'relevanceScore': relevanceScore
    });
  }

  @override
  Future updateActivity(
      {required String activityId,
        required Map<String, dynamic> data,
        bool alert = false,
        String? alertTitle,
        String? alertBody}) async {
    assert(_initComplete, 'init required');
    await _liveActivityImageService.addImageToAppGroup(data);
    return methodChannel.invokeMethod('updateActivity', {
      'activityId': activityId,
      'data': data,
      'alert': alert,
      'alertTitle': alertTitle,
      'alertBody': alertBody,
    });
  }

  @override
  Future endActivity(String activityId) {
    assert(_initComplete, 'init required');
    return methodChannel.invokeMethod('endActivity', {
      'activityId': activityId,
    });
  }

  @override
  Future endAllActivities() {
    assert(_initComplete, 'init required');
    return methodChannel.invokeMethod('endAllActivities');
  }

  @override
  Future<List<String>> getAllActivityIds() async {
    assert(_initComplete, 'init required');
    return await methodChannel
        .invokeListMethod<String>('getAllActivitiesIds') ??
        [];
  }

  @override
  Future<LiveActivityState> getActivityState(String activityId) async {
    assert(_initComplete, 'init required');
    final result = await methodChannel.invokeMethod<String>(
      'getActivityState',
      {
        'activityId': activityId,
      },
    );
    return LiveActivityState.values.byName(result ?? 'dismissed');
  }

  @override
  Stream<LiveActivityProperty> get activityChangeNotifier =>
      activityListenableChannel
          .receiveBroadcastStream('onActivityChange')
          .distinct()
          .map(
            (event) => LiveActivityProperty.fromMap(
          Map<String, dynamic>.from(event),
        ),
      );

  @override
  Future<void> clearImagesInAppGroupFolder() async {
    assert(_initComplete, 'init required');
    _liveActivityImageService.removeImages();
  }
}
