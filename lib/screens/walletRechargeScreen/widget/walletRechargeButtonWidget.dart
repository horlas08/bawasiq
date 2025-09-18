import 'package:project/helper/utils/generalImports.dart';


class WalletRechargeButtonWidget extends StatefulWidget {
  final BuildContext context;
  final TextEditingController rechargeAmount;

  const WalletRechargeButtonWidget(
      {Key? key, required this.context, required this.rechargeAmount})
      : super(key: key);

  @override
  State<WalletRechargeButtonWidget> createState() =>
      WalletRechargeButtonWidgetState();
}

class WalletRechargeButtonWidgetState
    extends State<WalletRechargeButtonWidget> {
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
    context.read<WalletRechargeProvider>().transactionId =
        response.paymentId.toString();
    context.read<WalletRechargeProvider>().addWalletTransaction(
        context: context,
        walletRechargeAmount: widget.rechargeAmount.text.toString());
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    context.read<WalletRechargeProvider>().setWalletPaymentProcessState(false);
    showMessage(context, response.message.toString(), MessageType.warning);
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    context.read<WalletRechargeProvider>().setWalletPaymentProcessState(false);
    showMessage(context, response.toString(), MessageType.warning);
  }

  void openRazorPayGateway() async {
    final options = {
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<WalletRechargeProvider>().razorpayOrderId,
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      },
    };

    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    try {
      await paystackPlugin.initialize(
          publicKey: context
                  .read<PaymentMethodsProvider>()
                  .paymentMethodsData
                  ?.paystackPublicKey ??
              "0");

      Charge charge = Charge()
        ..amount =
            (widget.rechargeAmount.text.toString().toDouble * 100).toInt()
        ..currency = context
                .read<PaymentMethodsProvider>()
                .paymentMethodsData
                ?.paystackCurrencyCode ??
            ""
        ..reference = DateTime.now().millisecondsSinceEpoch.toString()
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
        context.read<WalletRechargeProvider>().transactionId =
            response.reference.toString();
        context.read<WalletRechargeProvider>().addWalletTransaction(
            context: context,
            walletRechargeAmount: widget.rechargeAmount.text.toString());
      } else {
        context
            .read<WalletRechargeProvider>()
            .setWalletPaymentProcessState(false);
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  openPaytmPaymentGateway(String rechargeAmount) async {
    try {
      var response = PaytmPaymentsAllinonesdk().startTransaction(
        context
                .read<PaymentMethodsProvider>()
                .paymentMethodsData
                ?.paytmMerchantId ??
            "",
        context.read<WalletRechargeProvider>().placedOrderId,
        rechargeAmount,
        context.read<WalletRechargeProvider>().paytmTxnToken.toString(),
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
    return Consumer<PaymentMethodsProvider>(
      builder: (context, paymentMethodsProvider, child) {
        return Consumer<WalletRechargeProvider>(
          builder: (context, walletRechargeProvider, child) {
            return gradientBtnWidget(
              context,
              5,
              callback: () async {
                if (widget.rechargeAmount.text.isNotEmpty &&
                    amountValidation(widget.rechargeAmount.text) == null &&
                    !walletRechargeProvider.isPaymentUnderProcessing) {
                  walletRechargeProvider
                      .setWalletPaymentProcessState(true)
                      .then(
                    (value) {
                      amount = widget.rechargeAmount.text.toString().toDouble;
                      if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Razorpay") {
                        razorpayKey = paymentMethodsProvider
                                .paymentMethodsData?.razorpayKey ??
                            "0";
                        // amount = widget.rechargeAmount.text.toString().toDouble;

                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletRazorpayTransaction(
                                context: context,
                                rechargeAmount:
                                    widget.rechargeAmount.text.toString())
                            .then((value)/*  => */ {
                          if (value["status"].toString() == "1") {
                            print("value:${value}");
                            openRazorPayGateway();
                          } else {
                            context.read<WalletRechargeProvider>().setWalletPaymentProcessState(false);
                            showMessage(context, value["message"], MessageType.warning);
                          }
                        });
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Paystack") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        return openPaystackPaymentGateway();
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Stripe") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;

                        try {
                          StripeService.init(
                            stripeId: paymentMethodsProvider.paymentMethods
                                    ?.data.stripePublishableKey ??
                                "",
                            secretKey: paymentMethodsProvider
                                    .paymentMethods?.data.stripeSecretKey ??
                                "",
                          ).then(
                            (value) {
                              StripeService.payWithPaymentSheet(
                                amount: int.parse(
                                    (amount * 100).toStringAsFixed(0)),
                                isTestEnvironment: true,
                                awaitedOrderId: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                context: context,
                                currency: paymentMethodsProvider.paymentMethods
                                        ?.data.stripeCurrencyCode ??
                                    "0",
                                from: "wallet",
                              ).then(
                                (value) {
                                  return context
                                      .read<WalletRechargeProvider>()
                                      .setWalletPaymentProcessState(false);
                                },
                              );
                            },
                          );
                        } catch (e) {
                          showMessage(context, e.toString(), MessageType.error);
                        }
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Paytm") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        openPaytmPaymentGateway(
                            widget.rechargeAmount.text.toString());
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Paypal") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletPaypalTransaction(
                                context: context,
                                rechargeAmount:
                                    widget.rechargeAmount.text.toString())
                            .then(
                          (value) {
                            context
                                .read<WalletRechargeProvider>()
                                .setWalletPaymentProcessState(false);
                          },
                        );
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Midtrans") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletMidtransTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString(),
                            );
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Phonepe") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletPhonePeTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString(),
                            );
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Cashfree") {
                        /* if (context
                                .read<PaymentMethodsProvider>()
                                .paymentMethodsData
                                ?.cashfreeMode ==
                            "sandbox") {
                          showMessage(
                              context,
                              getTranslatedValue(
                                  context, cashfreeSandboxWarningLabel),
                              MessageType.warning);
                        } */
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletCashfreeTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString(),
                            )
                            .then(
                          (value) {
                            context
                                .read<WalletRechargeProvider>()
                                .setWalletPaymentProcessState(false);
                          },
                        );
                      } else if (paymentMethodsProvider.selectedPaymentMethod ==
                          "Paytabs") {
                        // amount = widget.rechargeAmount.text.toString().toDouble;
                        context
                            .read<WalletRechargeProvider>()
                            .initiateWalletPaytabsTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString(),
                            )
                            .then(
                          (value) {
                            context
                                .read<WalletRechargeProvider>()
                                .setWalletPaymentProcessState(false);
                          },
                        );
                      }
                    },
                  );
                } else {
                  showMessage(
                      context,
                      getTranslatedValue(context, enterValidAmountLabel)
                          .toString(),
                      MessageType.warning);
                }
              },
              otherWidgets: (context
                      .read<WalletRechargeProvider>()
                      .isPaymentUnderProcessing)
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.all(4),
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: ColorsRes.appColorWhite,
                      ),
                    )
                  : context
                          .read<WalletRechargeProvider>()
                          .isPaymentUnderProcessing
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
                          child: CustomTextLabel(
                            jsonKey: rechargeLabel,
                            style:
                                Theme.of(context).textTheme.titleMedium!.merge(
                                      TextStyle(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsRes.appColorWhite,
                                        fontSize: 16,
                                      ),
                                    ),
                          ),
                        ),
            );
          },
        );
      },
    );
  }
}
