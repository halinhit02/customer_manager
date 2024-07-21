import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/ic_app.png',
            height: 105,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
