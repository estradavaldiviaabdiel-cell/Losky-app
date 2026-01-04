import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/redeem_qr_screen.dart';

void main() {
  runApp(LoskyApp());
}

class LoskyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Losky Factory',
      theme: ThemeData(
        primaryColor: Color(0xFFA8D9B0),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/rewards': (context) => RewardsScreen(),
        '/redeem_qr': (context) => RedeemQRScreen(),
      },
    );
  }
}