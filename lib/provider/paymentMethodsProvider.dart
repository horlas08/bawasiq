import 'package:project/helper/utils/generalImports.dart';

enum PaymentMethodsState {
  loading,
  loaded,
  empty,
  error,
}

class PaymentMethodsProvider extends ChangeNotifier {
  PaymentMethodsState paymentMethodsState = PaymentMethodsState.loading;

  //Payment methods variables
  PaymentMethods? paymentMethods;
  PaymentMethodsData? paymentMethodsData;
  String selectedPaymentMethod = "";
  String isCodAllowed = "0";
  String message = "";

  Future getPaymentMethods({
    required BuildContext context,
    required String from,
  }) async {
    try {
      Map<String, dynamic> getPaymentMethodsSettings =
          (await getPaymentMethodsSettingsApi(context: context, params: {}));

      if (getPaymentMethodsSettings[ApiAndParams.status].toString() == "1") {
        List<int> decodedBytes = base64
            .decode(getPaymentMethodsSettings[ApiAndParams.data].toString());
        String decodedString = utf8.decode(decodedBytes);
        Map<String, dynamic> map = json.decode(decodedString);
        getPaymentMethodsSettings[ApiAndParams.data] = map;

        paymentMethods = PaymentMethods.fromJson(getPaymentMethodsSettings);
        paymentMethodsData = paymentMethods?.data;

        if (paymentMethodsData?.codPaymentMethod.toString() == "1" &&
            isCodAllowed == "1") {
          setSelectedPaymentMethod("COD");
        } else if (paymentMethodsData?.paytabsPaymentMethod.toString() ==
            "1") {
          setSelectedPaymentMethod("Paytabs");
        } else if (paymentMethodsData?.midtransPaymentMethod.toString() ==
            "1") {
          setSelectedPaymentMethod("Midtrans");
        } else if (paymentMethodsData?.cashfreePaymentMethod.toString() ==
            "1") {
          setSelectedPaymentMethod("Cashfree");
        } else if (paymentMethodsData?.phonePePaymentMethod.toString() == "1") {
          setSelectedPaymentMethod("Phonepe");
        } else if (paymentMethodsData?.razorpayPaymentMethod.toString() ==
            "1") {
          setSelectedPaymentMethod("Razorpay");
        } else if (paymentMethodsData?.paystackPaymentMethod.toString() ==
            "1") {
          setSelectedPaymentMethod("Paystack");
        } else if (paymentMethodsData?.stripePaymentMethod.toString() == "1") {
          setSelectedPaymentMethod("Stripe");
        } else if (paymentMethodsData?.paytmPaymentMethod.toString() == "1") {
          setSelectedPaymentMethod("Paytm");
        } else if (paymentMethodsData?.paypalPaymentMethod.toString() == "1") {
          setSelectedPaymentMethod("Paypal");
        }

        paymentMethodsState = PaymentMethodsState.loaded;
        notifyListeners();
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        paymentMethodsState = PaymentMethodsState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      paymentMethodsState = PaymentMethodsState.error;
      notifyListeners();
    }
  }

  Future setSelectedPaymentMethod(String method) async {
    selectedPaymentMethod = method;
    notifyListeners();
  }
}
