import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Region {
  Region({
    required this.coords,
    required this.id,
    required this.name,
    required this.zoom,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class Poi {
  Poi({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.peoplevisited,
    required this.likes,
    required this.rating,
    required this.locationtype,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.address,
    required this.cityname,
  });

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);
  Map<String, dynamic> toJson() => _$PoiToJson(this);

  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int peoplevisited;
  late  int likes;
  late  double rating;
  final String locationtype;
  final String image1;
  final String image2;
  final String image3;
  final String address;
  final String cityname;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.pois,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Poi> pois;
}

@JsonSerializable()
class City {
  City({required this.name, required this.id});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  final String name;
  final int id;
}

@JsonSerializable()
class CityList {
  CityList({required this.cities});

  factory CityList.fromJson(Map<String, dynamic> json) =>
      _$CityListFromJson(json);
  Map<String, dynamic> toJson() => _$CityListToJson(this);

  final List<City> cities;
}

Future<Locations> getPointsOfInterest() async {
  // const googleLocationsURL = 'https://about.google/static/data/locations.json';
  //
  // // Retrieve the locations of Google offices
  // try {
  //   final response = await http.get(Uri.parse(googleLocationsURL));
  //   if (response.statusCode == 200) {
  //     return Locations.fromJson(json.decode(response.body));
  //   }
  // } catch (e) {
  //   print(e);
  // }

  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/locations.json'),
    ),
  );
}
