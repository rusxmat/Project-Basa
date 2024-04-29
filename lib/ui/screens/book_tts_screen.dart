import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/tts_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/constants.dart';
import 'package:basa_proj_app/ui/modals/edit_book_page_modal.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/custom_icon_btn.dart';
import 'package:basa_proj_app/ui/widgets/page_image_display.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_page_model.dart';

enum TtsState { playing, paused, stopped }

class BookTTSScreen extends StatefulWidget {
  final Book book;

  BookTTSScreen({super.key, required this.book});

  @override
  _BookTTSScreenState createState() => _BookTTSScreenState();
}

class _BookTTSScreenState extends State<BookTTSScreen> {
  final BookProvider _bookProvider = BookProvider();
  late Book book = widget.book;
  late List<BookPage> pages = [];
  late BookPage _currentPage;
  late int _currentPageIndex = 0;
  late bool ttsInitialized = false;

  int start = -1;
  int end = -1;

  TtsState _ttsState = TtsState.stopped;
  TTSProvider? _ttsProvider;

  @override
  void initState() {
    super.initState();
    book = widget.book;

    _ttsProvider = TTSProvider(
        LANGUAGE_VOICES[book.language]!, LANGUAGE_TTS[book.language]!);
    _ttsProvider!.initTTS();
    _ttsProvider!.regProgressHandler(_setProgressHandler);
    _ttsProvider!.regCompletionHandler(_resetTTS);
    _ttsProvider!.regCancelHandler(_resetTTS);

    _fetchBookPages();
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = await _bookProvider.getBookPagesById(book.id!);
    setState(() {
      pages = bookpages;
      _currentPage = pages[_currentPageIndex];
    });
  }

  void _resetTTS() {
    setState(() {
      _ttsState = TtsState.stopped;
      start = -1;
      end = -1;
    });
  }

  void _setProgressHandler(
      String text, int startOffset, int endOffset, String word) {
    setState(() {
      start = startOffset;
      end = endOffset;
    });
  }

  List<TextSpan> getTextSpans() {
    List<TextSpan> spans = [];
    if (_currentPage.content.isEmpty) return spans;

    if (start == -1) {
      spans.add(TextSpan(
        text: _currentPage.content,
      ));
      return spans;
    }

    spans.add(TextSpan(
      text: _currentPage.content.substring(0, start),
    ));
    spans.add(TextSpan(
      text: _currentPage.content.substring(start, end),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        backgroundColor: ConstantUI.customBlue,
      ),
    ));
    spans.add(TextSpan(
      text: _currentPage.content.substring(end),
    ));

    return spans;
  }

  Future<dynamic> _speak() async {
    _ttsProvider!.speak(_currentPage.content);
    setState(() => _ttsState = TtsState.playing);
  }

  Future<void> _replay() async {
    _ttsProvider!.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    await _speak();
    setState(() => _ttsState = TtsState.playing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: book.title,
        onPressedArrowBack: () {
          _ttsProvider!.stop();
          _ttsState = TtsState.stopped;
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: (!ttsInitialized)
                  ? ConstantUI.customYellow
                  : ConstantUI.customGrey,
            ),
            onPressed: (!ttsInitialized)
                ? () async {
                    _ttsProvider!.stop();
                    _resetTTS();
                    await showDialog(
                        context: context,
                        builder: (context) => EditBookPageModal(
                            bookPage: _currentPage,
                            pageNumber: _currentPageIndex));
                    _fetchBookPages();
                  }
                : null,
          )
        ],
      ),
      body: PageView.builder(
        physics: (_ttsState == TtsState.playing)
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _ttsProvider!.stop();
            _ttsState = TtsState.stopped;
            _currentPage = pages[index];
            ttsInitialized = false;
            start = -1;
            end = -1;
            _currentPageIndex = index;
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: PageImageDisplay(
                  image: Image.memory(
                    page.photo!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Card(
                  margin: const EdgeInsets.all(10.0),
                  elevation: 4.0,
                  child: SingleChildScrollView(
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: ITIM_FONTNAME,
                            ),
                            children: getTextSpans(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (ttsInitialized)
                  ? Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              icon: const Icon(Icons.replay_rounded),
                              onPressed: _replay,
                              backgroundColor: ConstantUI.customYellow,
                            ),
                            CustomIconButton(
                              icon: const Icon(Icons.square_rounded),
                              onPressed: () {
                                setState(() {
                                  _ttsProvider!.stop();
                                  ttsInitialized = false;
                                });
                              },
                              backgroundColor: ConstantUI.customPink,
                            ),
                          ],
                        ),
                      ),
                    )
                  : EMPTY_SPACE
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          (!ttsInitialized)
              ? CustomFloatingAction(
                  btnColor: ConstantUI.customBlue,
                  btnIcon: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      ttsInitialized = true;
                      _speak();
                    });
                  },
                )
              : EMPTY_SPACE
        ],
      ),
    );
  }
}
