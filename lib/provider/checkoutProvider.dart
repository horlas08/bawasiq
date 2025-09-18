import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/additionalCharges.dart';


enum CheckoutTimeSlotsState {
  timeSlotsLoading,
  timeSlotsLoaded,
  timeSlotsError,
}

enum CheckoutAddressState {
  addressLoading,
  addressLoaded,
  addressBlank,
  addressError,
}

enum CheckoutDeliveryChargeState {
  deliveryChargeLoading,
  deliveryChargeLoaded,
  deliveryChargeError,
}

enum CheckoutPlaceOrderState {
  placeOrderLoading,
  placeOrderLoaded,
  placeOrderError,
}

class CheckoutProvider extends ChangeNotifier {
  CheckoutAddressState checkoutAddressState =
      CheckoutAddressState.addressLoading;

  CheckoutDeliveryChargeState checkoutDeliveryChargeState =
      CheckoutDeliveryChargeState.deliveryChargeLoading;

  CheckoutTimeSlotsState checkoutTimeSlotsState =
      CheckoutTimeSlotsState.timeSlotsLoading;

  CheckoutPlaceOrderState checkoutPlaceOrderState =
      CheckoutPlaceOrderState.placeOrderLoading;

  String message = '';
  bool isPaymentUnderProcessing = false;

  //UserAddress variables
  UserAddressData? selectedAddress = UserAddressData();

  // Order Delivery charge variables
  bool? usedWallet;
  double walletUsedAmount = 0.0;
  double availableWalletAmount = 0.0;
  double subTotalAmount = 0.0;
  double totalAmount = 0.0;
  double savedAmount = 0.0;
  double deliveryCharge = 0.0;
  List<SellersInfo>? sellerWiseDeliveryCharges;
  DeliveryChargeData? deliveryChargeData;
  List<AdditionalCharges>? additionalCharges;

  //Timeslots variables
  TimeSlotsData? timeSlotsData;
  bool isTimeSlotsEnabled = true;
  int selectedDateId = 0;
  String? selectedDate = null;
  int selectedTime = 0;
  int initiallySelectedIndex = -1;
  int totalVisibleTimeSlots = 0;

  //Place order variables
  String placedOrderId = "";
  String razorpayOrderId = "";
  String transactionId = "";
  String payStackReference = "";

  String paytmTxnToken = "";

  TextEditingController edtOrderNote = TextEditingController();

  Future addOrResetTimeSlots(bool isReset) async {
    if (isReset) {
      totalVisibleTimeSlots = 0;
    } else {
      totalVisibleTimeSlots = totalVisibleTimeSlots + 1;
    }
  }

  int getTotalVisibleTimeSlots() {
    return totalVisibleTimeSlots;
  }

  Future setPaymentProcessState(bool value) async {
    isPaymentUnderProcessing = value;
    notifyListeners();
  }

  Future userWalletAmount(bool used) async {
    usedWallet = used;
    if (used) {
      if (availableWalletAmount >= totalAmount) {
        walletUsedAmount = totalAmount;
        availableWalletAmount = availableWalletAmount - totalAmount;
        totalAmount = 0.0;
      } else {
        walletUsedAmount = availableWalletAmount;
        totalAmount = totalAmount - walletUsedAmount;
        availableWalletAmount = 0.0;
      }
    } else {
      availableWalletAmount = walletUsedAmount + availableWalletAmount;
      totalAmount = totalAmount + walletUsedAmount;
      walletUsedAmount = 0.0;
    }
    notifyListeners();
  }

  Future<UserAddressData?> getSingleAddressProvider(
      {required BuildContext context}) async {
    try {
      Map<String, dynamic> getAddress = (await getAddressApi(
          context: context, params: {ApiAndParams.isDefault: "1"}));
      if (getAddress[ApiAndParams.status].toString() == "1") {
        UserAddress addressData = UserAddress.fromJson(getAddress);
        selectedAddress = addressData.data?[0];

        if (selectedAddress?.cityId?.toString() == "0") {
          isPaymentUnderProcessing = false;
        }
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        notifyListeners();
        return selectedAddress;
      } else {
        checkoutAddressState = CheckoutAddressState.addressBlank;
        isPaymentUnderProcessing = false;
        notifyListeners();
        return selectedAddress;
      }
    } catch (e) {
      message = e.toString();
      checkoutAddressState = CheckoutAddressState.addressError;
      isPaymentUnderProcessing = false;
      notifyListeners();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      return selectedAddress;
    }
  }

