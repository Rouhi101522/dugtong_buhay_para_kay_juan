import 'package:flutter/material.dart';

class CprFlowchartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CPR Flowchart')),
      body: Center(
        child: Image.asset('assets/cpr_flowchart.png', fit: BoxFit.contain),
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
        child: Image.asset('assets/fbao_flowchart.png', fit: BoxFit.contain),
      ),
    );
  }
}
