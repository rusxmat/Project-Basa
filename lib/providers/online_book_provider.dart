import 'dart:typed_data';
import 'package:basa_proj_app/models/book_page_local_model.dart';
import 'package:basa_proj_app/models/book_page_model.dart';
import 'package:basa_proj_app/services/book_service.dart';
import 'package:basa_proj_app/services/online_book_service.dart';
import 'package:basa_proj_app/shared/image_util.dart';
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

  Future<void> downloadBook(Book book) async {
    final DatabaseHelper db = DatabaseHelper();
    List<BookPage> bookPages = await onlineLibDb.getBookPagesById(book.id!);
    List<Uint8List> photos = await onlineLibDb.downloadBookPhotos(
        bookPages.map((e) => e.imageFileName!.trim()).toList());

    final int bookId = await db.createBook(Book(
      title: book.title,
      author: book.author,
      language: book.language,
      pageCount: book.pageCount,
    ));

    for (var i = 0; i < bookPages.length; i++) {
      await db.createBookPage(
        BookPageLocal(
          pageNumber: bookPages[i].pageNumber,
          content: bookPages[i].content,
          bookId: bookId,
          photo: await compressImage(photos[i]),
        ),
      );
    }
  }
}
