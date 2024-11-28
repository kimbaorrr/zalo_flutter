import 'package:flutter/material.dart';
import '/Auth/Service/auth_service.dart';
import '/Auth/UserModel.dart';
import '/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

import '/Auth/StartPage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) debugPrint('movieTitle');
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null ? const StartPage() : const HomeScreen();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
