import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:carousel_slider/carousel_slider.dart';
import 'package:serenity/screens/Sakhi/chat_screen.dart';
import 'package:serenity/screens/mental_health/mental_splash.dart';

import 'package:serenity/screens/mindfulness_screen.dart';
import 'package:serenity/screens/sos/sos_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'physical_health/health_screen_home.dart';

class CarouselItem {
  final String title;
  final String description;
  final String imageAssetPath;
  final String redirectLink;

  CarouselItem({
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.redirectLink,
  });
}

class HomePage extends StatefulWidget {
  final bool justLoggedIn;

  const HomePage({required this.justLoggedIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFemale = false;
  bool isPromptShown = false;

  List<CarouselItem> carouselItems = [
    CarouselItem(
      title: "How to Prevent Heart Attacks",
      description: "Learn about the best practices to prevent heart attacks.",
      imageAssetPath: "assets/images/heart.png",
      redirectLink: "https://example.com/heart-attacks",
    ),
    CarouselItem(
      title: "Benefits of Exercise",
      description: "Discover the numerous benefits of regular exercise.",
      imageAssetPath: "assets/images/exercise.png",
      redirectLink: "https://example.com/benefits-of-exercise",
    ),
    CarouselItem(
      title: "Tips for a Healthy Diet",
      description: "Get valuable tips for maintaining a healthy diet.",
      imageAssetPath: "assets/images/diet.png",
      redirectLink: "https://example.com/healthy-diet-tips",
    ),
  ];

  List<CardItem> cardItems = [
    CardItem(
      title: 'Health Advice 1',
      description: 'Description of health advice 1',
      imageAssetPath: 'assets/images/advice1.png',
      redirectLink: 'https://example.com',
    ),
    CardItem(
      title: 'Health Advice 2',
      description: 'Description of health advice 2',
      imageAssetPath: 'assets/images/advice2.png',
      redirectLink: 'https://example.com',
    ),
    CardItem(
      title: 'Health Advice 2',
      description: 'Description of health advice 2',
      imageAssetPath: 'assets/images/advice2.png',
      redirectLink: 'https://example.com',
    ),
    // Add more card items as needed
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    // Replace 'avatarUrl' with the URL of the user's avatar
                    FirebaseAuth.instance.currentUser?.photoURL ?? '',
                  ),
                  radius: 15,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? 'Username',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'Email',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ?? '',
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : const Color(0xFFAEC6CF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[980],
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.error,
                          color: Colors.black,
                        ),
                        title: Text(
                          'SoS',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SoSPage()),
                          );
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Swasthya Sakhi',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()),
                          );
                        },
                        tileColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: carouselItems.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final item = carouselItems[index];
                return GestureDetector(
                  onTap: () {
                    // Handle item click, e.g., open redirect link
                    // You can use a package like url_launcher to open the link in a browser
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            item.description,
                            style: TextStyle(fontSize: 14.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          Image.asset(
                            item.imageAssetPath,
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            child: Text(
                              'Learn More',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onPressed: () {
                              // Handle button click
                              // Open the redirect link
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: cardItems.length,
                itemBuilder: (BuildContext context, int index) {
                  CardItem item = cardItems[index];
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              item.description,
                              style: TextStyle(fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.0),
                            Image.asset(
                              item.imageAssetPath,
                              height: 120.0,
                              width: 120.0,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              child: Text(
                                'Learn More',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              onPressed: () {
                                // Handle button click
                                // Open the redirect link
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.screen_rotation),
            label: 'Screen 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.screen_rotation),
            label: 'Screen 3',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Handle home tab click
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MentalSplashScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MedicationScreen()),
            );
          }
        },
      ),
    );
  }
}

class CardItem {
  final String title;
  final String description;
  final String imageAssetPath;
  final String redirectLink;

  CardItem({
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.redirectLink,
  });
}
