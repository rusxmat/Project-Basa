import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttProvider with ChangeNotifier {
  SpeechToText? _speechToText;

  SttProvider() {
    _speechToText = SpeechToText();
    _speechToText!.initialize(
      onError: (error) {
        print('Error: $error');
      },
      onStatus: (status) {
        if (status == 'listening') {
        } else {}
        notifyListeners();
      },
    );
  }

  SpeechToText? get speechToText => _speechToText;
  bool? get isListening => _speechToText!.isListening;
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
