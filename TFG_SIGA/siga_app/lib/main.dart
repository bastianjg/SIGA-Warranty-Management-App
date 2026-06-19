import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/boletas_list_screen.dart';
import 'screens/ocr_screen.dart';
import 'screens/profile_screen.dart';

import 'services/auth_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthService authService = AuthService();

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: FutureBuilder<bool>(

        future: authService.isLoggedIn(),

        builder: (context, snapshot) {

          // loading inicial
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final loggedIn = snapshot.data ?? false;

          // si tiene sesión → home
          if (loggedIn) {
            return const HomeScreen();
          }

          // si NO tiene sesión → auth
          return const AuthScreen();
        },
      ),

      routes: {

        '/home': (context) => const HomeScreen(),

        '/boletas': (context) => const BoletasListScreen(),

        '/ocr': (context) => const OCRScreen(),

        '/perfil': (context) => const ProfileScreen(),

        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}