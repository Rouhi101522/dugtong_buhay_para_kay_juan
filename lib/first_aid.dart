import 'package:flutter/material.dart';

class FirstAidPage extends StatelessWidget {
  final List<Map<String, String>> injuries = [
    {
      'name': 'Sore Eyes',
      'image': 'assets/sore-eyes.png',
      'care': 'Flush the eyes with clean water. Apply a cold compress.',
      'items': 'Clean water, cold compress, sterile gauze or clean cloth',
      'preCare': 'Ensure your hands are clean before touching the affected area.',
      'postCare': 'Avoid rubbing the eyes. Rest the eyes and avoid strain.',
      'healingTime': '1-3 days for minor irritation, longer for serious injuries.',
      'disclaimer': 'If the condition does not improve or worsens, consult a doctor.',
    },
    {
      'name': 'Wound',
      'image': 'assets/wounded.png',
      'care': 'Clean the wound with clean water and cover it with a sterile bandage.',
      'items': 'Sterile bandages, antiseptic solution, clean water',
      'preCare': 'Wash your hands thoroughly before handling the wound.',
      'postCare': 'Change the bandage daily. Monitor for signs of infection.',
      'healingTime': '5-7 days for minor wounds; longer for deep or infected wounds.',
      'disclaimer': 'If the wound becomes red, swollen, or painful, see a doctor.',
    },
    {
      'name': 'Fever',
      'image': 'assets/fever.png',
      'care': 'Rest, stay hydrated, and take fever-reducing medication.',
      'items': 'Water, fever-reducing medication (e.g., paracetamol, ibuprofen), thermometer',
      'preCare': 'Measure temperature with a thermometer to confirm fever.',
      'postCare': 'Stay hydrated and rest. Monitor temperature regularly.',
      'healingTime': '1-3 days, depending on the cause of the fever.',
      'disclaimer': 'Consult a doctor if the fever persists or is very high.',
    },
    {
      'name': 'Heart Attack',
      'image': 'assets/heart-attack.png',
      'care': 'Call emergency services. Perform CPR if necessary.',
      'items': 'None (immediate medical help needed)',
      'preCare': 'Check for responsiveness and pulse. Keep the person calm.',
      'postCare': 'Once emergency services arrive, provide them with all the details.',
      'healingTime': 'Varies based on the severity; requires professional care.',
      'disclaimer': 'A heart attack requires immediate medical intervention; don’t attempt to treat this on your own.',
    },
    {
      'name': 'Broken Leg',
      'image': 'assets/broken-bone.png',
      'care': 'Keep the leg immobilized and call for emergency medical help.',
      'items': 'Splint, bandages, cold compress, padding for comfort',
      'preCare': 'Make sure the person does not move the leg to avoid further injury.',
      'postCare': 'Follow medical instructions for casting, and avoid putting weight on the leg.',
      'healingTime': '6-8 weeks, depending on the severity of the fracture.',
      'disclaimer': 'Always consult a doctor for fractures. Improper healing can lead to complications.',
    },
    {
      'name': 'Nose Bleeding',
      'image': 'assets/nose-bleeding.png',
      'care': 'Pinch your nose and lean forward to stop the bleeding.',
      'items': 'Tissues or clean cloth',
      'preCare': 'Sit upright and remain calm. Pinch the nostrils together.',
      'postCare': 'Avoid leaning back or blowing your nose for at least 12 hours.',
      'healingTime': 'Bleeding usually stops within 10-15 minutes.',
      'disclaimer': 'If bleeding persists for more than 20 minutes, seek medical attention.',
    },
    {
      'name': 'Seizures',
      'image': 'assets/epilepsy.png',
      'care': 'Protect the person from injury and call for medical help if the seizure lasts more than 5 minutes.',
      'items': 'None (just ensure the person’s safety)',
      'preCare': 'Clear the area of sharp objects and protect their head.',
      'postCare': 'Once the seizure is over, turn the person on their side and monitor their breathing.',
      'healingTime': 'Seizures vary, but recovery is usually quick after the seizure ends.',
      'disclaimer': 'Always consult a doctor after a seizure, especially if it’s the first occurrence or lasts more than 5 minutes.',
    },
    {
      'name': 'Cerebral',
      'image': 'assets/cerebral.png',
      'care': 'Seek immediate medical help. Administer CPR if necessary.',
      'items': 'None (immediate medical intervention needed)',
      'preCare': 'Ensure the person is safe and try to keep them calm.',
      'postCare': 'Follow medical personnel’s advice for further treatment and rehabilitation.',
      'healingTime': 'Varies depending on the severity of the stroke or injury.',
      'disclaimer': 'A stroke or cerebral injury is a medical emergency. Immediate medical intervention is critical.',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Aid - Select an Injury"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns for the grid
            crossAxisSpacing: 16.0, // Horizontal spacing
            mainAxisSpacing: 16.0, // Vertical spacing
          ),
          itemCount: injuries.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the detail page for the selected injury
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InjuryDetailPage(injury: injuries[index])),
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(injuries[index]['image']!, width: 60, height: 60),
                    const SizedBox(height: 8),
                    Text(
                      injuries[index]['name']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class InjuryDetailPage extends StatelessWidget {
  final Map<String, String> injury;

  const InjuryDetailPage({super.key, required this.injury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(injury['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display injury image
              Image.asset(injury['image']!, width: 150, height: 150),
              const SizedBox(height: 20),
              Text(
                'How to Care for ${injury['name']}:',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                injury['care']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // New sections for additional details
              Text(
                'Items to Prepare:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                injury['items']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              Text(
                'Pre-Care Procedure:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                injury['preCare']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              Text(
                'Post-Care Procedure:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                injury['postCare']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              Text(
                'Ideal Time for Healing:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                injury['healingTime']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              Text(
                'Disclaimer:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                injury['disclaimer']!,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
