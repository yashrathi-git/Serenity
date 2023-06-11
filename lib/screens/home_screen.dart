import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:carousel_slider/carousel_slider.dart';
import 'package:serenity/screens/Sakhi/chat_screen.dart';
import 'package:serenity/screens/mental_health/mental_splash.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:serenity/screens/mindfulness_screen.dart';
import 'package:serenity/screens/sos/sos_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      imageAssetPath: "assets/images/attack.jpg",
      redirectLink:
          "https://www.moneycontrol.com/news/health-and-fitness/how-to-prevent-heart-attacks-dont-skip-your-leg-exercises-in-the-gym-10718931.html",
    ),
    CarouselItem(
      title: "Benefits of Exercise",
      description: "Discover the numerous benefits of regular exercise.",
      imageAssetPath: "assets/images/exerc.png",
      redirectLink:
          "https://zeenews.india.com/health/benefits-of-exercise-daily-movement-can-help-reduce-the-risk-of-type-2-diabetes-2618522",
    ),
    CarouselItem(
      title: "Tips for a Healthy Diet",
      description: "Get valuable tips for maintaining a healthy diet.",
      imageAssetPath: "assets/images/diet.jpg",
      redirectLink:
          "https://www.india.com/lifestyle/healthy-diet-101-7-diet-tips-to-lose-weight-and-improve-overall-health-6082632/",
    ),
  ];

  List<CardItem> cardItems = [
    CardItem(
        title: 'Sleep Well',
        description:
            'Get enough sleep to support overall health and well-being. Aim for 7-8 hours of quality sleep each night.',
        imageAssetPath: 'assets/images/sleep.jpg',
        redirectLink: 'https://www.medicalnewstoday.com/articles/325353'),
    CardItem(
      title: 'Take care of Hydration',
      description:
          'Stay hydrated throughout the day by drinking an adequate amount of water. Aim for at least 8 glasses (64 ounces) per day.',
      imageAssetPath: 'assets/images/hydrate.png',
      redirectLink:
          'https://www.metropolisindia.com/blog/lifestyle/health-wellness-summer-special-6-smart-ways-to-stay-hydrated/',
    ),
    CardItem(
      title: 'Reduce Stress',
      description:
          'Practice mindfulness or meditation to reduce stress and improve mental well-being. Take a few minutes each day to relax and focus on your breath.',
      imageAssetPath: 'assets/images/easy.png',
      redirectLink: 'https://health.clevelandclinic.org/how-to-relieve-stress/',
    ),
    CardItem(
      title: 'Keep Good Posture',
      description:
          'Maintain a healthy posture while sitting and standing to prevent back and neck pain. Use ergonomic furniture and take breaks to stretch.',
      imageAssetPath: 'assets/images/posture2.jpeg',
      redirectLink:
          'https://www.healthline.com/health/bone-health/the-4-main-types-of-posture',
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
          title: const Row(
            children: [
              Text(
                'Which Gender do you Identify As?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Row(
                  children: [
                    Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '👱‍♂️',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, false);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Text(
                      'Female',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '👩‍🦰',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Text(
                      'Prefer Not to Say',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '❌',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
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
        title: const Text('Home'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    // Replace 'avatarUrl' with the URL of the user's avatar
                    FirebaseAuth.instance.currentUser?.photoURL ?? '',
                  ),
                  radius: 18,
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
                accountName: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      FirebaseAuth.instance.currentUser?.displayName ??
                          'Username',
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 100),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
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
                  borderRadius: const BorderRadius.only(
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
                      const SizedBox(height: 8),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 200),
                        child: ListTile(
                          leading: const Icon(
                            Icons.warning,
                            color: Colors.amber,
                          ),
                          title: const Text(
                            'SoS',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SoSPage()),
                            );
                          },
                          tileColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DelayedDisplay(
                        delay: const Duration(milliseconds: 300),
                        child: ListTile(
                          leading: const Icon(
                            Icons.chat,
                            color: Colors.green,
                          ),
                          title: const Text(
                            'Swasthya Sakhi',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatScreen()),
                            );
                          },
                          tileColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 360),
                      ListTile(
                        title: Container(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Image.asset(
                              'assets/images/gdsc.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        tileColor: Colors.transparent,
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
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                item.imageAssetPath,
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[900],
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    child: const Text(
                                      'Learn More',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    onPressed: () {
                                      launch(item.redirectLink);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: cardItems.length,
                itemBuilder: (BuildContext context, int index) {
                  CardItem item = cardItems[index];
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  ElevatedButton(
                                    child: const Text(
                                      'Learn More',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      launch(item.redirectLink);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.pink,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: AssetImage(item.imageAssetPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            // label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            // label: 'Toolbox',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.screen_rotation),
          //   label: 'Screen 3',
          // ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Handle home tab click
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MedicationScreen()),
            );
          }
          // } else if (index == 2) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => MedicationScreen()),
          //   );
          // }
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
