import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:basa_proj_app/models/book_model.dart';

class BookProvider extends ChangeNotifier {
  Future<List<String>> ocrBookPhotos(List<XFile> photos) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    List<InputImage> inputImages = [];
    List<String> extractedStrings = [];

    for (XFile photo in photos) {
      final inputImage = InputImage.fromFilePath(photo.path);
      inputImages.add(inputImage);
    }

    for (InputImage inputImage in inputImages) {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      extractedStrings.add(recognizedText.text);
    }
    return extractedStrings;
  }

  // TODO: Add necessary properties and methods

  // TODO: Implement the constructor

  // TODO: Implement other methods

  // TODO: Implement getters and setters if needed
}
