import 'package:project/helper/utils/generalImports.dart';


class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  @override
  void initState() {
    super.initState();

    Constant.isPromoCodeApplied = false;
    Constant.selectedCoupon = "";
    Constant.discountedAmount = 0.0;
    Constant.discount = 0.0;
    Constant.selectedPromoCodeId = "0";

    //fetch cartList from api
    Future.delayed(Duration.zero).then((value) async {
      callApi();
    });
  }

  callApi() async {
    if (Constant.session.isUserLoggedIn()) {
      await context.read<CartProvider>().getCartListProvider(context: context);
    } else {
      if (context.read<CartListProvider>().cartList.isNotEmpty) {
        await context
            .read<CartProvider>()
            .getGuestCartListProvider(context: context);
      }
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: cartLabel,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
        refreshCallback: () async {
          context.read<CartListProvider>().getAllCartItems(context: context);
          callApi();
        },
        child: (context.watch<CartListProvider>().cartList.isNotEmpty ||
                context.read<CartProvider>().cartState == CartState.error)
            ? cartWidget()
            : Container(
                alignment: Alignment.center,
                height: context.height,
                width: context.width,
                child: DefaultBlankItemMessageScreen(
                  image: "cart_empty",
                  title: emptyCartListMessageLabel,
                  description: emptyCartListDescriptionLabel,
                  buttonTitle: emptyCartListButtonNameLabel,
                  callback: () {
                    context
                        .read<HomeMainScreenProvider>()
                        .selectBottomMenu(0)
                        .then(
                          (value) => Navigator.of(context).popUntil(
                            (Route<dynamic> route) => route.isFirst,
                          ),
                        );
                  },
                ),
              ),
      ),
    );
  }

  btnWidget() {
    return gradientBtnWidget(context, 10, callback: () async {
      if (await context.read<CartProvider>().checkCartItemsStockStatus() ==
          false) {
        if (Constant.session.isUserLoggedIn()) {
          Navigator.pushNamed(context, checkoutScreen);
        } else {
          Navigator.pushNamed(context, loginAccountScreen,
                  arguments: "add_to_cart_register")
              .then(
            (value) => callApi(),
          );
        }
      } else {
        showMessage(
            context,
            getTranslatedValue(context, removeSoldOutItemsLabel),
            MessageType.warning);
      }
    },
        otherWidgets: CustomTextLabel(
          jsonKey: Constant.session.isUserLoggedIn()
              ? proceedToCheckoutLabel
              : loginToCheckoutLabel,
          softWrap: true,
          style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
              color: ColorsRes.appColorWhite,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500)),
        ));
  }

  cartWidget() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return (cartProvider.cartState == CartState.initial ||
                cartProvider.cartState == CartState.loading)
            ? getCartListShimmer(
                context: context,
              )
            : (cartProvider.cartState == CartState.loaded ||
                    cartProvider.cartState == CartState.silentLoading)
                ? Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsetsDirectional.only(
                              bottom: Constant.size10),
                          children: List.generate(
                            cartProvider.cartData.data.cart.length,
                            (index) {
                              CartItem cart =
                                  cartProvider.cartData.data.cart[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: Constant.size10,
                                  end: Constant.size10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      productDetailScreen,
                                      arguments: [
                                        cart.productId.toString(),
                                        cart.name.toString(),
                                        null,
                                        "cart"
                                      ],
                                    ).then((value) async {
                                      callApi();
                                    });
                                  },
                                  child: CartListItemContainer(
                                    cart: cart,
                                    from: 'cartList',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(Constant.size10),
                        margin: EdgeInsetsDirectional.only(
                          bottom: Constant.size10,
                          start: Constant.size10,
                          end: Constant.size10,
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: Constant.borderRadius10),
                        child: Column(
                          children: [
                            if (Constant.session.isUserLoggedIn())
                              Consumer<PromoCodeProvider>(
                                builder: (context, promoCodeProvider, _) {
                                  return promoCodeLayoutWidget(context);
                                },
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection: Directionality.of(context),
                              children: [
                                CustomTextLabel(
                                  text:
                                      "${getTranslatedValue(context, subtotalLabel)} (${cartProvider.cartData.data.cart.length} ${cartProvider.cartData.data.cart.length > 1 ? getTranslatedValue(context, itemsLabel) : getTranslatedValue(context, itemLabel)})",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                                if (Constant.isPromoCodeApplied == true)
                                  CustomTextLabel(
                                    text:
                                        "${Constant.discountedAmount.toString().currency}",
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                if (Constant.isPromoCodeApplied == false)
                                  CustomTextLabel(
                                    text:
                                        "${cartProvider.subTotal.toString().currency}",
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                              ],
                            ),
                            getSizedBox(height: 15),
                            btnWidget()
                          ],
                        ),
                      )
                    ],
                  )
                : DefaultBlankItemMessageScreen(
                    title: emptyCartListMessageLabel,
                    description: emptyCartListDescriptionLabel,
                    buttonTitle: emptyCartListButtonNameLabel,
                    callback: () {
                      context
                          .read<HomeMainScreenProvider>()
                          .selectBottomMenu(0)
                          .then((value) => Navigator.of(context).popUntil(
                                (Route<dynamic> route) => route.isFirst,
                              ));
                    },
                    image: "cart_empty",
                  );
      },
    );
  }

  promoCodeLayoutWidget(BuildContext context) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, promoCodeScreen,
                        arguments: context.read<CartProvider>().subTotal)
                    .then((value) {
                  if (value == true) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomPromoCodeDialog(
                          couponAmount: Constant.discount,
                          couponCode: Constant.selectedCoupon,
                        );
                      },
                    );
                  } else if (value == false) {
                    Constant.selectedCoupon = "";
                    Constant.discountedAmount = 0.0;
                    Constant.discount = 0.0;
                    Constant.isPromoCodeApplied = false;
                  }
                  setState(() {});
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 45,
                    decoration: DesignConfig.boxDecoration(
                        ColorsRes.appColor.withValues(alpha: 0.2), 10),
                    child: DashedRect(
                      color: ColorsRes.appColor,
                      strokeWidth: 1.0,
                      gap: 10,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          backgroundColor: ColorsRes.appColor,
                          radius: 100,
                          child: defaultImg(
                            image: AppAssets.discountCouponIcon,
                            height: 15,
                            width: 15,
                            iconColor: ColorsRes.mainIconColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextLabel(
                          text: Constant.isPromoCodeApplied == true
                              ? Constant.selectedCoupon
                              : getTranslatedValue(
                                  context,
                                  applyDiscountCodeLabel,
                                ),
                          softWrap: true,
                          lines: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (Constant.isPromoCodeApplied)
                        CustomTextLabel(
                          jsonKey: changeCouponLabel,
                          style: TextStyle(color: ColorsRes.appColor),
                        ),
                      const SizedBox(width: 12),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (Constant.isPromoCodeApplied == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: Directionality.of(context),
                children: [
                  Expanded(
                    child: CustomTextLabel(
                      text: "${getTranslatedValue(
                        context,
                        couponLabel,
                      )} (${Constant.selectedCoupon})",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      lines: 1,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 17,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ),
                  CustomTextLabel(
                    text: "-${Constant.discount.toString().currency}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    lines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 17,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  getCartListShimmer({required BuildContext context}) {
    return ListView(
      children: List.generate(10, (index) {
        return const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
      }),
    );
  }
}