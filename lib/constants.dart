import 'package:flutter/material.dart';

// Colors used in app
const kPrimaryColor = Color(0xFFfe5f55);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFEEF1E4);

const double kDefaultPadding = 20.0;

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);