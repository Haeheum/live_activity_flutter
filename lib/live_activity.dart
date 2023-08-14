import 'dart:io';

import 'live_activity_platform_interface.dart';
import 'model/live_activity_property.dart';

class LiveActivity implements LiveActivityPlatform {
  /// Whether Live Activity is supported in current device.
  ///
  /// Live Activity is only supported on IOS 16.1+.
  @override
  Future<bool> isActivitySupported() async {
    if (Platform.isIOS) {
      return LiveActivityPlatform.instance.isActivitySupported();
    } else {
      return false;
    }
  }

  /// Creates App Group inside Runner and Extension.
  ///
  /// [init] is pre-required to use this plugin.
  /// Be sure to use valid [appGroupId].
  @override
  Future init({required String appGroupId}) {
    return LiveActivityPlatform.instance.init(appGroupId: appGroupId);
  }

  /// Whether your app can start a Live Activity.
  @override
  Future<bool> isActivityExecutable() {
    return LiveActivityPlatform.instance.isActivityExecutable();
  }

  /// Creates a Live Activity.
  ///
  /// [data] is a map of data that will be used for creating this Live Activity.
  /// Included [LiveActivityImageFromAsset] or [LiveActivityImageFromNetwork] object in [data] is added to App Group.
  /// The parameter [durationHours], [durationMinutes] and [relevanceScore] only affects on IOS 16.2+.
  /// [durationHours] and [durationMinutes] are used summed up to be [durationSumInMinutes].
  /// After the [durationSumInMinutes], the system considers the Live Activity to be out of date.
  /// Maximum [durationSumInMinutes] is 480 minutes (8 hours).
  /// If [durationSumInMinutes] is less than or equal to 0, null value is passed.
  /// [relevanceScore] is a score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app.
  /// If you start more than one Live Activity in your app, the Live Activity with the highest [relevanceScore] appears in the Dynamic Island.
  /// If Live Activities have the same [relevanceScore], the system displays the Live Activity that started first.
  /// Additionally, [relevanceScore] determines the order of your Live Activities on the Lock Screen.
  /// Returns a Live Activity Id when successfully created.
  @override
  Future<String?> createActivity(
      {required Map<String, dynamic> data,
        int? durationHours,
        int? durationMinutes,
        double? relevanceScore}) {
    return LiveActivityPlatform.instance.createActivity(
      data: data,
      durationHours: durationHours,
      durationMinutes: durationMinutes,
      relevanceScore: relevanceScore,
    );
  }

  /// Updates the dynamic content of the Live Activity.
  ///
  /// [data] is a map of data that will be used to update dynamic content of the Live Activity with [activityId].
  /// Whether to [alert] user when updates.
  /// If [alert] is true, [alertTitle] and [alertBody] are used.
  @override
  Future updateActivity(
      {required String activityId,
        required Map<String, dynamic> data,
        bool alert = false,
        String? alertTitle,
        String? alertBody}) {
    if (alert) {
      assert(
      alertTitle != null, 'If alert is true, alertTitle must not be null');
      assert(alertBody != null, 'If alert is true, alertBody must not be null');
    }
    return LiveActivityPlatform.instance.updateActivity(
      activityId: activityId,
      data: data,
      alert: alert,
      alertTitle: alertTitle,
      alertBody: alertBody,
    );
  }

  /// Ends the Live Activity with [activityId] if active.
  @override
  Future endActivity(String activityId) {
    return LiveActivityPlatform.instance.endActivity(activityId);
  }

  /// Ends all active Live Activities.
  @override
  Future endAllActivities() {
    return LiveActivityPlatform.instance.endAllActivities();
  }

  /// Get list of [activityId].
  @override
  Future<List<String>> getAllActivityIds() {
    return LiveActivityPlatform.instance.getAllActivityIds();
  }

  /// Get [LiveActivityState] of the Live Activity with [activityId]
  @override
  Future<LiveActivityState> getActivityState(String activityId) {
    return LiveActivityPlatform.instance.getActivityState(activityId);
  }

  ///Get [LiveActivityProperty] when a Live Activity.
  @override
  Stream<LiveActivityProperty> get activityChangeNotifier =>
      LiveActivityPlatform.instance.activityChangeNotifier;

  @override
  Future clearImagesInAppGroupFolder() async {
    LiveActivityPlatform.instance.clearImagesInAppGroupFolder();
  }
}
