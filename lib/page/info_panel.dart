import 'dart:ui';

import 'package:flutter/material.dart';

import '../src/locations.dart';

class InfoPanelLayout extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const InfoPanelLayout(this.poi);

  final Poi poi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.network(
            poi.image,
          ),
          Container(
            child: Center(
                child: Text(poi.name,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(221, 43, 35, 160),
                    ))),
          ),
          Container(
              child: Center(
            child: Text(
              poi.id,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(221, 43, 35, 160),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
