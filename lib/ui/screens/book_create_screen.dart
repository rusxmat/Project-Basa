import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';

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
  final List<TextEditingController> _bookContentControllers = [];
  String? _languageSelected = LANGUAGE_CODES['Filipino'];

  @override
  Widget build(BuildContext context) {
    BookProvider bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
        backgroundColor: ConstantUI.customYellow,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ConstantUI.customYellow,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: ConstantUI.customBlue,
          title: const Text(
            'Mga Larawan',
            style: TextStyle(
              fontFamily: ITIM_FONTNAME,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: bookProvider.ocrBookPhotos(widget.photos),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still processing, show a loading spinner
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If the Future completed with an error, show an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If the Future completed with a result, show the result
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        hintText: 'Title',
                        controller: _titleController,
                        isTextArea: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        hintText: 'Author',
                        controller: _authorController,
                        isTextArea: false,
                      ),
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          _bookContentControllers.add(TextEditingController(
                              text: snapshot.data![index]));
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.file(
                                    File(widget.photos[index].path),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: CustomTextField(
                                    hintText: "Page ${index + 1}",
                                    controller: _bookContentControllers[index],
                                    isTextArea: true,
                                  ),
                                ),
                              ],
                            ),
                          );

                          // TextField(
                          //   keyboardType: TextInputType.multiline,
                          //   maxLines: 5,
                          //   decoration: InputDecoration(
                          //     labelText: "Page ${index + 1}",
                          //   ),
                          //   controller: _bookContentControllers[index],
                          // );
                        },
                      ),
                    )
                  ],
                ),
              );
              // Column(
              //   children: [
              //     CustomTextField(
              //         hintText: 'Title', controller: _titleController),
              //     TextField(
              //       controller: _titleController,
              //       decoration: const InputDecoration(
              //         labelText: 'Title',
              //       ),
              //     ),
              //     TextField(
              //       controller: _authorController,
              //       decoration: const InputDecoration(
              //         labelText: 'Author',
              //       ),
              //     ),
              //     ToggleSwitch(
              //       initialLabelIndex: 0,
              //       labels: LANGUAGE_CODES.keys.toList(),
              //       onToggle: (index) {
              //         _languageSelected =
              //             LANGUAGE_CODES.values.toList()[index!];
              //       },
              //     ),
              //     Expanded(
              //       child: ListView.builder(
              //         itemCount: snapshot.data!.length,
              //         itemBuilder: (context, index) {
              //           _bookContentControllers.add(
              //               TextEditingController(text: snapshot.data![index]));
              //           return TextField(
              //             keyboardType: TextInputType.multiline,
              //             maxLines: 5,
              //             decoration: InputDecoration(
              //               labelText: "Page ${index + 1}",
              //             ),
              //             controller: _bookContentControllers[index],
              //           );
              //         },
              //       ),
              //     )
              //   ],
              // );
            }
          },
        ),
        floatingActionButton: CustomFloatingAction(
          btnColor: Colors.white,
          btnIcon: FORWARD_ICON,
          onPressed: () {
            Book bookToCreate = Book(
              title: _titleController.text,
              author: _authorController.text,
              language: _languageSelected!,
              pageCount: _bookContentControllers.length,
            );

            bookProvider.addBook(
              bookToCreate,
              _bookContentControllers.map((e) => e.text).toList(),
              widget.photos,
            );
          },
        )

        // FloatingActionButton(
        //   onPressed: () {
        //     Book bookToCreate = Book(
        //       title: _titleController.text,
        //       author: _authorController.text,
        //       language: _languageSelected!,
        //       pageCount: _bookContentControllers.length,
        //     );

        //     bookProvider.addBook(bookToCreate,
        //         _bookContentControllers.map((e) => e.text).toList());
        //   },
        // ),
        );
  }
}
