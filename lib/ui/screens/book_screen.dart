import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/stt_provider.dart';
import 'package:basa_proj_app/providers/tts_provider.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  BookScreen({super.key, required this.book});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookProvider _bookProvider = BookProvider();
  late Book book = widget.book;
  late List<BookPage> pages = [];

  TTSProvider? _ttsProvider;
  int? _currentWordStart, _currentWordEnd;

  SttProvider _sttProvider = SttProvider();
  bool sttMode = false;
  String wordsSpoken = "";

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

  void _startListening() async {
    await _sttProvider.speechToText!.listen(
      onResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    await _sttProvider.speechToText!.stop();
    setState(() {
      sttMode = false;
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      wordsSpoken = "${result.recognizedWords}";
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
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Page ${page.pageNumber}',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  page.content.substring(0, _currentWordStart),
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
                      Row(
                        children: [
                          FloatingActionButton(
                            child: Icon(Icons.volume_up),
                            onPressed: () {
                              _ttsProvider!.flutterTts.setCompletionHandler(() {
                                setState(() {
                                  _currentWordStart = null;
                                  _currentWordEnd = null;
                                });
                              });
                              _ttsProvider!.speak(page.content);
                            },
                          ),
                          FloatingActionButton(
                            child: Icon(Icons.mic),
                            onPressed: () {
                              setState(() {
                                sttMode = !sttMode;
                              });
                              if (sttMode) _startListening();
                              if (!sttMode) _stopListening();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              (sttMode)
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Speech to Text',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(wordsSpoken),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
//BUG WHEN MOVING TO NEXT PAGE THE WORD HIGHLIGHT IS NOT RESET
