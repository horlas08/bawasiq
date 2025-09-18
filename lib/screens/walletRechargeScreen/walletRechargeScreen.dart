import 'package:project/helper/utils/generalImports.dart';


class WalletRechargeScreen extends StatefulWidget {
  const WalletRechargeScreen({super.key});

  @override
  State<WalletRechargeScreen> createState() => _WalletRechargeScreenState();
}

class _WalletRechargeScreenState extends State<WalletRechargeScreen> {
  TextEditingController rechargeAmount = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context
          .read<PaymentMethodsProvider>()
          .getPaymentMethods(context: context, from: "wallet_recharge");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: walletRechargeLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Consumer<PaymentMethodsProvider>(
          builder: (context, paymentMethodsProvider, _) {
        return Consumer<WalletRechargeProvider>(
            builder: (context, walletRechargeProvider, _) {
          if (paymentMethodsProvider.paymentMethodsState ==
              PaymentMethodsState.loading) {
            return ListView(
              shrinkWrap: true,
              children: [
                CustomShimmer(
                  width: context.width,
                  height: 60,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                getSizedBox(height: 10),
                CustomShimmer(
                  width: context.width * 0.4,
                  height: 30,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
                getSizedBox(height: 10),
                CustomShimmer(
                  width: context.width,
                  height: 50,
                  margin:
                      EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
                ),
              ],
            );
          } else if (paymentMethodsProvider.paymentMethodsState ==
              PaymentMethodsState.loaded) {
            if (paymentMethodsProvider.selectedPaymentMethod.isNotEmpty) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 10, end: 10, top: 20),
                    child: editBoxWidget(
                      context,
                      rechargeAmount,
                      amountValidation,
                      getTranslatedValue(context, rechargeAmountLabel),
                      getTranslatedValue(context, enterValidAmountLabel),
                      TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*')),
                      ],
                    ),
                  ),
                  PaymentMethodsWidget(
                    isPaymentUnderProcessing: context
                        .watch<WalletRechargeProvider>()
                        .isPaymentUnderProcessing,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.all(10),
                    child: WalletRechargeButtonWidget(
                      context: context,
                      rechargeAmount: rechargeAmount,
                    ),
                  )
                ],
              );
            } else {
              return DefaultBlankItemMessageScreen(
                height: context.height,
                title: emptyPaymentMethodsMessageLabel,
                description: emptyPaymentMethodsDescriptionLabel,
                image: "no_payment_options_available",
                buttonTitle: goBackLabel,
                callback: () {
                  Navigator.pop(context);
                },
              );
            }
          } else {
            return SizedBox.shrink();
          }
        });
      }),
    );
  }
}
