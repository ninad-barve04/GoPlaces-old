import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';

import '../src/locations.dart';

class InfoPanelLayout extends StatelessWidget {
  // ignore: use_key_in_widget_constructors

  final VoidCallback letsGoSelected;

  const InfoPanelLayout(this.poi, this.letsGoSelected);

  final Poi poi;

  Widget getImageSlideShow() {
    return ImageSlideshow(
      width: 200,
      height: 150,
      initialPage: 0,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      children: [
        Image.network(
          poi.image1,
          fit: BoxFit.cover,
        ),
        Image.network(
          poi.image2,
          fit: BoxFit.cover,
        ),
        Image.network(
          poi.image3,
          fit: BoxFit.cover,
        ),
      ],
      onPageChanged: (value) {},
      autoPlayInterval: 3000,
      isLoop: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          getImageSlideShow(),
          Container(
            height: 80,
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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: RatingBarIndicator(
                    rating: 2.75,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 30.0,
                    direction: Axis.horizontal,
                  )),
              SizedBox(width: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: LikeButton(
                    size: 15,
                    likeCount: 12,
                    likeCountPadding: const EdgeInsets.all(4.0),
                    likeBuilder: (bool like) {
                      return Icon(
                        Icons.thumb_up,
                        color: Colors.blue,
                      );
                    },
                  ))
            ],
          )),
          Container(
              height: 180,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        poi.description,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(221, 43, 35, 160),
                        ),
                      )))),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ElevatedButton(
                    onPressed: () => letsGoSelected(),
                    child: const Text('Lets Go..'),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ElevatedButton(
                      onPressed: () => {}, child: const Text("Visit Later")))
            ],
          ))
        ],
      ),
    );
  }
}
