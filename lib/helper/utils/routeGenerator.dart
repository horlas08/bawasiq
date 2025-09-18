import 'package:flutter/cupertino.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/provider/placeDetailsProvider.dart';
import 'package:project/provider/placeSuggestionsProvider.dart';

import 'package:project/screens/mainHomeScreen/profileMenuScreen/screens/referEarnScreen.dart';


const String introSliderScreen = 'introSliderScreen';
const String splashScreen = 'splashScreen';
const String loginAccountScreen = 'loginAccountScreen';
const String forgotPasswordScreen = 'forgotPasswordScreen';
const String webViewScreen = 'webViewScreen';
const String otpScreen = 'otpScreen';
const String editProfileScreen = 'editProfileScreen';
const String confirmLocationScreen = 'confirmLocationScreen';
const String mainHomeScreen = 'mainHomeScreen';
const String brandListScreen = 'brandListScreen';
const String sellerListScreen = 'sellerListScreen';
const String categoryListScreen = 'categoryListScreen';
const String countryListScreen = 'countryListScreen';
const String cartScreen = 'cartScreen';
const String checkoutScreen = 'checkoutScreen';
const String promoCodeScreen = 'promoCodeScreen';
const String productListScreen = 'productListScreen';
const String productSearchScreen = 'productSearchScreen';
const String productListFilterScreen = 'productListFilterScreen';
const String productDetailScreen = 'productDetailScreen';
const String ratingAndReviewScreen = 'ratingAndReviewScreen';
const String fullScreenProductImageScreen = 'fullScreenProductImageScreen';
const String addressListScreen = 'addressListScreen';
const String addressDetailScreen = 'addressDetailScreen';
const String orderDetailScreen = 'orderDetailScreen';
const String orderTrackerScreen = 'orderTrackerScreen';
const String orderHistoryScreen = 'orderHistoryScreen';
const String notificationListScreen = 'notificationListScreen';
const String transactionListScreen = 'transactionListScreen';
const String walletHistoryListScreen = 'walletHistoryListScreen';
const String faqListScreen = 'faqListScreen';
const String orderPlaceScreen = 'orderPlaceScreen';
const String notificationsAndMailSettingsScreenScreen =
    'notificationsAndMailSettingsScreenScreen';
const String underMaintenanceScreen = 'underMaintenanceScreen';
const String appUpdateScreen = 'appUpdateScreen';
const String paypalPaymentScreen = 'paypalPaymentScreen';
const String midtransPaymentScreen = 'midtransPaymentScreen';
const String phonePePaymentScreen = 'phonePePaymentScreen';
const String cashfreePaymentScreen = 'cashfreePaymentScreen';
const String paytabsPaymentScreen = 'paytabsPaymentScreen';
const String walletRechargeScreen = 'walletRechargeScreen';
const String ratingImageViewScreen = 'ratingImageViewScreen';
const String barCodeScanner = 'barCodeScanner';
const String referAndEarn = 'referAndEarn';

