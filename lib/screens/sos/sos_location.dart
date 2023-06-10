import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SoSPage extends StatelessWidget {
  SoSPage({Key? key}) : super(key: key);

  // void navigateToDigital(BuildContext context) {
  //   Routemaster.of(context).push('/safety/digital');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : const Color(0xFFAEC6CF),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black,
            child: const SizedBox(height: 1.0),
          ),
          const Divider(
              height: 1.0, color: Colors.black), // add black divider line
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black // set color for dark mode
                : const Color(0xFFAEC6CF),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.call,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8.0),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                        children: [
                          const TextSpan(text: 'Are you in an '),
                          TextSpan(
                            text: 'Emergency',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.redAccent
                                  : Colors.red,
                            ),
                          ),
                          const TextSpan(text: ' ?'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => launch('tel:100'),
                          icon: Icon(
                            Icons.local_police_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          tooltip: 'Call Police',
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Police',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => launch('tel:102'),
                          icon: Icon(
                            Icons.local_hospital_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          tooltip: 'Call Ambulance',
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Ambulance',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FutureBuilder(
                          future: Permission.location.status,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == PermissionStatus.granted) {
                              return IconButton(
                                onPressed: () async {
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high,
                                  );

                                  String message =
                                      'I am in an Emergency at: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}&zoom=15&ll=${position.latitude},${position.longitude}&markers=color:blue%7Clabel:S%7C${position.latitude},${position.longitude}';
                                  String encodedMessage =
                                      Uri.encodeComponent(message);
                                  String url = 'sms:?body=$encodedMessage';
                                  launchUrlString(url);
                                },
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                tooltip: 'Share location via SMS',
                              );
                            } else {
                              return IconButton(
                                onPressed: () async {
                                  var status =
                                      await Permission.location.request();
                                  if (status == PermissionStatus.granted) {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high,
                                    );

                                    String message =
                                        'I am in an Emergency at: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}&zoom=15&ll=${position.latitude},${position.longitude}&markers=color:blue%7Clabel:S%7C${position.latitude},${position.longitude}';
                                    String encodedMessage =
                                        Uri.encodeComponent(message);
                                    String url = 'sms:?body=$encodedMessage';
                                    launchUrlString(url);
                                  }
                                },
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                tooltip: 'Share location via SMS',
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Location',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Resource {
  final String title;
  final String description;
  final String url;
  final String thumbnailUrl; // new property

  Resource({
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailUrl, // initialize the new property
  });
}
