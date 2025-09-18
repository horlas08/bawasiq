import 'package:project/helper/generalWidgets/bottomSheetChangePasswordContainer.dart';
import 'package:project/helper/utils/generalImports.dart';


class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List personalDataMenu = [];
  List settingsMenu = [];
  List otherInformationMenu = [];
  List deleteMenuItem = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setProfileMenuList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: getAppBar(
        context: context,
        centerTitle: true,
        title: CustomTextLabel(
          jsonKey: profileLabel,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        showBackButton: false,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          setProfileMenuList();
          return ListView(
            controller: widget.scrollController,
            children: [
              ProfileHeader(),
              QuickUseWidget(),
              menuItemsContainer(
                title: personalDataLabel,
                menuItem: personalDataMenu,
              ),
              menuItemsContainer(
                title: settingsLabel,
                menuItem: settingsMenu,
              ),
              menuItemsContainer(
                title: otherInformationLabel,
                menuItem: otherInformationMenu,
              ),
              menuItemsContainer(
                title: "",
                menuItem: deleteMenuItem,
                fontColor: ColorsRes.appColorRed,
                iconColor: ColorsRes.appColorRed,
              ),
            ],
          );
        },
      ),
    );
  }

  setProfileMenuList() {
    personalDataMenu = [];
    settingsMenu = [];
    otherInformationMenu = [];
    deleteMenuItem = [];

    personalDataMenu = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.walletHistoryIcon,
          "label": myWalletLabel,
          "value": Consumer<SessionManager>(
            builder: (context, sessionManager, child) {
              return CustomTextLabel(
                text:
                    "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                        .currency,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  color: ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, walletHistoryListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.notificationIcon,
          "label": notificationLabel,
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.transactionIcon,
          "label": transactionHistoryLabel,
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
    ];

    settingsMenu = [
      if (Constant.session.isUserLoggedIn() && (/* Constant.session.getData(SessionManager.keyLoginType) == "phone" */context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword=="1" || Constant.session.getData(SessionManager.keyLoginType) == "email"))
        {
          "icon": AppAssets.passwordIcon,
          "label": changePasswordLabel,
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              backgroundColor: Theme.of(context).cardColor,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetChangePasswordContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": false
        },
      {
        "icon": AppAssets.themeIcon,
        "label": changeThemeLabel,
        "clickFunction": (context) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,useSafeArea: true,
            shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
            backgroundColor: Theme.of(context).cardColor,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  BottomSheetThemeListContainer(),
                ],
              );
            },
          );
        },
        "isResetLabel": true,
      },
      if (context.read<LanguageProvider>().languages.length > 1)
        {
          "icon": AppAssets.translateIcon,
          "label": changeLanguageLabel,
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              backgroundColor: Theme.of(context).cardColor,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetLanguageListContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": true,
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.settingsIcon,
          "label": notificationsSettingsLabel,
          "clickFunction": (context) {
            Navigator.pushNamed(
                context, notificationsAndMailSettingsScreenScreen);
          },
          "isResetLabel": false
        },
    ];

    otherInformationMenu = [
     if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.referFriendIcon,
          "label": referAndEarnLabel,
          "clickFunction": (context) {
            Navigator.pushNamed(context, referAndEarn);
          },
          "isResetLabel": false
        },
      {
        "icon": AppAssets.contactIcon,
        "label": contactUsLabel,
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              contactUsLabel,
            ),
          );
        }
      },
      {
        "icon": AppAssets.aboutIcon,
        "label": aboutUsLabel,
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              aboutUsLabel,
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": AppAssets.rateUsIcon,
        "label": rateUsLabel,
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
      {
        "icon": AppAssets.shareIcon,
        "label": shareAppLabel,
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            shareAppMessageLabel,
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          // Share.share(shareAppMessage, subject: "Share app");
          SharePlus.instance.share(ShareParams(text: shareAppMessage, subject: "Share app"));
        },
      },
      {
        "icon": AppAssets.faqIcon,
        "label": faqLabel,
        "clickFunction": (context) {
          Navigator.pushNamed(context, faqListScreen);
        }
      },
      {
        "icon": AppAssets.termsIcon,
        "label": termsAndConditionsLabel,
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                termsAndConditionsLabel,
              ));
        }
      },
      {
        "icon": AppAssets.privacyIcon,
        "label": policiesLabel,
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                policiesLabel,
              ));
        }
      },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.logoutIcon,
          "label": logoutLabel,
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
    ];

    deleteMenuItem = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": AppAssets.deleteUserAccountIcon,
          "label": deleteUserAccountLabel,
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }

  Widget menuItemsContainer({
    required String title,
    required List menuItem,
    Color? iconColor,
    Color? fontColor,
  }) {
    if (menuItem.isNotEmpty) {
      return Container(
        decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
        padding: EdgeInsetsDirectional.only(start: 10, end: 10),
        margin: EdgeInsetsDirectional.only(
          start: 10,
          end: 10,
          bottom: 10,
          top: Constant.session.isUserLoggedIn() ? 0 : 10,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            if (title.isNotEmpty) getSizedBox(height: 10),
            if (title.isNotEmpty)
              CustomTextLabel(
                jsonKey: title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: ColorsRes.mainTextColor,
                ),
              ),
            if (title.isNotEmpty) getSizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                menuItem.length,
                (index) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        menuItem[index]['clickFunction'](context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            defaultImg(
                              image: menuItem[index]['icon'],
                              iconColor: iconColor ?? ColorsRes.mainTextColor,
                              height: 24,
                              width: 24,
                            ),
                            getSizedBox(width: 15),
                            Expanded(
                              child: CustomTextLabel(
                                jsonKey: menuItem[index]['label'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: fontColor ?? ColorsRes.mainTextColor,
                                ),
                              ),
                            ),
                            if (menuItem[index]['value'] != null)
                              menuItem[index]['value'],
                            if (menuItem[index]['value'] != null)
                              getSizedBox(width: 10),
                            Icon(
                              Icons.navigate_next,
                              color: fontColor ??
                                  ColorsRes.mainTextColor.withValues(alpha:0.5),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (index != menuItem.length - 1)
                      getDivider(
                        height: 5,
                        color: fontColor ??
                            ColorsRes.mainTextColor.withValues(alpha:0.1),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
