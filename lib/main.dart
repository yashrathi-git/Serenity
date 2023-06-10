import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serenity/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:
          LoginPage(), // Change "HomePage" to the name of your home page widget
    );
  }
}
