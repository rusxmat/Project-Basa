import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/ui/screens/book_screen.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';

class ModeChoiceModal extends StatelessWidget {
  Book? book;

  ModeChoiceModal({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Mode'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              0.5,
            ),
            iconColor: Colors.white,
            tileColor: ConstantUI.customBlue,
            leading: const Icon(
              Icons.volume_up_rounded,
              size: 50,
            ),
            title: const Text(
              'Makinig',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            onTap: () {
              // Handle mode 1 selection
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookScreen(book: book!, isMakinig: true),
                ),
              );
            },
          ),
          Container(
            height: 10,
          ),
          ListTile(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              0.5,
            ),
            iconColor: Colors.white,
            tileColor: ConstantUI.customYellow,
            leading: const Icon(
              Icons.mic_rounded,
              size: 50,
            ),
            title: const Text(
              'Magsalita',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            onTap: () {
              // Handle mode 1 selection
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookScreen(
                    book: book!,
                    isMakinig: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
