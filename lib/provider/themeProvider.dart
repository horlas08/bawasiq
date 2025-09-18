import 'package:project/helper/utils/generalImports.dart';

enum ThemeState { systemDefault, light, dark }

class ThemeProvider extends ChangeNotifier {
  List<String> ThemeList = [
    themeDisplayNamesSystemDefaultLabel,
    themeDisplayNamesLightLabel,
    themeDisplayNamesDarkLabel
  ];

  String selectedTheme = "";

  ThemeState themeState = Constant.session
              .getData(SessionManager.appThemeName)
              .toLowerCase() ==
          "system default"
      ? ThemeState.systemDefault
      : Constant.session.getData(SessionManager.appThemeName).toLowerCase() ==
              "light"
          ? ThemeState.light
          : ThemeState.dark;

  Future setSelectedTheme({required String currentTheme}) async {
    themeState = currentTheme.toLowerCase() == "system default"
        ? ThemeState.systemDefault
        : currentTheme.toLowerCase() == "light"
            ? ThemeState.light
            : ThemeState.dark;

    selectedTheme = currentTheme.toLowerCase() == "system default"
        ? Constant.themeList[0]
        : currentTheme.toLowerCase() == "light"
            ? Constant.themeList[1]
            : Constant.themeList[2];

    notifyListeners();
  }

  Future updateTheme({required String currentTheme}) async {
    Constant.session.setData(SessionManager.appThemeName, currentTheme, true);

    bool isDark = false;

    if (currentTheme == Constant.themeList[2]) {
      isDark = true;
    } else if (currentTheme == Constant.themeList[1]) {
      isDark = false;
    } else if (currentTheme == "" || currentTheme == Constant.themeList[0]) {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      isDark = brightness == Brightness.dark;

      if (currentTheme == "") {
        Constant.session
            .setData(SessionManager.appThemeName, Constant.themeList[0], false);
      }
    }

    Constant.session.setBoolData(SessionManager.isDarkTheme, isDark, true);
  }
}
