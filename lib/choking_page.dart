import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fbao_page.dart';
import 'flowchart_page.dart';

class ChokingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choking Procedure Guides'),
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
              crossAxisCount: 2, // Two buttons per row
              mainAxisSpacing: 12, // Vertical spacing
              crossAxisSpacing: 12, // Horizontal spacing
              childAspectRatio: 1.45, // Adjusts button height-width balance
              physics: const NeverScrollableScrollPhysics(), // Prevents separate scrolling
              children: [
                _buildNavButton(
                  context,
                  'FBAO GUIDE',
                  FbaoPage(),
                  SvgPicture.asset(
                    'assets/choking_icon.svg',
                    height: 50,
                    width: 50,
                  ),
                ),
                _buildNavButton(
                  context,
                  'FLOWCHART',
                  FbaoFlowchartPage(),
                  SvgPicture.asset(
                    'assets/flowchart_icon.svg',
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ExpansionTile(
                  title: _buildMainExpansionTileTitle('What is FBAO?',''),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _buildText(
                        "Foreign Body Airway Obstruction (FBAO), commonly known as choking, occurs when a foreign object partially or completely blocks the airway, preventing normal breathing. If untreated, it can lead to asphyxiation (lack of oxygen), loss of consciousness, and even death.",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ExpansionTile(
                  title: _buildMainExpansionTileTitle('Details of FBAO', 'assets/details_icon.svg'),
                  children: [
                    ExpansionTile(
                      title: _buildSubExpansionTileTitle('Causes of FBAO'),
                      children: [
                        _buildContainer(
                          'Causes of FBAO',
                          [
                            _buildBulletPoint('Food-related causes:', 'Large pieces of meat, hard candies, nuts, grapes, popcorn, sticky foods like peanut butter.'),
                            _buildBulletPoint('Non-food causes:', 'Small toys, balloons, buttons, pen caps, beads.'),
                            _buildBulletPoint('Medical conditions:', 'Stroke, neurological disorders, alcohol/drug intoxication, dental problems (e.g., dentures).'),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: _buildSubExpansionTileTitle('Types of Airway Obstruction'),
                      children: [
                        _buildContainer(
                          'Types of Airway Obstruction',
                          [
                            _buildText('Obstructions can be partial or complete, depending on how much the airway is blocked. Some cases resolve with minimal intervention, while others require immediate life-saving techniques such as the Heimlich maneuver, back blows, or chest thrusts.'),
                            _buildBulletPoint('Partial (Mild) Obstruction:', 'Airway is not fully blocked, some airflow is possible. Signs: Forceful coughing, wheezing, difficulty speaking.'),
                            _buildBulletPoint('What to Do?', 'Encourage the person to keep coughing to expel the object. Do not intervene unless obstruction worsens.'),
                            _buildBulletPoint('Complete (Severe) Obstruction:', 'Airway is fully blocked, no airflow possible. Signs: Hands clutching throat, silent coughing, turning blue (cyanosis).'),
                            _buildBulletPoint('What to Do?', 'Perform the Heimlich maneuver (abdominal thrusts) for conscious adults and children. Start CPR if unconscious while checking for the object.'),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: _buildSubExpansionTileTitle('Universal Sign for Choking'),
                      children: [
                        _buildContainer(
                          'Universal Sign for Choking',
                          [
                            _buildText('The universal choking sign is when a person places both hands around their throat, signaling that they are unable to breathe and need immediate help.'),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: _buildSubExpansionTileTitle('Classification of Obstruction'),
                      children: [
                        _buildContainer(
                          'Classification of Obstruction',
                          [
                            _buildBulletPoint('Mild Obstruction:', 'Person can cough, talk, or make noise. Encourage forceful coughing. Do not perform abdominal thrusts unless breathing worsens.'),
                            _buildBulletPoint('Severe Obstruction:', 'Person cannot breathe, speak, or cough. Immediate intervention is required.'),
                            _buildBulletPoint('What to Do?', 'Heimlich maneuver (Abdominal Thrusts) for adults/children. Back Blows and Chest Thrusts for infants (<1 year old).'),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: _buildSubExpansionTileTitle('Limitations for Pregnant and Obese Individuals'),
                      children: [
                        _buildContainer(
                          'Limitations for Pregnant and Obese Individuals',
                          [
                            _buildText('The traditional Heimlich maneuver (abdominal thrusts) may not be effective or safe for pregnant women (especially in later stages) and obese individuals.'),
                            _buildBulletPoint('Alternative Method:', 'Perform chest thrusts by placing your hands at the center of the chest and applying quick, inward and upward thrusts.'),
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

  void _showCoursePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Learn Through These Videos from Lifesaver Channel (A UNTV Program)'),
          content: Text(
            'Want to learn through these videos? Click the buttons below:',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('BTN (FBAO guide)'),
              onPressed: () async {
                const url = 'https://www.youtube.com/watch?v=pzlwOI7xQRc';
                bool shouldRedirect = await _showRedirectConfirmation(context);
                if (shouldRedirect) {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    // Error handling
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $url')),
                    );
                  }
                }
              },
            ),
            TextButton(
              child: Text('BTN (FBAO for infant)'),
              onPressed: () async {
                const url = 'https://www.youtube.com/watch?v=gfUd19Ibp9I';
                bool shouldRedirect = await _showRedirectConfirmation(context);
                if (shouldRedirect) {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    // Error handling
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $url')),
                    );
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
