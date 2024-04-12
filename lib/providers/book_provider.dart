import 'package:basa_proj_app/services/book_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:sqflite/sqlite_api.dart';

class BookProvider extends ChangeNotifier {
  final DatabaseHelper db = DatabaseHelper();

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
  Future<void> addBook(Book book, List<String> bookContent) async {
    final int bookId = await db.createBook(book);

    int pageNumber = 1;
    for (String content in bookContent) {
      await db.createBookPage(
          BookPage(pageNumber: pageNumber, content: content, bookId: bookId));
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

  // // Read a specific book by its index
  // Book getBook(int index) {
  //   if (index >= 0 && index < books.length) {
  //     return books[index];
  //   }
  //   return null;
  // }

  // // Update a book by its index
  // void updateBook(int index, Book updatedBook) {
  //   if (index >= 0 && index < books.length) {
  //     books[index] = updatedBook;
  //     notifyListeners();
  //   }
  // }

  // // Delete a book by its index

  // void deleteBook(int index) {
  //   if (index >= 0 && index < books.length) {
  //     books.removeAt(index);
  //     notifyListeners();
  //   }
  // }

  // TODO: Add necessary properties and methods

  // TODO: Implement the constructor

  // TODO: Implement other methods

  // TODO: Implement getters and setters if needed
}