  setSelectedAddress(BuildContext context, var address) async {
    selectedAddress = address;

    checkoutAddressState = CheckoutAddressState.addressLoaded;
    notifyListeners();

    Map<String, String> params = {
      ApiAndParams.cityId: selectedAddress!.cityId.toString(),
      ApiAndParams.latitude: selectedAddress!.latitude.toString(),
      ApiAndParams.longitude: selectedAddress!.longitude.toString(),
      ApiAndParams.isCheckout: "1"
    };
    if (Constant.isPromoCodeApplied) {
      params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
    }

    if (selectedAddress!.cityId.toString() != "0") {
      await getOrderChargesProvider(
        context: context,
        params: params,
      );
    } else {
      isPaymentUnderProcessing = false;
      message = e.toString();
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeError;
      checkoutAddressState = CheckoutAddressState.addressLoaded;
      notifyListeners();

      showMessage(
          context,
          getTranslatedValue(context, addressNotDeliverableSelectedLabel),
          MessageType.warning);
    }
  }

  Future getOrderChargesProvider(
      {required BuildContext context,
      required Map<String, String> params}) async {
    try {
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeLoading;
      notifyListeners();
      Map<String, dynamic> getCheckoutData =
          (await getCartListApi(context: context, params: params));

      if (getCheckoutData[ApiAndParams.status].toString() == "1") {
        Checkout checkoutData = Checkout.fromJson(getCheckoutData);
        deliveryChargeData = checkoutData.data!;
        context.read<PaymentMethodsProvider>().isCodAllowed =
            deliveryChargeData?.codAllowed.toString() ?? "===";
        subTotalAmount = double.parse(deliveryChargeData?.subTotal ?? "0");
        totalAmount = double.parse(deliveryChargeData?.totalAmount ?? "0");
        deliveryCharge = double.parse(
            deliveryChargeData?.deliveryCharge?.totalDeliveryCharge ?? "0");
        sellerWiseDeliveryCharges =
            deliveryChargeData?.deliveryCharge!.sellersInfo!;
        additionalCharges = deliveryChargeData?.additionalCharges??[];

        usedWallet = false;
        walletUsedAmount = 0.0;
        availableWalletAmount =
            double.parse(deliveryChargeData!.userBalance.toString());

        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeLoaded;
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        notifyListeners();
      } else {
        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeError;
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        isPaymentUnderProcessing = false;
        notifyListeners();
        showMessage(
          context,
          getTranslatedValue(context, getCheckoutData["message"]),
          MessageType.warning,
        );
      }
    } catch (e) {
      isPaymentUnderProcessing = false;
      message = e.toString();
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeError;
      checkoutAddressState = CheckoutAddressState.addressLoaded;
      notifyListeners();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
    }
  }

  Future getTimeSlotsSettings({required BuildContext context}) async {
    try {
      Map<String, dynamic> getTimeSlotsSettings =
          (await getTimeSlotSettingsApi(context: context, params: {}));
      if (getTimeSlotsSettings[ApiAndParams.status].toString() == "1") {
        TimeSlotsSettings timeSlots =
            TimeSlotsSettings.fromJson(getTimeSlotsSettings);
        timeSlotsData = timeSlots.data;
        isTimeSlotsEnabled = timeSlots.data.timeSlotsIsEnabled == "true";

        selectedDateId = 0;
        selectedTime = 0;

        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsLoaded;
        notifyListeners();
      } else {
        showMessage(
          context,
          getTimeSlotsSettings[ApiAndParams.message].toString(),
          MessageType.warning,
        );
        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
        notifyListeners();
      }
    } catch (e) {
      showMessage(
        context,
        getTranslatedValue(context, pleaseAddTimeslotInAdminPanelLabel),
        MessageType.warning,
      );
      checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
      notifyListeners();
    }
  }

  setSelectedDate(int index) {
    selectedTime = 0;
    selectedDateId = index;
    if (int.parse(timeSlotsData?.estimateDeliveryDays.toString() ?? "0") > 1) {
      selectedTime = 0;
    }
    notifyListeners();
  }

  setSelectedTime(int index) {
    initiallySelectedIndex = index;
    selectedTime = index;
    notifyListeners();
  }

  setSelectedTimeWithoutNotify(int index) {
    initiallySelectedIndex = index;
    selectedTime = index;
  }

