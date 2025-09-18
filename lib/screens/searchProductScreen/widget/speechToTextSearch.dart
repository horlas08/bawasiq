import 'package:project/helper/utils/generalImports.dart';


class SpeechToTextSearch extends StatefulWidget {
  const SpeechToTextSearch({Key? key}) : super(key: key);

  @override
  _SpeechToTextSearchState createState() => _SpeechToTextSearchState();
}

class _SpeechToTextSearchState extends State<SpeechToTextSearch> {
  final SpeechToText speech = SpeechToText();
  String _currentLocaleId = '';
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSpeechState();
    });
  }

  @override
  void dispose() {
    speech.cancel();
    super.dispose();
  }

  void errorListener(SpeechRecognitionError error) async {
    try {
      context
          .read<VoiceSearchProvider>()
          .changeState(state: VoiceSearchState.error);
    } catch (e) {
      setState(() {});
    }
  }

  void statusListener(String status) {
    context.read<VoiceSearchProvider>().changeState(
          state: status == 'listening'
              ? VoiceSearchState.listening
              : status == 'done'
                  ? VoiceSearchState.listened
                  : VoiceSearchState.error,
        );
  }

  Future<void> initSpeechState() async {
    final isInitialized = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: false,
      finalTimeout: const Duration(milliseconds: 0),
    );
    if (isInitialized) {
      context.read<VoiceSearchProvider>().changeState(
            state: VoiceSearchState.listening,
            hasSpeech: true,
          );

      _currentLocaleId = Constant.session
              .getData(SessionManager.keySelectedLanguageCode)
              .isEmpty
          ? "EN"
          : Constant.session.getData(SessionManager.keySelectedLanguageCode);
      startListening();
    }
  }

  void startListening() {
    context
        .read<VoiceSearchProvider>()
        .changeState(state: VoiceSearchState.listening, result: "");
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 3),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
    );
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
  }

  void resultListener(SpeechRecognitionResult result) {
    context.read<VoiceSearchProvider>().changeState(
          state: VoiceSearchState.listening,
          result: result.recognizedWords,
        );
    if (result.finalResult) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        Navigator.of(context, rootNavigator: true).pop(result.recognizedWords);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height / 3.0,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
        ),
      ),
      child: Consumer<VoiceSearchProvider>(
        builder: (context, voiceSearchProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              getSizedBox(height: 20),
              if (voiceSearchProvider.voiceSearchState ==
                  VoiceSearchState.listening)
                CustomTextLabel(
                  jsonKey: listeningLabel,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (voiceSearchProvider.voiceSearchState ==
                  VoiceSearchState.error)
                CustomTextLabel(
                  jsonKey: sorryDidntHearTryAgainLabel,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 35),
                child: GestureDetector(
                  onTap: () {
                    if (context.read<VoiceSearchProvider>().hasSpeech ||
                        speech.isNotListening) {
                      startListening();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorsRes.appColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: defaultImg(
                      image: AppAssets.voiceSearchIcon,
                      iconColor: ColorsRes.mainIconColor,
                    ),
                  ),
                ),
              ),
              if (context.read<VoiceSearchProvider>().lastWords.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(top: 20, bottom: 20),
                  child: Text(
                    context.read<VoiceSearchProvider>().lastWords,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              if (voiceSearchProvider.voiceSearchState ==
                  VoiceSearchState.error)
                Container(
                  padding: const EdgeInsetsDirectional.only(top: 35),
                  child: Center(
                    child: CustomTextLabel(
                      jsonKey: tapMicrophoneToTryAgainLabel,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
