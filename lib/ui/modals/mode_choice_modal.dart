import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/shared/connectivity_util.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/ui/screens/book_stt_screen.dart';
import 'package:basa_proj_app/ui/screens/book_tts_screen.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';

class ModeChoiceModal extends StatelessWidget {
  final Book? book;

  ModeChoiceModal({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Mode'),
      content: FutureBuilder<bool>(
        future: isConnectedToInternet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error checking connectivity');
          }
          return Column(
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
                      builder: (context) => BookTTSScreen(book: book!),
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
                tileColor: (!snapshot.data! && book!.language == FILIPINO_CODE)
                    ? ConstantUI.customGrey
                    : ConstantUI.customYellow,
                leading: const Icon(
                  Icons.mic_rounded,
                  size: 50,
                ),
                title: const Text(
                  'Magsalita',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                subtitle: (!snapshot.data! && book!.language == FILIPINO_CODE)
                    ? const Text(
                        'Internet required for Filipino Magsalita mode',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )
                    : null,
                onTap: (!snapshot.data! && book!.language == FILIPINO_CODE)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookSTTScreen(
                                    book: book!,
                                  )),
                        );
                      },
              ),
            ],
          );
        },
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