  Future placeOrder({required BuildContext context}) async {
    if (timeSlotsData!.timeSlots.isNotEmpty) {
      try {
        isPaymentUnderProcessing = true;

        if (totalAmount == 0.0) {
          context.read<PaymentMethodsProvider>().selectedPaymentMethod =
              "Wallet";
        }

        final orderStatus = (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "COD" ||
                context.read<PaymentMethodsProvider>().selectedPaymentMethod ==
                    "Wallet")
            ? "2"
            : "1";

        Constant.session.setData(SessionManager.keyWalletBalance,
            availableWalletAmount.toString(), true);

        Map<String, String> params = {};
        params[ApiAndParams.productVariantId] =
            deliveryChargeData?.productVariantId.toString() ?? "0";
        params[ApiAndParams.quantity] =
            deliveryChargeData?.quantity.toString() ?? "0";
        params[ApiAndParams.total] =
            (deliveryChargeData?.subTotal.toString() ?? "0")
                .toDouble
                .toPrecision(2)
                .toString();
        params[ApiAndParams.deliveryCharge] =
            (deliveryChargeData?.deliveryCharge?.totalDeliveryCharge ?? "0")
                .toDouble
                .toPrecision(2)
                .toString();
        params[ApiAndParams.finalTotal] =
            totalAmount.toString().toDouble.toPrecision(2).toString();
        params[ApiAndParams.paymentMethod] = context
            .read<PaymentMethodsProvider>()
            .selectedPaymentMethod
            .toString();
        if (usedWallet == true) {
          params[ApiAndParams.walletUsed] = "1";
          params[ApiAndParams.walletBalance] =
              walletUsedAmount.toString().toDouble.toPrecision(2).toString();
        }
        params[ApiAndParams.addressId] = selectedAddress!.id.toString();
        if (edtOrderNote.text.isNotEmpty) {
          params[ApiAndParams.orderNote] = edtOrderNote.text;
        }
        if (isTimeSlotsEnabled) {
          params[ApiAndParams.deliveryTime] =
              "$selectedDate ${timeSlotsData?.timeSlots[selectedTime].title}";
        } else {
          params[ApiAndParams.deliveryTime] = "N/A";
        }
        params[ApiAndParams.status] = orderStatus;
        if (Constant.isPromoCodeApplied) {
          params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
        }

        Map<String, dynamic> getPlaceOrderResponse =
            await getPlaceOrderApi(context: context, params: params);

        if (getPlaceOrderResponse[ApiAndParams.status].toString() == "1") {
          if (context.read<PaymentMethodsProvider>().selectedPaymentMethod !=
              "COD") {
            PlacedPrePaidOrder placedPrePaidOrder =
                PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
            placedOrderId = placedPrePaidOrder.data.orderId.toString();
          }

          if (context.read<PaymentMethodsProvider>().selectedPaymentMethod ==
                  "Razorpay" ||
              context.read<PaymentMethodsProvider>().selectedPaymentMethod ==
                  "Stripe") {
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Paystack") {
            payStackReference =
                "Charged_From_${setFirstLetterUppercase(Platform.operatingSystem)}_${DateTime.now().millisecondsSinceEpoch}";
            transactionId = payStackReference;
          } else if (context
                      .read<PaymentMethodsProvider>()
                      .selectedPaymentMethod ==
                  "COD" ||
              context.read<PaymentMethodsProvider>().selectedPaymentMethod ==
                  "Wallet") {
            showOrderPlacedScreen(context);
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Paytm") {
            initiatePaytmTransaction(context: context).then((value) {
              return value;
            });
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Paypal") {
            initiatePaypalTransaction(context: context).then((value) {
              return value;
            });
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Midtrans") {
            initiateMidtransTransaction(context: context).then((value) {
              return value;
            });
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Phonepe") {
            initiatePhonePeTransaction(context: context).then((value) {
              return value;
            });
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Cashfree") {
            initiateCashfreeTransaction(context: context).then((value) {
              return value;
            });
          } else if (context
                  .read<PaymentMethodsProvider>()
                  .selectedPaymentMethod ==
              "Paytabs") {
            initiatePaytabsTransaction(context: context).then((value) {
              return value;
            });
          }

          checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
          notifyListeners();
          return true;
        } else {
          showMessage(
            context,
            getPlaceOrderResponse[ApiAndParams.message],
            MessageType.warning,
          );
          checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
          isPaymentUnderProcessing = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        message = e.toString();
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        isPaymentUnderProcessing = false;
        notifyListeners();
        return false;
      }
    } else {
      showMessage(
        context,
        getTranslatedValue(context, pleaseAddTimeslotInAdminPanelLabel),
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      isPaymentUnderProcessing = false;
    }
    notifyListeners();

    return false;
  }

  Future initiatePaytmTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.amount] = totalAmount.toString();
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getPaytmTransactionTokenResponse =
          (await getPaytmTransactionTokenApi(context: context, params: params));

      if (getPaytmTransactionTokenResponse[ApiAndParams.status].toString() ==
          "1") {
        PaytmTransactionToken paytmTransactionToken =
            PaytmTransactionToken.fromJson(getPaytmTransactionTokenResponse);
        paytmTxnToken = paytmTransactionToken.data?.txnToken ?? "";
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
        return false;
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
      return false;
    }
  }

