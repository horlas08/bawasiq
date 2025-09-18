import 'package:project/helper/utils/generalImports.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> /*
    with TickerProviderStateMixin */
{
  late PackageInfo packageInfo;
  String currentAppVersion = "1.0.0";

  // late Animation<double> animation;
  // late AnimationController controller;

  @override
  void initState() {
    super.initState();

    // // Handle notification when app is terminated
    // LocalAwesomeNotification.terminatedStateNotificationHandler();

    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(
    //     milliseconds: 1500,
    //   ),
    //   upperBound: 0.5,
    // );
    // animation = Tween<double>(
    //   begin: 0,
    //   end: 600,
    // ).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller.stop();
    //     }
    //   });
    //
    // controller.forward();

    Future.delayed(Duration.zero).then(
      (value) async {
        await LocalAwesomeNotification().requestNotificationPermission(context);

        callAllApis();
      },
    );
  }

  Future callAllApis() async {
    try {
      context
          .read<AppSettingsProvider>()
          .getAppSettingsProvider(context)
          .then((value) async {
        packageInfo = await PackageInfo.fromPlatform();
        currentAppVersion = packageInfo.version;

        Map<String, String> params = {ApiAndParams.system_type: "1"};
        if (Constant.session
            .getData(SessionManager.keySelectedLanguageId)
            .isEmpty) {
          params[ApiAndParams.is_default] = "1";
        } else {
          params[ApiAndParams.id] =
              Constant.session.getData(SessionManager.keySelectedLanguageId);
        }

        await context.read<LanguageProvider>().getAvailableLanguageList(
            params: {ApiAndParams.system_type: "1"},
            context: context).then((value) {
          context
              .read<LanguageProvider>()
              .getLanguageDataProvider(
                params: params,
                context: context,
              )
              .then((value) {
            if (context.read<LanguageProvider>().languageState ==
                    LanguageState.loaded &&
                context.read<AppSettingsProvider>().settingsState ==
                    SettingsState.loaded) {
              startTime();
            }
          });
        });
      });
    } on SocketException {
      context.read<AppSettingsProvider>().changeState();
      throw Constant.noInternetConnection;
    } catch (e) {
      context.read<AppSettingsProvider>().changeState();
      throw Constant.somethingWentWrong;
    }
  }

  // startTime() async {
  //
  //   {
  //     if (Constant.appMaintenanceMode == "1") {
  //       Navigator.pushReplacementNamed(context, underMaintenanceScreen);
  //     }
  //     else if (Platform.isAndroid) {
  //       if (!Constant.session.getBoolData(SessionManager.introSlider)) {
  //         if ((Constant.isVersionSystemOn == "1" ||
  //                 Constant.currentRequiredAppVersion.isNotEmpty) &&
  //             (Version.parse(Constant.currentRequiredAppVersion) >
  //                 Version.parse(currentAppVersion))) {
  //           if (Constant.requiredForceUpdate == "1") {
  //             Constant.session
  //                 .setBoolData(SessionManager.introSlider, true, false);
  //             Navigator.pushReplacementNamed(context, introSliderScreen);
  //             Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                 arguments: true);
  //           } else {
  //             Constant.session
  //                 .setBoolData(SessionManager.introSlider, true, false);
  //             Navigator.pushReplacementNamed(context, introSliderScreen);
  //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //           }
  //         } else {
  //           Constant.session
  //               .setBoolData(SessionManager.introSlider, true, false);
  //           Navigator.pushReplacementNamed(context, introSliderScreen);
  //         }
  //       } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
  //           Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
  //         if (Constant.isVersionSystemOn == "1" &&
  //             (Version.parse(Constant.currentRequiredAppVersion) >
  //                 Version.parse(currentAppVersion))) {
  //           if (Constant.requiredForceUpdate == "1") {
  //             Navigator.pushReplacementNamed(context, editProfileScreen,
  //                 arguments: ["register", null]);
  //             Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                 arguments: true);
  //           } else {
  //             Navigator.pushReplacementNamed(context, editProfileScreen,
  //                 arguments: ["register", null]);
  //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //           }
  //         } else {
  //           Navigator.pushReplacementNamed(context, editProfileScreen,
  //               arguments: ["register", null]);
  //         }
  //       } else {
  //         if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
  //             Constant.session.getBoolData(SessionManager.isUserLogin)) {
  //           if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
  //                   Constant.session.getData(SessionManager.keyLongitude) ==
  //                       "") ||
  //               (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
  //                   Constant.session.getData(SessionManager.keyLongitude) ==
  //                       "0")) {
  //             if (Constant.isVersionSystemOn == "1" &&
  //                 (Version.parse(Constant.currentRequiredAppVersion) >
  //                     Version.parse(currentAppVersion))) {
  //               if (Constant.requiredForceUpdate == "1") {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                     arguments: true);
  //               } else {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushNamed(context, appUpdateScreen,
  //                     arguments: false);
  //               }
  //             } else {
  //               Navigator.pushReplacementNamed(context, mainHomeScreen);
  //             }
  //           } else {
  //             if (Constant.isVersionSystemOn == "1" &&
  //                 (Version.parse(Constant.currentRequiredAppVersion) >
  //                     Version.parse(currentAppVersion))) {
  //               if (Constant.requiredForceUpdate == "1") {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                     arguments: true);
  //               } else {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushNamed(context, appUpdateScreen,
  //                     arguments: false);
  //               }
  //             } else {
  //               Navigator.pushReplacementNamed(context, mainHomeScreen);
  //             }
  //           }
  //         } else {
  //           if (Constant.isVersionSystemOn == "1" &&
  //               (Version.parse(Constant.currentRequiredAppVersion) >
  //                   Version.parse(currentAppVersion))) {
  //             if (Constant.requiredForceUpdate == "1") {
  //               Navigator.pushReplacementNamed(context, loginAccountScreen);
  //               Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                   arguments: true);
  //             } else {
  //               Navigator.pushReplacementNamed(context, loginAccountScreen);
  //               Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //             }
  //           } else {
  //             Navigator.pushReplacementNamed(context, loginAccountScreen);
  //           }
  //         }
  //       }
  //     }
  //     else if (Platform.isIOS) {
  //       if (!Constant.session.getBoolData(SessionManager.introSlider)) {
  //         if ((Constant.isIosVersionSystemOn == "1" ||
  //                 Constant.currentRequiredIosAppVersion.isNotEmpty) &&
  //             (Version.parse(Constant.currentRequiredIosAppVersion) >
  //                 Version.parse(currentAppVersion))) {
  //           if (Constant.requiredIosForceUpdate == "1") {
  //             Constant.session
  //                 .setBoolData(SessionManager.introSlider, true, false);
  //             Navigator.pushReplacementNamed(context, introSliderScreen);
  //             Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                 arguments: true);
  //           } else {
  //             Constant.session
  //                 .setBoolData(SessionManager.introSlider, true, false);
  //             Navigator.pushReplacementNamed(context, introSliderScreen);
  //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //           }
  //         } else {
  //           Constant.session
  //               .setBoolData(SessionManager.introSlider, true, false);
  //           Navigator.pushReplacementNamed(context, introSliderScreen);
  //         }
  //       } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
  //           Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
  //         if (await versionInformationAvailable()) {
  //           if (Constant.requiredIosForceUpdate == "1") {
  //             Navigator.pushReplacementNamed(context, editProfileScreen,
  //                 arguments: ["register", null]);
  //             Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                 arguments: true);
  //           } else {
  //             Navigator.pushReplacementNamed(context, editProfileScreen,
  //                 arguments: ["register", null]);
  //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //           }
  //         } else {
  //           Navigator.pushReplacementNamed(context, editProfileScreen,
  //               arguments: ["register", null]);
  //         }
  //       } else {
  //         if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
  //             Constant.session.getBoolData(SessionManager.isUserLogin)) {
  //           if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
  //                   Constant.session.getData(SessionManager.keyLongitude) ==
  //                       "") ||
  //               (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
  //                   Constant.session.getData(SessionManager.keyLongitude) ==
  //                       "0")) {
  //             if (await versionInformationAvailable()) {
  //               if (Constant.requiredIosForceUpdate == "1") {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                     arguments: true);
  //               } else {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushNamed(context, appUpdateScreen,
  //                     arguments: false);
  //               }
  //             } else {
  //               Navigator.pushReplacementNamed(context, mainHomeScreen);
  //             }
  //           } else {
  //             if (await versionInformationAvailable()) {
  //               if (Constant.requiredIosForceUpdate == "1") {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                     arguments: true);
  //               } else {
  //                 Navigator.pushReplacementNamed(context, mainHomeScreen);
  //                 Navigator.pushNamed(context, appUpdateScreen,
  //                     arguments: false);
  //               }
  //             } else {
  //               Navigator.pushReplacementNamed(context, mainHomeScreen);
  //             }
  //           }
  //         } else {
  //           if (await versionInformationAvailable()) {
  //             if (Constant.requiredIosForceUpdate == "1") {
  //               Navigator.pushReplacementNamed(context, loginAccountScreen);
  //               Navigator.pushReplacementNamed(context, appUpdateScreen,
  //                   arguments: true);
  //             } else {
  //               Navigator.pushReplacementNamed(context, loginAccountScreen);
  //               Navigator.pushNamed(context, appUpdateScreen, arguments: false);
  //             }
  //           } else {
  //             Navigator.pushReplacementNamed(context, loginAccountScreen);
  //           }
  //         }
  //       }
  //     }
  //   }
  // }


  startTime() async {
    if (!mounted) return;

    void safeNavigate(String route, {Object? arguments}) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, route, arguments: arguments);
    }

    if (Constant.appMaintenanceMode == "1") {
      safeNavigate(underMaintenanceScreen);
      return;
    }

    // ========== ANDROID ==========
    if (Platform.isAndroid) {
      if (!Constant.session.getBoolData(SessionManager.introSlider)) {
        if ((Constant.isVersionSystemOn == "1" ||
            Constant.currentRequiredAppVersion.isNotEmpty) &&
            (Version.parse(Constant.currentRequiredAppVersion) >
                Version.parse(currentAppVersion))) {
          Constant.session.setBoolData(SessionManager.introSlider, true, false);
          safeNavigate(introSliderScreen);
          Future.microtask(() => safeNavigate(appUpdateScreen,
              arguments: Constant.requiredForceUpdate == "1"));
        } else {
          Constant.session.setBoolData(SessionManager.introSlider, true, false);
          safeNavigate(introSliderScreen);
        }
      } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
          Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
        if ((Constant.isVersionSystemOn == "1") &&
            (Version.parse(Constant.currentRequiredAppVersion) >
                Version.parse(currentAppVersion))) {
          safeNavigate(editProfileScreen, arguments: ["register", null]);
          Future.microtask(() => safeNavigate(appUpdateScreen,
              arguments: Constant.requiredForceUpdate == "1"));
        } else {
          safeNavigate(editProfileScreen, arguments: ["register", null]);
        }
      } else {
        safeNavigate(
          Constant.session.getBoolData(SessionManager.isUserLogin) ||
              Constant.session.getBoolData(SessionManager.keySkipLogin)
              ? mainHomeScreen
              : loginAccountScreen,
        );
      }
    }

    // ========== IOS ==========
    if (Platform.isIOS) {
      if (!Constant.session.getBoolData(SessionManager.introSlider)) {
        if (await versionInformationAvailable()) {
          Constant.session.setBoolData(SessionManager.introSlider, true, false);
          safeNavigate(introSliderScreen);
          Future.microtask(() => safeNavigate(appUpdateScreen,
              arguments: Constant.requiredIosForceUpdate == "1"));
        } else {
          Constant.session.setBoolData(SessionManager.introSlider, true, false);
          safeNavigate(introSliderScreen);
        }
      } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
          Constant.session.getIntData(SessionManager.keyUserStatus) == 2) {
        if (await versionInformationAvailable()) {
          safeNavigate(editProfileScreen, arguments: ["register", null]);
          Future.microtask(() => safeNavigate(appUpdateScreen,
              arguments: Constant.requiredIosForceUpdate == "1"));
        } else {
          safeNavigate(editProfileScreen, arguments: ["register", null]);
        }
      } else {
        safeNavigate(
          Constant.session.getBoolData(SessionManager.isUserLogin) ||
              Constant.session.getBoolData(SessionManager.keySkipLogin)
              ? mainHomeScreen
              : loginAccountScreen,
        );
      }
    }
  }
  Future<bool> versionInformationAvailable() async {
    return Constant.isIosVersionSystemOn == "1" &&
        (Version.parse(Constant.currentRequiredIosAppVersion) >
            Version.parse(currentAppVersion));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Consumer<AppSettingsProvider>(
          builder: (context, appSettingsProvider, child) {
            if (languageProvider.languageState == LanguageState.error ||
                appSettingsProvider.settingsState == SettingsState.error) {
              return Scaffold(
                backgroundColor: Theme.of(context).cardColor,
                body: DefaultBlankItemMessageScreen(
                  height: context.height,
                  image: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? "no_internet_icon"
                          : "something_went_wrong",
                  title: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? noInternetTitleLabel
                          : somethingWentWrongTitleLabel,
                  description: languageProvider.message.isNotEmpty
                      ? languageProvider.message
                      : appSettingsProvider.message ==
                              Constant.noInternetConnection
                          ? noInternetDescriptionLabel
                          : somethingWentWrongDescriptionLabel,
                  buttonTitle: tryAgainLabel,
                  callback: () async {
                    await callAllApis();
                  },
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: defaultImg(
                      image: AppAssets.logoIcon,
                    ),
                  ),
                ),
                // body: Align(
                //   alignment: FractionalOffset(
                //     controller.value,
                //     controller.value,
                //   ),
                //   child: Transform.scale(
                //     alignment: FractionalOffset(
                //       controller.value,
                //       controller.value,
                //     ),
                //     scale: controller.value * 2,
                //     child: defaultImg(
                //       image: 'logo',
                //     ),
                //   ),
                // ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // animation.removeListener(
    //   () {},
    // );
    // controller.dispose();
    super.dispose();
  }
}