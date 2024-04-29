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
