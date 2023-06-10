import 'package:flutter/material.dart';

class MedicationRemindersScreen extends StatefulWidget {
  @override
  _MedicationRemindersScreenState createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController medicationNameController = TextEditingController();

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
  void dispose() {
    medicationNameController.dispose();
    super.dispose();
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
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: medicationNameController,
                  decoration: InputDecoration(
                    labelText: 'Medication Name',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              child: ListTile(
                title: Text(
                  'Medication Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  selectedDate == null
                      ? 'To'
                      : selectedDate.toString().substring(0, 10),
                ),
                onTap: _openDatePicker,
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(
                  'Medication Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'From'
                          : 'Date: ${selectedDate.toString().substring(0, 10)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to select date',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _openDatePicker,
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(
                  'Reminder Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedTime == null
                          ? 'Select time'
                          : 'Time: ${selectedTime!.format(context)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to select time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Icon(Icons.access_time),
                onTap: _openTimePicker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
