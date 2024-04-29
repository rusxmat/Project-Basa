import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/ui/modals/mode_choice_modal.dart';
import 'package:basa_proj_app/ui/widgets/book_card.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:basa_proj_app/ui/widgets/custom_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/providers/online_book_provider.dart';

class OnlineLibraryScreen extends StatefulWidget {
  @override
  _OnlineLibraryScreenState createState() => _OnlineLibraryScreenState();
}

class _OnlineLibraryScreenState extends State<OnlineLibraryScreen> {
  final OnlineBookProvider onlineBookProvider = OnlineBookProvider();
  late Future<List<Book>> onlineBooks;
  int downloadingBookId = -1;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    onlineBooks = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    return await onlineBookProvider.getAllBooks();
  }

  void downloadBook(Book book) {
    setState(() {
      downloadingBookId = book.id!;
      isDownloading = true;
    });

    onlineBookProvider.downloadBook(book).then((value) {
      setState(() {
        isDownloading = false;
        downloadingBookId = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Online Library',
      ),
      body: FutureBuilder<List<Book>>(
        future: onlineBooks,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CIRCULAR_PROGRESS_INDICATOR,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return BookCard(
                    book: book,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => ModeChoiceModal(
                          fromOnline: true,
                          book: book,
                        ),
                      );
                    },
                    trailing: isDownloading && downloadingBookId == book.id
                        ? CIRCULAR_PROGRESS_INDICATOR
                        : CustomIconButton(
                            icon: const Icon(Icons.download_rounded,
                                color: Colors.white),
                            onPressed: (isDownloading)
                                ? null
                                : () {
                                    downloadBook(book);
                                  },
                          ));
              },
            );
          }
        },
      ),
    );
  }
}
