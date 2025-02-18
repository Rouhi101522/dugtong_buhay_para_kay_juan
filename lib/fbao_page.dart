import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/fullscreen.dart'; // Ensure you have the full screen page

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

class FbaoPage extends StatelessWidget {
  final List<String> fbaoImages = [
    'assets/fbao_poster_1.png',
    'assets/fbao_poster_2.png',
    'assets/fbao_poster_3.png',
    'assets/fbao_poster_4.png',
    'assets/fbao_poster_5.png',
    'assets/fbao_poster_6.png',
    'assets/fbao_poster_7.png',
    'assets/fbao_poster_8.png',
    'assets/fbao_poster_9.png',
    'assets/fbao_poster_10.png',
    'assets/fbao_poster_11.png',
    'assets/fbao_poster_12.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FBAO Guide')),
      body: Center(
        child: buildCarousel(fbaoImages, context), // Pass context to buildCarousel
      ),
    );
  }
}
