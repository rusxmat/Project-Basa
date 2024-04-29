import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/modals/confirm_delete_modal.dart';
import 'package:basa_proj_app/ui/modals/edit_book_modal.dart';
import 'package:basa_proj_app/ui/modals/mode_choice_modal.dart';
import 'package:basa_proj_app/ui/widgets/book_card.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/models/book_model.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final BookProvider _bookProvider = BookProvider();

  Future<List<Book>> _fetchBooks() async {
    return await _bookProvider.getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Book>>(
        future: _fetchBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Book> books = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: books.length,
              itemBuilder: (context, index) {
                Book book = books[index];
                return BookCard(
                  book: book,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await showDialog(
                          context: context,
                          builder: (context) => EditBookModal(
                            book: book,
                          ),
                        );
                      } else if (value == 'delete') {
                        await showDialog(
                          context: context,
                          builder: (context) => ConfirmDeleteModal(
                            bookId: book.id!,
                          ),
                        );
                      }
                      setState(() {});
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
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
                              fromOnline: false,
                              book: book,
                            ));
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: CustomFloatingAction(
        icon: Icons.download_rounded,
        iconSize: 30,
        btnColor: ConstantUI.customBlue,
        extendedText: "Online Library",
        onPressed: () {
          Navigator.pushNamed(context, '/onlinelib');
        },
      ),
    );
  }
}
