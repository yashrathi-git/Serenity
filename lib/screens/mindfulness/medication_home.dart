import 'package:flutter/material.dart';

class MedicationScreen extends StatelessWidget {
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

class MedicationRemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminders'),
      ),
      body: Center(
        child: Text('Medication Reminders Screen'),
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
