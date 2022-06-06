import 'package:flutter/material.dart';

class Infopage extends StatelessWidget {
  const Infopage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GoPlaces"),
          backgroundColor: const Color.fromARGB(255, 0, 92, 179),
          actions: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            '   WELCOME TO GoPlaces App\n\n\nThis app is a perfect companion to explore the surroundings. Just let us know your location and we provide you suggestions of exciting places near by with lots of images and info for you to choose from them the place to go.\n Login from your google account to create a user profile and you are ready to go.\n\nCreated by:\nNinad Barve\nAditya Bornare\nCreated as RPPOOP project for Sem IV\n',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 0, 73, 141),
              fontStyle: FontStyle.italic,
              wordSpacing: 10,
              //shadows: [Shadow(color: Colors.yellowAccent, blurRadius: 15)]
            ),
          ),
        ),
      ),
    );
  }
}
