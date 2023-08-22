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
  ValueNotifier<String> liveActivityState = ValueNotifier('HI');

  @override
  void initState() {
    super.initState();

    liveActivity.activityChangeNotifier.listen((event) {
      debugPrint('ActivityChanged');
      liveActivityState.value =
          'LiveActivityState: ${event.liveActivityState}\nLiveActivityId: ${event.activityId}\n PushToken: ${event.pushToken} ${event.toString()}';
    });
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
                debugPrint('InitLiveActivity');
                if (await liveActivity.isActivitySupported()) {
                  await liveActivity.init(
                      appGroupId: 'group.kr.doubled.liveActivity');
                }
              },
              child: const Text('Init Live Activity'),
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('CreateLiveActivity');
                await liveActivity.createActivity(data: sampleInitialData);
              },
              child: const Text('Create Live Activity'),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('Update LiveActivity');
              },
              child: const Text('Update Live Activity'),
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

Map<String, dynamic> sampleInitialData = {
  'aTeam': 1,
  'bTeam': 4,
  'aScore': 3,
  'bScore': 6,
  'onLive': false,
  'gameStatus': '2nd Inning',
};
