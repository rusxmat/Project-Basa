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
  bool get isListening => _speechToText!.isListening;
  String? get lastRecognizedWords => _speechToText!.lastRecognizedWords;
  // Future<List<LocaleName>> Function() get locales => _speechToText!.locales;

  void startListening({void Function(dynamic result)? onSpeechResult}) async {
    await _speechToText!.listen(
      onResult: onSpeechResult,
      listenFor: Duration(minutes: 5),
    );
  }

  void stopListening() async {
    await _speechToText!.stop();
  }

  // void test() {
  //   _speechToText!.listen(
  //     onResult: (result) {
  //       print(result.recognizedWords);
  //     },
  //     listenOptions: SpeechListenOptions()
  //   );

  //   _speechToText.
  // }
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
