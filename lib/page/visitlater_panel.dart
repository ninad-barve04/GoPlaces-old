import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../src/locations.dart';

class VisitLaterLayout extends StatefulWidget {
  final String email;
  const VisitLaterLayout({Key? key, required this.email}) : super(key: key);

  @override
  State createState() => VisitLaterLayoutState();
}

class VisitLaterLayoutState extends State<VisitLaterLayout> {
  // ignore: use_key_in_widget_constructors

  List<String> placesList = [];

  void getVisitPlaces() async {
    http.Response resp = await http.get(Uri.parse(
        "http://54.184.164.77:5000/getuserloc?email=" + widget.email));

    if (resp.statusCode == 200) {
      List<dynamic> list = json.decode(resp.body);
      // locations.CityList list =
      //     locations.CityList.fromJson(jsonDecode(resp.body));

      List<String> pList = [];
      list.forEach((element) {
        print(element);
        pList.add(element['name']);
      });
      setState(() {
        placesList = pList;
      });
    }
  }

  @override
  void initState() {
    getVisitPlaces();
  }

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
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      color: Colors.white.withOpacity(0.95),
                      width: 400,
                      height: 400,
                      child: ListView.builder(
                          itemCount: placesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: const Icon(Icons.list),
                                title: Text(placesList[index]));
                          })),
                ],
              ),
            )));
  }
}
