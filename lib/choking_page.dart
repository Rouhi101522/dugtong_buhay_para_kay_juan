import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fbao_page.dart';
import 'flowchart_page.dart';

class ChokingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choking Guide')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context,
              'FBAO GUIDE',
              FbaoPage(),
              SvgPicture.asset(
                'assets/choking_icon.svg',
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(height: 20),
            _buildNavButton(
              context,
              'FLOWCHART',
              FbaoFlowchartPage(),
              SvgPicture.asset(
                'assets/flowchart_icon.svg',
                height: 40,
                width: 40,
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
      Widget icon,
      ) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(

        height: screenHeight * 0.12,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              icon,
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
