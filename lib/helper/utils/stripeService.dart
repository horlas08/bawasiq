import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:project/helper/utils/generalImports.dart';


class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String? secret = '';
  static String? from = '';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static getHeaders() {
    return {
      'Authorization': 'Bearer ${secret}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
  }

  static Future init({String? stripeId, String? secretKey}) async {
    Stripe.publishableKey = stripeId ?? '';
    secret = secretKey ?? '';
  }

  static Future<StripeTransactionResponse> payWithPaymentSheet(
      {required int amount,
      required String currency,
      String? from,
      required bool isTestEnvironment,
      required BuildContext context,
      required String awaitedOrderId}) async {
    try {
      //create Payment intent
      var paymentIntent = await (StripeService.createPaymentIntent(
          amount: amount,
          currency: currency,
          from: from,
          context: context,
          awaitedOrderID: awaitedOrderId));
      //setting up Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          intentConfiguration: IntentConfiguration(
            mode: IntentMode.paymentMode(
              currencyCode: Constant.currencyCode,
              amount: amount,
            ),
          ),
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style:
              Constant.session.getBoolData(SessionManager.isDarkTheme) == true
                  ? ThemeMode.dark
                  : ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              componentBackground: Theme.of(context).cardColor,
              icon: ColorsRes.appColor,
              secondaryText: ColorsRes.mainTextColor,
              primaryText: ColorsRes.mainTextColor,
              background: Theme.of(context).scaffoldBackgroundColor,
              primary: ColorsRes.appColor,
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: ColorsRes.appColor,
                ),
              ),
            ),
            shapes: PaymentSheetShape(
              borderRadius: 10,
            ),
          ),
          merchantDisplayName: getTranslatedValue(context, appNameLabel),
        ),
      );

      //open payment sheet
      await Stripe.instance.presentPaymentSheet();

      http.Response response = await http.post(
          Uri.parse(
            '${StripeService.paymentApiUrl}/${paymentIntent['id']}',
          ),
          headers: headers);

      var getData = Map.from(json.decode(response.body));

      var statusOfTransaction = getData['status'];

      if (statusOfTransaction == 'succeeded' ||
          statusOfTransaction == 'pending' ||
          statusOfTransaction == 'captured') {
        if (from == "wallet") {
          context.read<WalletRechargeProvider>().transactionId = getData['id'];
          context.read<WalletRechargeProvider>().addWalletTransaction(
              context: context,
              walletRechargeAmount: "${amount.toDouble() / 100}");
        } else {
          context.read<CheckoutProvider>().transactionId = getData['id'];
          context.read<CheckoutProvider>().addTransaction(context: context);
        }
        return StripeTransactionResponse(
            message: 'Transaction successful',
            success: true,
            status: statusOfTransaction);
      } else {
        showMessage(
            context,
            getTranslatedValue(context, paymentCancelledByUserLabel),
            MessageType.warning);
        return StripeTransactionResponse(
            message: 'Transaction failed',
            success: false,
            status: statusOfTransaction);
      }
    } catch (error) {
      showMessage(
          context,
          getTranslatedValue(context, paymentCancelledByUserLabel),
          MessageType.warning);

      return StripeTransactionResponse(
          message: 'Transaction failed: ${error.toString()}',
          success: false,
          status: 'fail');
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return StripeTransactionResponse(
        message: message, success: false, status: 'cancelled');
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      {required int amount,
      String? currency,
      String? from,
      BuildContext? context,
      String? awaitedOrderID}) async {
    try {
      Map<String, dynamic> parameter = {
        'amount': amount.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
        //      'description': from,
      };

      if (from == 'order') parameter['metadata[order_id]'] = awaitedOrderID;

      /*final Dio dio = Dio();*/
      // final FormData formData =
      //     FormData.fromMap(parameter, ListFormat.multiCompatible);
      if (kDebugMode) {
        print(
            "API is ${StripeService.paymentApiUrl} \n para $parameter \n secret key $secret\n public key ${Stripe.publishableKey}");
      }
      /*final response = await dio.post(StripeService.paymentApiUrl,
          data: parameter,
          options: Options(headers: StripeService.getHeaders()));*/

      http.Response response = await http.post(
          Uri.parse(
            StripeService.paymentApiUrl,
          ),
          body: parameter,
          headers: StripeService.getHeaders());
      return Map.from(json.decode(response.body));
    } catch (err) {}
    return null;
  }
}

class StripeTransactionResponse {
  final String? message, status;
  bool? success;

  StripeTransactionResponse({this.message, this.success, this.status});
}
