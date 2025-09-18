import 'package:project/helper/utils/generalImports.dart';

class OrderBillingDetailsWidget extends StatelessWidget {
  final Order order;

  const OrderBillingDetailsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextLabel(
          jsonKey: billingDetailsLabel,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        getSizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          width: context.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: paymentMethodLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(text: order.paymentMethod),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                order.transactionId!.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          Row(
                            children: [
                              CustomTextLabel(
                                jsonKey: transactionIdLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              const Spacer(),
                              CustomTextLabel(
                                text: order.transactionId,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constant.size10,
                          ),
                        ],
                      ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: subtotalLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.total?.currency,
                      style: TextStyle(fontWeight: FontWeight.w500, color: ColorsRes.mainTextColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                order.additionalCharges!.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          order.additionalCharges!.length,
                          (index) => Padding(
                            padding: EdgeInsetsDirectional.only(bottom: Constant.size10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextLabel(
                                  jsonKey: order.additionalCharges![index].title,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                                CustomTextLabel(
                                  text: order.additionalCharges![index].amount.toString().currency,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: deliveryChargeLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.deliveryCharge?.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ],
                ),
                if (double.parse(order.promoDiscount ?? "0.0") > 0.0)
                  SizedBox(
                    height: Constant.size10,
                  ),
                if (double.parse(order.promoDiscount ?? "0.0") > 0.0)
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextLabel(
                          textAlign: TextAlign.start,
                          text: "${getTranslatedValue(context, discountLabel)}(${order.promoCode})",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: CustomTextLabel(
                          textAlign: TextAlign.end,
                          text: "-${order.promoDiscount?.currency}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (double.parse(order.walletBalance ?? "0.0") > 0.0)
                  SizedBox(
                    height: Constant.size10,
                  ),
                if (double.parse(order.walletBalance ?? "0.0") > 0.0)
                  Row(
                    children: [
                      CustomTextLabel(
                        text: "${getTranslatedValue(context, walletLabel)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const Spacer(),
                      CustomTextLabel(
                        text: "-${order.walletBalance?.currency}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: Constant.size10,
                ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: totalLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.finalTotal?.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
