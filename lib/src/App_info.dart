import 'package:flutter/material.dart';

class Infopage extends StatelessWidget {
  const Infopage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GoPlaces"),
          backgroundColor: const Color.fromARGB(255, 8, 214, 118),
          actions: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            '                                                                WELCOME TO GoPlaces APP.\n\n\nThis app is a perfect companion to explore the surroundings. Just let us know your location and we provide you suggestions of exciting places near by with lots of images and info for you to choose from them the place to go.\n Login from your google account to create a user profile and you are ready to go. ',
            style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 11, 126, 14),
                fontStyle: FontStyle.italic,
                wordSpacing: 10,
                shadows: [Shadow(color: Colors.yellowAccent, blurRadius: 15)]),
          ),
        ),
      ),
    );
  }
}
