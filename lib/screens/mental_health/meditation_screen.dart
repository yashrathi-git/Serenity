import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

const Icon kPlayClockButton = Icon(Icons.play_arrow_sharp);
const Icon kPauseClockButton = Icon(Icons.pause_sharp);

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final CountDownController _clockController = CountDownController();

  Icon _clockButton = kPlayClockButton; // Initial value
  bool _isClockStarted = false; // Conditional flag
  bool _isClockRunning = false; // Flag to track clock running state

  int selectedTime = 5; // Default time in minutes

  final List<int> meditationTimes = [5, 10, 15, 20, 25, 30];

  // Change Clock button icon and controller
  void switchClockActionButton() async {
    if (_clockButton == kPlayClockButton) {
      _clockButton = kPauseClockButton;

      final player = AudioPlayer();
      // await player.setFilePath("t.mp3");
      // player.play();
      if (!_isClockStarted) {
        // Processed on init
        _isClockStarted = true;
        _clockController.start();
        setState(() {
          _isClockRunning =
              true; // Update the flag to indicate clock is running
        });
      } else {
        // Processed on play
        _clockController.resume();
      }
    } else {
      // Processed on pause
      _clockButton = kPlayClockButton;
      _clockController.pause();
    }

    setState(() {
      // Update the UI with the new icon
      _clockButton = _clockButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height / 2;
    final double width = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Meditate',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade900,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularCountDownTimer(
                key: Key(
                    selectedTime.toString()), // Add a key to the timer widget
                controller: _clockController,
                isReverseAnimation: true,
                ringColor: Color(0xFF0B0C19),
                height: height,
                width: width,
                autoStart: false,
                duration: selectedTime * 60,
                isReverse: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: Colors.pink,
                backgroundColor: Colors.purple.shade900,
                strokeCap: StrokeCap.round,
                onComplete: () {
                  setState(() {
                    _clockController.restart(); // Restart the timer
                  });
                },
              ),
              SizedBox(height: 10.0),
              DropdownButton<int>(
                value: selectedTime,
                items: meditationTimes.map((time) {
                  return DropdownMenuItem<int>(
                    value: time,
                    child: Text(
                      '$time min',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Update the color to white
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _isClockRunning
                    ? null
                    : (value) {
                        setState(() {
                          selectedTime = value!;
                        });
                      },
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Update the color to white
                ),
                elevation: 3,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white, // Update the icon color to white
                ),
                iconSize: 24,
                underline: Container(
                  height: 1,
                  color: Colors.white, // Update the underline color to white
                ),
                isExpanded: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      switchClockActionButton();
                    });
                  },
                  child: Container(
                    width: width / 2.5,
                    height: height / 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _clockButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
