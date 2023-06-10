import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final bool justLoggedIn;

  HomePage({required this.justLoggedIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFemale = false;
  bool isPromptShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkPromptStatus();
    });
  }

  Future<void> _checkPromptStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? promptShown = prefs.getBool('promptShown');

    if (promptShown == true) {
      setState(() {
        isPromptShown = true;
      });
    } else if (widget.justLoggedIn) {
      _showPrompt();
    }
  }

  Future<void> _showPrompt() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final gender = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Male'),
                onTap: () {
                  Navigator.pop(context, false);
                },
              ),
              ListTile(
                title: Text('Female'),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
      },
    );

    if (gender != null) {
      setState(() {
        isFemale = gender;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'isFemale': isFemale});
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('promptShown', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the home page!'),
      ),
    );
  }
}
