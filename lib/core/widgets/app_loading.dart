import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoading extends StatelessWidget {
  final double size;
  final double lineWidth;
  final Color? color;

  const AppLoading({super.key, this.size = 28, this.lineWidth = 3, this.color});

  @override
  Widget build(BuildContext context) {
    final spinnerColor = color ?? Theme.of(context).colorScheme.primary;
    return SpinKitDualRing(
      size: size,
      lineWidth: lineWidth,
      color: spinnerColor,
    );
  }
}
