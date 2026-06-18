import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final File file = File('assets/images/logo.png');
  if (!file.existsSync()) {
    print("logo.png not found");
    return;
  }

  final img.Image? original = img.decodeImage(file.readAsBytesSync());

  if (original == null) {
    print("Failed to decode image");
    return;
  }

  // Scale factor: canvas will be 1.3x the size of the logo.
  final int newWidth = (original.width * 1.3).round();
  final int newHeight = (original.height * 1.3).round();

  // Create a transparent image (RGBA)
  final img.Image padded = img.Image(width: newWidth, height: newHeight, numChannels: 4);

  // The image package by default fills with 0 (transparent black).
  // Draw original image in the center
  final int dstX = (newWidth - original.width) ~/ 2;
  final int dstY = (newHeight - original.height) ~/ 2;

  img.compositeImage(padded, original, dstX: dstX, dstY: dstY);

  final File outFile = File('assets/images/logo_padded.png');
  outFile.writeAsBytesSync(img.encodePng(padded));

  print("Saved padded logo to assets/images/logo_padded.png");
}
