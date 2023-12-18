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
  // Variable to store the battery percentage
  String _batteryPercentage = '';

  // Event channel for listening to button click events
  late EventChannel _eventChannel;

  // Method channel for invoking native methods
  static const batteryChannel = MethodChannel('battery_channel');

  @override
  void initState() {
    super.initState();

    // Initialize the event channel to listen for button click events
    _eventChannel = const EventChannel('get_battery_event');

    // Listen to events from the event channel
    _eventChannel.receiveBroadcastStream().listen(
      (event) {
        // Event handler for button click events
        print('Button clicked! Event: $event');
        getBatteryPercentage();
      },
      onError: (error) {
        // Handle errors when receiving events
        print('Error receiving event: $error');
      },
    );
  }

  // Method to fetch the battery percentage
  Future<void> getBatteryPercentage() async {
    try {
      // Invoke the native method to get the battery percentage
      final int result = await batteryChannel.invokeMethod('getBatteryPercentage');
      
      // Update the UI with the received battery percentage
      setState(() {
        _batteryPercentage = '$result%';
      });
    } on PlatformException catch (e) {
      // Handle errors when getting the battery percentage
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
            // Native view embedded in the Flutter UI
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
            const SizedBox(height: 200),
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
