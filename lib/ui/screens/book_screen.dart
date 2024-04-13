import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/tts_provider.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:flutter/widgets.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  BookScreen({super.key, required this.book});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookProvider _bookProvider = BookProvider();
  TTSProvider? _ttsProvider;
  int? _currentWordStart, _currentWordEnd;
  late Book book = widget.book;
  late List<BookPage> pages = [];

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _ttsProvider = TTSProvider(
        LANGUAGE_VOICES[book.language]!, LANGUAGE_TTS[book.language]!);
    _ttsProvider!.flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _fetchBookPages();
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = await _bookProvider.getBookPagesById(book.id!);
    setState(() {
      pages = bookpages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Page ${page.pageNumber}',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: page.content.substring(0, _currentWordStart),
                        ),
                        if (_currentWordStart != null)
                          TextSpan(
                            text: page.content.substring(
                                _currentWordStart!, _currentWordEnd!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        if (_currentWordEnd != null)
                          TextSpan(
                            text: page.content.substring(_currentWordEnd!),
                          ),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.volume_up),
                    onPressed: () {
                      _ttsProvider!.flutterTts.getDefaultVoice.then((value) {
                        print('\n\n\n\nThis is the default voice: ');
                        print(value);
                      });

                      _ttsProvider!.flutterTts.getVoices.then((value) {
                        List<Map> _voices = List<Map>.from(value);
                        _voices = _voices
                            .where((voice) => voice["locale"].contains('en-US'))
                            .toList();
                        print(_voices);
                      });

                      _ttsProvider!.flutterTts.setCompletionHandler(() {
                        setState(() {
                          _currentWordStart = null;
                          _currentWordEnd = null;
                        });
                      });
                      _ttsProvider!.speak(page.content);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
//BUG WHEN MOVING TO NEXT PAGE THE WORD HIGHLIGHT IS NOT RESET
