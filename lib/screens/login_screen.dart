import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:serenity/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselItem {
  final String imagePath;
  final String title;
  final String description;

  CarouselItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String loggedInKey = 'loggedIn';

  LoginPage({Key? key});

  Future<UserCredential> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store login status
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInKey, true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            justLoggedIn: true,
          ),
        ),
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
        MaterialPageRoute(
          builder: (context) => HomePage(
            justLoggedIn: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoggedIn(context);

    final List<CarouselItem> carouselItems = [
      CarouselItem(
        imagePath: 'assets/images/feature1.png',
        title: 'Feature 1',
        description: 'Description for Feature 1',
      ),
      CarouselItem(
        imagePath: 'assets/images/feature2.png',
        title: 'Feature 2',
        description: 'Description for Feature 2',
      ),
      CarouselItem(
        imagePath: 'assets/images/feature3.png',
        title: 'Feature 3',
        description: 'Description for Feature 3',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[400]!,
              Colors.green[400]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Serenity',
                  style: TextStyle(
                    fontFamily: 'AlBrush',
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 2.0,
                  ),
                  items: carouselItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.white.withOpacity(0.7),
                          child: Column(
                            children: [
                              Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
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
