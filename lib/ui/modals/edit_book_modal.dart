import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/shared/input_validation_util.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditBookModal extends StatefulWidget {
  final Book book;

  const EditBookModal({required this.book});

  @override
  _EditBookModalState createState() => _EditBookModalState();
}

class _EditBookModalState extends State<EditBookModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final BookProvider _bookProvider = BookProvider();
  String? _languageSelected = LANGUAGE_CODES['Filipino'];
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book.title;
    _authorController.text = (widget.book.author ?? '');
    _languageSelected = widget.book.language;
  }

  bool get _isInputValid =>
      isInputValidBookTitle(_titleController.text) &&
      isInputValidBookAuthor(_authorController.text);

  String? get _errorTextBookTitle =>
      errorTextBookTitle(_titleController.value.text);

  String? get _errorTextBookAuthor =>
      errorTextBookAuthor(_authorController.value.text);

  void _submitBookEdit() {
    if (!_submitted) {
      setState(() {
        _submitted = true;
      });
    }

    if (!_isInputValid) {
      return;
    }

    BookEdit bookToUpdate = BookEdit(
      title: _titleController.text,
      author: _authorController.text,
      language: _languageSelected!,
    );

    _bookProvider.updateBook(bookToUpdate, widget.book.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Book'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _titleController,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomTextField(
                    hintText: 'Title',
                    controller: _titleController,
                    errorText: _submitted ? _errorTextBookTitle : null,
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _authorController,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomTextField(
                    hintText: 'Author',
                    controller: _authorController,
                    errorText: _submitted ? _errorTextBookAuthor : null,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ToggleSwitch(
                minWidth: 90,
                fontSize: 16,
                inactiveBgColor: Colors.white,
                inactiveFgColor: Colors.black45,
                cornerRadius: 50,
                initialLabelIndex:
                    _languageSelected == LANGUAGE_CODES['Filipino'] ? 0 : 1,
                labels: LANGUAGE_CODES.keys.toList(),
                onToggle: (index) {
                  _languageSelected = LANGUAGE_CODES.values.toList()[index!];
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: Listenable.merge([
            _titleController,
            _authorController,
          ]),
          builder: (context, _) {
            return CustomFloatingAction(
              btnColor: Colors.white,
              btnIcon: FORWARD_ICON,
              onPressed: ((_isInputValid || !_submitted))
                  ? () => _submitBookEdit()
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
