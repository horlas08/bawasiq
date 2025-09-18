import 'package:project/helper/utils/generalImports.dart';

enum SettingsState { initial, loading, loaded, error }

class AppSettingsProvider extends ChangeNotifier {
  SettingsState settingsState = SettingsState.initial;
  String message = "";
  SettingsData? settingsData;
  Settings? settings;

  Future getAppSettingsProvider(BuildContext context) async {
    settingsState = SettingsState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> response =
      await getAppSettings(context: context);


      List<int> decodedBytes = base64.decode(response[ApiAndParams.data].toString());

      
      String decodedString = utf8.decode(decodedBytes);
      Map<String, dynamic> map = json.decode(decodedString);
      response[ApiAndParams.data] = map;

      settings = Settings.fromJson(response);
      settingsData = settings?.data;

      if (response[ApiAndParams.status].toString() == "1") {
        settingsData =
        SettingsData.fromJson(response[ApiAndParams.data]);

        Constant.favorite = settingsData!.favoriteProductIds?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [];


        Constant.maxAllowItemsInCart = settingsData!.maxCartItemsCount ?? "";
        Constant.minimumOrderAmount = settingsData!.minOrderAmount ?? "";
        Constant.minimumReferEarnOrderAmount =
            settingsData!.minReferEarnOrderAmount ?? "";
        Constant.referEarnBonus = settingsData!.referEarnBonus ?? "";
        Constant.maximumReferEarnAmount = settingsData!.maxReferEarnAmount ?? "";
        Constant.minimumWithdrawalAmount =
            settingsData!.minimumWithdrawalAmount ?? "";
        Constant.maximumProductReturnDays = settingsData!.maxProductReturnDays ?? "";
        Constant.userWalletRefillLimit = settingsData!.userWalletRefillLimit ?? "";
        Constant.isReferEarnOn = settingsData!.isReferEarnOn ?? "";
        Constant.referEarnMethod = settingsData!.referEarnMethod ?? "";
        Constant.privacyPolicy = settingsData!.privacyPolicy ?? "";
        Constant.termsConditions = settingsData!.termsConditions ?? "";
        Constant.aboutUs = settingsData!.aboutUs ?? "";
        Constant.contactUs = settingsData!.contactUs ?? "";
        Constant.returnAndExchangesPolicy =
            settingsData!.returnsAndExchangesPolicy ?? "";
        Constant.cancellationPolicy = settingsData!.cancellationPolicy ?? "";
        Constant.shippingPolicy = settingsData!.shippingPolicy ?? "";
        // Constant.googleApiKey = settingsData!.apiKey ?? "";
        Constant.currencyCode = settingsData!.currencyCode.toString().isEmpty ? "USD" : settingsData!.currencyCode.toString();
        Constant.decimalPoints = settingsData!.decimalPoint.toString().isEmpty ? "0" : settingsData!.decimalPoint.toString();
        Constant.currency = settingsData!.currency.toString().isEmpty ? "\$" : settingsData!.currency.toString();
        Constant.appMaintenanceMode = settingsData!.appModeCustomer ?? "0";
        Constant.appMaintenanceModeRemark =
            settingsData!.appModeCustomerRemark ?? "";

        Constant.popupBannerEnabled = settingsData!.popupEnabled == "1";
        Constant.showAlwaysPopupBannerAtHomeScreen =
            settingsData!.popupAlwaysShowHome == "1";
        Constant.popupBannerType = settingsData!.popupType ?? "";
        Constant.popupBannerTypeId = settingsData!.popupTypeId ?? "";
        Constant.popupBannerUrl = settingsData!.popupUrl ?? "";
        Constant.popupBannerImageUrl = settingsData!.popupImage ?? "";
        Constant.playStoreUrl = settingsData!.androidAppUrl ?? "";
        Constant.appStoreUrl = settingsData!.iosAppUrl ?? "";
        Constant.estimateDeliveryDays =
            settingsData!.estimateDeliveryDays?.toInt ?? 0;

        Constant.authTypeAppleLogin = settingsData!.appleLogin ?? "0";
        Constant.authTypeGoogleLogin = settingsData!.googleLogin ?? "0";
        Constant.authTypePhoneLogin = settingsData!.phoneLogin ?? "0";
        Constant.authTypeEmailLogin = settingsData!.emailLogin ?? "0";
        Constant.customSmsGatewayOtpBased =
            settingsData!.customSmsGatewayOtpBased ?? "0";
        /* context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication =
            settingsData!.firebaseAuthentication ?? "0"; */

        if (settingsData!.isVersionSystemOn == "1" &&
            settingsData!.currentVersion.toString().isNotEmpty) {
          Constant.isVersionSystemOn = settingsData!.isVersionSystemOn ?? "";
          Constant.currentRequiredAppVersion = settingsData!.currentVersion ?? "";
          Constant.requiredForceUpdate = settingsData!.requiredForceUpdate ?? "";
          Constant.oneSellerCart = settingsData!.oneSellerCart ?? "0";
          // Constant.guestCartOptionIsOn = settingsData!.guestCart ?? "0";
        }

        if (settingsData!.iosIsVersionSystemOn == "1" &&
            settingsData!.iosCurrentVersion.toString().isNotEmpty) {
          Constant.isIosVersionSystemOn = settingsData!.iosCurrentVersion ?? "";
          Constant.currentRequiredIosAppVersion =
              settingsData!.iosCurrentVersion ?? "";
          Constant.requiredIosForceUpdate =
              settingsData!.iosRequiredForceUpdate ?? "";
        }
        if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
            Constant.session.getData(SessionManager.keyLongitude) == "") ||
            (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                Constant.session.getData(SessionManager.keyLongitude) == "0")) {
          String tempLat = settingsData!.defaultCity?.latitude.toString() ?? "0";
          String tempLong = settingsData!.defaultCity?.longitude.toString() ?? "0";
          String tempAddress =
              settingsData!.defaultCity?.formattedAddress.toString() ?? "";

          if (tempAddress == "" ||
              tempLong == "0" ||
              tempLat == "0" ||
              Constant.session.getData(SessionManager.keyLongitude) == "" ||
              Constant.session.getData(SessionManager.keyLatitude) == "" ||
              Constant.session.getData(SessionManager.keyLongitude) == "0" ||
              Constant.session.getData(SessionManager.keyLatitude) == "0" ||
              Constant.session.getData(SessionManager.keyAddress) == "") {
            Constant.session
                .setData(SessionManager.keyLongitude, tempLong, false);
            Constant.session
                .setData(SessionManager.keyLatitude, tempLat, false);
            Constant.session
                .setData(SessionManager.keyAddress, tempAddress, false);
          }

        }

        settingsState = SettingsState.loaded;
        notifyListeners();
      } else {
        message = Constant.somethingWentWrong;
        settingsState = SettingsState.error;
        notifyListeners();
      }
    } catch (e) {
      settingsState = SettingsState.error;
      notifyListeners();
      rethrow;
    }
  }

  changeState() {
    settingsState = SettingsState.error;
    notifyListeners();
  }
}
