import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../src/locations.dart' as locations;
import 'info_panel.dart' as infopanel;
import 'app_info.dart' as appinfo;

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

class MapState extends StatefulWidget {
  const MapState({Key? key}) : super(key: key);

  @override
  State<MapState> createState() => _MapState();
}

class _MapState extends State<MapState> {
  final Map<String, Marker> _markers = {};

  final PanelController _pc = PanelController();
  bool _visible = true;
  int currentIndex = 0;
  List<locations.Poi> pois = [];
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

  Future<void> _onMapCreated(GoogleMapController controller) async {
    locations.Locations locs = await locations.getPointsOfInterest();

    pois = locs.pois;
    setState(() {
      _markers.clear();

      int idx = 0;
      for (final poi in pois) {
        final marker = Marker(
          markerId: MarkerId(poi.name),
          position: LatLng(poi.lat, poi.lng),
          visible: _visible,
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

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    );
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
        panel: infopanel.InfoPanelLayout(currentPoi),
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
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/drawer.jpg'),
                ),
              ),
              child: Container(
                child: Column(
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Container(child: const MyStatefulWidget()),
            Container(
              color: Colors.white,
              height: 50,
              width: 100,
            ),
            Container(
              child: FlatButton(
                color: const Color.fromARGB(255, 0, 92, 179),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const appinfo.Infopage()),
                  );
                },
                child: const Text('App Info'),
              ),
            ),
          ],
        ),
      ),
    ));
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
