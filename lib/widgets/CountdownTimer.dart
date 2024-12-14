import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds; // Countdown duration in seconds

  CountdownTimer({required this.seconds});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  late int _pomodoroState;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _pomodoroState = 0;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          // _playSound();
          switch (_pomodoroState) {
            case 0: // Work time
              breakTime();
              _pomodoroState = 1;
              break;
            case 1: // Short break
              workTime();
              _pomodoroState = 2;
              break;
            case 2: // Work time
              breakTime();
              _pomodoroState = 3;
              break;
            case 3: // Long break or reset
              stopTimer();
              _pomodoroState = 0;
              break;
          }
        }
      });
    });
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/sound-1.mp3'));
  }

  void stopTimer() {
    _timer?.cancel(); // Arrête le minuteur
  }

  void workTime() {
    setState(() {
      _remainingSeconds = 5;
    });
  }

  void breakTime() {
    setState(() {
      _remainingSeconds = 2;
    });
  }

  void addThirtySeconds() {
    setState(() {
      _remainingSeconds += 30;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text(
        formatTime(_remainingSeconds),
        style: TextStyle(fontSize: 48),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pomodoro state: $_pomodoroState"),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  print("Button $i pressed");
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getButtonColor(i),
                  ),
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: startTimer,
            child: Text("Start"),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: stopTimer,
            child: Text("Stop"),
          ),
          SizedBox(width: 10),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: breakTime,
            child: Text("Break"),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: workTime,
            child: Text("Work"),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: addThirtySeconds,
            child: Text("Add 30 seconds"),
          ),
        ],
      ),
    ],
  );
}

Color _getButtonColor(int buttonIndex) {
  if (buttonIndex == _pomodoroState) {
    return Colors.green;
  } else {
    return Colors.grey;
  }
}
}
