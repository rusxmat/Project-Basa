import 'package:basa_proj_app/models/book_page_local_model.dart';
import 'package:basa_proj_app/services/book_service.dart';
import 'package:basa_proj_app/shared/image_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/models/book_edit_model.dart';
import 'package:basa_proj_app/models/book_page_edit_model.dart';
import 'package:basa_proj_app/models/book_page_model.dart';

class BookProvider extends ChangeNotifier {
  final DatabaseHelper db = DatabaseHelper();
  final flutterTts = FlutterTts();

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

  List<BookPage> createBookPages(List<String> bookContent, int bookId) {
    List<BookPage> bookPages = [];
    int pageNumber = 1;
    for (String content in bookContent) {
      bookPages.add(
          BookPage(pageNumber: pageNumber, content: content, bookId: bookId));
      pageNumber++;
    }
    return bookPages;
  }

  // Create a new book
  Future<void> addBook(
      Book book, List<String> bookContent, List<XFile> photos) async {
    final int bookId = await db.createBook(book);

    int pageNumber = 1;

    for (var i = 0; i < bookContent.length; i++) {
      await db.createBookPage(
        BookPageLocal(
          pageNumber: pageNumber,
          content: bookContent[i],
          bookId: bookId,
          photo: (photos.isNotEmpty)
              ? await convertAndCompressImage(photos[i])
              : null,
        ),
      );
      pageNumber++;
    }
    notifyListeners();
  }

  // Read all books
  Future<List<Book>> getAllBooks() async {
    return await db.getAllBooks();
  }

  Future<List<BookPage>> getBookPagesById(int bookId) async {
    return await db.getBookPagesbyBookId(bookId);
  }

  // Delete a book by its ID
  Future<void> deleteBook(int bookId) async {
    await db.deleteBookPagesByBookId(bookId);
    await db.deleteBook(bookId);
    notifyListeners();
  }

  Future<void> updateBook(BookEdit book, int bookId) async {
    await db.updateBook(book, bookId);
    notifyListeners();
  }

  Future<void> updateBookPage(BookPageEdit bookPage, int bookPageId) async {
    await db.updateBookPage(bookPage, bookPageId);
    notifyListeners();
  }
}
