import 'package:geolocator/geolocator.dart';
import 'package:project/helper/utils/generalImports.dart';


class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.online;

  @override
  void dispose() {
    context
        .read<HomeMainScreenProvider>()
        .scrollController[0]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[1]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[2]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[3]
        .removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      context.read<HomeMainScreenProvider>().setPages();
    }
    // Future.delayed(
    //   Duration.zero,
    //   () async {
    //     context.read<AppSettingsProvider>().getAppSettingsProvider(context);
    //
    //
    //
    //     if (Constant.session
    //         .getData(SessionManager.keyFCMToken)
    //         .trim()
    //         .isEmpty) {
    //       await FirebaseMessaging.instance.getToken().then((token) {
    //         Constant.session.setData(SessionManager.keyFCMToken, token!, false);
    //
    //         Map<String, String> params = {
    //           ApiAndParams.fcmToken:
    //               /* Constant.session.getData(SessionManager.keyFCMToken) */ token,
    //           ApiAndParams.platform: Platform.isAndroid ? "android" : "ios"
    //         };
    //
    //         registerFcmKey(context: context, params: params);
    //       }).onError((e, _) {
    //         return;
    //       });
    //     }
    //
    //     LocationPermission permission;
    //     permission = await Geolocator.checkPermission();
    //
    //     if (permission == LocationPermission.denied) {
    //       permission = await Geolocator.requestPermission();
    //     } else if (permission == LocationPermission.deniedForever) {
    //       return Future.error('Location Not Available');
    //     }
    //
    //     if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
    //             Constant.session.getData(SessionManager.keyLongitude) == "") ||
    //         (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
    //             Constant.session.getData(SessionManager.keyLongitude) == "0")) {
    //       Navigator.pushNamed(context, confirmLocationScreen,
    //           arguments: [null, "location"]);
    //     } else {
    //       if (context.read<HomeMainScreenProvider>().getCurrentPage() == 0) {
    //         if (Constant.popupBannerEnabled) {
    //           showDialog(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return CustomDialog();
    //             },
    //           );
    //         }
    //       }
    //
    //       if (Constant.session.isUserLoggedIn()) {
    //         await getAppNotificationSettingsRepository(
    //                 params: {}, context: context)
    //             .then(
    //           (value) async {
    //             if (value[ApiAndParams.status].toString() == "1") {
    //               late AppNotificationSettings notificationSettings =
    //                   AppNotificationSettings.fromJson(value);
    //               if (notificationSettings.data!.isEmpty) {
    //                 await updateAppNotificationSettingsRepository(params: {
    //                   ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
    //                   ApiAndParams.mobileStatuses: "0,1,1,1,1,1,1,1",
    //                   ApiAndParams.mailStatuses: "0,1,1,1,1,1,1,1"
    //                 }, context: context);
    //               }
    //             }
    //           },
    //         );
    //       }
    //     }
    //   },
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeMainScreenProvider>(
      builder: (context, homeMainScreenProvider, child) {
        return Scaffold(
          bottomNavigationBar: homeBottomNavigation(
            homeMainScreenProvider.getCurrentPage(),
            homeMainScreenProvider.selectBottomMenu,
            homeMainScreenProvider.getPages().length,
            context,
          ),
          body: networkStatus == NetworkStatus.online
              ? PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, _) {
                    if (didPop) {
                      return;
                    } else {
                      if (homeMainScreenProvider.currentPage == 0) {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      } else {
                        setState(() {});
                        homeMainScreenProvider.currentPage = 0;
                      }
                    }
                  },
                  child: IndexedStack(
                    index: homeMainScreenProvider.currentPage,
                    children: homeMainScreenProvider.getPages(),
                  ),
                )
              : Center(
                  child: CustomTextLabel(
                    jsonKey: checkInternetLabel,
                  ),
                ),
        );
      },
    );
  }

  homeBottomNavigation(int selectedIndex, Function selectBottomMenu,
      int totalPage, BuildContext context) {
    List lblHomeBottomMenu = [
      getTranslatedValue(
        context,
        homeBottomMenuHomeLabel,
      ),
      getTranslatedValue(
        context,
        homeBottomMenuCategoryLabel,
      ),
      getTranslatedValue(
        context,
        homeBottomMenuWishlistLabel,
      ),
      getTranslatedValue(
        context,
        homeBottomMenuProfileLabel,
      ),
    ];
    return BottomNavigationBar(
        items: List.generate(
          totalPage,
          (index) => BottomNavigationBarItem(
            backgroundColor: Theme.of(context).cardColor,
            icon: getHomeBottomNavigationBarIcons(
                isActive: selectedIndex == index)[index],
            label: lblHomeBottomMenu[index],
          ),
        ),
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        selectedItemColor: ColorsRes.mainTextColor,
        unselectedItemColor: ColorsRes.appColorTransparent,
        onTap: (int ind) {
          selectBottomMenu(ind);
        },
        elevation: 5);
  }
}