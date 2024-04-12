import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:basa_proj_app/shared/constants.dart';

class BookCreateScreen extends StatefulWidget {
  List<XFile> photos;
  BookCreateScreen({super.key, required this.photos});

  @override
  _BookCreateScreenState createState() => _BookCreateScreenState();
}

class _BookCreateScreenState extends State<BookCreateScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  List<TextEditingController> _bookContentControllers = [];
  String? _languageSelected = LANGUAGE_CODES['Filipino'];

  @override
  Widget build(BuildContext context) {
    BookProvider bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Book'),
      ),
      body: FutureBuilder<List<String>>(
        future: bookProvider.ocrBookPhotos(widget.photos),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still processing, show a loading spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If the Future completed with an error, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // If the Future completed with a result, show the result
            return Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                  ),
                ),
                ToggleSwitch(
                  initialLabelIndex: 0,
                  labels: LANGUAGE_CODES.keys.toList(),
                  onToggle: (index) {
                    print('switched to: $index');
                    _languageSelected = LANGUAGE_CODES.values.toList()[index!];
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      _bookContentControllers.add(
                          TextEditingController(text: snapshot.data![index]));
                      return TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Page ${index + 1}",
                        ),
                        controller: _bookContentControllers[index],
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
