import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/online_book_provider.dart';
import 'package:basa_proj_app/providers/stt_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/modals/edit_book_page_modal.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/page_content_card.dart';
import 'package:basa_proj_app/ui/widgets/page_image_display.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';
import 'package:basa_proj_app/models/book_page_model.dart';

class BookSTTScreen extends StatefulWidget {
  final Book book;
  final bool fromOnline;

  BookSTTScreen({super.key, required this.book, this.fromOnline = false});

  @override
  _BookSTTScreenState createState() => _BookSTTScreenState();
}

class _BookSTTScreenState extends State<BookSTTScreen> {
  late BookProvider _bookProvider;
  late OnlineBookProvider _onlineBookProvider;

  final SttProvider _sttProvider = SttProvider();

  late Book book;
  late bool fromOnline;

  late BookPage currentPage;
  int currentPageIndex = 0;
  List<BookPage> pages = [];
  List<String> referenceWords = [];

  String wordsSpoken = "";
  List<String> spokenWords = [];

  bool hasListened = false;
  int lastDetectedTextSize = 1;

  bool get isListening => _sttProvider.isListening;

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = [];

    if (fromOnline) {
      bookpages = await _onlineBookProvider.getBookPagesById(book.id!);
    } else {
      bookpages = await _bookProvider.getBookPagesById(book.id!);
    }

