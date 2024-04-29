import 'package:flutter/material.dart';

class PageImageDisplay extends StatelessWidget {
  final Image image;

  PageImageDisplay({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(width: double.infinity),
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 4.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: image,
        ),
      ),
    );
  }
}
