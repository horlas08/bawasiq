import 'package:project/helper/utils/generalImports.dart';


class PlaceOrderButtonWidget extends StatefulWidget {
  final BuildContext context;

  const PlaceOrderButtonWidget({Key? key, required this.context})
      : super(key: key);

  @override
  State<PlaceOrderButtonWidget> createState() => PlaceOrderButtonWidgetState();
}

class PlaceOrderButtonWidgetState extends State<PlaceOrderButtonWidget> {
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late String paystackKey = "";
  late double amount = 0.00;
  late PaystackPlugin paystackPlugin;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      paystackPlugin = PaystackPlugin();

      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
    });
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) {
    context.read<CheckoutProvider>().transactionId =
        response.paymentId.toString();
    context.read<CheckoutProvider>().addTransaction(context: context);
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    context.read<CheckoutProvider>().deleteAwaitingOrder(context);
    context.read<CheckoutProvider>().setPaymentProcessState(false);
    showMessage(context, response.message.toString(), MessageType.warning);
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    context.read<CheckoutProvider>().setPaymentProcessState(false);
    showMessage(context, response.toString(), MessageType.warning);
  }

  void openRazorPayGateway() async {
    final options = {
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<CheckoutProvider>().razorpayOrderId,
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      },
    };

    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    await paystackPlugin.initialize(
        publicKey: context
                .read<PaymentMethodsProvider>()
                .paymentMethodsData
                ?.paystackPublicKey ??
            "0");

    Charge charge = Charge()
      ..amount = (context.read<CheckoutProvider>().totalAmount * 100).toInt()
      ..currency = context
              .read<PaymentMethodsProvider>()
              .paymentMethodsData
              ?.paystackCurrencyCode ??
          ""
      ..reference = context.read<CheckoutProvider>().payStackReference
      ..email = Constant.session.getData(SessionManager.keyEmail);

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      fullscreen: false,
      logo: defaultImg(
        height: 50,
        width: 50,
        image: AppAssets.logoIcon,
        requiredRTL: false,
      ),
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status) {
      context.read<CheckoutProvider>().addTransaction(context: context);
    } else {
      context.read<CheckoutProvider>().deleteAwaitingOrder(context);
      context.read<CheckoutProvider>().setPaymentProcessState(false);
    }
  }

  openPaytmPaymentGateway() async {
    try {
      var response = PaytmPaymentsAllinonesdk().startTransaction(
        context
                .read<PaymentMethodsProvider>()
                .paymentMethodsData
                ?.paytmMerchantId ??
            "",
        context.read<CheckoutProvider>().placedOrderId,
        context.read<CheckoutProvider>().totalAmount.toString(),
        context.read<CheckoutProvider>().paytmTxnToken.toString(),
        "",
        context.read<PaymentMethodsProvider>().paymentMethodsData?.paytmMode ==
            "sandbox",
        false,
      );
      response.then((value) {
        print(value);
        setState(() {});
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {});
        } else {
          setState(() {});
        }
      });
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, child) {
        bool isAddressDeliverable =
            checkoutProvider.selectedAddress?.cityId.toString() == "0";
        bool isAddressEmpty = checkoutProvider.selectedAddress == null || checkoutProvider.selectedAddress == "";
        return gradientBtnWidget(
          context,
          5,
          callback: () async {
            if (context.read<PaymentMethodsProvider>().selectedPaymentMethod ==
                "") {
              showMessage(
                  context,
                  getTranslatedValue(context, paymentMethodUnavailableLabel),
                  MessageType.warning);
            } else if (isAddressDeliverable) {
              showMessage(
                  context,
                  getTranslatedValue(
                      context, addressNotDeliverableSelectedLabel),
                  MessageType.warning);
            } else if (isAddressEmpty) {
              showMessage(
                  context,
                  getTranslatedValue(context, addAddressFirstLabel),
                  MessageType.warning);
            } else if (checkoutProvider.checkoutTimeSlotsState ==
                CheckoutTimeSlotsState.timeSlotsError) {
              showMessage(
                  context,
                  getTranslatedValue(
                      context, pleaseAddTimeslotInAdminPanelLabel),
                  MessageType.warning);
            } else if (checkoutProvider.getTotalVisibleTimeSlots().toString() ==
                    "0" &&
                checkoutProvider.timeSlotsData?.timeSlotsIsEnabled.toString() ==
                    "true") {
              showMessage(
                  context,
                  getTranslatedValue(context, timeSlotsExpiredIssueLabel),
                  MessageType.warning);
            } else if (!checkoutProvider.isPaymentUnderProcessing) {
              checkoutProvider.setPaymentProcessState(true).then((value) {
                if (context
                            .read<PaymentMethodsProvider>()
                            .selectedPaymentMethod ==
                        "COD" ||
                    context
                            .read<PaymentMethodsProvider>()
                            .selectedPaymentMethod ==
                        "Wallet") {
                  checkoutProvider.placeOrder(context: context);
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Razorpay") {
                  razorpayKey = context
                          .read<PaymentMethodsProvider>()
                          .paymentMethodsData
                          ?.razorpayKey ??
                      "0";
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      context
                          .read<CheckoutProvider>()
                          .initiateRazorpayTransaction(context: context)
                          .then((value) /* =>  */{if(value["status"].toString()=="1"){print("value:${value}");openRazorPayGateway();}else{
                            context.read<CheckoutProvider>().setPaymentProcessState(false);
                          showMessage(context, value["message"], MessageType.warning);
                          }});
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Midtrans") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context.read<CheckoutProvider>().placeOrder(context: context);
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Phonepe") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context.read<CheckoutProvider>().placeOrder(context: context);
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Paystack") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      return openPaystackPaymentGateway();
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Stripe") {
                  amount = context.read<CheckoutProvider>().totalAmount;

                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value) {
                      StripeService.payWithPaymentSheet(
                        amount: int.parse((amount * 100).toStringAsFixed(0)),
                        isTestEnvironment: true,
                        awaitedOrderId: checkoutProvider.placedOrderId,
                        context: context,
                        currency: context
                                .read<PaymentMethodsProvider>()
                                .paymentMethods
                                ?.data
                                .stripeCurrencyCode ??
                            "inr",
                        from: "order",
                      ).then((value) {
                        if (!value.success!) {
                          context
                              .read<CheckoutProvider>()
                              .deleteAwaitingOrder(context);

                          context
                              .read<CheckoutProvider>()
                              .setPaymentProcessState(false);
                          showMessage(
                              context,
                              getTranslatedValue(
                                  context, paymentCancelledByUserLabel),
                              MessageType.warning);
                        }
                      });
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Paytm") {
                  amount = context.read<CheckoutProvider>().totalAmount;

                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                      showMessage(
                          context,
                          getTranslatedValue(context, somethingWentWrongLabel),
                          MessageType.warning);
                    } else {
                      openPaytmPaymentGateway();
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Paypal") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Cashfree") {
                  /* if (context
                          .read<PaymentMethodsProvider>()
                          .paymentMethodsData
                          ?.cashfreeMode ==
                      "sandbox") {
                    showMessage(
                        context,
                        getTranslatedValue(context, cashfreeSandboxWarningLabel),
                        MessageType.warning);
                  } */
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                    }
                  });
                } else if (context
                        .read<PaymentMethodsProvider>()
                        .selectedPaymentMethod ==
                    "Paytabs") {
                  amount = context.read<CheckoutProvider>().totalAmount;
                  context
                      .read<CheckoutProvider>()
                      .placeOrder(context: context)
                      .then((value) {
                    if (value is bool) {
                      context
                          .read<CheckoutProvider>()
                          .setPaymentProcessState(false);
                    }
                  });
                }
              });
            }
          },
          otherWidgets: (checkoutProvider.checkoutDeliveryChargeState ==
                  CheckoutDeliveryChargeState.deliveryChargeLoading)
              ? CustomShimmer(
                  height: 40,
                  borderRadius: 10,
                )
              : (context.read<CheckoutProvider>().isPaymentUnderProcessing)
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.all(4),
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: ColorsRes.appColorWhite,
                      ),
                    )
                  : context.read<CheckoutProvider>().isPaymentUnderProcessing
                      ? Container(
                          alignment: Alignment.center,
                          padding: EdgeInsetsDirectional.all(4),
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            color: ColorsRes.appColorWhite,
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.only(start: 25, end: 25),
                            child: CustomTextLabel(
                              jsonKey: isAddressDeliverable
                                  ? addressNotDeliverableLabel
                                  : isAddressEmpty
                                      ? addAddressFirstLabel
                                      : placeOrderLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .merge(
                                    TextStyle(
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                      color: (isAddressDeliverable &&
                                              isAddressEmpty)
                                          ? ColorsRes.mainTextColor
                                          : ColorsRes.appColorWhite,
                                      fontSize: 16,
                                    ),
                                  ),
                            ),
                          ),
                        ),
          color1: (!isAddressDeliverable && !isAddressEmpty)
              ? ColorsRes.gradient1
              : ColorsRes.grey,
          color2: (!isAddressDeliverable && !isAddressEmpty)
              ? ColorsRes.gradient2
              : ColorsRes.grey,
        );
      },
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    paystackPlugin.dispose();
    super.dispose();
  }
}
