
import 'dart:async';
import 'dart:convert' show json;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'main_map_page.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email'
  ],
);

class GoPlacesLogin extends StatefulWidget {
  const GoPlacesLogin({Key? key}) : super(key: key);

  @override
  State createState() => GoPlacesLoginState();
}



class GoPlacesLoginState extends State<GoPlacesLogin> with TickerProviderStateMixin {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  late AnimationController controller;

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } 
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    super.initState();
    _checkPermission();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
       final GoogleSignInAccount? user = _currentUser;
       if (user != null) {
           _contactText = user.email;
            Future.delayed(Duration(seconds: 3), () {

            log('data: $user.email');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MapState(),
                    ),
                );
           });
      }
    });
    _googleSignIn.signInSilently();
  }

    @override
    void dispose(){
        controller.dispose();
        super.dispose();
    }
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    // Navigator.of(context).pushReplacement(
    //                 MaterialPageRoute(
    //                   builder: (context) => MapState(),
    //                 ),
    //               );
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    // if (user != null) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: <Widget>[
    //       ListTile(
    //         leading: GoogleUserCircleAvatar(
    //           identity: user,
    //         ),
    //         title: Text(user.displayName ?? ''),
    //         subtitle: Text(user.email),
    //       ),
    //       const Text('Signed in successfully.'),
    //       Text(_contactText),
    //       ElevatedButton(
    //         onPressed: _handleSignOut,
    //         child: const Text('SIGN OUT'),
    //       ),
    //       ElevatedButton(
    //         child: const Text('REFRESH'),
    //         onPressed: () => _handleGetContact(user),
    //       ),
    //     ],
    //   );
    // } else {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: <Widget>[
    //       const Text('You are not currently signed in.'),
    //       ElevatedButton(
    //         onPressed: _handleSignIn,
    //         child: const Text('SIGN IN'),
    //       ),
    //     ],
    //   );
      return Container( 
        decoration:BoxDecoration(
          image:DecorationImage(
            image:AssetImage( 'assets/images/goplaces_2.jpg'),
            fit:BoxFit.fitHeight
          )
        ),
        constraints: BoxConstraints.expand(),
        child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
          ),
          getLoginButton()
        ],
      ));
   // }
  }

    Widget getLoginButton()
    {
        final GoogleSignInAccount? user = _currentUser;
        if( user != null){
            return CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Linear progress indicator',
            );
        }
        else{
            return GestureDetector(
                    onTap:_handleSignIn,
                    child:Image.asset('assets/images/btn_google_signin_dark_normal_web.png'),
                );
        }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GoPlaces'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}