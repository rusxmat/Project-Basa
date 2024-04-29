import 'dart:async';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/models/book_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineBookService {
  SupabaseClient? supabase;

  OnlineBookService() {
    supabase = Supabase.instance.client;
  }

  Future<List<Book>> getAllBooks() async {
    List<Map> maps = await supabase!.from('books').select();

    List<Book> books = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return books;
  }

  Future<List<BookPage>> getBookPagesById(int bookId) async {
    List<Map> maps =
        await supabase!.from('bookPages').select().eq('bookId', bookId);

    List<BookPage> bookPages = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        bookPages.add(BookPage.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return bookPages;
  }
}
