import 'package:flutter/material.dart';

//Azure blue
const Color primaryColor = Color(0xFF89CFF0);
//Aero blue
const Color secondaryColor = Color(0xFF7CB9E8);
const Color textOnWhiteColor = Color(0xFF3D1220);
const Color mistakeHighlightColor = Color(0xFFD45562);

const MaterialColor primaryColorSwatch = MaterialColor(0xFFC56C35, <int, Color>{
  50: Color(0xFFF8EDE7),
  100: Color(0xFFEED3C2),
  200: Color(0xFFE2B69A),
  300: Color(0xFFD69872),
  400: Color(0xFFCE8253),
  500: Color(0xFF4DADEE),
  600: Color(0xFFBF6430),
  700: Color(0xFFB85928),
  800: Color(0xFFB04F22),
  900: Color(0xFFA33D16),
});

ThemeData materialThemeData = ThemeData(
  fontFamily: "JetBrainsMono",
  primarySwatch: primaryColorSwatch,
);

CustomThemeData customThemeData = const CustomThemeData(
  primaryColor: primaryColor,
  secondaryColor: secondaryColor,
  textOnWhiteColor: textOnWhiteColor,
  mistakeHighlightColor: mistakeHighlightColor,
  cardText: TextStyle(
    fontSize: 20,
  ),
  cardTextHighlighted: TextStyle(
    fontSize: 22,
    color: primaryColor,
    fontWeight: FontWeight.bold,
  ),
  homePageMainStatText: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  homePageStatText: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  cardTitleText: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

@immutable
class CustomThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final Color textOnWhiteColor;
  final Color mistakeHighlightColor;

  final TextStyle cardText;
  final TextStyle cardTextHighlighted;

  final TextStyle homePageStatText;
  final TextStyle homePageMainStatText;
  final TextStyle cardTitleText;

  const CustomThemeData({
    required this.cardText,
    required this.cardTextHighlighted,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textOnWhiteColor,
    required this.mistakeHighlightColor,
    required this.homePageStatText,
    required this.homePageMainStatText,
    required this.cardTitleText,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomThemeData &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.textOnWhiteColor == textOnWhiteColor &&
        other.mistakeHighlightColor == mistakeHighlightColor &&
        other.cardText == cardText &&
        other.cardTextHighlighted == cardTextHighlighted &&
        other.homePageStatText == homePageStatText &&
        other.homePageMainStatText == homePageMainStatText &&
        other.cardTitleText == cardTitleText;
  }

  @override
  int get hashCode {
    return primaryColor.hashCode ^
        secondaryColor.hashCode ^
        textOnWhiteColor.hashCode ^
        mistakeHighlightColor.hashCode ^
        cardText.hashCode ^
        cardTextHighlighted.hashCode ^
        homePageStatText.hashCode ^
        homePageMainStatText.hashCode ^
        cardTitleText.hashCode;
  }

  @override
  String toString() {
    return 'CustomThemeData(primaryColor: $primaryColor, secondaryColor: $secondaryColor, textOnWhiteColor: $textOnWhiteColor, mistakeHighlightColor: $mistakeHighlightColor, cardText: $cardText, cardTextHighlighted: $cardTextHighlighted, homePageStatText: $homePageStatText, homePageMainStatText: $homePageMainStatText, cardTitleText: $cardTitleText)';
  }
}
