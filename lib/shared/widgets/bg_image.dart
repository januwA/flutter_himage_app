import 'package:flutter/material.dart';

class BgImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Image.asset(
        'assets/images/bg.jpg',
        height: MediaQuery.of(context).size.height / 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
