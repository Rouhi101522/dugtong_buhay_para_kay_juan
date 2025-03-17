import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cpr_page.dart';
import 'choking_page.dart';

class BlsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Basic Life Support Guide'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _showCoursePopup(context);
              },
            ),
          ],
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
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: _buildMainExpansionTileTitle(
                              'What is Basic Life Support or BLS?', 'assets/bls_icon.svg'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _buildText(
                                'Basic Life Support (BLS) is a level of medical care used in emergencies for patients with life-threatening illnesses or injuries until they can receive full medical care. It focuses on maintaining the patient’s airway, breathing, and circulation (often referred to as the ABCs of BLS). BLS is typically performed by medical personnel, first responders, and trained bystanders.',
                              ),
                            ),
                          ],
                        ),

                        ExpansionTile(
                          title: _buildMainExpansionTileTitle(
                              'Emergency Action Principles', 'assets/emergency_icon.svg'),
                          children: [
                            ExpansionTile(
                              title: _buildSubExpansionTileTitle('1. Survey the Scene'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _buildText(
                                    'This initial step helps you gather critical information about the environment and the incident. The goal is to ensure the scene is safe and to understand the situation better.',
                                  ),
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
                                    _buildBulletPoint('Are there bystanders who can help?',
                                        'Ask if they can assist with calling for help, providing basic first aid, or getting AED.'),
                                    _buildBulletPoint(
                                        'Identify yourself as a trained first aider.',
                                        "Hi, I'm Juan, I am a lay rescuer."),
                                  ],
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: _buildSubExpansionTileTitle('2. Activate Medical Assistance'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _buildText(
                                    'Call First, CPR First Principle: If the victim is unresponsive and not breathing, call for emergency medical help immediately and begin CPR (if trained). Activation of emergency services (911 or local numbers) should occur as soon as possible.',
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: _buildSubExpansionTileTitle('3. Do Primary Assessment of the Victim'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _buildText(
                                    'The Primary Assessment is quick and involves checking for immediate life-threatening conditions. This is commonly known as the ABC approach.',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildBulletPoint('A – Airway:',
                                    "Ensure the airway is clear. If the victim is unconscious, position their head to open the airway."),
                                _buildBulletPoint('B – Breathing:',
                                    'Check if the victim is breathing. If they aren’t, provide rescue breaths.'),
                                _buildBulletPoint('C – Circulation:',
                                    'Check for a pulse. If there is no pulse, begin CPR with chest compressions.'),
                              ],
                            ),
                            ExpansionTile(
                              title: _buildSubExpansionTileTitle('4. Secondary Survey'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _buildText(
                                    'Once immediate life threats are addressed, perform a secondary survey for a more thorough evaluation.',
                                  ),
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
                              ],
                            ),
                            ExpansionTile(
                              title: _buildSubExpansionTileTitle('5. Referral of Patient to Advanced Medical Team'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _buildText(
                                    'After performing the primary and secondary assessments, refer the patient to a more advanced medical team (paramedics, doctors) for further evaluation and treatment. Provide a clear and concise report on the victim’s condition, history, and any treatment you have administered.',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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

  void _showCoursePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Learn Through an Online Interactive Course'),
          content: Text(
            'Want to learn through an online interactive course? Click the button below:',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Online Course'),
              onPressed: () async {
                const url = 'https://www.stopthebleed.org/training/online-course/mobile-course/';
                bool shouldRedirect = await _showRedirectConfirmation(context);
                if (shouldRedirect) {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showRedirectConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Redirect Confirmation'),
          content: Text('You are being redirected to a webpage. Do you want to continue?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }
}
