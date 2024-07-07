import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:flutter_myapp/Auth/UserModel.dart';
import 'package:flutter_myapp/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../StartPage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) debugPrint('movieTitle');
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null ? StartPage() : HomeScreen();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
