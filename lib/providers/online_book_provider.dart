import 'package:basa_proj_app/models/book_page_model.dart';
import 'package:basa_proj_app/services/online_book_service.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';

class OnlineBookProvider extends ChangeNotifier {
  final OnlineBookService onlineLibDb = OnlineBookService();

  // Read all books
  Future<List<Book>> getAllBooks() async {
    return await onlineLibDb.getAllBooks();
  }

  Future<List<BookPage>> getBookPagesById(int bookId) async {
    return await onlineLibDb.getBookPagesById(bookId);
  }
}
