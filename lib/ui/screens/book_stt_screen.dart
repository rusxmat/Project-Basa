import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/providers/stt_provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/modals/edit_book_page_modal.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/models/book_model.dart';

class BookSTTScreen extends StatefulWidget {
  final Book book;

  BookSTTScreen({super.key, required this.book});

  @override
  _BookSTTScreenState createState() => _BookSTTScreenState();
}

class _BookSTTScreenState extends State<BookSTTScreen> {
  final BookProvider _bookProvider = BookProvider();
  late Book book = widget.book;
  List<BookPage> pages = [];
  late BookPage _currentPage;
  final SttProvider _sttProvider = SttProvider();

  List<String> referenceWords = [];
  String wordsSpoken = "";
  bool hasListened = false;
  int lastDetectedTextSize = 1;
  int _currentPageIndex = 0;
  List<String> spokenWords = [];

  @override
  void initState() {
    super.initState();
    book = widget.book;

    _fetchBookPages();
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
    return _currentPage.content
        .trim()
        .split(RegExp(r"[^-'\w]+"))
        .map((e) =>
            e.replaceAll(RegExp(r'^[^\w\s]+|[^\w\s]+$'), '').toLowerCase())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  Future<void> _fetchBookPages() async {
    List<BookPage> bookpages = await _bookProvider.getBookPagesById(book.id!);
    setState(() {
      pages = bookpages;
      _currentPage = pages[0];
      referenceWords = getReferenceWords();
    });
  }

  void _startListening() {
    _sttProvider.startListening(
      onSpeechResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    _sttProvider.stopListening();
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
      String referenceWord = referenceWords[i].toLowerCase();

      String spokenWord = spokenWords[i].toLowerCase(); // Make case-insensitive
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

  bool get isListening => _sttProvider.isListening;

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
          IconButton(
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
                            bookPage: _currentPage,
                            pageNumber: _currentPageIndex));
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
            _currentPage = pages[index];
            _currentPageIndex = index;
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
                child: Container(
                  constraints:
                      const BoxConstraints.expand(width: double.infinity),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                        page.photo!,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                        Text(
                          page.content,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontFamily: ITIM_FONTNAME,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  btnColor: ConstantUI.customYellow,
                  btnIcon: const Icon(
                    Icons.replay_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    replay();
                    _startListening();
                  },
                )
              : EMPTY_SPACE,
          (hasListened) ? const SizedBox(height: 10.0) : EMPTY_SPACE,
          CustomFloatingAction(
            btnColor:
                (!hasListened) ? ConstantUI.customBlue : ConstantUI.customPink,
            btnIcon: Icon(
              (!hasListened) ? Icons.mic : Icons.exit_to_app_rounded,
              color: Colors.white,
              size: 50,
            ),
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
          ),
        ],
      ),
    );
  }
}
//BUG WHEN MOVING TO NEXT PAGE THE WORD HIGHLIGHT IS NOT RESET
