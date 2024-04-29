import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class PageContentCard extends StatelessWidget {
  final int pageNumber;
  final String pageContent;

  PageContentCard({
    super.key,
    required this.pageNumber,
    required this.pageContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 4.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Page $pageNumber',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              pageContent,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontFamily: ITIM_FONTNAME,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
