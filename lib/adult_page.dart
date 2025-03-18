import 'package:flutter/material.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/collats_full.dart';

//
// class AdultPage extends StatefulWidget {
//   @override
//   _AdultPageState createState() => _AdultPageState();
// }
//
// class _AdultPageState extends State<AdultPage> {
//   final CarouselController _carouselController = CarouselController();
//   int _currentIndex = 0;
//
//   final List<String> adultPosters = [
//     'assets/adult_poster_1.png',
//     'assets/adult_poster_2.png',
//     'assets/adult_poster_3.png',
//     'assets/adult_poster_4.png',
//     'assets/adult_poster_5.png',
//     'assets/adult_poster_6.png',
//     'assets/adult_poster_7.png',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Adult CPR Guide')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CarouselSlider(
//             carouselController: _carouselController,
//             options: CarouselOptions(
//               height: 400,
//               enlargeCenterPage: true,
//               enableInfiniteScroll: false,
//               autoPlay: false,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             ),
//             items: adultPosters.map((image) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FullScreenImagePage(imageUrl: image),
//                     ),
//                   );
//                 },
//                 child: Image.asset(image, fit: BoxFit.contain),
//               );
//             }).toList(),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Built-in Carousel Slider Indicator
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: adultPosters.asMap().entries.map((entry) {
//               return GestureDetector(
//                 onTap: () => _carouselController.animateToPage(entry.key),
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }



class AdultPage extends StatefulWidget {
  @override
  _AdultPageState createState() => _AdultPageState();
}

class _AdultPageState extends State<AdultPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
      appBar: AppBar(title: const Text('Adult CPR Guide')),
      body: Column(
        children: [
          // Image Slider
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: adultPosters.length,
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
                      builder: (context) => FullScreenImagePage(imageUrl: adultPosters[index]),
                    ),
                  );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(adultPosters[index], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),

          // Page Indicators (Dots)
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(adultPosters.length, (index) {
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

