import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/ui/modals/confirm_delete_modal.dart';
import 'package:basa_proj_app/ui/modals/edit_book_modal.dart';
import 'package:basa_proj_app/ui/modals/mode_choice_modal.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  BookProvider _bookProvider = BookProvider();
  List<Book> _books = [];

  Future<void> _fetchBooks() async {
    List<Book> books = await _bookProvider.getAllBooks();
    setState(() {
      _books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BookProvider _bookProvider = Provider.of<BookProvider>(context);
    _fetchBooks();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstantUI.customYellow,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ConstantUI.customBlue,
        title: const Text(
          'Mga Kwento',
          style: TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          Book book = _books[index];
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.book_rounded,
                color: ConstantUI.customBlue,
              ),
              title: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${(book.author!.isNotEmpty) ? '${book.author!} | ' : ''}${LANGUAGE_CODES_TO_VALUE[book.language]} | ${book.pageCount} pages',
                style:
                    const TextStyle(color: ConstantUI.customBlue, fontSize: 12),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    showDialog(
                      context: context,
                      builder: (context) => EditBookModal(
                        book: book,
                      ),
                    );
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDeleteModal(
                        bookId: book.id!,
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => ModeChoiceModal(
                          book: book,
                        ));
              },
            ),
          );
        },
      ),
    );
  }
}
