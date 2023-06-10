import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:serenity/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String loggedInKey = 'loggedIn';

  Future<UserCredential> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Store login status
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInKey, true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(justLoggedIn: true,)),
      );

      return userCredential;
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign in with Google.'),
        ),
      );
      throw e;
    }
  }

  Future<void> _checkLoggedIn(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? loggedIn = prefs.getBool(loggedInKey);

    if (loggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(justLoggedIn: true,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoggedIn(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Serenity',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    await _signInWithGoogle(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
