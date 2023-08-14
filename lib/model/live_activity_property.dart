class LiveActivityProperty{

  String? activityId;
  String? pushToken;
  LiveActivityState? liveActivityState;

  LiveActivityProperty.fromMap(Map<String, dynamic> map){
    activityId = map['activityId'] as String;
    pushToken = map['pushToken'] as String;
    liveActivityState = LiveActivityState.values.byName(map['liveActivityState']);
  }
}

enum LiveActivityState{
  ///The Live Activity is active, visible, and can receive content updates.
  active,
  ///The Live Activity content is out of date and needs an update.
  stale,
  ///The Live Activity is visible, but a person, app, or system ended it, and it won’t update its content anymore.
  ended,
  ///The Live Activity ended and is no longer visible because a person or the system removed it.
  dismissed,
}