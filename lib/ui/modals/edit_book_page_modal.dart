import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/input_validation_util.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditBookPageModal extends StatefulWidget {
  final int pageNumber;
  final BookPage bookPage;

  EditBookPageModal({
    required this.pageNumber,
    required this.bookPage,
  });

  @override
  _EditBookPageModalState createState() => _EditBookPageModalState();
}

class _EditBookPageModalState extends State<EditBookPageModal> {
  late int pageNumber;
  late BookPage bookPage;
  late TextEditingController bookContentController;
  bool _submitted = false;
  final BookProvider _bookProvider = BookProvider();

  @override
  void initState() {
    super.initState();
    pageNumber = widget.pageNumber;
    bookPage = widget.bookPage;
    bookContentController = TextEditingController(text: bookPage.content);
  }

  String? _errorTextBookContent() =>
      errorTextBookContent(bookContentController.value.text);

  bool get _isInputValid => isInputValidBookContent(bookContentController.text);

  void _submitBookPageEdit() {
    if (!_submitted) {
      setState(() {
        _submitted = true;
      });
    }

    if (!_isInputValid) {
      return;
    }

    BookPageEdit bookPageToUpdate = BookPageEdit(
      content: bookContentController.text,
    );

    print(bookContentController.text);

    _bookProvider.updateBookPage(bookPageToUpdate, bookPage.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Page'),
      content: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        color: Colors.white,
        child: SingleChildScrollView(
          child: IntrinsicWidth(
            stepWidth: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Page ${widget.pageNumber + 1}',
                    style: const TextStyle(
                      color: ConstantUI.customBlue,
                      fontSize: 16,
                    ),
                  ),
                ),
                Image.memory(
                  bookPage.photo!,
                  fit: BoxFit.cover,
                ),
                ValueListenableBuilder(
                  valueListenable: bookContentController,
                  builder: (context, value, child) {
                    return Padding(
                      padding: (bookContentController.text.isNotEmpty)
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: CustomTextField(
                        controller: bookContentController,
                        isTextArea: true,
                        defaultMaxLines: 5,
                        errorText: _submitted ? _errorTextBookContent() : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: bookContentController,
          builder: (context, value, child) {
            return CustomFloatingAction(
              btnColor: Colors.white,
              btnIcon: FORWARD_ICON,
              onPressed: ((_isInputValid || !_submitted))
                  ? () => _submitBookPageEdit()
                  : null,
            );
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
