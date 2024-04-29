class BookEdit {
  String? title;
  String? author;
  String? language; //fil - Filipino, eng - English

  BookEdit({
    this.title,
    this.author,
    this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'language': language,
    };
  }
}
