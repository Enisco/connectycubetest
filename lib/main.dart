// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<bool> onCallRejectedWhenTerminated(CallEvent callEvent) async {
  print(" ||||||||||| Call Accepted at Terminated State");
  return false;
}

@pragma('vm:entry-point')
Future<bool> onCallAcceptedWhenTerminated(CallEvent callEvent) async {
  print(" ??????????? Call Declined at Terminated State");
  return true;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connecticube Demo',
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Connecticube Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: _onCallAccepted,
      onCallRejected: _onCallRejected,
    );
    ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
        onCallRejectedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
        onCallAcceptedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallMuted = onCallMuted;
  }

  Future<void> _onCallAccepted(CallEvent callEvent) async {
    print(" >>>>>>>>>>>>>>> Call Accepted");
  }

  Future<void> _onCallRejected(CallEvent callEvent) async {
    print(" &&&&&&&&&&&&&&& Call Declined");
  }

  Future<void> onCallMuted(bool mute, String uuid) async {
    print(" ^^^^^^^^^^^^^^ Call Muted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Press FAB to show fake incoming call',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showFakeIncomingCall,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  showFakeIncomingCall() {
    var uuid = const Uuid();

    CallEvent callEvent = CallEvent(
      sessionId: uuid.v1(),
      callType: 0,
      callerId: Random().nextInt(1000000),
      callerName: 'Fake Caller',
      opponentsIds: {
        Random().nextInt(1000000),
      },
      callPhoto: 'https://i.imgur.com/KwrDil8b.jpg',
      userInfo: {'id': uuid.v1()},
    );
    print(callEvent.toJson());
    try {
      ConnectycubeFlutterCallKit.showCallNotification(callEvent);
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }
}
