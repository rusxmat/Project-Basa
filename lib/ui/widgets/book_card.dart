import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Widget? trailing;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          style: const TextStyle(color: ConstantUI.customBlue, fontSize: 12),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
