import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/fullscreen.dart'; // Make sure to import the fullscreen.dart file

Widget buildCarousel(List<String> imageList, BuildContext context) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 400,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      autoPlay: false,
    ),
    items: imageList.map((image) {
      return GestureDetector(
        onTap: () {
          // Navigate to FullScreenImagePage when an image is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImagePage(imageUrl: image),
            ),
          );
        },
        child: Image.asset(image, fit: BoxFit.contain), // Image displayed in carousel
      );
    }).toList(),
  );
}

class ChildPage extends StatelessWidget {
  final List<String> childPosters = [
    'assets/child_poster_1.png',
    'assets/child_poster_2.png',
    'assets/child_poster_3.png',
    'assets/child_poster_4.png',
    'assets/child_poster_5.png',
    'assets/child_poster_6.png',
    'assets/child_poster_7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child CPR Guide')),
      body: Center(
        child: buildCarousel(childPosters, context), // Pass context to buildCarousel
      ),
    );
  }
}
