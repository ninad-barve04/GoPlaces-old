import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';

import '../src/locations.dart';

class InfoPanelLayout extends StatelessWidget {
  // ignore: use_key_in_widget_constructors

  final VoidCallback letsGoSelected;
  final void Function(int) visitLaterSelected;
  final void Function(int, double, double) addRating;
  final void Function(int, int) addLike;

  InfoPanelLayout(this.poi, this.letsGoSelected, 
  this.visitLaterSelected,
  this.addLike,
  this.addRating);

  Poi poi;

  Widget standByImage(BuildContext context, Object exception, StackTrace? stackTrace) {
      return  Image.asset('assets/images/noimage.jpeg');
  }

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
          errorBuilder: standByImage,
        ),
        Image.network(
          poi.image2,
          fit: BoxFit.cover,
          errorBuilder: standByImage,
        ),
        Image.network(
          poi.image3,
          fit: BoxFit.cover,
          errorBuilder: standByImage,
        ),
      ],
      onPageChanged: (value) {},
      autoPlayInterval: 3000,
      isLoop: true,
    );
  }


  Future<bool> onLikeTapped( bool isLiked){
    int lk = poi.likes;
    bool like = !isLiked;
    if( like){
      lk++;
    }else{
      lk--;
    }
    addLike(poi.id,lk);

    poi.likes = lk;
    return  Future.value(like);
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
                  child: RatingBar.builder(
                    minRating: 0,
                    maxRating: 5,
                    initialRating:poi.rating,
                    allowHalfRating: true,
                    itemBuilder: (context,_) => const Icon(
                      Icons.star,
                      color:Colors.amber
                    ),
                    itemSize: 30.0,
                    onRatingUpdate: (rating){
                      double d1 = (poi.rating+rating)/2.0;
                      poi.rating = d1;
                      addRating(poi.id,poi.rating, rating);
                      print (rating);
                    }
                  )),
              SizedBox(width: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: LikeButton(
                    size: 15,
                    likeCount: poi.likes,
                    likeCountPadding: const EdgeInsets.all(4.0),
                    likeBuilder: (bool like) {
                      return Icon(
                        Icons.thumb_up,
                        color: Colors.blue,
                      );
                    },
                    onTap: onLikeTapped
                      
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
                      onPressed: () => visitLaterSelected(poi.id), 
                      child: const Text("Visit Later")))
            ],
          ))
        ],
      ),
    );
  }
}
