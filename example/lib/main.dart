import 'package:flutter/material.dart';
import 'package:live_activity_flutter/live_activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final liveActivity = LiveActivity();
  String? liveActivityId;
  ValueNotifier<String> liveActivityState = ValueNotifier('HI');

  Map<String, dynamic> sampleData = {
    'aTeam': 1,
    'bTeam': 4,
    'aScore': 0,
    'bScore': 0,
    'onLive': false,
    'gameStatus': '2nd',
  };

  initialize() async {
    if (await liveActivity.isActivitySupported()) {
      liveActivity.init(appGroupId: 'group.kr.doubled.liveActivity');
      liveActivity.activityChangeNotifier.distinct().listen((event) {
        debugPrint('ActivityId: ${event.activityId}');
        debugPrint('State: ${event.liveActivityState}');
        debugPrint('PushToken: ${event.pushToken}');
        liveActivityState.value =
        'LiveActivityState: ${event.liveActivityState}\nLiveActivityId: ${event.activityId}\n PushToken: ${event.pushToken} ${event.toString()}';
      });

    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Activity Example'),
        ),
        body: Center(
          child: Column(children: [
            ValueListenableBuilder(
                valueListenable: liveActivityState,
                builder: (_, liveActivityState, __) {
                  return Text(liveActivityState);
                }),
            ElevatedButton(
              onPressed: () async {
                debugPrint('CreateLiveActivity');
                liveActivityId =
                    await liveActivity.createActivity(data: sampleData);
              },
              child: const Text('Create Live Activity'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    sampleData['aScore'] += 1;
                    await liveActivity.updateActivity(
                        activityId: liveActivityId!, data: sampleData);
                  },
                  child: const Text('aTeam +'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Update LiveActivity');
                    sampleData['bScore'] += 1;
                    await liveActivity.updateActivity(
                        activityId: liveActivityId!, data: sampleData);
                  },
                  child: const Text('bTeam +'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('End LiveActivity');
                await liveActivity.endAllActivities();
              },
              child: const Text('End Live Activity'),
            ),
          ]),
        ),
      ),
    );
  }
}
