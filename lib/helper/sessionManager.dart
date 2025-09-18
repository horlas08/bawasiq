import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/PlaceDetailsModel.dart';

class SessionManager extends ChangeNotifier {
  static String isUserLogin = "isUserLogin";
  static String introSlider = "introSlider";
  static String isDarkTheme = "isDarkTheme";
  static String appThemeName = "appThemeName";
  static String keySelectedLanguageId = "selectedLanguageId";
  static String keySelectedLanguageCode = "selectedLanguageCode";
  static String keyRecentAddressSearch = "recentAddress";
  static String keySkipLogin = "keySkipLogin";
  static String keyUserName = "username";
  static String keyUserImage = "image";
  static String keyPhone = "phone";
  static String keyEmail = "email";
  static String keyCountryCode = "countryCode";
  static String keyReferralCode = "referral_code";
  static String keyUserStatus = "userStatus";
  static String keyToken = "keyToken";
  static String keyFCMToken = "keyFCMToken";
  static String keyIsGrid = "isGrid";
  static String keyLatitude = "keyLatitude";
  static String keyLongitude = "keyLongitude";
  static String keyAddress = "keyAddress";
  static String keyWalletBalance = "keyWalletBalance";
  static String keyGuestCartItems = "keyGuestCartItems";
  static String keyLoginType = "keyLoginType";

  static String keyPermissionGalleryHidePromptPermanently = "keyPermissionGalleryHidePromptPermanently";
  static String keyPermissionNotificationHidePromptPermanently = "keyPermissionNotificationHidePromptPermanently";
  static String keyPermissionLocationHidePromptPermanently = "keyPermissionLocationHidePromptPermanently";
  static String keyPermissionCameraHidePromptPermanently = "keyPermissionCameraHidePromptPermanently";
  static String keyPermissionMicrophoneHidePromptPermanently = "keyPermissionMicrophoneHidePromptPermanently";

  //search address
  static String keySuggestionsCache = "input";
  static String keyPlaceDetails = "place_id";

  late SharedPreferences prefs;

  SessionManager({required this.prefs});

  String getData(String id) {
    return prefs.getString(id) ?? "";
  }

  void setData(String id, String val, bool isRefresh) {
    prefs.setString(id, val);
    if (isRefresh) {
      notifyListeners();
    }
  }

  List<CartList> getGuestCartItems() {
    if (getData(keyGuestCartItems).isNotEmpty) {
      return CartList.JsonToCartItems(getData(keyGuestCartItems));
    } else {
      return [];
    }
  }

  void addItemIntoList(String id, String item) {
    if (!Constant.searchedItemsHistoryList.contains(item)) {
      Constant.searchedItemsHistoryList.add(item);
      prefs.setStringList(id, Constant.searchedItemsHistoryList);
    }
  }

  void clearItemList(String id) {
    Constant.searchedItemsHistoryList = [];
    prefs.setStringList(id, []);
  }

  Future setUserData({
    required BuildContext context,
    required String name,
    required String email,
    required String profile,
    required String countryCode,
    required String mobile,
    required String referralCode,
    required int status,
    required String token,
    required String balance,
    required String type,
  }) async {
    prefs.setString(keyToken, token);

    setData(keyUserName, name, true);
    setData(keyUserImage, profile, true);
    setData(keyEmail, email, true);
    prefs.setString(keyCountryCode, countryCode);
    prefs.setString(keyPhone, mobile);
    prefs.setString(keyReferralCode, referralCode);
    prefs.setInt(keyUserStatus, status);
    setBoolData(isUserLogin, true, true);
    prefs.setString(keyWalletBalance, balance.toString());
    prefs.setString(keyLoginType, type.toString());

    notifyListeners();
  }

  void setDoubleData(String key, double value) {
    prefs.setDouble(key, value);
    notifyListeners();
  }

  double getDoubleData(String key) {
    return prefs.getDouble(key) ?? 0.0;
  }

  bool getBoolData(String key) {
    return prefs.getBool(key) ?? false;
  }

  void setBoolData(String key, bool value, bool isRefresh) {
    prefs.setBool(key, value);
    if (isRefresh) notifyListeners();
  }

  int getIntData(String key) {
    return prefs.getInt(key) ?? 0;
  }

  void setIntData(String key, int value) {
    prefs.setInt(key, value);
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return getBoolData(isUserLogin);
  }

