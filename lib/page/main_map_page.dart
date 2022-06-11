import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../src/locations.dart' as locations;
import 'info_panel.dart' as infopanel;
import 'app_info.dart' as appinfo;
import './login.dart' as login;

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePage();
// }
//
// class _HomePage extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("MapApp"),
//           backgroundColor: const Color.fromARGB(255, 8, 214, 118),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const settingspage.SettingsPage()),
//                 );
//               },
//               icon: const Icon(Icons.menu),
//             ),
//           ],
//         ),
//         body: const MapState(),
//       ),
//     );
//   }
// }
// final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class MapState extends StatefulWidget {

  final GoogleSignInAccount? currentUser;
  final VoidCallback signout;

  const MapState({Key? key, this.currentUser, required this.signout}) : super(key: key);

  @override
  State<MapState> createState() => _MapState();
}

class _MapState extends State<MapState> {
  Map<String, Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];

  final PanelController _pc = PanelController();
  bool _visible = true;
  int currentIndex = 0;
  List<locations.Poi> pois = [];
  List<DropdownMenuItem<String>> city_items = [];

  GoogleMapController? _mapController;
  locations.Poi currentPoi = locations.Poi(
    id: 1,
    name: "Dummy",
    description: "Test",
    latitude: 0.0,
    longitude: 0.0,
    peoplevisited: 10,
    likes: 100,
    rating: 4.5,
    locationtype: "Test",
    image1:
        "https://ik.imagekit.io/goplaces/GoPlaces-logos_QI1sFe82N.jpeg?ik-sdk-version=javascript-1.4.3&updatedAt=1654224201276",
    image2:
        "https://ik.imagekit.io/goplaces/GoPlaces-logos_QI1sFe82N.jpeg?ik-sdk-version=javascript-1.4.3&updatedAt=1654224201276",
    image3:
        "https://ik.imagekit.io/goplaces/GoPlaces-logos_QI1sFe82N.jpeg?ik-sdk-version=javascript-1.4.3&updatedAt=1654224201276",
    address: "Test",
    cityname: "Test",
  );

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

  Future<void> _createMapMarker() async
  {
    var iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 21)), "assets/images/marker_gp.png");

    pois.clear();
    _markers.clear();
    _polylines.clear();
    polylineCoordinates.clear();

    pois = await getLocations(_city);
    setState(() {
      //  _markers.clear();

      double lt1=0.0,lng1=0.0,lt2=0.0,lng2=0.0;
       
      int idx = 0;
      for (final poi in pois) {
        final marker = Marker(
          markerId: MarkerId(poi.name),
          position: LatLng(poi.latitude, poi.longitude),
          visible: true,
          icon: iconMarker,
          onTap: () {
            _visible = false;
            setState(() {
              
              currentPoi = poi;
            });
            _pc.open();
          }
        );
        
        _markers[poi.name] = marker;
        if (idx == 0) {
          lt1 = poi.latitude;
          lt2 = poi.latitude;
          lng1 = poi.longitude;
          lng2 = poi.longitude;
        } else {
          if (poi.latitude > lt1) lt2 = poi.latitude;
          if (poi.latitude < lt2) lt1 = poi.latitude;
          if (poi.longitude > lng1) lng2 = poi.longitude;
          if (poi.longitude < lng2) lng1 = poi.longitude;
        } 
        idx++;
        print( lt1);
        print( lt2);
        print(lng1);
        print(lng2);

      }

      if( pois.length >0){
        LatLngBounds bounds = LatLngBounds(northeast: LatLng(lt2, lng2), southwest: LatLng(lt1, lng1));
        print( bounds);
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds,150));
      }
      else{
        Fluttertoast.showToast(
            msg: "No locations found for city " + _city,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Color.fromARGB(255, 106, 138, 243),
            textColor: Colors.white,
            fontSize: 16.0
        );
        LatLng latLng = new LatLng(18.5293825, 73.8543523);
         _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng,12));
      }
      print(_markers);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    await _createMapMarker();
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylineCoordinates.clear();
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBHoMp1gcr1GPk05YrtIsL01hQi2rw0SMM', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    double l1 = 0.0;
    double l2 = 0.0;
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        l1 = l1 + point.latitude;
        l2 = l2 + point.longitude;
      });
    }
    int ln = polylineCoordinates.length;
    if( ln > 0){
      
        l1 = l1 / ln;
        l2 = l2 / ln;

      // Defining an ID
      PolylineId id = PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      setState(() {
          _polylines[id] = polyline;
      });
      // Adding the polyline to the map

    LatLng latLng = LatLng(l1, l2);
         _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng,12));
    }  
  
  }

  processDirectionRequest() async {
    print(">>processDirectionRequest");

    await _getCurrentLocation();

    print(_currentPosition);
    print(currentPoi);

    await _createPolylines(_currentPosition!.latitude, _currentPosition!.longitude,currentPoi.latitude,currentPoi.longitude);


    // print(_markers['loc']);
  }

  void processVisitLaterRequest(int locnid)async{

    Map<String,dynamic> data = Map<String,dynamic>();
    data['email'] = widget.currentUser?.email;
    data['locid'] = locnid;
    var body = json.encode(data);
     http.Response resp =
        await http.post(Uri.parse("http://54.184.164.77:5000/adduserloc"), headers: {"Content-Type": "application/json"}, body:body);
    if (resp.statusCode == 200) {

      Fluttertoast.showToast(
            msg: "New location added in visit later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Color.fromARGB(255, 106, 138, 243),
            textColor: Colors.white,
            fontSize: 16.0
        ); 
    }
  
  }

  void addLike(int locnid, int likes )async{

    Map<String,dynamic> data = Map<String,dynamic>();
    data['id'] = locnid;
    data['like'] = likes;
    var body = json.encode(data);
     http.Response resp =
        await http.post(Uri.parse("http://54.184.164.77:5000/addlike"), headers: {"Content-Type": "application/json"}, body:body);
    if (resp.statusCode == 200) {
      print( resp.statusCode);
    }
  
  }

  void addRating(int locnid, double existintRating, double newRating )async{

    double modRating = (existintRating + newRating)/2.0;

    Map<String,dynamic> data = Map<String,dynamic>();
    data['id'] = locnid;
    data['rating'] = modRating;
    var body = json.encode(data);
     http.Response resp =
        await http.post(Uri.parse("http://54.184.164.77:5000/addrating"), headers: {"Content-Type": "application/json"}, body:body);
    if (resp.statusCode == 200) {
      print( resp.statusCode);
    }
  
  }

  void getCities() async {
    http.Response resp =
        await http.get(Uri.parse("http://54.184.164.77:5000/city"));

    if (resp.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<dynamic> list = json.decode(resp.body);
      // locations.CityList list =
      //     locations.CityList.fromJson(jsonDecode(resp.body));

      list.forEach((element) {
        locations.City c1 = locations.City.fromJson(element);
        DropdownMenuItem<String> di = DropdownMenuItem(
          child: Text(c1.name),
          value: c1.name,
        );
        city_items.add(di);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<locations.Poi>> getLocations(city) async {
    http.Response resp = await http
        .get(Uri.parse("http://54.184.164.77:5000/locations/" + city));

    List<locations.Poi> lcList = [];
    if (resp.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<dynamic> list = json.decode(resp.body);
      var iconMarker = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(10, 21)),
          "assets/images/marker_gp.png");
      int idx = 0;
      list.forEach((element) {
        print(element);
        locations.Poi c1 = locations.Poi.fromJson(element);
        lcList.add(c1);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    return lcList;
  }

  // I want list


  String _city = "Pune";

  Position? _currentPosition;

  // Convert Future<http.Response> to List? How?

  @override
  void initState() {

    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    // });
    //_googleSignIn.signInSilently();
    getCities();
    super.initState();
  }

  void showMyPlaces()
  {

  }

  void panelClosedCallback()
  {
    setState(() {
      _polylines.clear();
      polylineCoordinates.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    );
    GoogleSignInAccount? user = widget.currentUser;
     
    // List cities = getCities() as List;

    if (user != null) {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text("GoPlaces..."),
          backgroundColor: const Color.fromARGB(255, 0, 92, 179),
        ),
        body: Stack(children: <Widget>[
          SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            minHeight: 0,
            onPanelClosed: panelClosedCallback,
            panel:
                infopanel.InfoPanelLayout(currentPoi, processDirectionRequest,
                 processVisitLaterRequest,
                 addLike,
                 addRating),
            borderRadius: radius,
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(18.5293825, 73.8543523),
                zoom: 12.0,
              ),
              markers: _markers.values.toSet(),
              polylines: _polylines.values.toSet(),
            ),
          ),
          // Container(
          //         child: Text(
          //           'Pune',
          //           style: TextStyle(fontSize: 22, color: Colors.white, backgroundColor:Colors.blue),
          //         ),
          //         alignment: Alignment.topRight,
          //       ),
          Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(20),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors
                        .lightBlue[100], //background color of dropdown button
                    border: Border.all(
                        color: Colors.black38,
                        width: 3), //border of dropdown button
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                          value: _city,
                          dropdownColor: Colors.lightBlue[100],
                          // items: [
                          //   DropdownMenuItem(
                          //     child: Text("Pune"),
                          //     value: "Pune",
                          //   ),
                          //   DropdownMenuItem(
                          //     child: Text("Mumbai"),
                          //     value: "Mumbai",
                          //   ),
                          //   DropdownMenuItem(
                          //     child: Text("Delhi"),
                          //     value: "Delhi",
                          //   )
                          // ],
                          items: city_items,
                          onChanged: (String? value) async {
                            if (_pc.isPanelOpen) {
                              _pc.close();
                            }
                            setState(() {
                              _city = value!;
                              
                            });

                            await _createMapMarker();
                          },
                          hint: Text("Select item")))))
        ]),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/drawer.jpg'),
                  ),
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      // GoogleUserCircleAvatar(identity: user),
                      CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(
                            user.photoUrl ?? 'https://via.placeholder.com/150'),
                      ),
                      Text(user.displayName ?? '',
                          style: TextStyle(color: Colors.white)),
                      Text(user.email, style: TextStyle(color: Colors.white)),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () => showMyPlaces(),
                      child: const Text('My places')),
              
                  ElevatedButton(
                      onPressed: () => signOut(context, widget.signout),
                      child: const Text('Sign Out')),
                ],
              )),
              Container(
                color: Colors.white,
                height: 50,
                width: 100,
              ),
              Container(
                child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const appinfo.Infopage()),
                    );
                  },
                  child: Text('About App'),
                ),
              ),
            ],
          ),
        ),
      ));
    } else {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text("GoPlaces..."),
          backgroundColor: const Color.fromARGB(255, 0, 92, 179),
        ),
        body: SlidingUpPanel(
          controller: _pc,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          minHeight: 0,
          onPanelClosed: panelClosedCallback,
          panel: infopanel.InfoPanelLayout(currentPoi, processDirectionRequest, 
          processVisitLaterRequest,
                 addLike,
                 addRating,
          ),
          borderRadius: radius,
          body: const Text("GoPlaces.."),
        ),
      ));
    }
  }
}

void signOut(BuildContext context,VoidCallback logout) async {
 
  logout();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => login.GoPlacesLogin(),
    ),
  );
}

// Future<void> signIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (e) {
//     print('Error in signIn $e');
//   }
// }

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
      decoration: BoxDecoration(color: Colors.blue),
    );
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.add),
      elevation: 8,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 4,
        color: const Color.fromARGB(255, 0, 92, 179),
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
