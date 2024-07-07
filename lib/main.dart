import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:flutter_myapp/Auth/Signin/Signin.dart';
import 'package:flutter_myapp/Auth/Service/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyAjmshOTFDjdaV0ZR4iI_kHbTGMmubR8ho",
            appId: "1:406276431831:android:3a331cd3244a3743e8b592",
            messagingSenderId: "406276431831",
            projectId: "pushnotification-f1532",
          ),
        )
      : await Firebase.initializeApp(); // Initialize Firebase without options

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: AuthService()),
        // StreamProvider<User>.value(AuthService().user)
        // Provider<AuthService>(create: (_) => AuthService(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/signin': (context) => SignInPage(),
        },
      ),
    );
  }
}
