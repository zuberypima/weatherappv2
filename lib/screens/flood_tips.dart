import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgListFlood = [
  'assets/tips/em1.png',
  'assets/tips/em2.png',
  'assets/tips/em3.png',
  // 'assets/tips/w4.png',
  // 'assets/tips/w5.png',
];

final themeMode = ValueNotifier(2);

class FloodTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tips for Strong wind"),
      ),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              pageSnapping: true,
              autoPlay: true,
            ),
            items: imgListFlood
                .map((item) => Container(
                      child: Center(
                          child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        height: height,
                      )),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
