import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'cpr_page.dart';
import 'choking_page.dart';

class BlsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Life Support Guide'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context,
              'CPR',
              CprPage(),
              SvgPicture.asset(
                'assets/cpr_icon.svg',
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(height: 30),

            _buildNavButton(
              context,
              'CHOKING',
              ChokingPage(),
              SvgPicture.asset(
                'assets/fbao_icon.svg',
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context,
      String title,
      Widget page,
      Widget icon, // Changed to Widget
      ) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: screenHeight * 0.12,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon, // Display the passed SVG or icon
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