  Future initiateRazorpayTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.orderId] = placedOrderId;

      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          (await getInitiatedTransactionApi(context: context, params: params));

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        InitiateTransaction initiateTransaction =
            InitiateTransaction.fromJson(getInitiatedTransactionResponse);
        razorpayOrderId = initiateTransaction.data.transactionId;
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        showMessage(
          context,
          getInitiatedTransactionResponse["message"],
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
      return getInitiatedTransactionResponse;
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  showOrderPlacedScreen(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamed(context, orderPlaceScreen);
  }

  Future initiatePhonePeTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context.read<PaymentMethodsProvider>().selectedPaymentMethod.toString();
      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse = await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() == "1") {
        Map<String, dynamic> data = getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("redirectUrl") && data["redirectUrl"].toString() != "") {
          Navigator.pushNamed(context, phonePePaymentScreen, arguments: data["redirectUrl"]).then((status_code) {
            if (status_code is String) {
              print("status_code:--${status_code}");
              if (status_code == "SUCCESS" || status_code == "PENDING") {
                if (status_code == "PENDING") {
                  showMessage(context, getTranslatedValue(context, orderPhonePePendingLabel), MessageType.warning);
                  showOrderPlacedScreen(context);
                } else if (status_code == "SUCCESS") {
                  // showOrderPlacedScreen(context);
                  orderStatusPhonePe(context: context, transactionId: data['merchantOrderId'], token: data['token']);
                }
              } else if (status_code == "PAYMENT_ERROR") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, orderPhonePeErrorLabel),
                  MessageType.warning,
                );
                return false;
              } else if (status_code == "FAILED") {
                orderStatusPhonePe(context: context, transactionId: data['merchantOrderId'], token: data['token']);
                /* deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, orderPhonePeErrorLabel),
                  MessageType.warning,
                ); */
                return false;
              } else if (status_code == "PAYMENT_DECLINED") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, orderPhonePeDeclinedLabel),
                  MessageType.warning,
                );
                return false;
              } else if (status_code == "PAYMENT_CANCELLED") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, orderPhonePeCancelledLabel),
                  MessageType.warning,
                );
                return false;
              }
            }
          });
        }
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future orderStatusPhonePe({required BuildContext context, required String transactionId, required String token}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.transactionId] = transactionId.toString();
      params[ApiAndParams.token] = token;

      Map<String, dynamic> getOrderStatusPhonePeResponse = await getOrderStatusPhonepeApi(context: context, params: params);

      if (getOrderStatusPhonePeResponse[ApiAndParams.status].toString() == "1") {
        if (getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "SUCCESS" || getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "COMPLETED") {
          showOrderPlacedScreen(context);
          checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
          notifyListeners();
        }else if(getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "FAILED"){
          setPaymentProcessState(false);
          showMessage(
            context,
            getTranslatedValue(context, orderPhonePeErrorLabel),
            MessageType.warning,
          );
        } else if (getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "PAYMENT_ERROR") {
          showOrderPlacedScreen(context);
          showMessage(
            context,
            getTranslatedValue(context, orderPhonePeErrorLabel),
            MessageType.warning,
          );
        }else if (getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "PAYMENT_DECLINED") {
          showOrderPlacedScreen(context);
          showMessage(
            context,
            getTranslatedValue(context, orderPhonePeDeclinedLabel),
            MessageType.warning,
          );
        } else if (getOrderStatusPhonePeResponse[ApiAndParams.data][ApiAndParams.status] == "PAYMENT_CANCELLED") {
          showOrderPlacedScreen(context);
          showMessage(
            context,
            getTranslatedValue(context, orderPhonePeCancelledLabel),
            MessageType.warning,
          );
        }
      }else{
        // deleteAwaitingOrder(context);
        setPaymentProcessState(false);
        showMessage(
          context,
          getOrderStatusPhonePeResponse[ApiAndParams.message].toString(),
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      // deleteAwaitingOrder(context);
      showOrderPlacedScreen(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }


  Future initiatePaypalTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];
        Navigator.pushNamed(context, paypalPaymentScreen,
                arguments: data["paypal_redirect_url"])
            .then((value) {
          if (value == "success" || value == "pending") {
            if (value == "pending") {
              showMessage(
                  context,
                  getTranslatedValue(context, orderPaypalPendingLabel),
                  MessageType.warning);
            }
            showOrderPlacedScreen(context);
          } else if (value == "fail") {
            deleteAwaitingOrder(context);
            showMessage(
              context,
              getTranslatedValue(context, paymentCancelledByUserLabel),
              MessageType.warning,
            );
            return false;
          }
        });
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        deleteAwaitingOrder(context);
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future initiateMidtransTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("snapUrl") && data["snapUrl"].toString() != "") {
          Navigator.pushNamed(context, midtransPaymentScreen,
                  arguments: data["snapUrl"])
              .then((status_code) {
            if (status_code is String) {
              if (status_code == "200" || status_code == "201") {
                if (status_code == "201") {
                  showMessage(
                      context,
                      getTranslatedValue(
                          context, orderMidtransPendingLabel),
                      MessageType.warning);
                  showOrderPlacedScreen(context);
                } else if (status_code == "200") {
                  showOrderPlacedScreen(context);
                }
              } else if (status_code == "202") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, paymentCancelledByUserLabel),
                  MessageType.warning,
                );
                return false;
              }
            }
          });
        }
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future initiateCashfreeTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("redirectUrl") &&
            data["redirectUrl"].toString() != "") {
          Navigator.pushNamed(context, cashfreePaymentScreen,
                  arguments: data["redirectUrl"])
              .then((status_code) {
            if (status_code is String) {
              if (status_code == "success" || status_code == "pending") {
                if (status_code == "pending") {
                  showMessage(
                      context,
                      getTranslatedValue(
                          context, orderCashfreePendingLabel),
                      MessageType.warning);
                  showOrderPlacedScreen(context);
                } else if (status_code == "success") {
                  showOrderPlacedScreen(context);
                }
              } else if (status_code == "failed") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, orderCashfreeErrorLabel),
                  MessageType.warning,
                );
                return false;
              } else if (status_code == "user_dropped") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(
                      context, orderCashfreeCancelledLabel),
                  MessageType.warning,
                );
                return false;
              }
            }
          });
        }
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future initiatePaytabsTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("redirectUrl") &&
            data["redirectUrl"].toString() != "") {
          Navigator.pushNamed(context, paytabsPaymentScreen,
                  arguments: data["redirectUrl"])
              .then((status) {
            if (status is String) {
              if (status == "success" || status == "pending") {
                if (status == "pending") {
                  showMessage(
                      context,
                      getTranslatedValue(
                          context, orderMidtransPendingLabel),
                      MessageType.warning);
                  showOrderPlacedScreen(context);
                } else if (status == "success") {
                  showOrderPlacedScreen(context);
                }
              } else if (status == "cancelled") {
                deleteAwaitingOrder(context);
                showMessage(
                  context,
                  getTranslatedValue(context, paymentCancelledByUserLabel),
                  MessageType.warning,
                );
                return false;
              }
            }
          });
        }
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      }
    } catch (e) {
      deleteAwaitingOrder(context);
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future addTransaction({required BuildContext context}) async {
    try {
      PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.deviceType] =
          setFirstLetterUppercase(Platform.operatingSystem);
      params[ApiAndParams.appVersion] = packageInfo.version;
      params[ApiAndParams.transactionId] = transactionId;
      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.type] = ApiAndParams.orderType;

      Map<String, dynamic> addedTransaction =
          (await getAddTransactionApi(context: context, params: params));
      if (addedTransaction[ApiAndParams.status].toString() == "1") {
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
        showOrderPlacedScreen(context);
      } else {
        showMessage(
          context,
          addedTransaction[ApiAndParams.message],
          MessageType.warning,
        );
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future deleteAwaitingOrder(BuildContext context) async {
    try {
      await deleteAwaitingOrderApi(
          params: {ApiAndParams.orderId: placedOrderId}, context: context);
      setPaymentProcessState(false);
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }
}
