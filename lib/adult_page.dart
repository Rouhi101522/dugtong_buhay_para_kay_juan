import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/fullscreen.dart';

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
        child: Image.asset(image, fit: BoxFit.contain), // Correctly loading from assets
      );
    }).toList(),
  );
}

class AdultPage extends StatelessWidget {
  final List<String> adultPosters = [
    'assets/adult_poster_1.png',
    'assets/adult_poster_2.png',
    'assets/adult_poster_3.png',
    'assets/adult_poster_4.png',
    'assets/adult_poster_5.png',
    'assets/adult_poster_6.png',
    'assets/adult_poster_7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adult CPR Guide')), // Updated title for clarity
      body: Center(
        child: buildCarousel(adultPosters, context),  // Pass context to buildCarousel
      ),
    );
  }
}
