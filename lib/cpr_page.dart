import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'adult_page.dart';
import 'child_page.dart';
import 'infant_page.dart';
import 'flowchart_page.dart';


class CprPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPR Guide'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(context, 'ADULT', AdultPage(),  SvgPicture.asset(
          'assets/adult_icon.svg',
          height: 40,
          width: 40,)),
            const SizedBox(height: 16),
            _buildNavButton(context, 'CHILD', ChildPage(),SvgPicture.asset(
              'assets/child_icon.svg',
              height: 40,
              width: 40,)),
            const SizedBox(height: 16),
            _buildNavButton(context, 'INFANT', InfantPage(),SvgPicture.asset(
              'assets/infant_icon.svg',
              height: 40,
              width: 40,)),
            const SizedBox(height: 16),
            _buildNavButton(context, 'FLOWCHART', CprFlowchartPage(),SvgPicture.asset(
              'assets/flowchart_icon.svg',
              height: 40,
              width: 40,))
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget page,  Widget icon) {
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
