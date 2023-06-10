import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenity/screens/mental_health/journal_screen.dart';
import 'package:serenity/screens/physical_health/widgets/menstrual_tracker.dart';

import 'medication_reminder.dart';

class MedicationScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> _getUserGender() async {
    final DocumentSnapshot snapshot =
        await firestore.collection('users').doc(user?.uid).get();
    final Map<String, dynamic>? userData =
        snapshot.data() as Map<String, dynamic>?; // Explicit casting
    final bool? isFemale = userData?['isFemale'];
    return isFemale ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Screen'),
        backgroundColor: Colors.deepPurple, // Set the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blueGrey, // Set the card background color
              child: ListTile(
                title: Text(
                  'Medication Reminders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white, // Set the title text color
                  ),
                ),
                subtitle: Text(
                  'Set reminders for your medications',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70, // Set the subtitle text color
                  ),
                ),
                leading: Icon(
                  Icons.medical_services,
                  color: Colors.white, // Set the leading icon color
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicationRemindersScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              color: Colors.purple, // Set the card background color
              child: ListTile(
                title: Text(
                  'Meditation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white, // Set the title text color
                  ),
                ),
                subtitle: Text(
                  'Meditate to relax your mind and body',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70, // Set the subtitle text color
                  ),
                ),
                leading: Icon(
                  Icons.spa,
                  color: Colors.white, // Set the leading icon color
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicationRemindersScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              color: Colors.green, // Set the card background color
              child: ListTile(
                title: Text(
                  'Journal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white, // Set the title text color
                  ),
                ),
                subtitle: Text(
                  'Journal your thoughts and feelings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70, // Set the subtitle text color
                  ),
                ),
                leading: Icon(
                  Icons.book,
                  color: Colors.white, // Set the leading icon color
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalScreen(),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: 16.0),
            FutureBuilder<bool>(
              future: _getUserGender(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Card(
                    color: Colors.deepOrange, // Set the card background color
                    child: ListTile(
                      title: Text(
                        'Menstrual Cycle Tracker',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white, // Set the title text color
                        ),
                      ),
                      subtitle: Text(
                        'Track your menstrual cycle',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70, // Set the subtitle text color
                        ),
                      ),
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.white, // Set the leading icon color
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenstrualCycleTrackerScreen(),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900], // Set the screen background color
    );
  }
}
