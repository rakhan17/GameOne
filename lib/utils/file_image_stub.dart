import 'package:flutter/material.dart';

Widget buildFileImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  Widget Function()? fallback,
}) {
  // Web/unsupported platform: fall back to provided widget or an icon placeholder
  return fallback?.call() ?? Center(child: Icon(Icons.broken_image, color: Colors.grey.shade400));
}
