import 'package:flutter/widgets.dart';
import 'file_image_stub.dart' if (dart.library.io) 'file_image_io.dart' as impl;

Widget buildFileImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  Widget Function()? fallback,
}) {
  return impl.buildFileImage(
    path,
    width: width,
    height: height,
    fit: fit,
    fallback: fallback,
  );
}
