import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:basa_proj_app/ui/widgets/page_content_card.dart';
import 'package:basa_proj_app/ui/widgets/page_image_display.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/providers/online_book_provider.dart';
import 'package:basa_proj_app/models/online_book_page_model.dart';

class BookOnlineScreen extends StatefulWidget {
  final Book book;

  BookOnlineScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookOnlineScreenState createState() => _BookOnlineScreenState();
}

class _BookOnlineScreenState extends State<BookOnlineScreen> {
  final OnlineBookProvider onlineBookProvider = OnlineBookProvider();

  Future<List<OnlineBookPage>> _fetchBookPagesById() async {
    return await onlineBookProvider.getBookPagesById(widget.book.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.book.title,
      ),
      body: FutureBuilder<List<OnlineBookPage>>(
        future: _fetchBookPagesById(),
        builder: (BuildContext context,
            AsyncSnapshot<List<OnlineBookPage>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<OnlineBookPage> pages = snapshot.data!;

            return PageView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final OnlineBookPage page = pages[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: PageImageDisplay(
                        image: Image.network(
                          page.photoUrl,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: PageContentCard(
                        pageContent: page.content,
                        pageNumber: page.pageNumber,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
