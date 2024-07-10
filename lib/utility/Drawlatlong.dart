import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;


class Drawlatlong {
  static img.Image drawlatlong(String path, String lat, String long) {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy HH:mm a');
    final timestamp = formatter.format(now);
    final originalImage = img.decodeImage(File(path).readAsBytesSync());

    final img.Image watermarkedImage = img.copyResize(
        originalImage!, width: 480, height: 680);
    img.drawString(watermarkedImage, x: 12,
      y: 580,
      'Date: $timestamp\nLat: ${lat ?? ""}/ Long: ${long ?? ""}',
      font: img.arial14,
      color: img.ColorFloat32.rgb(255, 0, 0),);
    // return watermarkedImage;
    return watermarkedImage;
  }







}
