import 'dart:typed_data';

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
