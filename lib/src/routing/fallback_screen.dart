import 'package:flutter/material.dart';

class FallbackScreen extends StatelessWidget {
  const FallbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Not Found Screen',
          style: TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