  void logoutUser(BuildContext buildContext) {
    AuthProviders _authProvider;
    if (getData(keyLoginType) == "phone") {
      _authProvider = AuthProviders.phone;
    } else if (getData(keyLoginType) == "google") {
      _authProvider = AuthProviders.google;
    } else {
      _authProvider = AuthProviders.apple;
    }

    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(buildContext).cardColor,
        surfaceTintColor: ColorsRes.appColorTransparent,
        title: CustomTextLabel(
          jsonKey: logoutTitleLabel,
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: logoutMessageLabel,
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: cancelLabel,
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              buildContext.read<CartProvider>().resetCartList();
              logoutApi(context: context, fcmToken: getData(keyFCMToken));
              String themeName = getData(appThemeName);
              String languageId = getData(keySelectedLanguageId);
              String latitude = getData(keyLatitude);
              String longitude = getData(keyLongitude);
              String address = getData(keyAddress);

              bool isDark = false;
              if (themeName == Constant.themeList[2]) {
                isDark = true;
              } else if (themeName == Constant.themeList[1]) {
                isDark = false;
              } else if (themeName == "" || themeName == Constant.themeList[0]) {
                var brightness = PlatformDispatcher.instance.platformBrightness;
                isDark = brightness == Brightness.dark;

                if (themeName == "") {
                  setData(appThemeName, Constant.themeList[0], false);
                }
              }
              signOut(
                authProvider: _authProvider,
                firebaseAuth: FirebaseAuth.instance,
                googleSignIn: GoogleSignIn(scopes: ["profile", "email"]),
              );
              prefs.clear();
              setBoolData(introSlider, true, false);
              setBoolData(isUserLogin, false, false);
              setData(appThemeName, themeName, false);
              setData(keySelectedLanguageId, languageId, false);
              setData(keyLatitude, latitude, false);
              setData(keyLongitude, longitude, false);
              setData(keyAddress, address, false);
              setBoolData(isDarkTheme, isDark, false);
              setBoolData(introSlider, true, false);
              context.read<CartListProvider>().cartList.clear();
              Navigator.of(buildContext).pushNamedAndRemoveUntil(loginAccountScreen, (Route<dynamic> route) => false);
            },
            child: CustomTextLabel(
              jsonKey: okLabel,
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }

  void deleteUserAccount(BuildContext buildContext) {
    AuthProviders authProvider;
    if (getData(keyLoginType) == "phone") {
      authProvider = AuthProviders.phone;
    } else if (getData(keyLoginType) == "google") {
      authProvider = AuthProviders.google;
    } else {
      authProvider = AuthProviders.apple;
    }
    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        surfaceTintColor: ColorsRes.appColorTransparent,
        backgroundColor: Theme.of(buildContext).cardColor,
        title: CustomTextLabel(
          jsonKey: deleteUserTitleLabel,
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: deleteUserMessageLabel,
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: cancelLabel,
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              buildContext.read<CartProvider>().resetCartList();
              await getDeleteAccountApi(context: context).then((response) async {
                if (response["status"].toString() == "1") {
                  String themeName = getData(appThemeName);
                  String languageId = getData(keySelectedLanguageId);
                  String latitude = getData(keyLatitude);
                  String longitude = getData(keyLongitude);
                  String address = getData(keyAddress);

                  bool isDark = false;
                  if (themeName == Constant.themeList[2]) {
                    isDark = true;
                  } else if (themeName == Constant.themeList[1]) {
                    isDark = false;
                  } else if (themeName == "" || themeName == Constant.themeList[0]) {
                    var brightness = PlatformDispatcher.instance.platformBrightness;
                    isDark = brightness == Brightness.dark;

                    if (themeName == "") {
                      setData(appThemeName, Constant.themeList[0], false);
                    }
                  }
                  signOut(
                    authProvider: authProvider,
                    firebaseAuth: FirebaseAuth.instance,
                    googleSignIn: GoogleSignIn(scopes: ["profile", "email"]),
                  );
                  prefs.clear();
                  setBoolData(introSlider, true, false);
                  setBoolData(isUserLogin, false, false);
                  setData(appThemeName, themeName, false);
                  setData(keyLatitude, latitude, false);
                  setData(keyLongitude, longitude, false);
                  setData(keyAddress, address, false);
                  setBoolData(isDarkTheme, isDark, false);
                  setBoolData(introSlider, true, false);
                  setData(keySelectedLanguageId, languageId, false);
                  context.read<CartListProvider>().cartList.clear();
                  Navigator.of(buildContext).pushNamedAndRemoveUntil(loginAccountScreen, (Route<dynamic> route) => false);
                  showMessage(
                    context,
                    response["message"],
                    MessageType.success,
                  );
                } else {
                  Navigator.pop(context);
                  showMessage(
                    context,
                    response["message"],
                    MessageType.error,
                  );
                }
              });
            },
            child: CustomTextLabel(
              jsonKey: okLabel,
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }

  // map catch data store already search
  Future<void> saveAutocompleteSuggestions() async {
    // Keep only the last 20 entries
    final entries = Constant.autocompleteSuggestionsCache.entries.toList();
    if (entries.length > 20) {
      entries.removeRange(0, entries.length - 20); // Remove oldest
    }

    // Convert to a Map<String, List> for storage
    final limitedCache = Map.fromEntries(entries);
    await prefs.setString(
      SessionManager.keySuggestionsCache,
      jsonEncode(limitedCache),
    );
  }

  Future<void> savePlaceDetails() async {
    final entries = Constant.placeSelectionMap.entries.toList();
    if (entries.length > 20) {
      entries.removeRange(0, entries.length - 20); // Remove oldest
    }

    // Convert to Map<String, PlaceSelection> for storage
    final limitedCache = Map.fromEntries(
      entries.map((e) => MapEntry(e.key, e.value.toJson())),
    );

    await prefs.setString(
      SessionManager.keyPlaceDetails,
      jsonEncode(limitedCache),
    );
  }

  Future<void> loadAutocompleteSuggestions() async {
    final cacheJson = prefs.getString(SessionManager.keySuggestionsCache);

    if (cacheJson != null && cacheJson.trim().isNotEmpty) {
      final Map<String, dynamic> decoded = jsonDecode(cacheJson);
      Constant.autocompleteSuggestionsCache = decoded.map(
        (key, value) => MapEntry(key, List<dynamic>.from(value)),
      );
    } else {
      Constant.autocompleteSuggestionsCache = {};
    }
  }

  Future<void> loadPlaceDetails() async {
    final cacheJson = prefs.getString(SessionManager.keyPlaceDetails);

    if (cacheJson != null && cacheJson.trim().isNotEmpty) {
      final Map<String, dynamic> decoded = jsonDecode(cacheJson);
      Constant.placeSelectionMap = decoded.map(
        (key, value) => MapEntry(
          key,
          PlaceDetailsModel.fromJson(value),
        ),
      );
    } else {
      Constant.placeSelectionMap = {};
    }
  }
}
