// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      coords: LatLng.fromJson(json['coords'] as Map<String, dynamic>),
      id: json['id'] as String,
      name: json['name'] as String,
      zoom: (json['zoom'] as num).toDouble(),
    );

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'coords': instance.coords,
      'id': instance.id,
      'name': instance.name,
      'zoom': instance.zoom,
    };

Poi _$PoiFromJson(Map<String, dynamic> json) => Poi(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      peoplevisited: json['peoplevisited'] as int,
      likes: json['likes'] as int,
      rating: (json['rating'] as num).toDouble(),
      locationtype: json['locationtype'] as String,
      image1: json['image1'] as String,
      image2: json['image2'] as String,
      image3: json['image3'] as String,
      address: json['address'] as String,
      cityname: json['cityname'] as String,
    );

Map<String, dynamic> _$PoiToJson(Poi instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'peoplevisited': instance.peoplevisited,
      'likes': instance.likes,
      'rating': instance.rating,
      'locationtype': instance.locationtype,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'address': instance.address,
      'cityname': instance.cityname,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      pois: (json['pois'] as List<dynamic>)
          .map((e) => Poi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'pois': instance.pois,
    };

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String,
      id: json['id'] as int,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

CityList _$CityListFromJson(Map<String, dynamic> json) => CityList(
      cities: (json['cities'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CityListToJson(CityList instance) => <String, dynamic>{
      'cities': instance.cities,
    };
