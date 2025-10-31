import 'dart:io' as io;
import 'package:flutter/material.dart';

Widget buildFileImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  Widget Function()? fallback,
}) {
  try {
    String resolved = path;
    if (path.startsWith('file://')) {
      resolved = Uri.parse(path).path;
    }
    return Image.file(
      io.File(resolved),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback?.call() ?? const Center(child: Icon(Icons.broken_image)),
    );
  } catch (_) {
    return fallback?.call() ?? const Center(child: Icon(Icons.broken_image));
  }
}
