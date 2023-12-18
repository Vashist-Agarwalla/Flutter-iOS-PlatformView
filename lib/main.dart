import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _batteryPercentage = '';
  late EventChannel _eventChannel;

  static const batteryChannel = MethodChannel('battery_channel');

  @override
  void initState() {
    super.initState();

    _eventChannel = const EventChannel('get_battery_event');
    _eventChannel.receiveBroadcastStream().listen(
      (event) {
        print('Button clicked! Event: $event');
        getBatteryPercentage();
      },
      onError: (error) {
        print('Error receiving event: $error');
      },
    );
  }

  Future<void> getBatteryPercentage() async {
    try {
      final int result = await batteryChannel.invokeMethod('getBatteryPercentage');
      setState(() {
        _batteryPercentage = '$result%';
      });
    } on PlatformException catch (e) {
      print('Error getting battery percentage: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 300,
              height: 200,
              child: UiKitView(
                viewType: "MySwiftUIView",
                layoutDirection: TextDirection.ltr,
                creationParamsCodec: StandardMessageCodec(),
                creationParams: {},
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Battery Percentage: $_batteryPercentage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