String currentRoute = splashScreen;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "";

    if (currentRoute.contains("/product/")) {
      String deeplinkUrl = currentRoute;
      final itemSlug = deeplinkUrl.split("/").last;

      return CupertinoPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductDetailProvider>(
              create: (context) => ProductDetailProvider(),
            ),
            ChangeNotifierProvider<RatingListProvider>(
              create: (context) => RatingListProvider(),
            ),
          ],
          child: ProductDetailScreen(
            id: itemSlug.toString(),
            title: getTranslatedValue(navigatorKey.currentContext!, appNameLabel),
          ),
        ),
      );
    }

    switch (settings.name) {
      case introSliderScreen:
        return CupertinoPageRoute(
          builder: (_) => const IntroSliderScreen(),
        );

      case splashScreen:
        return CupertinoPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case loginAccountScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<PasswordShowHideProvider>(
            create: (context) => PasswordShowHideProvider(),
            child: LoginAccountScreen(from: settings.arguments as String?),
          ),
        );

      case forgotPasswordScreen:
      List<dynamic> forgotPasswordArguments = settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ForgotPasswordScreen(showMobileNumberWidget: forgotPasswordArguments[0], from: forgotPasswordArguments[1],),
        );

      case otpScreen:
        List<dynamic> firebaseArguments = settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => OtpVerificationScreen(
            firebaseAuth: firebaseArguments[0] as FirebaseAuth,
            otpVerificationId: firebaseArguments[1] as String,
            phoneNumber: firebaseArguments[2] as String,
            selectedCountryCode: firebaseArguments[3] as CountryCode,
            from: firebaseArguments[4] as String?,
          ),
        );

      case webViewScreen:
        return CupertinoPageRoute(
          builder: (_) => WebViewScreen(
            dataFor: settings.arguments as String,
          ),
        );

      case editProfileScreen:
        List<dynamic> editProfileArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => EditProfile(
            from: editProfileArguments[0] as String,
            loginParams: editProfileArguments[1] is Map<String, String>
                ? editProfileArguments[1]
                : null,
          ),
        );

      case confirmLocationScreen:
        List<dynamic> confirmLocationArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => PlaceSuggestionsProvider(),
              ),
              ChangeNotifierProvider(
                  create: (context) => PlaceDetailsProvider(),
                ),
            ],
            child: ConfirmLocation(
            address: confirmLocationArguments[0],
            from: confirmLocationArguments[1] as String,
          )),
        );

      case mainHomeScreen:
        return CupertinoPageRoute(
          builder: (_) => HomeMainScreen(/*key: Constant.navigatorKay*/),
        );

      case categoryListScreen:
        List<dynamic> categoryArguments = settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<CategoryListProvider>(
            create: (context) => CategoryListProvider(),
            child: CategoryListScreen(
              scrollController: categoryArguments[0] as ScrollController,
              categoryName: categoryArguments[1] as String,
              categoryId: categoryArguments[2] as String,
            ),
          ),
        );

      case countryListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<CountryProvider>(
            create: (context) => CountryProvider(),
            child: CountryListScreen(),
          ),
        );

      case brandListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<BrandListProvider>(
            create: (context) => BrandListProvider(),
            child: BrandListScreen(),
          ),
        );

      case sellerListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<SellerListProvider>(
            create: (context) => SellerListProvider(),
            child: SellerListScreen(),
          ),
        );

      case cartScreen:
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => PromoCodeProvider(),
              ),
            ],
            child: const CartListScreen(),
          ),
        );

      case checkoutScreen:
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider<CheckoutProvider>(
                create: (context) => CheckoutProvider(),
              ),
              ChangeNotifierProvider<PaymentMethodsProvider>(
                create: (context) => PaymentMethodsProvider(),
              )
            ],
            child: const CheckoutScreen(),
          ),
        );

      case promoCodeScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<PromoCodeProvider>(
            create: (context) => PromoCodeProvider(),
            child: PromoCodeListScreen(amount: settings.arguments as double),
          ),
        );

      case productListScreen:
        List<dynamic> productListArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductListProvider>(
            create: (context) => ProductListProvider(),
            child: ProductListScreen(
              from: productListArguments[0] as String,
              id: productListArguments[1] as String,
              title: setFirstLetterUppercase(
                productListArguments[2],
              ),
            ),
          ),
        );

      case productSearchScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductSearchProvider>(
            create: (context) => ProductSearchProvider(),
            child: const ProductSearchScreen(),
          ),
        );

      case productListFilterScreen:
        List<dynamic> productListFilterArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductFilterProvider>(
            create: (context) => ProductFilterProvider(),
            child: ProductListFilterScreen(
              brands: productListFilterArguments[0] as List<Brands>,
              totalMaxPrice: productListFilterArguments[1] as double,
              totalMinPrice: productListFilterArguments[2] as double,
              sizes: productListFilterArguments[3] as List<Sizes>,
              selectedCategoryId: productListFilterArguments[4] as List<String>,
            ),
          ),
        );

      case productDetailScreen:
        List<dynamic> productDetailArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider<ProductDetailProvider>(
                create: (context) => ProductDetailProvider(),
              ),
              ChangeNotifierProvider<RatingListProvider>(
                create: (context) => RatingListProvider(),
              ),
            ],
            child: ProductDetailScreen(
              id: productDetailArguments[0] as String,
              title: productDetailArguments[1] as String,
              productListItem: productDetailArguments[2],
              from: productDetailArguments.length == 4
                  ? productDetailArguments[3]
                  : null,
            ),
          ),
        );

      case ratingAndReviewScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<RatingListProvider>(
            create: (context) => RatingListProvider(),
            child: RatingAndReviewScreen(
              productId: settings.arguments as String,
            ),
          ),
        );

      case fullScreenProductImageScreen:
        List<dynamic> productFullScreenImagesScreen =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ProductFullScreenImagesScreen(
            initialPage: productFullScreenImagesScreen[0] as int,
            images: productFullScreenImagesScreen[1] as List<String>,
          ),
        );

      case addressListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<AddressProvider>(
            create: (context) => AddressProvider(),
            child: AddressListScreen(
              from: settings.arguments as String,
            ),
          ),
        );

      case addressDetailScreen:
        List<dynamic> addressDetailArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<AddressProvider>(
            create: (context) => AddressProvider(),
            child: AddressDetailScreen(
              address: addressDetailArguments[0],
              addressProviderContext: addressDetailArguments[1] as BuildContext,
            ),
          ),
        );

      case orderHistoryScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ActiveOrdersProvider>(
            create: (context) => ActiveOrdersProvider(),
            child: const OrdersHistoryScreen(),
          ),
        );

      case orderDetailScreen:
        List<dynamic> orderDetailScreenArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => OrderInvoiceProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => CurrentOrderProvider(),
              )
            ],
            child: OrderDetailScreen(
              orderId: orderDetailScreenArguments[0] as String,
              from: orderDetailScreenArguments[1] as String,
            ),
          ),
        );

      case orderTrackerScreen:
        List<dynamic> orderTrackerScreenArguments =
            settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => LiveOrderTrackingProvider(),
              ),
            ],
            child: OrderTrackerScreen(
              addressLatitude: orderTrackerScreenArguments[0] as double,
              addressLongitude: orderTrackerScreenArguments[1] as double,
              address: orderTrackerScreenArguments[2] as String,
              orderId: orderTrackerScreenArguments[3] as String,
              deliveryBoyName: orderTrackerScreenArguments[4] as String,
              deliveryBoyNumber: orderTrackerScreenArguments[5] as String,
            ),
          ),
        );

      case notificationListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<NotificationProvider>(
            create: (context) => NotificationProvider(),
            child: const NotificationListScreen(),
          ),
        );

      case transactionListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<TransactionProvider>(
            create: (context) => TransactionProvider(),
            child: const TransactionListScreen(),
          ),
        );

      case walletHistoryListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<WalletHistoryProvider>(
            create: (context) => WalletHistoryProvider(),
            child: const WalletHistoryListScreen(),
          ),
        );

      case faqListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<FaqProvider>(
            create: (context) => FaqProvider(),
            child: const FaqListScreen(),
          ),
        );

      case notificationsAndMailSettingsScreenScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<NotificationsSettingsProvider>(
            create: (context) => NotificationsSettingsProvider(),
            child: const NotificationsAndMailSettingsScreenScreen(),
          ),
        );

      case orderPlaceScreen:
        return CupertinoPageRoute(
          builder: (_) => const OrderPlacedScreen(),
        );

      case underMaintenanceScreen:
        return CupertinoPageRoute(
          builder: (_) => const UnderMaintenanceScreen(),
        );

      case appUpdateScreen:
        return CupertinoPageRoute(
          builder: (_) => AppUpdateScreen(
            canIgnoreUpdate: settings.arguments as bool,
          ),
        );

      case paypalPaymentScreen:
        return CupertinoPageRoute(
          builder: (_) => PayPalPaymentScreen(
            paymentUrl: settings.arguments as String,
          ),
        );

      case midtransPaymentScreen:
        return CupertinoPageRoute(
          builder: (_) => MidtransPaymentScreen(
            paymentUrl: settings.arguments as String,
          ),
        );

      case phonePePaymentScreen:
        return CupertinoPageRoute(
          builder: (_) => PhonePePaymentScreen(
            paymentUrl: settings.arguments as String,
          ),
        );

      case cashfreePaymentScreen:
        return CupertinoPageRoute(
          builder: (_) => CashfreePaymentScreen(
            paymentUrl: settings.arguments as String,
          ),
        );

      case paytabsPaymentScreen:
        return CupertinoPageRoute(
          builder: (_) => PaytabsPaymentScreen(
            paymentUrl: settings.arguments as String,
          ),
        );

      case walletRechargeScreen:
        return CupertinoPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider<WalletRechargeProvider>(
                create: (context) => WalletRechargeProvider(),
              ),
              ChangeNotifierProvider<PaymentMethodsProvider>(
                create: (context) => PaymentMethodsProvider(),
              )
            ],
            child: const WalletRechargeScreen(),
          ),
        );

      case ratingImageViewScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<RatingListProvider>(
            create: (context) => RatingListProvider(),
            child: RatingImageViewScreen(
              productId: settings.arguments as String,
            ),
          ),
        );

      case barCodeScanner:
        return CupertinoPageRoute(
          builder: (_) => BarCodeScanner(),
        );

      case referAndEarn:
        return CupertinoPageRoute(
          builder: (_) => ReferAndEarn(),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}