import 'dart:typed_data';

class Book {
  int? id;
  String title;
  String? author;
  String language; //fil - Filipino, eng - English
  int pageCount;

  Book({
    this.id,
    required this.title,
    this.author,
    required this.language,
    required this.pageCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'language': language,
      'pageCount': pageCount,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      language: map['language'],
      pageCount: map['pageCount'],
    );
  }
}

class BookPage {
  int? id;
  int bookId;
  int pageNumber;
  String content;
  Uint8List? photo;

  BookPage({
    this.id,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'content': content,
      'photo': photo,
    };
  }

  static BookPage fromMap(Map<String, dynamic> map) {
    return BookPage(
      id: map['id'],
      bookId: map['bookId'],
      pageNumber: map['pageNumber'],
      content: map['content'],
      photo: map['photo'],
    );
  }
}
