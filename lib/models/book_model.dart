class Book {
  String? id;
  String title;
  String? author;
  String languageId; //fil - Filipino, eng - English
  int pageCount;
  List<String> contents;

  Book({
    this.id,
    required this.title,
    this.author,
    required this.languageId,
    required this.pageCount,
    required this.contents, // Add field initializer for 'contents'
  });
}
