import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/stt_provider.dart';
import 'package:basa_proj_app/providers/tts_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:flutter/widgets.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  final bool isMakinig;

  BookScreen({super.key, required this.book, required this.isMakinig});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookProvider _bookProvider = BookProvider();
  late Book book = widget.book;
  late List<BookPage> pages = [];
  late BookPage _currentPage;
  late bool isMakinig = widget.isMakinig;

  TTSProvider? _ttsProvider;
  int? _currentWordStart, _currentWordEnd;

  final SttProvider _sttProvider = SttProvider();
  String wordsSpoken = "";
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _ttsProvider = TTSProvider(
        LANGUAGE_VOICES[book.language]!, LANGUAGE_TTS[book.language]!);
    _fetchBookPages();
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = await _bookProvider.getBookPagesById(book.id!);
    setState(() {
      pages = bookpages;
      _currentPage = pages[0];
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
      isListening = false;
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
        title: Text(
          book.title,
          style: const TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
      ),
      body: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _currentPage = pages[index];
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Column(
            children: [
              Expanded(
                child: Container(
                  constraints:
                      const BoxConstraints.expand(width: double.infinity),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Page ${page.pageNumber}',
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: ITIM_FONTNAME,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: page.content
                                        .substring(0, _currentWordStart),
                                  ),
                                  if (_currentWordStart != null)
                                    TextSpan(
                                      text: page.content.substring(
                                          _currentWordStart!, _currentWordEnd!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: ConstantUI.customBlue,
                                      ),
                                    ),
                                  if (_currentWordEnd != null)
                                    TextSpan(
                                      text: page.content
                                          .substring(_currentWordEnd!),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              (!isMakinig)
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        constraints:
                            const BoxConstraints.expand(width: double.infinity),
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          elevation: 4.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Speech to Text',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(wordsSpoken),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 1,
                    ),
            ],
          );
        },
      ),
      floatingActionButton: (isMakinig)
          ? CustomFloatingAction(
              btnColor: ConstantUI.customBlue,
              btnIcon: const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                _ttsProvider!.flutterTts.setCompletionHandler(() {
                  setState(() {
                    _currentWordStart = null;
                    _currentWordEnd = null;
                  });
                });

                _ttsProvider!.flutterTts.setProgressHandler(
                  (text, start, end, word) {
                    setState(() {
                      _currentWordStart = start;
                      _currentWordEnd = end;
                    });
                  },
                );
                _ttsProvider!.speak(_currentPage.content);
              },
            )
          : CustomFloatingAction(
              btnColor: (!isListening)
                  ? ConstantUI.customYellow
                  : ConstantUI.customPink,
              btnIcon: Icon(
                (!isListening) ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                setState(() {
                  isListening = !isListening;
                });
                if (isListening) _startListening();
                if (!isListening) _stopListening();
              },
            ),
    );
  }
}
//BUG WHEN MOVING TO NEXT PAGE THE WORD HIGHLIGHT IS NOT RESET
