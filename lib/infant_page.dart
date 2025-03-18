import 'package:flutter/material.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/collats_full.dart';

class InfantPage extends StatefulWidget {
  @override
  _InfantPageState createState() => _InfantPageState();
}

class _InfantPageState extends State<InfantPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> infantPosters = [
    'assets/infant_poster_1.png',
    'assets/infant_poster_2.png',
    'assets/infant_poster_3.png',
    'assets/infant_poster_4.png',
    'assets/infant_poster_5.png',
    'assets/infant_poster_6.png',
    'assets/infant_poster_7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infant CPR Guide')),
      body: Column(
        children: [
          // Image Slider
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: infantPosters.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(imageUrl: infantPosters[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(infantPosters[index], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),

          // Page Indicators (Dots)
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(infantPosters.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
