import 'package:project/helper/utils/generalImports.dart';

class ColorsRes {
  static MaterialColor appColor = const MaterialColor(
    0xff55AE7B,
    <int, Color>{
      50: Color(0xff55AE7B),
      100: Color(0xff55AE7B),
      200: Color(0xff55AE7B),
      300: Color(0xff55AE7B),
      400: Color(0xff55AE7B),
      500: Color(0xff55AE7B),
      600: Color(0xff55AE7B),
      700: Color(0xff55AE7B),
      800: Color(0xff55AE7B),
      900: Color(0xff55AE7B),
    },
  );

  static Color appColorLight = const Color(0xffe1ffeb);
  static Color appColorLightHalfTransparent = const Color(0x2655AE7B);
  static Color appColorDark = const Color(0xff3d8c68);

  static Color gradient1 = const Color(0xff78c797);
  static Color gradient2 = const Color(0xff55AE7B);

  static Color defaultPageInnerCircle = const Color(0x1A999999);
  static Color defaultPageOuterCircle = const Color(0x0d999999);

  static Color mainTextColor = const Color(0xde000000);

  ///[mainTextColor] do not change the main color change only [mainTextColorLight] and [mainTextColorDark] color only
  static Color mainTextColorLight = const Color(0xff121418);
  static Color mainTextColorDark = const Color(0xfffefefe);

  static Color subTitleMainTextColor = const Color(0x94000000);

  ///[subtitleTextColorLight] do not change the main color change only [subTitleTextColorDark] and [subTitleTextColorLight] color only
  static Color subTitleTextColorLight = const Color(0xffAEAEAE);
  static Color subTitleTextColorDark = const Color(0xff7F878E);

  static Color mainIconColor = Colors.white;

  static Color bgColorLight = const Color(0xffF7F7F7);
  static Color bgColorDark = const Color(0xff141A1F);

  static Color cardColorLight = const Color(0xffFEFEFE);
  static Color cardColorDark = const Color(0xff202934);

  static Color grey = Colors.grey;
  static Color lightGrey = const Color(0xffb8babb);
  static Color appColorWhite = Colors.white;
  static Color appColorBlack = Colors.black;
  static Color appColorRed = Color(0xffF52C45);
  static Color appColorGreen = Colors.green;
  static Color appColorTransparent = Colors.transparent;
  static Color appColorOrange = Colors.orange;
  static Color appColorBlack45 = Colors.black45;
  static Color appColorBlack12 = Colors.black12;
  static Color appColorBlack38 = Colors.black38;
  static Color appColorAmber = Colors.amber;
  static Color appColorBlueAccent = Colors.blueAccent;

  static Color greyBox = const Color(0x0a000000);
  static Color lightGreyBox = const Color.fromARGB(9, 213, 212, 212);

  //It will be same for both theme
  static Color shimmerBaseColor = Colors.white;
  static Color shimmerHighlightColor = Colors.white;
  static Color shimmerContentColor = Colors.white;

  //Dark theme shimmer color
  static Color shimmerBaseColorDark = Colors.grey.withValues(alpha: 0.05);
  static Color shimmerHighlightColorDark = Colors.grey.withValues(alpha: 0.005);
  static Color shimmerContentColorDark = Colors.black;

  //Light theme shimmer color
  static Color shimmerBaseColorLight = Colors.black.withValues(alpha: 0.05);
  static Color shimmerHighlightColorLight =
      Colors.black.withValues(alpha: 0.005);
  static Color shimmerContentColorLight = Colors.white;

  static Color activeRatingColor = Color(0xffF4CD32);
  static Color deActiveRatingColor = Color(0xffAEAEAE);

  static Color statusBgColorPendingPayment = Color(0xffFFF8EC);
  static Color statusBgColorReceived = Color(0xffF1FFFC);
  static Color statusBgColorProcessed = Color(0xffFBF8FF);
  static Color statusBgColorShipped = Color(0xffF2FAFF);
  static Color statusBgColorOutForDelivery = Color(0xffF7FAFC);
  static Color statusBgColorDelivered = Color(0xffF7FAFC);
  static Color statusBgColorCancelled = Color(0xffF1FFEF);
  static Color statusBgColorReturned = Color(0xffFFF4F4);

  static List<Color> statusBgColor = [
    statusBgColorPendingPayment,
    statusBgColorReceived,
    statusBgColorProcessed,
    statusBgColorShipped,
    statusBgColorOutForDelivery,
    statusBgColorDelivered,
    statusBgColorCancelled,
    statusBgColorReturned,
  ];

  static Color statusTextColorPendingPayment = Color(0xffDD6B20);
  static Color statusTextColorReceived = Color(0xff319795);
  static Color statusTextColorProcessed = Color(0xff805AD5);
  static Color statusTextColorShipped = Color(0xff3182CE);
  static Color statusTextColorOutForDelivery = Color(0xff2D3748);
  static Color statusTextColorDelivered = Color(0xff38A169);
  static Color statusTextColorCancelled = Color(0xffE53E3E);
  static Color statusTextColorReturned = Color(0xffD69E2E);

  static List<Color> statusTextColor = [
    statusTextColorPendingPayment,
    statusTextColorReceived,
    statusTextColorProcessed,
    statusTextColorShipped,
    statusTextColorOutForDelivery,
    statusTextColorDelivered,
    statusTextColorCancelled,
    statusTextColorReturned,
  ];

  static ThemeData lightTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgColorLight,
    cardColor: cardColorLight,
    iconTheme: IconThemeData(
      color: grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: grey,
      iconTheme: IconThemeData(
        color: grey,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: bgColorLight,
      brightness: Brightness.light,
    ),
    cardTheme: CardThemeData(
      color: mainTextColor,
      surfaceTintColor: mainTextColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColorDark,
    cardColor: cardColorDark,
    iconTheme: IconThemeData(
      color: grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: grey,
      iconTheme: IconThemeData(
        color: grey,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: Colors.grey,//bgColorDark,
      brightness: Brightness.dark,
    ),
    cardTheme: CardThemeData(
      color: mainTextColor,
      surfaceTintColor: mainTextColor,
    ),
  );

  static ThemeData setAppTheme() {
    String theme = Constant.session.getData(SessionManager.appThemeName);
    bool isDarkTheme = Constant.session.getBoolData(SessionManager.isDarkTheme);

    bool isDark = false;
    if (theme == Constant.themeList[2]) {
      isDark = true;
    } else if (theme == Constant.themeList[1]) {
      isDark = false;
    } else if (theme == "" || theme == Constant.themeList[0]) {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      isDark = brightness == Brightness.dark;

      if (theme == "") {
        Constant.session
            .setData(SessionManager.appThemeName, Constant.themeList[0], false);
      }
    }

    if (isDark) {
      if (!isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, false, false);
      }
      mainTextColor = mainTextColorDark;
      subTitleMainTextColor = subTitleTextColorDark;

      shimmerBaseColor = shimmerBaseColorDark;
      shimmerHighlightColor = shimmerHighlightColorDark;
      shimmerContentColor = shimmerContentColorDark;
      return darkTheme;
    } else {
      if (isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, true, false);
      }
      mainTextColor = mainTextColorLight;
      subTitleMainTextColor = subTitleTextColorLight;

      shimmerBaseColor = shimmerBaseColorLight;
      shimmerHighlightColor = shimmerHighlightColorLight;
      shimmerContentColor = shimmerContentColorLight;
      return lightTheme;
    }
  }
}

String colorToHex(Color color) {
  final red = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
  final green = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
  final blue = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
  final alpha = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');

  return '#$alpha$red$green$blue';
}
