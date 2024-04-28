import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSProvider with ChangeNotifier {
  late Map<String, String> _voice;
  late String _language;
  final FlutterTts _flutterTts = FlutterTts();

  TTSProvider(Map<String, String> voice, String language) {
    _voice = voice;
    _language = language;
  }

  FlutterTts get flutterTts => _flutterTts;

  void initTTS() async {
    await _flutterTts.setLanguage(_language);
    await _flutterTts.setVoice(_voice);
  }

  void speak(String text) async {
    await _flutterTts.speak(text);
  }

  void pause() async {
    await _flutterTts.pause();
  }

  void stop() async {
    await _flutterTts.stop();
  }

  void regCompletionHandler(VoidCallback completionHandler) {
    _flutterTts.setCompletionHandler(completionHandler);
  }

  void regCancelHandler(VoidCallback cancelHandler) {
    _flutterTts.setCancelHandler(cancelHandler);
  }

  void regProgressHandler(
      void Function(String text, int startOffset, int endOffset, String word)
          progressHandler) async {
    _flutterTts.setProgressHandler(progressHandler);
  }
}
