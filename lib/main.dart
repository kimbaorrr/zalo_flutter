import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zalo/firebase_options.dart';
import '/Auth/Service/auth_service.dart';
import '/Auth/Signin/Signin.dart';
import '/Auth/Service/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          '/': (context) => const Wrapper(),
          '/signin': (context) => const SignInPage(),
        },
      ),
    );
  }
}
