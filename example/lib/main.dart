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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Activity Example'),
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                initIfLiveActivitySupported();
              },
              child: const Text('Init Live Activity'),
            ),
            ElevatedButton(
              onPressed: () {
                //TODO:
              },
              child: const Text('Create Live Activity'),
            ),
            ElevatedButton(
              onPressed: () {
                //TODO:
              },
              child: const Text('End Live Activity'),
            ),
          ]),
        ),
      ),
    );
  }

  initIfLiveActivitySupported() async {
    if (await liveActivity.isActivitySupported()) {
      liveActivity.init(
          appGroupId: 'group.kr.doubled.liveActivityPlugin');
    }
  }
}
