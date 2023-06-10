import 'package:flutter/material.dart';

class MedicationRemindersScreen extends StatefulWidget {
  @override
  _MedicationRemindersScreenState createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _openTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Medication Reminders'),
                subtitle: Text(
                  selectedDate == null
                      ? 'Select date'
                      : selectedDate.toString().substring(0, 10),
                ),
                onTap: _openDatePicker,
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              child: ListTile(
                title: Text('Medication Tracker'),
                subtitle: Text(
                  selectedTime == null
                      ? 'Select time'
                      : selectedTime!.format(context),
                ),
                onTap: _openTimePicker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
