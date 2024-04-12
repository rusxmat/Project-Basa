import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  BookScreen({super.key, required this.book});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  BookProvider _bookProvider = BookProvider();
  late Book book;
  late List<BookPage> pages = [];

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _fetchBookPages();
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = await _bookProvider.getBookPagesById(book.id!);
    setState(() {
      pages = bookpages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Page ${page.pageNumber}',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    page.content,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
