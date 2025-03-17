import 'package:flutter/material.dart';

void _showCoursePopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Learn Through an Online Interactive Course'),
        content: Text(
          'Want to learn through an online interactive course? Click the link here: https://www.stopthebleed.org/training/online-course/mobile-course/',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}