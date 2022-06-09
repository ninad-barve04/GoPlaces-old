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
        body: Column(
          children: <Widget>[
        //     Container( 
        // decoration:BoxDecoration(
        //   image:DecorationImage(
        //     image:AssetImage( 'assets/images/goplaces_2.jpg'),
        //     fit:BoxFit.fitHeight
        //   )
        // )),
        Image.asset('assets/images/icon.png',
                  height: 150,
                  scale: 2.5), 
        const Padding(
            padding: EdgeInsets.all(16.0),
            child:  Text(
            '   Welcome to GoPlaces..\n\n\nThis is a perfect companion to explore the surroundings especially in new city or town. Just let us know your location and we provide you suggestions of exciting places near by with details for you to choose from them the place to go.\n Login with your google account to create a user profile and you are ready to go.\n\nCreated by:\nNinad Barve\nAditya Bornare\n(RPPOOP project for semester IV)\n',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 0, 73, 141),
              // fontStyle: FontStyle.italic,
              wordSpacing: 10,
              //shadows: [Shadow(color: Colors.yellowAccent, blurRadius: 15)]
            ),
          ),
        )])
      ),
    );
  }
}
