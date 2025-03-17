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
        title: const Text('CPR Guide for Age Groups'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              // Allows GridView inside Column
              crossAxisCount: 2,
              // 2 columns
              mainAxisSpacing: 12,
              // Reduced spacing
              crossAxisSpacing: 12,
              // Reduced spacing
              childAspectRatio: 1.45,
              // Adjusts the height/width ratio
              physics: const NeverScrollableScrollPhysics(),
              // Prevents GridView from scrolling separately
              children: [
                _buildNavButton(
                  context,
                  'ADULT',
                  AdultPage(),
                  SvgPicture.asset('assets/adult_icon.svg',
                      height: 50, width: 50),
                ),
                _buildNavButton(
                  context,
                  'CHILD',
                  ChildPage(),
                  SvgPicture.asset('assets/child_icon.svg',
                      height: 50, width: 50),
                ),
                _buildNavButton(
                  context,
                  'INFANT',
                  InfantPage(),
                  SvgPicture.asset('assets/infant_icon.svg',
                      height: 50, width: 50),
                ),
                _buildNavButton(
                  context,
                  'FLOWCHART',
                  CprFlowchartPage(),
                  SvgPicture.asset('assets/flowchart_icon.svg',
                      height: 50, width: 50),
                ),
              ],
            ),

            const SizedBox(height: 16), // Space before the text section

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: _buildMainExpansionTileTitle('What is CPR?', ''),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText(
                                "Cardiopulmonary Resuscitation (CPR) is an emergency life-saving procedure used when someone’s heart stops beating or they stop breathing. It involves two main actions:",
                              ),
                              _buildBulletPoint('Chest Compressions:',
                                  'To restore blood circulation and supply oxygen to vital organs, particularly the brain and heart.'),
                              _buildBulletPoint('Rescue Breaths (optional):',
                                  "To provide oxygen to the lungs if the person isn't breathing. This step is typically included if the rescuer is trained in mouth-to-mouth resuscitation."),
                              _buildText(
                                'CPR helps maintain circulation and oxygen flow until more advanced medical help arrives, potentially saving the person’s life.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ExpansionTile(
                      title: _buildMainExpansionTileTitle('Details of CPR', ''),
                      children: [
                        ExpansionTile(
                          title: _buildSubExpansionTileTitle('When to Start CPR'),
                          children: [
                            _buildContainer(
                              'When to Start CPR',
                              [
                                _buildBulletPoint('Unresponsive:', 'The victim does not respond to your voice or physical stimulation (e.g., shaking).'),
                                _buildBulletPoint('No Breathing (or Gasping):', 'The person isn’t breathing or is gasping for air, which is a sign of cardiac arrest.'),
                                _buildBulletPoint('No Definite Pulse:', 'If you cannot detect a pulse in the victim, this is another indication that CPR is needed.'),
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: _buildSubExpansionTileTitle('When NOT to Start CPR'),
                          children: [
                            _buildContainer(
                              'When NOT to Start CPR',
                              [
                                _buildBulletPoint('DNAR (Do Not Attempt Resuscitation):',
                                    'If there’s a clear instruction not to attempt resuscitation (usually based on the patient’s medical directive).'),
                                _buildBulletPoint('Irreversible Death:',
                                    'If the victim shows clear signs of death, such as rigor mortis or obvious decomposition, CPR should not be attempted'),
                                _buildBulletPoint('Vital Functions Deteriorated (e.g., Septic or Cardiogenic Shock):',
                                    'If the person’s vital functions have deteriorated beyond recovery, such as in cases of advanced septic shock or severe cardiogenic shock.'),
                                _buildBulletPoint('Confirmed Gestation (Pregnancy):',
                                    'In cases of advanced pregnancy, CPR techniques may differ and require additional considerations.'),
                                _buildBulletPoint('Attempting CPR Would Place the Rescuer at Risk:',
                                    "If performing CPR could expose the rescuer to significant harm (e.g., in unsafe conditions like a burning building or dangerous traffic), it's critical to assess the situation and prioritize your safety first"),
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: _buildSubExpansionTileTitle('When to STOP CPR'),
                          children: [
                            _buildContainer(
                              'When to STOP CPR',
                              [
                                _buildBulletPoint('S – Signs of Life:',
                                    'If the victim shows signs of life (e.g., breathing, moving, or having a pulse), stop CPR.'),
                                _buildBulletPoint('T – Trained Medical Help Arrives:',
                                    'If advanced medical personnel (EMS or paramedics) arrive, stop CPR and let them take over.'),
                                _buildBulletPoint('O – Out of Energy/Resources:',
                                    'If you are too exhausted to continue CPR effectively, you may stop and allow another person to take over if available.'),
                                _buildBulletPoint("P – Physician's Order:",
                                    'If a medical professional orders you to stop CPR (in the case of a DNAR order, for example), cease immediately.'),
                                _buildBulletPoint('S – Scene Becomes Unsafe:',
                                    "If the scene becomes dangerous or unsafe, stop performing CPR and move to a safer location if possible"),
                                _buildBulletPoint('S – Spontaneous Circulation Restored',
                                    "If the victim starts breathing normally, has a pulse, or shows signs of recovery, stop CPR and monitor their condition until emergency services arrive."),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMainExpansionTileTitle(String title, String assetPath) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          height: 24,
          width: 24,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubExpansionTileTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(
      BuildContext context, String title, Widget page, Widget icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildContainer(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: '$title\n ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: description,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
