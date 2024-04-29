class OnlineBookPage {
  int? id;
  int bookId;
  int pageNumber;
  String content;
  String photoUrl;
  String imageFileName;

  OnlineBookPage({
    this.id,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    required this.photoUrl,
    required this.imageFileName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'content': content,
      'photoUrl': photoUrl,
      'imageFileName': imageFileName,
    };
  }

  static OnlineBookPage fromMap(Map<String, dynamic> map) {
    return OnlineBookPage(
      id: map['id'],
      bookId: map['bookId'],
      pageNumber: map['pageNumber'],
      content: map['content'],
      photoUrl: map['photoUrl'],
      imageFileName: map['imageFileName'],
    );
  }
}
