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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                // Two buttons per row
                mainAxisSpacing: 12,
                // Vertical spacing
                crossAxisSpacing: 12,
                // Horizontal spacing
                childAspectRatio: 1.45,
                // Adjusts button height-width balance
                physics: const NeverScrollableScrollPhysics(),
                // Prevents separate scrolling
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
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _buildSectionTitle('What is Basic Life Support or BLS?'),
                      const SizedBox(height: 20),
                      _buildText(
                        'Basic Life Support (BLS) is a level of medical care used in emergencies for patients with life-threatening illnesses or injuries until they can receive full medical care. It focuses on maintaining the patient’s airway, breathing, and circulation (often referred to as the ABCs of BLS). BLS is typically performed by medical personnel, first responders, and trained bystanders.',
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Emergency Action Principles'),
                      _buildText(
                        'The Emergency Action Principles are essential guidelines for anyone providing first aid in an emergency situation. They help ensure that responders approach the scene methodically and provide the most appropriate care. Below is a breakdown of the key steps and elements involved in emergency action:',
                      ),
                      const SizedBox(height: 10),
                      _buildSubSection(
                        '1. Survey the Scene',
                        'This initial step helps you gather critical information about the environment and the incident. The goal is to ensure the scene is safe and to understand the situation better.',
                        'assets/survey.png',
                      ),
                      const SizedBox(height: 10),
                      _buildContainer(
                        'Elements of Surveying the Scene:',
                        [
                          _buildBulletPoint('Scene Safety:',
                              'Ensure the environment is safe for you, the victim, and bystanders. Look out for hazards like fire, electrical wires, or traffic.'),
                          _buildBulletPoint('Mechanism of Injury:',
                              'Assess how the injury or condition occurred. This helps determine the nature of the problem and the level of care needed (e.g., head trauma from a fall, crushing injuries).'),
                          _buildBulletPoint(
                              'Wearing PPE (Personal Protective Equipment):',
                              'If available, wear gloves, masks, and other protective gear to avoid contamination and minimize risk.'),
                          _buildBulletPoint('Determine the Number of Patients:',
                              'Check if there are multiple victims and prioritize care based on the severity of their injuries (triage).'),
                          _buildBulletPoint(
                              'Consider Additional/Specialized Resources:',
                              'Assess whether specialized help (firefighters, paramedics) or equipment (defibrillators, stretchers) is needed.'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildContainer(
                        'Questions to Ask During Scene Surveillance:',
                        [
                          _buildBulletPoint('Is the scene safe?',
                              'To ensure if it is safe to move in the scene.'),
                          _buildBulletPoint(
                              'What happened? (Nature of the incident or injury)',
                              'This helps understand the severity and urgency.'),
                          _buildBulletPoint('How many people are injured?',
                              'For the dispatcher to know how many ambulances to dispatch. 1 patient is to 1 ambulance.'),
                          _buildBulletPoint(
                              'Are there bystanders who can help?',
                              'Ask if they can assist with calling for help, providing basic first aid, or getting AED.'),
                          _buildBulletPoint(
                              'Identify yourself as a trained first aider.',
                              "Hi, I'm Juan, I am a lay rescuer."),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSubSection(
                        '2. Activate Medical Assistance',
                        'Call First, CPR First Principle: If the victim is unresponsive and not breathing, call for emergency medical help immediately and begin CPR (if trained). Activation of emergency services (911 or local numbers) should occur as soon as possible.',
                        'assets/activateEMS.png',
                      ),
                      const SizedBox(height: 20),
                      _buildSubSection(
                        '3. Do Primary Assessment of the Victim',
                        'The Primary Assessment is quick and involves checking for immediate life-threatening conditions. This is commonly known as the ABC approach.',
                        'assets/primary_check.png',
                      ),
                      const SizedBox(height: 8),
                      _buildBulletPoint('A – Airway:',
                          "Ensure the airway is clear. If the victim is unconscious, position their head to open the airway."),
                      _buildBulletPoint('B – Breathing:',
                          'Check if the victim is breathing. If they aren’t, provide rescue breaths.'),
                      _buildBulletPoint('C – Circulation:',
                          'Check for a pulse. If there is no pulse, begin CPR with chest compressions.'),
                      const SizedBox(height: 20),
                      _buildSubSection(
                        '4. Secondary Survey',
                        'Once immediate life threats are addressed, perform a secondary survey for a more thorough evaluation.',
                        'assets/secondary_check.png',
                      ),
                      const SizedBox(height: 16),
                      _buildContainer(
                        'Remember S.A.M.P.L.E. (Patient History):',
                        [
                          _buildBulletPoint('S – Signs & Symptoms:',
                              'Ask the patient or bystanders about what is happening. (e.g., pain, dizziness)'),
                          _buildBulletPoint('A – Allergies:',
                              'Ask if the patient has any known allergies (e.g., food, medications, insect stings).'),
                          _buildBulletPoint('M – Medications:',
                              'Ask about any medications the patient is taking.'),
                          _buildBulletPoint('P – Past medical history:',
                              'Inquire about any previous medical conditions that may be relevant.'),
                          _buildBulletPoint('L – Last oral intake:',
                              "Ask when the victim last ate or drank. This can help inform treatment."),
                          _buildBulletPoint(
                              'E – Events leading up to the incident:',
                              "Ask what happened right before the injury or illness."),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildContainer(
                        'Vital Checking:',
                        [
                          _buildText(
                              'Check vital signs such as pulse, breathing, and level of consciousness (e.g., AVPU scale: Alert, Verbal, Pain, Unresponsive).'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildContainer(
                        'Head-to-Toe Examination (DCAPBTLS):',
                        [
                          _buildBulletPoint('D – Deformities', ''),
                          _buildBulletPoint('C – Contusions (bruising)', ''),
                          _buildBulletPoint('A – Abrasions (scrapes)', ''),
                          _buildBulletPoint('P – Punctures/penetrations', ''),
                          _buildBulletPoint('B – Burns', ''),
                          _buildBulletPoint('T – Tenderness', ''),
                          _buildBulletPoint('L – Lacerations (cuts)', ''),
                          _buildBulletPoint('S – Swelling', ''),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSubSection(
                        '5. Referral of Patient to Advanced Medical Team',
                        'After performing the primary and secondary assessments, refer the patient to a more advanced medical team (paramedics, doctors) for further evaluation and treatment. Provide a clear and concise report on the victim’s condition, history, and any treatment you have administered.',
                        'assets/referral.png',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildSubSection(String title, String description, String assetPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset(assetPath),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
      ],
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
