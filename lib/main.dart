import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() async{
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
    print('API Key: $apiKey');

    return MaterialApp(
      title: 'DUGTONG BUHAY PARA KAY JUAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

