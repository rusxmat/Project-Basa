import 'package:basa_proj_app/services/online_library_service.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/models/online_book_page_model.dart';

class OnlineBookProvider extends ChangeNotifier {
  final OnlineLibraryService onlineLibDb = OnlineLibraryService();

  // Read all books
  Future<List<Book>> getAllBooks() async {
    return await onlineLibDb.getAllBooks();
  }

  Future<List<OnlineBookPage>> getBookPagesById(int bookId) async {
    return await onlineLibDb.getBookPagesById(bookId);
  }
}
