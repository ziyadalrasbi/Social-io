import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialio/extra/chatpage/chat_page.dart';
import 'package:socialio/form_authentication.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/home/home_page.dart';
import 'package:socialio/pages/camera/camera.dart';
import 'package:socialio/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialio/pages/navbar/bottombar.dart';
import 'package:socialio/pages/profile/profile_1.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLogged = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    await HelperFunction.getLoggedInSharedPref().then((val) {
      setState(() {
        userLogged = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social-io',
        theme: ThemeData(
          primaryColor: primaryLightColour,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();

    Future.delayed(Duration.zero, () {
      if (firebaseuser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return BottomBar();
          }),
        );
      } else {
        return HomePage();
      }
    });
    return HomePage();
  }
}
