import 'dart:typed_data';

class BookPageLocal {
  int? id;
  int bookId;
  int pageNumber;
  String content;
  Uint8List? photo;

  BookPageLocal({
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
}
