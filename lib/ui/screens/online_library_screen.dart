import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/ui/screens/book_online_screen.dart';
import 'package:basa_proj_app/ui/widgets/book_card.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/providers/online_book_provider.dart';

class OnlineLibraryScreen extends StatefulWidget {
  @override
  _OnlineLibraryScreenState createState() => _OnlineLibraryScreenState();
}

class _OnlineLibraryScreenState extends State<OnlineLibraryScreen> {
  final OnlineBookProvider onlineBookProvider = OnlineBookProvider();

  List<Book> books = [];

  Future<List<Book>> _fetchBooks() async {
    return await onlineBookProvider.getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    _fetchBooks();

    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Online Library',
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
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return BookCard(
                  book: book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookOnlineScreen(
                          book: book,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
