// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goplaces/page/Destination.dart';
import 'package:goplaces/page/Utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, Marker> _markers = {};
  // ignore: unused_field
  late Position _currentPosition;
  // ignore: deprecated_member_use
  List<Destination> destinationlist = <Destination>[];

  @override
  void initState() {
    _getCurrentLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Start trip in the order ->"),
        ),
        body: Container(
          child: destinationlist.length > 0
              ? ListView.builder(
                  itemCount: destinationlist.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(5),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 40,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text("${destinationlist[index].name}"),
                              Text(
                                  "${destinationlist[index].distance.toStringAsFixed(2)} km"),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(),
        ));
  }

  // get Current Location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        if (_currentPosition != null) {
          print('CURRENT POS: $_currentPosition');
          final marker = Marker(
            markerId: MarkerId('loc'),
            position: LatLng(position.latitude, position.longitude),
            visible: true,
          );
          _markers['loc'] = marker;
          print('>>>>>>NEW MARKER');
          distanceCalculation(_currentPosition);
        }

        // mapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       target: LatLng(position.latitude, position.longitude),
        //       zoom: 18.0,
        //     ),
        //   ),
        // );
      });
      //await _getAddress();
    }).catchError((e) {
      print(e);
      print(">>>>>>>>>>>>>>err");
    });
  }

  distanceCalculation(Position position) {
    List<Destination> temp_destinationlist = <Destination>[];

    for (var i = 0; i < destinations.length; i++) {
      temp_destinationlist.add(destinations[i]);
    }

    double lat1 = position.latitude;
    double lng1 = position.longitude;
    var i = 0;
    var j = 0;
    for (i = 0; i < temp_destinationlist.length; i++) {
      List<Destination> list2 = <Destination>[];
      for (j = i; j < temp_destinationlist.length; j++) {
        //var km = getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng);
        var d = temp_destinationlist[j];
        var m = Geolocator.distanceBetween(lat1, lng1, d.lat, d.lng);
        d.distance = m / 1000;
        list2.add(d);
        print(d);
      }
      list2.sort((a, b) {
        return a.distance.compareTo(b.distance);
      });
      print(list2[0]);
      setState(() {
        var d = list2[0];
        var m = 0;
        for (; m < temp_destinationlist.length; m++) {
          if (d.name == temp_destinationlist[m].name) {
            lat1 = d.lat;
            lng1 = d.lng;
            break;
          }
        }

        destinationlist.add(temp_destinationlist.removeAt(m));
        i--;
        j--;
      });
    }
  }
}
