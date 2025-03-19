import 'package:flutter/material.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/collats_full.dart';

class CprFlowchartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CPR Flowchart')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImagePage(imageUrl: 'assets/cpr_flowchart.png'),
              ),
            );
          },
          child: Image.asset('assets/cpr_flowchart.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class FbaoFlowchartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FBAO Flowchart')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImagePage(imageUrl: 'assets/fbao_flowchart.png'),
              ),
            );
          },
          child: Image.asset('assets/fbao_flowchart.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
