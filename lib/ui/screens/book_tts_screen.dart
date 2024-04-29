import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/online_book_provider.dart';
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
  final bool fromOnline;

  BookTTSScreen({super.key, required this.book, required this.fromOnline});

  @override
  _BookTTSScreenState createState() => _BookTTSScreenState();
}

class _BookTTSScreenState extends State<BookTTSScreen> {
  late BookProvider _bookProvider;
  late OnlineBookProvider _onlineBookProvider;

  late Book book;
  late bool fromOnline;
  late List<BookPage> pages = [];
  late BookPage currentPage;
  late int currentPageIndex = 0;

  int start = -1;
  int end = -1;

  late bool ttsInitialized = false;
  TTSProvider? _ttsProvider;
  TtsState _ttsState = TtsState.stopped;

  void _initTTS() {
    _ttsProvider = TTSProvider(
        LANGUAGE_VOICES[book.language]!, LANGUAGE_TTS[book.language]!);
    _ttsProvider!.initTTS();
    _ttsProvider!.regProgressHandler(setProgressHandler);
    _ttsProvider!.regCompletionHandler(resetTTS);
    _ttsProvider!.regCancelHandler(resetTTS);
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = [];

    if (!fromOnline) {
      print('fromOffline');
      bookpages = await _bookProvider.getBookPagesById(book.id!);
    } else {
      print('fromOnline');
      bookpages = await _onlineBookProvider.getBookPagesById(book.id!);
    }

    bookpages.forEach((element) {
      print(element.content);
    });

    setState(() {
      pages = bookpages;
      currentPage = pages[currentPageIndex];
    });
  }

  @override
  void initState() {
    super.initState();

    fromOnline = widget.fromOnline;
    book = widget.book;

    if (fromOnline) {
      _onlineBookProvider = OnlineBookProvider();
    } else {
      _bookProvider = BookProvider();
    }

    _initTTS();
    _fetchBookPages();
  }

  void resetTTS() {
    setState(() {
      _ttsState = TtsState.stopped;
      start = -1;
      end = -1;
    });
  }

  void hardResetTTS() {
    setState(() {
      ttsInitialized = false;
    });
    resetTTS();
  }

  void setProgressHandler(
      String text, int startOffset, int endOffset, String word) {
    setState(() {
      start = startOffset;
      end = endOffset;
    });
  }

  Future<dynamic> _speak() async {
    _ttsProvider!.speak(currentPage.content);
    setState(() => _ttsState = TtsState.playing);
  }

  Future<void> _replay() async {
    _ttsProvider!.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    await _speak();
    setState(() => _ttsState = TtsState.playing);
  }

  List<TextSpan> getTextSpans(String content) {
    List<TextSpan> spans = [];
    if (content.isEmpty) return spans;

    if (start == -1) {
      spans.add(TextSpan(
        text: content,
      ));
      return spans;
    }

    spans.add(TextSpan(
      text: content.substring(0, start),
    ));
    spans.add(TextSpan(
      text: content.substring(start, end),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        backgroundColor: ConstantUI.customBlue,
      ),
    ));
    spans.add(TextSpan(
      text: content.substring(end),
    ));

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: book.title,
        onPressedArrowBack: () {
          _ttsProvider!.stop();
          hardResetTTS();
          Navigator.pop(context);
        },
        actions: [
          (fromOnline)
              ? EMPTY_SPACE
              : IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: (!ttsInitialized)
                        ? ConstantUI.customYellow
                        : ConstantUI.customGrey,
                  ),
                  onPressed: (!ttsInitialized)
                      ? () async {
                          _ttsProvider!.stop();
                          resetTTS();
                          await showDialog(
                              context: context,
                              builder: (context) => EditBookPageModal(
                                  bookPage: currentPage,
                                  pageNumber: currentPageIndex));
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
          hardResetTTS();
          setState(() {
            currentPage = pages[index];
            currentPageIndex = index;
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final BookPage page = pages[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: PageImageDisplay(
                  image: (fromOnline)
                      ? Image.network(
                          page.photoUrl!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CIRCULAR_PROGRESS_INDICATOR,
                              );
                            }
                          },
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
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
                            children: getTextSpans(page.content),
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
                                  hardResetTTS();
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
                  icon: Icons.volume_up_rounded,
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
