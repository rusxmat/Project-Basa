import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/models/book_edit_model.dart';
import 'package:basa_proj_app/models/book_page_edit_model.dart';
import 'package:basa_proj_app/models/book_page_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book.db');

    // Open/create the database at a given path
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    // Create the book table
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        language TEXT,
        pageCount INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE book_pages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        pageNumber INTEGER,
        content TEXT,
        photo BLOB, 
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
        ''');
  }

  Future<int> createBook(Book book) async {
    var dbClient = await db;
    return await dbClient!.insert('books', book.toMap());
  }

  Future<List<Book>> getAllBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query('books');
    List<Book> books = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return books;
  }

  Future<int> updateBook(BookEdit book, int bookId) async {
    var dbClient = await db;
    return await dbClient!
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [bookId]);
  }

  Future<int> deleteBook(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createBookPage(BookPage bookPage) async {
    var dbClient = await db;
    return await dbClient!.insert('book_pages', bookPage.toMap());
  }

  Future<List<BookPage>> getBookPagesbyBookId(int bookId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient!
        .query('book_pages', where: 'bookId = ?', whereArgs: [bookId]);
    List<BookPage> bookPages = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        bookPages.add(BookPage.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return bookPages;
  }

  Future<int> updateBookPage(BookPageEdit bookPage, int bookPageId) async {
    var dbClient = await db;
    return await dbClient!.update('book_pages', bookPage.toMap(),
        where: 'id = ?', whereArgs: [bookPageId]);
  }

  Future<int> deleteBookPage(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete('book_pages', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBookPagesByBookId(int bookId) async {
    var dbClient = await db;
    return await dbClient!
        .delete('book_pages', where: 'bookId = ?', whereArgs: [bookId]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient!.close();
  }
}
