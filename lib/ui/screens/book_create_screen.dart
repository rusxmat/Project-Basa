import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/ui/modals/view_image_modal.dart';
import 'package:basa_proj_app/ui/screens/library_screen.dart';
import 'package:basa_proj_app/ui/screens/photo_gallery_screen.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';
import 'package:basa_proj_app/ui/widgets/loading_card.dart';
import 'package:basa_proj_app/ui/widgets/nophotos_warning_card.dart';
import 'package:basa_proj_app/shared/input_validation_util.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BookCreateScreen extends StatefulWidget {
  final List<XFile> photos;
  const BookCreateScreen({super.key, required this.photos});

  @override
  _BookCreateScreenState createState() => _BookCreateScreenState();
}

class _BookCreateScreenState extends State<BookCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  List<TextEditingController> _bookContentControllers = [];
  BookProvider? bookProvider;
  Future<List<String>>? _future;
  String? _languageSelected = LANGUAGE_CODES['Filipino'];
  List<Widget> contentFields = [];

  bool _isSubmitting = false;
  bool _submitted = false;
  bool _isAddingBook = false;

  @override
  void initState() {
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    _future = bookProvider!.ocrBookPhotos(widget.photos);
    _future?.then((data) {
      _bookContentControllers =
          data.map((item) => TextEditingController(text: item)).toList();
      setState(() {}); // Rebuild the widget tree with controllers
    });
    super.initState();
    // photos = widget.photos;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _bookContentControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  bool get _isInputValid =>
      isInputValidBookTitle(_titleController.text) &&
      isInputValidBookAuthor(_authorController.text) &&
      _bookContentControllers
          .every((controller) => isInputValidBookContent(controller.text));

  String? get _errorTextBookTitle =>
      errorTextBookTitle(_titleController.value.text);

  String? get _errorTextBookAuthor =>
      errorTextBookAuthor(_authorController.value.text);

  String? _errorTextBookContent(TextEditingController bookContentController) {
    return errorTextBookContent(bookContentController.value.text);
  }

  void _submitBook() async {
    setState(() => _isSubmitting = true);
    if (!_submitted) setState(() => _submitted = true);
    bool isInputValid = _isInputValid;
    setState(() => _isSubmitting = false);
    if (!isInputValid) return;
    setState(() => _isAddingBook = true);

    Book bookToCreate = Book(
      title: _titleController.text,
      author: _authorController.text,
      language: _languageSelected!,
      pageCount: _bookContentControllers.length,
    );

    await bookProvider!.addBook(
      bookToCreate,
      _bookContentControllers.map((e) => e.text).toList(),
      widget.photos,
    );

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LibraryScreen()),
        ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ConstantUI.customYellow,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: (_isAddingBook)
                ? ConstantUI.customGrey
                : ConstantUI.customYellow,
          ),
          onPressed: (_isAddingBook)
              ? null
              : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoGalleryScreen(
                        photos: widget.photos,
                      ),
                    ),
                  );
                },
        ),
        backgroundColor: ConstantUI.customBlue,
        title: const Text(
          'Gumawa ng Libro',
          style: TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
      ),
      body: (_isAddingBook)
          ? const LoadingCard(title: 'Ginagawa ang Libro...')
          : (widget.photos.isEmpty)
              ? const NoPhotosWarningCard()
              : FutureBuilder<List<String>>(
                  future: _future,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the Future is still processing, show a loading spinner
                      return const LoadingCard(
                          title: 'Binabasa ang mga Larawan...');
                    } else if (snapshot.hasError) {
                      // If the Future completed with an error, show an error message
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.photos.length + 1,
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5),
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
                                          errorText: _submitted
                                              ? _errorTextBookTitle
                                              : null,
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
                                          errorText: _submitted
                                              ? _errorTextBookAuthor
                                              : null,
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
                                      initialLabelIndex: 0,
                                      labels: LANGUAGE_CODES.keys.toList(),
                                      onToggle: (index) {
                                        _languageSelected = LANGUAGE_CODES
                                            .values
                                            .toList()[index!];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          index--;

                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                                color: Colors.white,
                                child: IntrinsicWidth(
                                  stepWidth: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Text(
                                              'Page ${index + 1}',
                                              style: const TextStyle(
                                                color: ConstantUI.customBlue,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: ConstantUI.customPink,
                                              ),
                                              onPressed: () {
                                                _bookContentControllers
                                                    .removeAt(index);
                                                widget.photos.removeAt(index);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ViewImageModal(
                                              image: Image.file(
                                                File(widget.photos[index].path),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.file(
                                          File(widget.photos[index].path),
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable:
                                            _bookContentControllers[index],
                                        builder: (context, value, child) {
                                          return Padding(
                                            padding:
                                                (_bookContentControllers[index]
                                                        .text
                                                        .isNotEmpty)
                                                    ? const EdgeInsets.all(0)
                                                    : const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                            child: CustomTextField(
                                              controller:
                                                  _bookContentControllers[
                                                      index],
                                              isTextArea: true,
                                              defaultMaxLines: 5,
                                              errorText: _submitted
                                                  ? _errorTextBookContent(
                                                      _bookContentControllers[
                                                          index])
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                      );
                    }
                  },
                ),
      floatingActionButton: AnimatedBuilder(
        animation: Listenable.merge([
          _titleController,
          _authorController,
          ..._bookContentControllers,
        ]),
        builder: (context, _) {
          return CustomFloatingAction(
            btnColor: Colors.white,
            btnIcon: FORWARD_ICON,
            onPressed: (((_isInputValid || !_submitted) &&
                        widget.photos.isNotEmpty &&
                        !_isAddingBook) ||
                    _isSubmitting)
                ? () => _submitBook()
                : null,
          );
        },
      ),
    );
  }
}
