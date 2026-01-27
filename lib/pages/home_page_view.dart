import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 2, 45, 90)
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text("Credito Solidario"),
            ),
          )
          
        ],
      ),
    );
  }
}