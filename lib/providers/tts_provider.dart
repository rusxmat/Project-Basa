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

  void speak(String text) async {
    await _flutterTts.setLanguage(_language);
    await _flutterTts.setVoice(_voice);
    await _flutterTts.speak(text);
  }

  void stop() async {
    await _flutterTts.stop();
  }

  void returnProgressHandler() {
    return _flutterTts
        .setProgressHandler((String text, int start, int end, String word) {});
  }
}
