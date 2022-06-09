import 'package:flutter/material.dart';

import 'page/main_map_page.dart' as mainpage;
import 'page/login.dart' as login;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoPlaces',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const login.GoPlacesLogin(),
    );
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidget();
}

class _SettingsWidget extends State<SettingsWidget> {
  String dropdownValue = 'Settings';

  @override
  Widget build(BuildContext context) {
    const DecoratedBox(
      decoration: BoxDecoration(color: Colors.blue),
    );
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.add),
      elevation: 8,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 4,
        color: const Color.fromARGB(255, 0, 92, 179),
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Settings', 'user', 'log in', 'log out']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
