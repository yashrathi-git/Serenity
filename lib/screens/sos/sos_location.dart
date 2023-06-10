import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _familyController = TextEditingController();

  @override
  void dispose() {
    _hospitalController.dispose();
    _familyController.dispose();
    super.dispose();
  }

  Future<void> saveEmergencyNumbers(String uid) async {
    String hospitalNumber = _hospitalController.text;
    String familyNumber = _familyController.text;

    if (hospitalNumber.isNotEmpty && familyNumber.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('emergency_data')
          .doc(uid)
          .set(
              {'hospitalNumber': hospitalNumber, 'familyNumber': familyNumber});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Emergency numbers saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both emergency numbers.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> sendLocationSMS(String uid) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    DocumentSnapshot? snapshot = await FirebaseFirestore.instance
        .collection('emergency_data')
        .doc(uid)
        .get();

    if (snapshot != null && snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        String? hospitalNumber = data['hospitalNumber'] as String?;
        String? familyNumber = data['familyNumber'] as String?;

        if (hospitalNumber != null && familyNumber != null) {
          String message =
              'Emergency at: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
          String encodedMessage = Uri.encodeComponent(message);

          try {
            SmsSender sender = new SmsSender();
            SmsMessage smsMessage = new SmsMessage(
              hospitalNumber,
              encodedMessage,
            );
            await sender.sendSms(smsMessage);

            smsMessage = new SmsMessage(
              familyNumber,
              encodedMessage,
            );
            await sender.sendSms(smsMessage);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('SMS sent successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } catch (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to send SMS.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Emergency numbers not found.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Emergency numbers not found.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Emergency numbers not found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Emergency Numbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _hospitalController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number of nearest hospital',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _familyController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number of family member',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  saveEmergencyNumbers(user.uid);
                }
              },
              child: Text('Save'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  sendLocationSMS(user.uid);
                }
              },
              child: Text('Send Location via SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
