import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hospital.dart';
import 'socials.dart';// for rss
import 'help.dart';
import 'bls.dart';
import 'first_aid.dart';
import 'first_aid_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //For Emergency Info
  String? _address;
  String? _bloodType;
  String? _allergies;
  String? _medication;
  String? _organDonor;

  //For Google Accounts
  String? _displayName;
  String? _email;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _loadEmergencyInfo();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() {
          _displayName = account.displayName;
          _email = account.email;
          _photoUrl = account.photoUrl;
        });

        // Save the user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('displayName', account.displayName ?? '');
        await prefs.setString('email', account.email);
        await prefs.setString('photoUrl', account.photoUrl ?? '');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _checkSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString('displayName');
      _email = prefs.getString('email');
      _photoUrl = prefs.getString('photoUrl');
    });
  }

  //method to build each medical information card
  Widget _buildInfoCard(String title, String? content) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content ?? 'Not provided'),
      ),
    );
  }

  //method to build the modal for editable medical information card
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        controller: controller,
      ),
    );
  }


  void _editEmergencyInfo() {
    TextEditingController addressController = TextEditingController(text: _address);
    TextEditingController bloodTypeController = TextEditingController(text: _bloodType);
    TextEditingController allergiesController = TextEditingController(text: _allergies);
    TextEditingController medicationController = TextEditingController(text: _medication);
    TextEditingController organDonorController = TextEditingController(text: _organDonor);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Emergency Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  _buildEditableField('Address', addressController),
                  _buildEditableField('Blood Type', bloodTypeController),
                  _buildEditableField('Allergies', allergiesController),
                  _buildEditableField('Medication', medicationController),
                  _buildEditableField('Organ Donor', organDonorController),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () async {
                      // Update state values
                      setState(() {
                        _address = addressController.text;
                        _bloodType = bloodTypeController.text;
                        _allergies = allergiesController.text;
                        _medication = medicationController.text;
                        _organDonor = organDonorController.text;
                      });

                      // Save data to SharedPreferences
                      await _saveEmergencyInfo();
                      Navigator.pop(context);
                    },
                    child: Text('Save Information'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveEmergencyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', _address ?? 'No Address Available');
    await prefs.setString('bloodType', _bloodType ?? 'Unknown');
    await prefs.setString('allergies', _allergies ?? 'None');
    await prefs.setString('medication', _medication ?? 'None');
    await prefs.setString('organDonor', _organDonor ?? 'Unknown');
  }

  Future<void> _loadEmergencyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString('address');
      _bloodType = prefs.getString('bloodType');
      _allergies = prefs.getString('allergies');
      _medication = prefs.getString('medication');
      _organDonor = prefs.getString('organDonor');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          screenHeight * .09,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Builder(
                //   builder: (context) => IconButton(
                //     icon: Icon(Icons.menu),
                //     onPressed: () {
                //       Scaffold.of(context).openDrawer();
                //     },
                //   ),
                // ),
                Image.asset(
                  'assets/still_logo.png',
                  width: 60,
                  height: 60,
                ),
                // IconButton(
                //   icon: Icon(Icons.feed),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => RssFeedPage()),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _photoUrl != null
                        ? NetworkImage(_photoUrl!)
                        : AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _displayName ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email ?? 'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Medical Information Section

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoCard('Address', _address),
                  _buildInfoCard('Blood Type', _bloodType),
                  _buildInfoCard('Allergies', _allergies),
                  _buildInfoCard('Medication', _medication),
                  _buildInfoCard('Organ Donor', _organDonor),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _editEmergencyInfo, // Call method to edit info
                    child: Text('Edit Information'),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.login),
              title: Text('Sign In with Google'),
              onTap: _handleSignIn,
            ),
          ],
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: _photoUrl != null
                            ? NetworkImage(_photoUrl!)
                            : AssetImage('assets/profile_placeholder.png')
                                as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayName ?? 'Guest',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(_email ?? 'user@example.com',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _editEmergencyInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        ),
                        child: Row(
                          children: [
                            Text('Edit',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16), // Spacing



          // //NEW UI TESTING          //NEW UI TESTING          //NEW UI TESTING          //NEW UI TESTING          //NEW UI TESTINg
          // Flexible(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: List.generate(4, (index) {
          //       return Expanded(
          //         child: Container(
          //           margin: EdgeInsets.all(8),
          //           padding: EdgeInsets.all(16),
          //           decoration: BoxDecoration(
          //             color: Colors.blueAccent,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           child: Center(
          //             child: Text(
          //               "Column ${index + 1}",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(color: Colors.white, fontSize: 16),
          //             ),
          //           ),
          //         ),
          //       );
          //     }),
          //   ),
          // ),





          // LEARN Section
          Card(
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEARN:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 15),

                  // Row for Side-by-Side Buttons
                  Row(
                    children: [
                      // Basic Life Support Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BlsPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(vertical: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'BLS',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between buttons

                      // First Aid Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FirstAidPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            padding: EdgeInsets.symmetric(vertical: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.healing, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'FIRST AID',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16), // Spacing

          // TOOLS Section
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOOLS:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 12),

                  // Nearest Hospital Button
                  SizedBox(
                    height: screenHeight * .12,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/hospital_icon.svg',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'NEAREST HOSPITAL',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // First Aid Checklist Button
                  SizedBox(
                    height: screenHeight * .12,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirstAidKitPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/checklist_icon.svg',
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            'FIRST AID CHECKLIST',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

// Floating Action Button (Help)
      floatingActionButton: Container(
        width: screenWidth * .25,
        height: screenWidth * .25,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.greenAccent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.green,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HelpPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.white),
                  Text(
                    'Help',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
