import 'package:project/helper/utils/generalImports.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late UserAddressData? selectedAddress;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        await context
            .read<CheckoutProvider>()
            .getTimeSlotsSettings(context: context);

        await context
            .read<CheckoutProvider>()
            .getSingleAddressProvider(context: context)
            .then(
          (selectedAddress) async {
            Map<String, String> params = {
              ApiAndParams.latitude: selectedAddress?.latitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLatitude),
              ApiAndParams.longitude: selectedAddress?.longitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLongitude),
              ApiAndParams.isCheckout: "1"
            };

            if (Constant.selectedPromoCodeId != "0") {
              params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
            }

            await context
                .read<CheckoutProvider>()
                .getOrderChargesProvider(
                  context: context,
                  params: params,
                )
                .then(
              (value) async {
                setState(() {});
                await context
                    .read<PaymentMethodsProvider>()
                    .getPaymentMethods(context: context, from: "checkout")
                    .then(
                  (value) {
                    setState(() {});
                    StripeService.init(
                      stripeId: context
                              .read<PaymentMethodsProvider>()
                              .paymentMethods
                              ?.data
                              .stripePublishableKey ??
                          "",
                      secretKey: context
                              .read<PaymentMethodsProvider>()
                              .paymentMethods
                              ?.data
                              .stripeSecretKey ??
                          "",
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          if (!context.read<CheckoutProvider>().isPaymentUnderProcessing) {
            Navigator.pop(context);
          } else {
            showMessage(
                context,
                getTranslatedValue(context,
                    noBackUntilPaymentDoneLabel),
                MessageType.warning);
          }
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: checkoutLabel,
            softWrap: true,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
          ),
          onTap: () async {
            if (context.read<CheckoutProvider>().isPaymentUnderProcessing) {
              showMessage(
                  context,
                  getTranslatedValue(context,
                      noBackUntilPaymentDoneLabel),
                  MessageType.warning);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (checkoutProvider.deliveryChargeData?.userBalance
                                  .toString() !=
                              "0" &&
                          checkoutProvider.deliveryChargeData?.userBalance
                                  .toString() !=
                              null)
                        Container(
                          decoration: DesignConfig.boxDecoration(
                              Theme.of(context).cardColor, 10),
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsetsDirectional.only(
                            start: 10,
                            end: 10,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              defaultImg(
                                image: AppAssets.walletIcon,
                                iconColor: ColorsRes.appColor,
                              ),
                              getSizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextLabel(
                                      jsonKey: walletBalanceLabel,
                                    ),
                                    CustomTextLabel(
                                      jsonKey:
                                          "${context.read<CheckoutProvider>().availableWalletAmount}"
                                              .currency,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: ColorsRes.appColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              getSizedBox(width: 10),
                              CustomCheckbox(
                                value: checkoutProvider.usedWallet ?? false,
                                onChanged: (value) {
                                  checkoutProvider.userWalletAmount(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      if (checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressLoading &&
                          checkoutProvider.checkoutTimeSlotsState ==
                              CheckoutTimeSlotsState.timeSlotsLoading &&
                          context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loading)
                        CheckoutShimmer(),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        AddressWidget(),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: 10, end: 10),
                          child: Column(
                            children: [
                              GetTimeSlots(),
                              OrderNoteWidget(
                                edtOrderNote: context
                                    .read<CheckoutProvider>()
                                    .edtOrderNote,
                              ),
                            ],
                          ),
                        ),
                      if (checkoutProvider.totalAmount != 0.0 &&
                          (context
                                      .read<PaymentMethodsProvider>()
                                      .paymentMethodsState ==
                                  PaymentMethodsState.loaded &&
                              (checkoutProvider.checkoutTimeSlotsState ==
                                      CheckoutTimeSlotsState.timeSlotsLoaded ||
                                  checkoutProvider.checkoutTimeSlotsState ==
                                      CheckoutTimeSlotsState.timeSlotsError) &&
                              (checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressLoaded ||
                                  checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressBlank ||
                                  checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressError)))
                        PaymentMethodsWidget(
                          isPaymentUnderProcessing:
                              checkoutProvider.isPaymentUnderProcessing,
                        ),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError) &&
                          checkoutProvider.checkoutDeliveryChargeState ==
                              CheckoutDeliveryChargeState
                                  .deliveryChargeLoaded &&
                          checkoutProvider.selectedAddress?.id != null)
                        DeliveryChargesWidget(),
                      if (checkoutProvider.checkoutDeliveryChargeState ==
                          CheckoutDeliveryChargeState.deliveryChargeLoading)
                        DeliveryChargeShimmer(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsetsDirectional.only(
                    start: 15,
                    end: 15,
                    bottom: 10,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextLabel(
                            jsonKey: totalLabel,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                          getSizedBox(width: 10),
                          CustomTextLabel(
                            text: context
                                .read<CheckoutProvider>()
                                .totalAmount
                                .toString()
                                .currency,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsRes.appColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      PlaceOrderButtonWidget(
                        context: context,
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ));
  }
}
