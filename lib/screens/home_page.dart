import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jjovpn/screens/server_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:jjovpn/main.dart';
import 'package:amplify_flutter/amplify.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'shared_widgets/server_list_widget.dart';
import 'package:flutter_openvpn/flutter_openvpn.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  String value1;
  String value2;
  String value3;

  HomePage({this.value1, this.value2, this.value3});

  @override
  _HomePageState createState() => _HomePageState(value1, value2, value3);
}

class _HomePageState extends State<HomePage> {
  FlutterVpnState _flutterVpnState = FlutterVpnState.disconnected;
  CharonErrorState charonState = CharonErrorState.NO_ERROR;

  //bool _amplifyConfigured = false;

  String value1;
  String value2;
  String value3;
  String data;
  _HomePageState(this.value1, this.value2, this.value3);

  @override
  void initState() {
    //FlutterVpn.prepare();
    //FlutterVpn.onStateChanged.listen((FlutterVpnState flutterVpnState) =>
    //setState(() => this._flutterVpnState = flutterVpnState));

    super.initState();
    //_configureAmplify();

    FlutterOpenvpn.init(
      localizedDescription: "jjovpn", //this is required only on iOS
      providerBundleIdentifier:
          "group.jjopentester.jjovpn.VPNNetExt", //this is required only on iOS
      //localizedDescription is the name of your VPN profile
      //providerBundleIdentifier is the bundle id of your vpn extension
    );
  }

  void _configureAmplify() async {
    if (!mounted) return;
    Amplify.addPlugins(
        [AmplifyAnalyticsPinpoint(), AmplifyAuthCognito(), AmplifyStorageS3()]);

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);

    try {
      setState(() {
        //_amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'JJO Pentester VPN',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w600),
          ),
          leading: new GestureDetector(
            child: new Icon(Icons.logout),
            onTap: () async {
              //print('logout button hit');
              try {
                await Amplify.Auth.signOut(
                    //globalSignOut: true
                    );
              } on AuthError catch (e) {
                print(e);
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 50,
                child: Opacity(
                    opacity: .1,
                    child: Image.asset(
                      'assets/background.png',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height / 1.5,
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Center(
                      child: Text(
                    '${connectionState(state: _flutterVpnState)}',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  SizedBox(height: 8),
                  Center(
                      child: Text(
                    "Current server: " + value2,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color.fromRGBO(37, 112, 252, 1),
                        fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: AvatarGlow(
                      glowColor:
                          _flutterVpnState == FlutterVpnState.disconnected
                              ? Colors.transparent
                              : Color.fromRGBO(37, 112, 252, 1),
                      endRadius: 100.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: _flutterVpnState == FlutterVpnState.disconnected
                          ? false
                          : true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      shape: BoxShape.circle,
                      // Add button gesture on Material below
                      child: new GestureDetector(
                        onTap: () async {
                          //debugPrint(finalcontent);
                          print("Connect button tapped.");
                          String finalcontent =
                              await rootBundle.loadString(value3);
                            FlutterOpenvpn.lunchVpn(
                              finalcontent,
                                  (isProfileLoaded) =>
                                  print('isProfileLoaded : $isProfileLoaded'),
                                  (newVpnStatus) =>
                              {
                                print('vpnActivated : $newVpnStatus'),
                                // Need to change the state according to the new status here, and reload the button
                                setState(() {
                                  if (newVpnStatus == 'CONNECTED')
                                    _flutterVpnState =
                                        FlutterVpnState.connected;
                                  else if (newVpnStatus == 'DISCONNECTED')
                                    _flutterVpnState =
                                        FlutterVpnState.disconnected;
                                  else
                                    _flutterVpnState =
                                        FlutterVpnState.connecting;
                                })
                              },
                              //onConnectionStatusChanged: (duration, lastPacketRecieve, byteIn, byteOut) => print(byteIn),
                              //expireAt: DateTime.now().add(Duration(seconds: 30)),
                            );
                        },
                        child: Material(
                          elevation: 2,
                          shape: CircleBorder(),
                          color:
                              _flutterVpnState == FlutterVpnState.connected
                                  ? Color.fromRGBO(146, 236, 136, 10)
                                  : Colors.grey,
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${connectionButtonState(state: _flutterVpnState)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(),
                  SizedBox(
                    height: 25,
                  ),
                  ServerItemWidget(
                    flagAsset: value1,
                    label: value2,
                    icon: Icons.arrow_forward_ios,
                    onTap: () {
                      //print(value1);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ServerListPage();
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  String connectionState({FlutterVpnState state}) {
    switch (state) {
      case FlutterVpnState.connected:
        return 'You are connected';
      case FlutterVpnState.connecting:
        return 'VPN is connecting';
      case FlutterVpnState.disconnected:
        return 'You are disconnected';
      case FlutterVpnState.disconnecting:
        return 'VPN is disconnecting';
      case FlutterVpnState.genericError:
        return 'Error getting status';
      default:
        return 'Getting connection status';
    }
  }

  String connectionButtonState({FlutterVpnState state}) {
    switch (state) {
      case FlutterVpnState.connected:
        return 'Connected';
      case FlutterVpnState.connecting:
        return 'Connecting';
      case FlutterVpnState.disconnected:
        return 'Disconnected';
      case FlutterVpnState.disconnecting:
        return 'Disconnecting';
      case FlutterVpnState.genericError:
        return 'Error';
      default:
        return 'Disconnected';
    }
  }
}