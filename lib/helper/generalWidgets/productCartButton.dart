import 'package:project/helper/utils/generalImports.dart';


class ProductCartButton extends StatefulWidget {
  final int count;
  final String productId;
  final String sellerId;
  final String productVariantId;
  final bool isUnlimitedStock;
  final double maximumAllowedQuantity;
  final double availableStock;
  final String from;
  final bool isGrid;

  const ProductCartButton({
    Key? key,
    required this.count,
    required this.productId,
    required this.productVariantId,
    required this.isUnlimitedStock,
    required this.maximumAllowedQuantity,
    required this.availableStock,
    required this.isGrid,
    required this.from,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState
    extends State<ProductCartButton> /*with TickerProviderStateMixin*/ {
  late AnimationController animationController;
  late Animation animation;
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartListProvider>(
      builder: (context, cartListProvider, child) {
        return (int.parse(cartListProvider.getItemCartItemQuantity(
                        widget.productId, widget.productVariantId)) ==
                    0 &&
                widget.count != -1)
            ? GestureDetector(
                onTap: () async {
                  if (Constant.session.isUserLoggedIn()) {
                    cartListProvider.currentSelectedProduct = widget.productId;
                    cartListProvider.currentSelectedVariant =
                        widget.productVariantId;

                    Map<String, String> params = {};
                    params[ApiAndParams.productId] = widget.productId;
                    params[ApiAndParams.productVariantId] =
                        widget.productVariantId;
                    params[ApiAndParams.qty] = (int.parse(
                                cartListProvider.getItemCartItemQuantity(
                                    widget.productId,
                                    widget.productVariantId)) +
                            1)
                        .toString();
                    await cartListProvider
                        .addRemoveCartItem(
                      context: context,
                      params: params,
                      isUnlimitedStock: widget.isUnlimitedStock,
                      maximumAllowedQuantity: widget.maximumAllowedQuantity,
                      availableStock: widget.availableStock,
                      actionFor: "add",
                      from: widget.from,
                      sellerId: widget.sellerId,
                    )
                        .then((value) {
                      if (value is String) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            surfaceTintColor: ColorsRes.appColorTransparent,
                            backgroundColor: Theme.of(context).cardColor,
                            content: CustomTextLabel(
                              jsonKey: sellerMismatchItemLabel,
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
                                  if (!Constant.session.isUserLoggedIn()){
                                    return Navigator.pop(context);
                                  }
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                            1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                          widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
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
                      }
                    });
                  }
                  else {
                    Navigator.of(context).pushNamedAndRemoveUntil(loginAccountScreen, (Route<dynamic> route) => false);

                    // if (Constant.guestCartOptionIsOn == "1") {
                    cartListProvider.currentSelectedProduct = widget.productId;
                    cartListProvider.currentSelectedVariant =
                        widget.productVariantId;

                    Map<String, String> params = {};
                    params[ApiAndParams.productId] = widget.productId;
                    params[ApiAndParams.productVariantId] =
                        widget.productVariantId;
                    params[ApiAndParams.qty] = (int.parse(
                                cartListProvider.getItemCartItemQuantity(
                                    widget.productId,
                                    widget.productVariantId)) +
                            1)
                        .toString();
                    await cartListProvider
                        .addRemoveGuestCartItem(
                      context: context,
                      params: params,
                      isUnlimitedStock: widget.isUnlimitedStock,
                      maximumAllowedQuantity: widget.maximumAllowedQuantity,
                      availableStock: widget.availableStock,
                      actionFor: "add",
                      from: widget.from,
                      sellerId: widget.sellerId,
                    )
                        .then((value) {
                      if (value is String) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            surfaceTintColor: ColorsRes.appColorTransparent,
                            backgroundColor: Theme.of(context).cardColor,
                            content: CustomTextLabel(
                              jsonKey: sellerMismatchItemLabel,
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
                                  if (!Constant.session.isUserLoggedIn()){
                                    return Navigator.pop(context);
                                  }
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                            1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                          widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
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
                      }
                    });
                    // } else {
                    //   loginUserAccount(context, "cart");
                    // }
                  }
                },
                child: Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: Constant.size10),
                  decoration: BoxDecoration(
                    color: ColorsRes.appColorLightHalfTransparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 35,
                  width: context.width * 0.25,
                  child: (cartListProvider.cartListState ==
                              CartListState.loading &&
                          cartListProvider.currentSelectedProduct ==
                              widget.productId &&
                          cartListProvider.currentSelectedVariant ==
                              widget.productVariantId)
                      ? Container(
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: ColorsRes.appColor,
                            ),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              defaultImg(
                                image: AppAssets.productCartIcon,
                                iconColor: ColorsRes.appColor,
                              ),
                              getSizedBox(width: 5),
                              CustomTextLabel(
                                jsonKey: addToCartLabel,
                                style: TextStyle(
                                  color:
                                      ColorsRes.mainTextColor.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              )
            : (int.parse(cartListProvider.getItemCartItemQuantity(
                            widget.productId, widget.productVariantId)) !=
                        0 &&
                    widget.count != -1)
                ? Container(
                    height: 35,
                    width: context.width * 0.25,
                    decoration: BoxDecoration(
                      gradient: DesignConfig.linearGradient(
                          ColorsRes.appColor, ColorsRes.appColor),
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 5),
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: gradientBtnWidget(
                              context,
                              50,
                              color1: ColorsRes.appColorWhite,
                              color2: ColorsRes.appColorWhite,
                              callback: () async {
                                cartListProvider.currentSelectedProduct =
                                    widget.productId;
                                cartListProvider.currentSelectedVariant =
                                    widget.productVariantId;

                                Map<String, String> params = {};
                                params[ApiAndParams.productId] =
                                    widget.productId;
                                params[ApiAndParams.productVariantId] =
                                    widget.productVariantId;
                                params[ApiAndParams.qty] = (int.parse(
                                            cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) -
                                        1)
                                    .toString();

                                if (Constant.session.isUserLoggedIn()) {
                                  await cartListProvider.addRemoveCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    sellerId: widget.sellerId,
                                    actionFor: "add",
                                  );
                                }
                                else {
                                  return Navigator.of(context).pushNamedAndRemoveUntil(loginAccountScreen, (Route<dynamic> route) => false);

                                  // if (Constant.guestCartOptionIsOn == "1") {
                                  await cartListProvider.addRemoveGuestCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    actionFor: "add",
                                    sellerId: widget.sellerId,
                                  );
                                  // } else {
                                  //   loginUserAccount(context, "cart");
                                  // }
                                }
                              },
                              otherWidgets: int.parse(cartListProvider
                                          .getItemCartItemQuantity(
                                              widget.productId,
                                              widget.productVariantId)) ==
                                      1
                                  ? defaultImg(
                                      image: AppAssets.cartDeleteIcon,
                                      width: 20,
                                      height: 20,
                                      padding:
                                          const EdgeInsetsDirectional.all(5),
                                      iconColor: ColorsRes.appColor,
                                    )
                                  : defaultImg(
                                      image: AppAssets.cartRemoveIcon,
                                      width: 20,
                                      height: 20,
                                      padding:
                                          const EdgeInsetsDirectional.all(5),
                                      iconColor: ColorsRes.appColor,
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: (cartListProvider.cartListState ==
                                      CartListState.loading &&
                                  cartListProvider.currentSelectedProduct ==
                                      widget.productId &&
                                  cartListProvider.currentSelectedVariant ==
                                      widget.productVariantId)
                              ? Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: ColorsRes.appColorWhite,
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: AlignmentDirectional.center,
                                  width: 35,
                                  height: 35,
                                  child: CustomTextLabel(
                                    text: cartListProvider
                                        .getItemCartItemQuantity(
                                            widget.productId,
                                            widget.productVariantId),
                                    softWrap: true,
                                    style: TextStyle(
                                        color: ColorsRes.appColorWhite),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: 5),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: gradientBtnWidget(
                              context,
                              50,
                              color1: ColorsRes.appColorWhite,
                              color2: ColorsRes.appColorWhite,
                              callback: () async {
                                cartListProvider.currentSelectedProduct =
                                    widget.productId;
                                cartListProvider.currentSelectedVariant =
                                    widget.productVariantId;
                                Map<String, String> params = {};
                                params[ApiAndParams.productId] =
                                    widget.productId;
                                params[ApiAndParams.productVariantId] =
                                    widget.productVariantId;
                                params[ApiAndParams.qty] = (int.parse(
                                            cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                        1)
                                    .toString();

                                if (Constant.session.isUserLoggedIn()) {
                                  await cartListProvider.addRemoveCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    sellerId: widget.sellerId,
                                    actionFor: "add",
                                  );
                                }
                                else {
                                  return Navigator.of(context).pushNamedAndRemoveUntil(loginAccountScreen, (Route<dynamic> route) => false);

                                  // if (Constant.guestCartOptionIsOn == "1") {
                                  await cartListProvider.addRemoveGuestCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    actionFor: "add",
                                    sellerId: widget.sellerId,
                                  );
                                  // } else {
                                  //   loginUserAccount(context, "cart");
                                  // }
                                }
                              },
                              otherWidgets: defaultImg(
                                image: AppAssets.cartAddIcon,
                                width: 20,
                                height: 20,
                                padding: const EdgeInsetsDirectional.all(5),
                                iconColor: ColorsRes.appColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 7, bottom: 7),
                    child: CustomTextLabel(
                      jsonKey: outOfStockLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.appColorRed,
                      ),
                    ),
                  );
      },
    );
  }
}
