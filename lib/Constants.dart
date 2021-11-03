import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// final kPrimaryColor = Color(0xff4AC85D);
final kPrimaryColor = Color(0xff4AC85D);
final kDarkPrimaryColor = Color(0xFF077f7b);
final kBlueColor = Color(0xFF2672ca);
final kRedColor = Color(0xFFfd3951);
final kwhite = Color(0x000000);
final Color kShimmerBaseColor = Colors.grey[300];
final Color kShimmerHighlightColor = Colors.grey[050];

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: Colors.black.withOpacity(0.5),
  );
}

SizedBox verticalSpace(double size) {
  return SizedBox(
    height: size,
  );
}

SizedBox horizontalSpace(double size) {
  return SizedBox(
    width: size,
  );
}

final kTextStyleTitleBlackSmallest = TextStyle(
  fontSize: 13.0,
  color: Colors.black,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleTitleBlacksmall = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kDarkGreenSmall = TextStyle(
  fontSize: 15.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);
final kDarkGreenLarge = TextStyle(
  fontSize: 17.0,
  color: kPrimaryColor,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleTitleBlack = TextStyle(
  fontSize: 18.0,
  color: kPrimaryColor,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleBlackTitle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kInputTextStyleBlack = TextStyle(
  fontSize: 15.0,
  color: Colors.black,
  decoration: TextDecoration.none,
);

final kInputTextStylePrimary = TextStyle(
  fontSize: 16.0,
  color: kPrimaryColor,
  decoration: TextDecoration.none,
);
final kInputTextStyleBlackSmallest = TextStyle(
  fontSize: 12.0,
  color: Colors.black,
  decoration: TextDecoration.none,
);

final kTextStyleBlackBold = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleBlackRegular = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kButtonStyleWhiteBold = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kButtonStyleBlackMedium = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTitleWhiteMedium = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kWhiteMediumSmall = TextStyle(
  fontSize: 10.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kWhiteMediumSmall1 = TextStyle(
  fontSize: 8.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kgreenMediumSmall = TextStyle(
  fontSize: 10.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kgrayMediumSmall = TextStyle(
  fontSize: 10.0,
  color: Colors.grey,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kButtonStyleBlackRegular = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
  decoration: TextDecoration.none,
);

final kTextStyleDarkGreenMedium = TextStyle(
  fontSize: 17.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextStyleDarkGreenMediumSmall = TextStyle(
  fontSize: 15.0,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
);

final kTextStyleDarkGreenSmallest = TextStyle(
  fontSize: 12.0,
  color: kPrimaryColor,
  decoration: TextDecoration.none,
);

final kTextStyleDarkGreenSmallestBold = TextStyle(
  fontSize: 12.0,
  color: kPrimaryColor,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kInputTextStyleGreen = TextStyle(
  fontSize: 16.0,
  color: kPrimaryColor,
  decoration: TextDecoration.none,
);

final kTextStyleTitleGreenMedium = TextStyle(
  fontSize: 13.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextStyleGreenSmallMedium = TextStyle(
  fontSize: 16.0,
  color: kPrimaryColor,
  fontFamily: 'Medium',
  decoration: TextDecoration.none,
);

final kTextStyleGreyTooSmall = TextStyle(
  color: Colors.grey,
  fontSize: 8,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kGreenBig = TextStyle(
  fontSize: 20.0,
  color: kPrimaryColor,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kInputTextStyleWhiteBold = TextStyle(
  fontSize: 17.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kInputTextStylePrimaryBold = TextStyle(
  fontSize: 17.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextStyleTitlePrimaryMedium = TextStyle(
  fontSize: 15.0,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleTitleWhitesmall = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);

final kTextStyleTitleblacksmall = TextStyle(
  fontSize: 12.0,
  color: Colors.black,
  fontFamily: 'bold',
  decoration: TextDecoration.none,
);
final kAppBarStyle = TextStyle(
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    fontSize: 18);

final kAppTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13);

final kTextFieldStyle = TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black38,
    fontWeight: FontWeight.bold,
    fontSize: 13);

final kToPayStyle = TextStyle(
    color: kwhite,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    fontSize: 14);

final kToPayStyle1 = TextStyle(
    color: Color(0xff004445), fontWeight: FontWeight.bold, fontSize: 14);
