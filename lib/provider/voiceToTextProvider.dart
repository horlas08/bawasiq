import 'package:project/helper/utils/generalImports.dart';

enum VoiceSearchState {
  initial,
  listening,
  listened,
  output_empty,
  error,
}

class VoiceSearchProvider extends ChangeNotifier {
  VoiceSearchState voiceSearchState = VoiceSearchState.initial;
  String lastWords = '';
  bool hasSpeech = false;

  changeState(
      {required VoiceSearchState state, String? result, bool? hasSpeech}) {
    voiceSearchState = state;
    lastWords = result ?? "";
    this.hasSpeech = hasSpeech ?? false;
    notifyListeners();
  }
}
