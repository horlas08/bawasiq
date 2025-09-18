import 'package:project/helper/utils/generalImports.dart';


class OrderProductsWidget extends StatelessWidget {
  final Order order;
  final VoidCallback voidCallback;
  final String from;

  const OrderProductsWidget(
      {super.key,
      required this.order,
      required this.voidCallback,
      required this.from});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextLabel(
          jsonKey: productsLabel,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        getSizedBox(
          height: 10,
        ),
        Consumer<CurrentOrderProvider>(
          builder: (context, currentOrderProvider, child) {
            return Column(
                children: List.generate(
              order.items?.length ?? 0,
              (index) {
                OrderItem? orderItem = order.items?[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsetsDirectional.all(10),
                  margin: EdgeInsetsDirectional.only(
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: setNetworkImg(
                          boxFit: BoxFit.cover,
                          image: orderItem?.imageUrl ?? "",
                          width: 90,
                          height: 90,
                        ),
                      ),
                      getSizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextLabel(
                              text: orderItem?.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextLabel(
                              text: "x ${orderItem?.quantity}",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextLabel(
                              text:
                                  "${orderItem?.measurement} ${orderItem?.unit}",
                              style: TextStyle(
                                  color: ColorsRes.subTitleMainTextColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextLabel(
                              text: orderItem?.price.toString().currency,
                              style: TextStyle(
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (from == "previousOrders")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Builder(
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          if (orderItem?.cancelableStatus ==
                                                  "1" &&
                                              orderItem?.activeStatus != "7")
                                            CancelProductButton(
                                              context: context,
                                              order: order,
                                              orderItem: orderItem!,
                                              voidCallback: voidCallback,
                                            ),
                                          if (orderItem?.returnStatus == "1" &&
                                              orderItem?.activeStatus !=
                                                  "8" &&
                                              orderItem?.activeStatus !=
                                                  "7" &&
                                              orderItem?.returnRequested !=
                                                  "1" &&
                                              orderItem?.returnRequested != "3")
                                            ReturnProductButton(
                                              orderItemId:
                                                  orderItem!.id.toString(),
                                              context: context,
                                              order: order,
                                              voidCallback: voidCallback,
                                            ),
                                          if (orderItem?.activeStatus == "7")
                                            CustomTextLabel(
                                              jsonKey:
                                                  orderStatusCancelledLabel,
                                              style: TextStyle(
                                                color: ColorsRes.appColorRed,
                                              ),
                                            ),
                                          (orderItem?.activeStatus != "7" &&
                                                  orderItem?.returnStatus ==
                                                      "1" &&
                                                  orderItem
                                                          ?.returnRequested ==
                                                      "1")
                                              ? CustomTextLabel(
                                                  jsonKey: returnRequestedLabel,
                                                  style: TextStyle(
                                                      color: ColorsRes
                                                          .appColorRed),
                                                )
                                              : (orderItem?.returnStatus ==
                                                          "1" &&
                                                      orderItem
                                                              ?.returnRequested ==
                                                          "3")
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomTextLabel(
                                                          jsonKey:
                                                              returnRejectedLabel,
                                                          style: TextStyle(
                                                            color: ColorsRes
                                                                .appColorRed,
                                                          ),
                                                        ),
                                                        CustomTextLabel(
                                                          text:
                                                              "${getTranslatedValue(context, returnReasonLabel)}: ${orderItem?.returnReason}",
                                                          style: TextStyle(
                                                              color: ColorsRes
                                                                  .subTitleMainTextColor),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                        ],
                                      );
                                    },
                                  ),
                                  (orderItem!.itemRating!.isNotEmpty)
                                      ? (orderItem.itemRating?.first.rate
                                                  .toString() !=
                                              "0")
                                          ? GestureDetector(
                                              onTap: () {
                                                openRatingDialog(
                                                  order: order,
                                                  index: index,
                                                  context: context,
                                                ).then((value) {
                                                  voidCallback.call();
                                                });
                                              },
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.star_rate_rounded,
                                                    color: ColorsRes.appColorAmber,
                                                  ),
                                                  getSizedBox(width: 5),
                                                  CustomTextLabel(
                                                    text: orderItem
                                                            .itemRating!
                                                            .isNotEmpty
                                                        ? orderItem.itemRating
                                                            ?.first.rate
                                                        : "0",
                                                    style: TextStyle(
                                                      color: ColorsRes
                                                          .subTitleMainTextColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : (orderItem.activeStatus != "7" && orderItem.activeStatus != "8")?gradientBtnWidget(
                                              context,
                                              5,
                                              callback: () {
                                                openRatingDialog(
                                                  order: order,
                                                  index: index,
                                                  context: context,
                                                ).then((value) {
                                                  voidCallback.call();
                                                });
                                              },
                                              otherWidgets: CustomTextLabel(
                                                jsonKey: writeAReviewLabel,
                                                style: TextStyle(
                                                  color:
                                                      ColorsRes.appColorWhite,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              height: 30,
                                              width: context.width * 0.30,
                                            ):const SizedBox.shrink()
                                      : (orderItem.activeStatus != "7" && orderItem.activeStatus != "8")?gradientBtnWidget(
                                          context,
                                          5,
                                          callback: () {
                                            openRatingDialog(
                                                    order: order,
                                                    index: index,
                                                    context: context)
                                                .then((value) {
                                              voidCallback.call();
                                            });
                                          },
                                          otherWidgets: CustomTextLabel(
                                            jsonKey:writeAReviewLabel,
                                            style: TextStyle(
                                              color: ColorsRes.appColorWhite,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          height: 30,
                                          width: context.width * 0.30,
                                        ):const SizedBox.shrink(),
                                ],
                              ),
                            if (from != "previousOrders")
                              Builder(
                                builder: (context) {
                                  return Column(
                                    children: [
                                      if (orderItem?.cancelableStatus ==
                                              "1" &&
                                          orderItem?.activeStatus != "7")
                                        CancelProductButton(
                                          context: context,
                                          order: order,
                                          orderItem: orderItem!,
                                          voidCallback: voidCallback,
                                        ),
                                      if (orderItem?.returnStatus == "1" &&
                                          orderItem?.activeStatus !=
                                              "8" &&
                                          orderItem?.activeStatus !=
                                              "7" &&
                                          orderItem?.returnRequested !=
                                              "1" &&
                                          orderItem?.returnRequested != "3")
                                        ReturnProductButton(
                                          orderItemId:
                                              orderItem!.id.toString(),
                                          context: context,
                                          order: order,
                                          voidCallback: voidCallback,
                                        ),
                                      if (orderItem?.activeStatus == "7")
                                        CustomTextLabel(
                                          jsonKey:
                                              orderStatusCancelledLabel,
                                          style: TextStyle(
                                            color: ColorsRes.appColorRed,
                                          ),
                                        ),
                                      (orderItem?.activeStatus != "7" &&
                                              orderItem?.returnStatus ==
                                                  "1" &&
                                              orderItem
                                                      ?.returnRequested ==
                                                  "1")
                                          ? CustomTextLabel(
                                              jsonKey: returnRequestedLabel,
                                              style: TextStyle(
                                                  color: ColorsRes
                                                      .appColorRed),
                                            )
                                          : (orderItem?.returnStatus ==
                                                      "1" &&
                                                  orderItem
                                                          ?.returnRequested ==
                                                      "3")
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    CustomTextLabel(
                                                      jsonKey:
                                                          returnRejectedLabel,
                                                      style: TextStyle(
                                                        color: ColorsRes
                                                            .appColorRed,
                                                      ),
                                                    ),
                                                    CustomTextLabel(
                                                      text:
                                                          "${getTranslatedValue(context, returnReasonLabel)}: ${orderItem?.returnReason}",
                                                      style: TextStyle(
                                                          color: ColorsRes
                                                              .subTitleMainTextColor),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
          },
        ),
      ],
    );
  }
}