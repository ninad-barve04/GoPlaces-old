import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'src/locations.dart' as locations;
import 'src/settings_page.dart' as homepage;
import 'src/App_info.dart' as App_info;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapState(),
    );
  }
}

class MapState extends StatefulWidget {
  const MapState({Key? key}) : super(key: key);

  @override
  State<MapState> createState() => _MapState();
}

class _MapState extends State<MapState> {
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
    _showMyDialog();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("MapApp"),
          backgroundColor: const Color.fromARGB(255, 8, 214, 118),
          
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(18, 73),
            zoom: 4.0,
          ),
          markers: _markers.values.toSet(),
        ),
        
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget>[
              DrawerHeader(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: AssetImage('assets/images/drawer.jpg'),),),
              child: Container(
                child: Column(children: [
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
              Container(child: MyStatefulWidget()),
              Container(
              color: Colors.white,
              height: 50,
              width: 100,
            ),
              Container(child: FlatButton(
                color: Color.fromARGB(255, 26, 192, 32),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const App_info.Infopage()),
                );

                },
                child: Text('App Info'),
                ),
                ),
                
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    DecoratedBox(decoration: BoxDecoration(color: Colors.green),);    
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.add),
      elevation: 8,
      style: const TextStyle(color: Colors.green),
      underline: Container(
        height: 4,
        color: Color.fromARGB(255, 45, 212, 51),
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Settings','user','log in','log out']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

