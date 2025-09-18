import 'package:project/helper/utils/generalImports.dart';


class OrderItemContainer extends StatelessWidget {
  final Order order;
  final String from;

  const OrderItemContainer(
      {super.key, required this.order, required this.from});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, orderDetailScreen,
            arguments: [order.id, from]).then((value) {
          if (value != null) {
            context.read<ActiveOrdersProvider>().updateOrder(value as Order);
          }
        });
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 10, end: 10, top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsetsDirectional.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextLabel(
                        text:
                            "${getTranslatedValue(context, orderLabel)} #${order.id}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      CustomTextLabel(
                        text: "${order.date.toString().formatDate()}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.subTitleMainTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                    color: ColorsRes
                        .statusBgColor[order.activeStatus.toString().toInt - 1],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: ColorsRes.statusTextColor[
                          order.activeStatus.toString().toInt - 1],
                      width: 1,
                    ),
                  ),
                  child: CustomTextLabel(
                    jsonKey: Constant.getOrderActiveStatusLabelFromCode(
                      order.activeStatus.toString(),
                      context,
                    ),
                    style: TextStyle(
                      color: ColorsRes.statusTextColor[
                          order.activeStatus.toString().toInt - 1],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            getSizedBox(
              height: 10,
            ),
            getDivider(
              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.3),
              height: 1,
              thickness: 1,
            ),
            getSizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...List.generate(
                  order.items!.length >= 3 ? 3 : order.items!.length,
                  (itemIndex) {
                    return Row(
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 7,
                          color: ColorsRes.subTitleMainTextColor,
                        ),
                        getSizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomTextLabel(
                            text: order.items?[itemIndex].productName,
                            style: TextStyle(
                              color: ColorsRes.subTitleMainTextColor,
                            ),
                          ),
                        ),
                        CustomTextLabel(
                          text:
                              "${order.items?[itemIndex].measurement} ${order.items?[itemIndex].unit}",
                          style: TextStyle(
                            color: ColorsRes.subTitleMainTextColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (order.items!.length > 3) ...[
                  getSizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.only(
                        start: 15, end: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: ColorsRes.subTitleMainTextColor
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CustomTextLabel(
                      text:
                          "+ ${order.items!.length - 3} ${(order.items!.length - 3) == 1 ? getTranslatedValue(context, itemLabel) : getTranslatedValue(context, itemsLabel)}",
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]
              ],
            ),
            getSizedBox(
              height: 10,
            ),
            getDivider(
              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.3),
              height: 1,
              thickness: 1,
            ),
            getSizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextLabel(
                    jsonKey: totalPayLabel,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                ),
                CustomTextLabel(
                  jsonKey: order.finalTotal.toString().currency,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsRes.appColor,
                  ),
                ),
              ],
            ),
            getSizedBox(
              height: 10,
            ),
            getDivider(
              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.3),
              height: 1,
              thickness: 1,
            ),
            getSizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsetsDirectional.all(10),
                    child: CustomTextLabel(
                      jsonKey: showMoreLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      List<CartList> cartList = [];
                      String? variantIds = order.items
                          ?.map((e) => e.variantId)
                          .toList()
                          .join(',')
                          .toString();
                      String? quantity = order.items
                          ?.map((e) => e.quantity)
                          .toList()
                          .join(',')
                          .toString();
                      String? productIds = order.items
                          ?.map((e) => e.productId)
                          .toList()
                          .join(',')
                          .toString();
                      String? sellerIds = order.items
                          ?.map((e) => e.sellerId)
                          .toList()
                          .join(',')
                          .toString();

                      print(
                          ">>>> ${variantIds}--${quantity}--${productIds}--${sellerIds}");

                      for (int i = 0; i < order.items!.length; i++) {
                        CartList cartListItem = CartList(
                          productId: order.items![i].productId.toString(),
                          productVariantId:
                              order.items![i].variantId.toString(),
                          sellerId: order.items![i].sellerId.toString(),
                          qty: order.items![i].quantity.toString(),
                        );
                        cartList.add(cartListItem);
                      }

                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Theme.of(context).cardColor,
                          surfaceTintColor: ColorsRes.appColorTransparent,
                          title: CustomTextLabel(
                            jsonKey: reorderLabel,
                            softWrap: true,
                          ),
                          content: CustomTextLabel(
                            jsonKey: reorderWarningLabel,
                            softWrap: true,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: CustomTextLabel(
                                jsonKey: cancelLabel,
                                softWrap: true,
                                style: TextStyle(
                                    color: ColorsRes.subTitleMainTextColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await addGuestCartBulkToCartWhileLogin(
                                    context: context,
                                    params: {
                                      ApiAndParams.quantities: quantity,
                                      ApiAndParams.variant_ids: variantIds,
                                    }).then(
                                  (value) async {
                                    if (value[ApiAndParams.status].toString() ==
                                        "1") {
                                      await context
                                          .read<CartProvider>()
                                          .getCartListProvider(
                                              context: context);

                                      await context
                                          .read<CartListProvider>()
                                          .getAllCartItems(context: context);
                                    } else {
                                      showMessage(
                                          context,
                                          getTranslatedValue(context,
                                              value[ApiAndParams.message]),
                                          MessageType.warning);
                                    }
                                  },
                                );

                                Navigator.pop(context);
                              },
                              child: CustomTextLabel(
                                jsonKey: okLabel,
                                softWrap: true,
                                style: TextStyle(color: ColorsRes.appColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.all(10),
                      child: CustomTextLabel(
                        jsonKey: reorderLabel,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (from != "previousOrders") ...[
                  SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (order.status!.isNotEmpty &&
                            order.activeStatus.toString() != "5") {
                          showModalBottomSheet(
                            backgroundColor: Theme.of(context).cardColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return OrderTrackingHistoryBottomSheet(
                                listOfStatus: order.status ?? [],
                              );
                            },
                          );
                        } else if (order.activeStatus.toString() == "5") {
                          Navigator.pushNamed(
                            context,
                            orderTrackerScreen,
                            arguments: [
                              order.latitude?.toDouble,
                              order.longitude?.toDouble,
                              order.orderAddress.toString(),
                              order.id.toString(),
                              order.deliveryBoyName.toString(),
                              order.deliveryBoyNumber.toString(),
                            ],
                          );
                        } else {
                          showMessage(
                              context,
                              getTranslatedValue(context,
                                  orderAwaitingPaymentTrackLabel),
                              MessageType.warning);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsRes.mainTextColorLight,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsetsDirectional.all(10),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextLabel(
                                jsonKey: trackMyOrderLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorsRes.mainTextColorDark,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: ColorsRes.mainTextColorDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}