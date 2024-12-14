import 'package:flutter/material.dart';
import 'widgets/CountdownTimer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: CountdownTimerPage(),
    );
  }
}

class CountdownTimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: Center(
        child: CountdownTimer(seconds: 10),
      ),
    );
  }
}
