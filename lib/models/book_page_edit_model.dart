class BookPageEdit {
  String content;

  BookPageEdit({
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
    };
  }
}
