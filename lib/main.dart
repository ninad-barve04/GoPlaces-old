import 'package:flutter/material.dart';

import 'page/main_map_page.dart' as mainpage;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const mainpage.MapState(),
    );
  }
}
