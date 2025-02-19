import 'package:basa_proj_app/shared/connectivity_util.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/modals/confirm_delete_modal.dart';
import 'package:basa_proj_app/ui/modals/edit_book_modal.dart';
import 'package:basa_proj_app/ui/modals/message_modal.dart';
import 'package:basa_proj_app/ui/modals/mode_choice_modal.dart';
import 'package:basa_proj_app/ui/widgets/book_card.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/nobooks_warning_card.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/models/book_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final BookProvider _bookProvider = BookProvider();
  bool hasLoaded = false;
  List<Book> books = [];

  void _fetchBooks() async {
    List<Book> futureBooks = await _bookProvider.getAllBooks();
    setState(() {
      books = futureBooks;
      if (!hasLoaded) hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fetchBooks();

    return Scaffold(
      extendBody: true,
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
      body: (books.isEmpty && hasLoaded)
          ? const NoBooksWarningCard()
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: books.length + 1,
              itemBuilder: (context, index) {
                if (index == books.length) {
                  return const SizedBox(height: 70);
                }

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
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: CustomFloatingAction(
        icon: Icons.download_rounded,
        iconSize: 30,
        btnColor: ConstantUI.customBlue,
        extendedText: "Online Library",
        onPressed: () async {
          if (await isConnectedToInternet()) {
            Navigator.pushNamed(context, '/onlinelib');
          } else {
            showDialog(
              context: context,
              builder: (context) => const MessageModal(
                  title: "No Internet Connection",
                  message:
                      'Please connect to the internet to access the online library. \n\nThank you!'),
            );
          }
        },
      ),
    );
  }
}
