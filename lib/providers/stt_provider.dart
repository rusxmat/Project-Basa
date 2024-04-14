import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttProvider with ChangeNotifier {
  SpeechToText? _speechToText;
  bool _speechEnabled = false;

  SttProvider() {
    _speechToText = SpeechToText();
    _speechToText!.initialize(
      onError: (error) {
        print('Error: $error');
      },
      onStatus: (status) {
        if (status == 'listening') {
          _speechEnabled = true;
        } else {
          _speechEnabled = false;
        }
        notifyListeners();
      },
    );
  }

  SpeechToText? get speechToText => _speechToText;
  Future<List<LocaleName>> Function() get locales => _speechToText!.locales;

  // Future<bool> initialize() async {
  //   bool isAvailable = await _speechToText.initialize();
  //   return isAvailable;
  // }

  // bool get isListening => _speechToText.isListening;

  // Future<void> startListening() async {
  //   await _speechToText.listen(
  //     onResult: (stt.SpeechRecognitionResult result) {
  //       // Handle the speech recognition result here
  //     },
  //   );
  // }

  // void stopListening() {
  //   _speechToText.stop();
  // }
}