    setState(() {
      pages = bookpages;
      currentPage = pages[currentPageIndex];
      referenceWords = getReferenceWords();
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

    _fetchBookPages();
  }

  @override
  void dispose() {
    _stopListening();
    _sttProvider.dispose();
    super.dispose();
  }

  void _startListening() {
    _sttProvider.startListening(
      onSpeechResult: _onSpeechResult,
    );
  }

  void _stopListening() {
    _sttProvider.stopListening();
  }

  void reset() {
    setState(() {
      wordsSpoken = "";
      hasListened = false;
      lastDetectedTextSize = 1;
      spokenWords = [];
    });
  }

  void replay() {
    setState(() {
      wordsSpoken = "";
      lastDetectedTextSize = 1;
      spokenWords = [];
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      wordsSpoken = "${result.recognizedWords}";
      spokenWords = wordsSpoken.isEmpty
          ? []
          : wordsSpoken
              .split(RegExp(r"\s+"))
              .map((e) => e.toLowerCase())
              .toList();

      Future.delayed(const Duration(milliseconds: 500));

      if (lastDetectedTextSize < spokenWords.length) {
        lastDetectedTextSize++;
      }

      if (spokenWords.length == referenceWords.length) {
        _stopListening();
      }
    });
  }

  String getMessage(double score) {
    if (score >= 90) {
      return "Excellent!";
    } else if (score >= 80) {
      return "Great!";
    } else if (score >= 70) {
      return "Good!";
    } else if (score >= 60) {
      return "Nice!";
    } else if (score >= 50) {
      return "Not bad!";
    } else {
      return "Keep practicing!";
    }
  }

  List<String> getReferenceWords() {
    return currentPage.content
        .trim()
        .split(RegExp(r"[^-'\w]+"))
        .map((e) =>
            e.replaceAll(RegExp(r'^[^\w\s]+|[^\w\s]+$'), '').toLowerCase())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  Text wordToRead() {
    return (lastDetectedTextSize == spokenWords.length)
        ? Text(
            spokenWords[lastDetectedTextSize - 1],
            style: TextStyle(
              backgroundColor: (spokenWords[lastDetectedTextSize - 1] ==
                      referenceWords[lastDetectedTextSize - 1])
                  ? ConstantUI.customGreen
                  : ConstantUI.customPink,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          )
        : (lastDetectedTextSize - 1 < referenceWords.length)
            ? Text(
                referenceWords[lastDetectedTextSize - 1],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ), // Highlight match
              )
            : const Text('');
  }

  List<TextSpan> _compareWords() {
    List<TextSpan> highlightedText = [];

    for (int i = 0; i < referenceWords.length; i++) {
      String referenceWord = referenceWords[i].toLowerCase();
      TextSpan span = const TextSpan(text: "");

      if (i < spokenWords.length) {
        String spokenWord =
            spokenWords[i].toLowerCase(); // Make case-insensitive

        span = TextSpan(
          text: spokenWord,
          style: TextStyle(
            color: (spokenWord == referenceWord)
                ? ConstantUI.customGreen
                : ConstantUI.customPink,
          ),
        );
      } else {
        span = TextSpan(
          text: referenceWord,
          style: const TextStyle(
            color: Colors.black,
          ),
        );
      }
      highlightedText.add(span);
      TextSpan space = const TextSpan(text: " ");
      highlightedText.add(space);
    }

    return highlightedText;
  }

  Card _getScore() {
    int score = 0;

    for (int i = 0; i < spokenWords.length; i++) {
      if (referenceWords.length == i) break;

      String referenceWord = referenceWords[i].toLowerCase();
      String spokenWord = spokenWords[i].toLowerCase();
      // Make case-insensitive
      if (spokenWord == referenceWord) score++;
    }

    double scorePercentage = ((score / (referenceWords.length)) * 100);

    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4.0,
      child: Center(
        child: ListTile(
          leading: Text(
            "${scorePercentage.toStringAsFixed(0)}%",
            style: const TextStyle(fontSize: 30),
          ),
          title: Text('${score}/${referenceWords.length} words correct'),
          subtitle: Text(getMessage(scorePercentage)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: book.title,
        onPressedArrowBack: () {
          _stopListening();
          reset();
          Navigator.pop(context);
        },
        actions: [
          (fromOnline)
              ? EMPTY_SPACE
              : IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: (!hasListened)
                        ? ConstantUI.customYellow
                        : ConstantUI.customGrey,
                  ),
                  onPressed: (!hasListened)
                      ? () async {
                          _stopListening();
                          reset();
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
        physics: (isListening)
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        onPageChanged: (index) {
          reset();
          setState(() {
            currentPage = pages[index];
            currentPageIndex = index;
            referenceWords = getReferenceWords();
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
                child: PageContentCard(
                  pageContent: page.content,
                  pageNumber: page.pageNumber,
                ),
              ),
              (hasListened)
                  ? Expanded(
                      flex: 4,
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        elevation: 4.0,
                        child:
                            (((referenceWords.length == spokenWords.length) ||
                                        (hasListened && !isListening)) &&
                                    spokenWords.isNotEmpty)
                                ? SingleChildScrollView(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: ITIM_FONTNAME,
                                          height: 1.5,
                                        ),
                                        children: _compareWords(),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: wordToRead(),
                                  ),
                      ),
                    )
                  : EMPTY_SPACE,
              (hasListened && !isListening && spokenWords.isNotEmpty)
                  ? Expanded(
                      flex: 2,
                      child: _getScore(),
                    )
                  : EMPTY_SPACE
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          (hasListened)
              ? CustomFloatingAction(
                  btnColor:
                      ((hasListened && !isListening) || spokenWords.isEmpty)
                          ? (spokenWords.isEmpty)
                              ? ConstantUI.customBlue
                              : ConstantUI.customYellow
                          : Colors.white,
                  icon: (spokenWords.isEmpty)
                      ? Icons.mic
                      : Icons.replay_circle_filled_rounded,
                  onPressed:
                      ((hasListened && !isListening) || spokenWords.isEmpty)
                          ? () {
                              replay();
                              _startListening();
                            }
                          : null,
                )
              : EMPTY_SPACE,
          (hasListened) ? const SizedBox(height: 10.0) : EMPTY_SPACE,
          CustomFloatingAction(
            btnColor:
                (!hasListened) ? ConstantUI.customBlue : ConstantUI.customPink,
            icon: (!hasListened) ? Icons.mic : Icons.close_rounded,
            onPressed: () {
              if (!hasListened) {
                _startListening();
                setState(() {
                  hasListened = true;
                });
              } else {
                _stopListening();
                reset();
              }
            },
          )
        ],
      ),
    );
  }
}
