import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class MapState extends StatefulWidget {
  const MapState({Key? key}) : super(key: key);

  @override
  State<MapState> createState() => _MapState();
}

class _MapState extends State<MapState> {
  Map<String, Marker> _markers = {};

  final PanelController _pc = PanelController();
  bool _visible = true;
  int currentIndex = 0;
  List<locations.Poi> pois = [];

  GoogleMapController? _mapController;
  locations.Poi currentPoi = locations.Poi(
      address: "",
      id: "",
      image:
          "https://ik.imagekit.io/goplaces/GoPlaces-logos_QI1sFe82N.jpeg?ik-sdk-version=javascript-1.4.3&updatedAt=1654224201276",
      lat: 0.0,
      lng: 0.0,
      name: "",
      phone: "",
      region: "");

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

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    locations.Locations locs = await locations.getPointsOfInterest();

    var iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 21)), "assets/images/marker_gp.png");

    pois = locs.pois;
    setState(() {
      //  _markers.clear();

      int idx = 0;
      for (final poi in pois) {
        final marker = Marker(
          markerId: MarkerId(poi.name),
          position: LatLng(poi.lat, poi.lng),
          visible: true,
          icon: iconMarker,
          onTap: () {
            _visible = false;
            setState(() {
              currentIndex = idx++;
              currentPoi = poi;
            });
            _pc.open();
          },
        );
        _markers[poi.name] = marker;
      }
    });
  }

  processDirectionRequest() async {
    print(">>processDirectionRequest");

    print(_markers['loc']);
    await _getCurrentLocation();

    print(_markers['loc']);
  }

  GoogleSignInAccount? _currentUser;
  String _city = "Pune";

  Position? _currentPosition;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    );
    GoogleSignInAccount? user = _currentUser;
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
            panel:
                infopanel.InfoPanelLayout(currentPoi, processDirectionRequest),
            borderRadius: radius,
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(18.5293825, 73.8543523),
                zoom: 12.0,
              ),
              markers: _markers.values.toSet(),
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
                          items: [
                            DropdownMenuItem(
                              child: Text("Pune"),
                              value: "Pune",
                            ),
                            DropdownMenuItem(
                              child: Text("Mumbai"),
                              value: "Mumbai",
                            ),
                            DropdownMenuItem(
                              child: Text("Delhi"),
                              value: "Delhi",
                            )
                          ],
                          onChanged: (String? value) {
                            if (_pc.isPanelOpen) {
                              _pc.close();
                            }
                            setState(() {
                              _city = value!;
                            });
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
                  // ListTile(
                  //   leading: GoogleUserCircleAvatar(identity: user),
                  //   title: Text(user.displayName ?? ''),
                  //   subtitle: Text(user.email),
                  // ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () => signOut(context),
                      child: const Text('Sign Out')),
                ],
              )),
              Container(
                color: Colors.white,
                height: 30,
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
          panel: infopanel.InfoPanelLayout(currentPoi, processDirectionRequest),
          borderRadius: radius,
          body: const Text("GoPlaces.."),
        ),
      ));
    }
  }
}

void signOut(BuildContext context) async {
  _googleSignIn.disconnect();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => login.GoPlacesLogin(),
    ),
  );
}

Future<void> signIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (e) {
    print('Error in signIn $e');
  }
}

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
