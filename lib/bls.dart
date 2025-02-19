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
      body: Column(
        children: [
          // Top Row with Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildNavButton(
                    context,
                    'CPR',
                    CprPage(),
                    SvgPicture.asset(
                      'assets/cpr_icon.svg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNavButton(
                    context,
                    'CHOKING',
                    ChokingPage(),
                    SvgPicture.asset(
                      'assets/fbao_icon.svg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Content Below
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'What is Basic Life Support or BLS?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,

                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Basic Life Support (BLS) is a level of medical care used in emergencies for patients with life-threatening illnesses or injuries until they can receive full medical care. It focuses on maintaining the patient’s airway, breathing, and circulation (often referred to as the ABCs of BLS). BLS is typically performed by medical personnel, first responders, and trained bystanders.',
                    style: TextStyle(
                        fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                 // Image.asset('assets/bls_guide.png'), // Placeholder

                  const SizedBox(height: 20),

                  Text(
                    ' Emergency Action Principles',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Text(
                    'The Emergency Action Principles are essential guidelines for anyone providing first aid in an emergency situation. They help ensure that responders approach the scene methodically and provide the most appropriate care. Below is a breakdown of the key steps and elements involved in emergency action:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Survey the Scene',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset('assets/bls_guide.png'),
                      Text(
                        'This initial step helps you gather critical information about the environment and the incident. The goal is to ensure the scene is safe and to understand the situation better.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

// Elements of Surveying the Scene
                  Container(
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
                          'Elements of Surveying the Scene:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildBulletPoint(
                          'Scene Safety:',
                          'Ensure the environment is safe for you, the victim, and bystanders. Look out for hazards like fire, electrical wires, or traffic.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Mechanism of Injury:',
                          'Assess how the injury or condition occurred. This helps determine the nature of the problem and the level of care needed (e.g., head trauma from a fall, crushing injuries).',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Wearing PPE (Personal Protective Equipment):',
                          'If available, wear gloves, masks, and other protective gear to avoid contamination and minimize risk.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Determine the Number of Patients:',
                          'Check if there are multiple victims and prioritize care based on the severity of their injuries (triage).',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Consider Additional/Specialized Resources:',
                          'Assess whether specialized help (firefighters, paramedics) or equipment (defibrillators, stretchers) is needed.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Questions to Ask During Scene Surveillance
                  Container(
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
                          'Questions to Ask During Scene Surveillance:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildBulletPoint(
                          'Is the scene safe?',
                          'To ensure if it is safe to move in the scene.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'What happened? (Nature of the incident or injury)',
                          'This helps understand the severity and urgency.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'How many people are injured?',
                          'For the dispatcher to know how many ambulances to dispatch. 1 patient is to 1 ambulance.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Are there bystanders who can help?',
                          'Ask if they can assist with calling for help, providing basic first aid, or getting AED.',
                        ),
                        const SizedBox(height: 8),

                        _buildBulletPoint(
                          'Identify yourself as a trained first aider.',
                          "Hi, I'm Juan, I am a lay rescuer.",
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2. Activate Medical Assistance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset('assets/bls_guide.png'),
                      Text(
                      'Call First, CPR First Principle:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      _buildBulletPoint(
                      "If the victim is unresponsive and not breathing, call for emergency medical help immediately and begin CPR (if trained)",
                          ""
                      ),
                      _buildBulletPoint(
                      "Activation of emergency services (911 or local numbers) should occur as soon as possible.",
                      ""
                      ),
                  ],
                  ),



                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3. Do Primary Assessment of the Victim',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset('assets/bls_guide.png'),
                      Text(
                        'The Primary Assessment is quick and involves checking for immediate life-threatening conditions. This is commonly known as the ABC approach.',
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      // Bullet Points
                      _buildBulletPoint(
                        'A – Airway:',
                        "Ensure the airway is clear. If the victim is unconscious, position their head to open the airway.",
                      ),
                      _buildBulletPoint(
                        'B – Breathing:',
                        'Check if the victim is breathing. If they aren’t, provide rescue breaths.',
                      ),
                      _buildBulletPoint(
                        'C – Circulation:',
                        'Check for a pulse. If there is no pulse, begin CPR with chest compressions.',
                      ),
                    ],
                  ),



                      const SizedBox(height: 8),



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context,
      String title,
      Widget page,
      Widget icon,
      ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBulletPoint(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
