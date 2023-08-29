import 'package:flutter/cupertino.dart';
import 'package:robocar_orbit/provider/remote_network.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecognition extends ChangeNotifier {
  bool tapSpeech = false;
  String speechText = "";
  String speechError = "";

  void speechTapDown() async {
    tapSpeech = true;
    speechError = "";
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) {
        print(status);
      },
      onError: (errorNotification) {
        speechError = errorNotification.errorMsg;
        notifyListeners();
      },
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          print(result);
          speechText = result.recognizedWords;
          notifyListeners();
        },
      );
    } else {
      speechError = "denied the use of speech";
      print("The user has denied the use of speech recognition.");
    }
    notifyListeners();
  }

  void speechTapUp() async {
    tapSpeech = false;
    stt.SpeechToText speech = stt.SpeechToText();
    speech.stop();

    if (speechText == "maju") {
      RemoteNetwork().Forward();
    } else if (speechText == "mundur") {
      RemoteNetwork().Backward();
    } else if (speechText == "belok kanan") {
      RemoteNetwork().Right();
    } else if (speechText == "belok kiri") {
      RemoteNetwork().Left();
    } else if (speechText == "berhenti") {
      RemoteNetwork().Stop();
    }
    notifyListeners();
  }
}
