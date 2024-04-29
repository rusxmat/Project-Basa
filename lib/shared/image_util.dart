import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> convertAndCompressImage(XFile imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();

  Uint8List imageBytesUint8List = Uint8List.fromList(imageBytes);
  img.Image? image = img.decodeImage(imageBytesUint8List);

  img.Image compressedImage = img.copyResize(image!, width: 500);

  List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 80);

  Uint8List compressedUint8List = Uint8List.fromList(compressedBytes);

  return compressedUint8List;
}

Future<Uint8List> compressImage(Uint8List imageBytes) async {
  img.Image? image = img.decodeImage(imageBytes);

  img.Image compressedImage = img.copyResize(image!, width: 500);

  List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 80);

  Uint8List compressedUint8List = Uint8List.fromList(compressedBytes);

  return compressedUint8List;
}
