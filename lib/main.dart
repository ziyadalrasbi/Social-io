import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/form_authentication.dart';
import 'package:login_page/pages/home/home_page.dart';
import 'package:login_page/extra/aboutus/about_us.dart';
import 'package:login_page/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        title: 'Home Page',
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
        MaterialPageRoute(
          builder: (context) {
            return AboutUs();
          }
        ),
      );
    } 
    });
    return HomePage();
  }
}
