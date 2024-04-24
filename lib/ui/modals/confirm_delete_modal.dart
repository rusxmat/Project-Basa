import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteModal extends StatelessWidget {
  final int bookId;
  final BookProvider _bookProvider = BookProvider();

  ConfirmDeleteModal({required this.bookId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content:
          const Text('Sigurado ka bang gusto mong burahin ang kwentong ito?'),
      actions: [
        CustomFloatingAction(
          btnColor: ConstantUI.customPink,
          btnIcon: DELETE_ICON,
          onPressed: () {
            _bookProvider.deleteBook(bookId);
            Navigator.pop(context);
          },
        ),
        CustomFloatingAction(
          btnColor: Colors.white,
          btnIcon: CLOSE_ICON,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
