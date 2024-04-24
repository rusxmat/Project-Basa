import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/ui/modals/view_image_modal.dart';
import 'package:basa_proj_app/ui/screens/library_screen.dart';
import 'package:basa_proj_app/ui/screens/photo_gallery_screen.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';
import 'package:basa_proj_app/ui/widgets/nophotos_warning_card.dart';

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
  bool _submitted = false;

  @override
  void initState() {
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    _future = bookProvider!.ocrBookPhotos(widget.photos);
    _bookContentControllers =
        List.generate(widget.photos.length, (index) => TextEditingController());
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

  String? get _errorTextBookTitle {
    final text = _titleController.value.text;

    if (text.isEmpty) {
      return 'Maglagay ng Pamagat ng Libro';
    }
    if (text.length < 3) {
      return 'Ang Pamagat ng Libro ay dapat na may 3 o higit pang mga titik';
    }
    if (text.length > 20) {
      return 'Ang Pamagat ng Libro ay dapat na hindi hihigit sa 20 na titik';
    }

    return null;
  }

  String? get _errorTextBookAuthor {
    final text = _authorController.value.text;

    if (text.isEmpty) {
      return null;
    }

    if (text.length < 3) {
      return 'Ang Pangalan ng Awtor ay dapat na may 3 o higit pang mga titik';
    }
    if (text.length > 20) {
      return 'Ang Pangalan ng Awtor ay dapat na hindi hihigit sa 20 na titik';
    }

    return null;
  }

  String? _errorTextBookContent(TextEditingController bookContentController) {
    final text = bookContentController.value.text;

    if (text.isEmpty) {
      return 'Ang Pahina ng libro ay hindi maaaring walang laman';
    }

    return null;
  }

  void _submitBook() {
    if (!_submitted) {
      setState(() {
        _submitted = true;
      });
    }

    if (!_isInputValid) {
      return;
    }

    Book bookToCreate = Book(
      title: _titleController.text,
      author: _authorController.text,
      language: _languageSelected!,
      pageCount: _bookContentControllers.length,
    );

    bookProvider!.addBook(
      bookToCreate,
      _bookContentControllers.map((e) => e.text).toList(),
      widget.photos,
    );

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LibraryScreen()),
        ModalRoute.withName("/"));
  }

  bool get _isInputValid {
    if (_titleController.value.text.isEmpty ||
        _titleController.value.text.length < 3 ||
        _titleController.value.text.length > 20) {
      return false;
    }

    if (_authorController.value.text.isNotEmpty &&
        (_authorController.value.text.length < 3 ||
            _authorController.value.text.length > 20)) {
      return false;
    }

    if (_bookContentControllers.any((element) => element.value.text.isEmpty)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstantUI.customYellow,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstantUI.customYellow,
          ),
          onPressed: () {
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
      body: (widget.photos.isEmpty)
          ? const NoPhotosWarningCard()
          : FutureBuilder<List<String>>(
              future: _future,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the Future is still processing, show a loading spinner
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If the Future completed with an error, show an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> bookContent = snapshot.data!;

                  return ListView.builder(
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
                                    _languageSelected =
                                        LANGUAGE_CODES.values.toList()[index!];
                                  },
                                ),
                              ),
                              Column(
                                children: contentFields,
                              )
                            ],
                          ),
                        );
                      }

                      index--;
                      _bookContentControllers[index].text = bookContent[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: IntrinsicWidth(
                          stepWidth: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                        _bookContentControllers.removeAt(index);
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
                                    builder: (context) => ViewImageModal(
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
                                valueListenable: _bookContentControllers[index],
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: (_bookContentControllers[index]
                                            .text
                                            .isNotEmpty)
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                    child: CustomTextField(
                                      controller:
                                          _bookContentControllers[index],
                                      isTextArea: true,
                                      defaultMaxLines: 5,
                                      errorText: _submitted
                                          ? _errorTextBookContent(
                                              _bookContentControllers[index])
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 8.0, vertical: 5),
                  //   child: SingleChildScrollView(
                  //     child: AnimatedBuilder(
                  //       animation: Listenable.merge([
                  //         _titleController,
                  //         _authorController,
                  //       ]),
                  //       builder: (context, _) {
                  //         return Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: CustomTextField(
                  //                 hintText: 'Title',
                  //                 controller: _titleController,
                  //                 errorText:
                  //                     _submitted ? _errorTextBookTitle : null,
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: CustomTextField(
                  //                 hintText: 'Author',
                  //                 controller: _authorController,
                  //                 errorText:
                  //                     _submitted ? _errorTextBookAuthor : null,
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: ToggleSwitch(
                  //                 minWidth: 90,
                  //                 fontSize: 16,
                  //                 inactiveBgColor: Colors.white,
                  //                 inactiveFgColor: Colors.black45,
                  //                 cornerRadius: 50,
                  //                 initialLabelIndex: 0,
                  //                 labels: LANGUAGE_CODES.keys.toList(),
                  //                 onToggle: (index) {
                  //                   _languageSelected =
                  //                       LANGUAGE_CODES.values.toList()[index!];
                  //                 },
                  //               ),
                  //             ),
                  //             // (contentFields.isNotEmpty)
                  //             //     ? Column(
                  //             //         children: contentFields,
                  //             //       )
                  //             //     : const SizedBox()
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ); // Column(
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
            onPressed:
                ((_isInputValid || !_submitted) && widget.photos.isNotEmpty)
                    ? () => _submitBook()
                    : null,
          );
        },
      ),
    );
  }
}
