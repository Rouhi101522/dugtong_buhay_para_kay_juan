import 'package:flutter/material.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/fullscreen.dart';

class ChildPage extends StatefulWidget {
  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
      body: Column(
        children: [
          // Image Slider
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: childPosters.length,
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
                        builder: (context) => FullScreenImagePage(imageUrl: childPosters[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(childPosters[index], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),

          // Page Indicators (Dots)
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(childPosters.length, (index) {
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
