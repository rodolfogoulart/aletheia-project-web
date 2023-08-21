import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Color> colorsDark = const [
  // Color.fromARGB(255, 18, 1, 67),
  // Color.fromARGB(255, 24, 13, 57),
  // Color.fromARGB(255, 37, 30, 57),
  // Color.fromARGB(255, 29, 27, 50),
  //good
  // Color.fromARGB(100, 42, 26, 165),
  // Color.fromARGB(50, 245, 59, 71),
  //to test
  Color(0xff042b4a), Color(0xff250402),
];
List<Color> colorsLight = const [
  // Color.fromARGB(255, 212, 210, 219),
  // Color.fromARGB(255, 188, 181, 209),
  // Color.fromARGB(255, 204, 194, 232),
  // Color.fromARGB(255, 189, 185, 242),
  Color.fromRGBO(189, 163, 141, 1),
  Color.fromRGBO(255, 246, 239, 1),
];

class CustomGradientBackground extends StatelessWidget {
  const CustomGradientBackground({
    super.key,
    required this.child,
    this.stops,
    this.opacity = 1.0,
    this.darken = 0,
    this.lighten = 0,
    this.blend,
    this.amountBlend = 10,
  });
  final Widget child;
  final List<double>? stops;
  final double opacity;
  final int darken;
  final int lighten;
  final Color? blend;
  final int amountBlend;

  @override
  Widget build(BuildContext context) {
    // var themeModel = context.watch<ThemeModel>();
    // List<Color> colors = themeModel.isDark ? colorsDark : colorsLight;
    List<Color> colors = colorsDark;

    colors = colors.map((color) {
      if (blend != null) {
        color = color.blend(blend!, amountBlend);
      }
      return color.withOpacity(opacity).darken(0).lighten(0);
    }).toList();
    //
    return DecoratedBox(
      decoration: BoxDecoration(
          // https://fluttergradientgenerator.com/
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: const GradientRotation(45 * pi / 180),
              stops: stops
              // ??
              //     const [
              //       .1,
              //       .4,
              //       .7,
              //       .9,
              //     ],
              )),
      child: child,
    );
  }
}
