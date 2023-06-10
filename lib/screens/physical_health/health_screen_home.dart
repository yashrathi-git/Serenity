import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                title: Text('Medication Reminders'),
                subtitle: Text('Set reminders for your medications'),
                leading: Icon(Icons.medical_services),
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
            SizedBox(height: 16.0),
            FutureBuilder<bool>(
              future: _getUserGender(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Card(
                    child: ListTile(
                      title: Text('Menstrual Cycle Tracker'),
                      subtitle: Text('Track your menstrual cycle'),
                      leading: Icon(Icons.calendar_today),
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
            Card(
              child: ListTile(
                title: Text('Menstrual Cycle Tracker'),
                subtitle: Text('Track your menstrual cycle'),
                leading: Icon(Icons.calendar_today),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenstrualCycleTrackerScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenstrualCycleTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menstrual Cycle Tracker'),
      ),
      body: Center(
        child: Text('Menstrual Cycle Tracker Screen'),
      ),
    );
  }
}
