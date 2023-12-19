import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//primary swatch
const Map<int, Color> primaryColor = {
  50: Color.fromRGBO(69, 119, 230, 0.1),
  100: Color.fromRGBO(69, 119, 230, 0.2),
  200: Color.fromRGBO(69, 119, 230, 0.3),
  300: Color.fromRGBO(69, 119, 230, 0.4),
  400: Color.fromRGBO(69, 119, 230, 0.5),
  500: Color.fromRGBO(69, 119, 230, 0.6),
  600: Color.fromRGBO(69, 119, 230, 0.7),
  700: Color.fromRGBO(69, 119, 230, 0.8),
  800: Color.fromRGBO(69, 119, 230, 0.9),
  900: Color.fromRGBO(69, 119, 230, 1),
};

// blue
const bluePrimary = Color.fromRGBO(67, 130, 224, 1);
const blueSecondary = Color.fromRGBO(69, 119, 230, 1);
const blueDark = Color.fromRGBO(5, 92, 223, 1);
const blueLight = Color.fromRGBO(74, 145, 224, 1);

const skyBluePrimary = Color.fromRGBO(203, 227, 246, 1);
const skyBlueSecondary = Color.fromRGBO(243, 250, 254, 1);
const skyBlueDark = Color.fromRGBO(207, 232, 253, 1);
const skyBlueLight = Color.fromRGBO(239, 246, 252, 1);

const skyBlueBorder = Color.fromRGBO(188, 210, 233, 1);

const blackPrimary = Color.fromRGBO(63, 61, 61, 1);
const blackSecondary = Color.fromRGBO(16, 9, 9, 1);
const blackDark = Color.fromRGBO(5, 25, 23, 1);
const blackLight = Color.fromRGBO(91, 87, 101, 1);

const greenPrimary = Color.fromRGBO(149, 224, 154, 1);
const greenSecondary = Color.fromRGBO(74, 216, 225, 1);
const greenProfile = Color.fromRGBO(74, 216, 225, 0.5);
const greenLight = Color.fromRGBO(39, 177, 164, 0.2);
const greenDark = Color.fromRGBO(74, 195, 139, 1);
const greenHigh = Color.fromRGBO(23, 112, 103, 1);

const greyPrimary = Color.fromRGBO(168, 168, 168, 1);
const greySecondary = Color.fromRGBO(172, 172, 172, 1);
const greyLight = Color.fromRGBO(209, 209, 209, 1);

const purplePrimary = Color.fromRGBO(99, 108, 234, 1);
const purpleSecondary = Color.fromRGBO(95, 83, 227, 1);

const whitePrimary = Color.fromRGBO(255, 255, 255, 1);
const whiteSecondary = Color.fromRGBO(233, 233, 233, 1);
const whiteLight = Color.fromRGBO(240, 247, 250, 1);

const pinkPrimary = Color.fromRGBO(255, 200, 189, 1);
const pinkLight = Color.fromRGBO(211, 208, 245, 1);

const redPrimary = Color.fromRGBO(243, 85, 85, 1);

const gradientDarkGreen = Color.fromRGBO(159, 219, 217, 1);
const gradientGreen = Color.fromRGBO(143, 222, 243, 1);
const gradientLightSkyBLue = Color.fromRGBO(191, 221, 253, 1);
const gradientSkyBlue = Color.fromRGBO(176, 210, 255, 1);

// statusBar

blueStatusBar() {
  return const SystemUiOverlayStyle(
      statusBarColor: blueSecondary,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: greenSecondary,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: greenSecondary);
}

whiteStatusBar() {
  return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: whitePrimary,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: whiteLight);
}

// gradient

Gradient gradientBlue = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      blueSecondary,
      greenSecondary,
    ]);

Gradient gradientLightBlue = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      gradientDarkGreen,
      gradientGreen,
      gradientLightSkyBLue,
      gradientSkyBlue
    ]);
