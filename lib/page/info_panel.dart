import 'package:flutter/material.dart';

import '../src/locations.dart';

class InfoPanelLayout extends StatelessWidget {
  InfoPanelLayout(this.poi);

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
                    style: TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(221, 43, 35, 160),
                    ))),
          )
        ],
      ),
    );
  }
}
