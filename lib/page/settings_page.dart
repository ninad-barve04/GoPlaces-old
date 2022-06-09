import 'package:flutter/material.dart';
import 'app_info.dart' as appinfo;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GoPlaces..."),
          backgroundColor: const Color.fromARGB(255, 8, 214, 118),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(child: const MyStatefulWidget()),
              Container(
                color: Colors.white,
                height: 50,
                width: 100,
              ),
              Container(
                child: FlatButton(
                  color: const Color.fromARGB(255, 26, 192, 32),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const appinfo.Infopage()),
                    );
                  },
                  child: const Text('About App'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Settings';

  @override
  Widget build(BuildContext context) {
    const DecoratedBox(
      decoration: BoxDecoration(color: Colors.green),
    );
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.add),
      elevation: 8,
      style: const TextStyle(color: Colors.green),
      underline: Container(
        height: 4,
        color: const Color.fromARGB(255, 45, 212, 51),
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
