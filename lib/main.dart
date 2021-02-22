import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:jjovpn/screens/home_page.dart';
import 'package:jjovpn/screens/server_list_page.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // gives our app awareness about whether we are succesfully connected to the cloud
  bool _amplifyConfigured = false;

  // controllers for text input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSignUpComplete = false;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    Amplify.addPlugin(AmplifyAnalyticsPinpoint());
    Amplify.addPlugin(AmplifyAuthCognito());
    //Amplify.addPlugin(AmplifyAuthCognito());


    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }

  }

  void _recordEvent() async {
    AnalyticsEvent event = AnalyticsEvent("test");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    Amplify.Analytics.recordEvent(event: event);
  }

  Future<String> _registerUser(LoginData data) async
  {
    try {
      Map<String, dynamic> userAttributes = {
        "email": emailController.text,
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: data.name,
          password: data.password,
          options: CognitoSignUpOptions(
              userAttributes: userAttributes
          )
      );
      setState(() {
        isSignUpComplete = res.isSignUpComplete;
        print("Sign up: " + (isSignUpComplete ? "Complete" : "Not Complete"));
      });
    } on AuthError catch (e) {
      print(e);
      return "Register Error: " + e.toString();
    }
  }

  Future<String> _signIn(LoginData data) async {
    try {
      await Amplify.Auth.signOut(
        //globalSignOut: true
      );
    } on AuthError catch (e) {
      print(e);
    }

    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );
      setState(() {
        isSignedIn = res.isSignedIn;
      });

      if (isSignedIn) {
        //Alert(context: context, type: AlertType.success, title: "Login Success", desc: "Noice!").show();
        isSignedIn = res.isSignedIn;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) {
          return ServerListPage();
        }));
      }

    } on AuthError catch (e) {
      Alert(context: context, type: AlertType.error, title: "Login Failed", desc: e.toString()).show();
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterLogin(
        //logo: 'assets/jjopentesterLogo.png',
          logo: 'assets/WhiteHat.png',
          onLogin: _signIn,
          onSignup: _registerUser,
          onRecoverPassword: (_) => null,
          title:'JJO VPN'
      ),
    );
  }
}