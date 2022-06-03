import 'package:flutter/material.dart';

import '../src/locations.dart';

class InfoPanelLayout extends StatelessWidget {
  InfoPanelLayout(this.idx, this.poi);

  final List<Poi> poi;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(
            "assets/images/shaniwarwada.jpeg",
          ),
          Center(
            child: Text(poi[idx].name,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black87,
                )),
          )
        ],
      ),
    );
  }
}
