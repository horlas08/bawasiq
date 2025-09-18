import 'package:project/helper/utils/generalImports.dart';


enum CartListState { initial, loaded, loading, error }

class CartListProvider extends ChangeNotifier {
  CartListState cartListState = CartListState.initial;
  List<CartList> cartList = [];
  String currentSelectedProduct = "";
  String currentSelectedVariant = "";

  Future<void> addRemoveCartItemFromLocalList(
      {required String productId,
      required String productVariantId,
      required String qty,
      required String sellerId}) async {
    if (int.parse(qty) == 0) {
      cartList.removeWhere((element) =>
          element.productId == productId &&
          element.productVariantId == productVariantId);
      cartListState = CartListState.loaded;
      notifyListeners();
    } else {
      cartList.removeWhere((element) =>
          element.productId == productId &&
          element.productVariantId == productVariantId);

      cartList.add(
        CartList(
          productId: productId,
          productVariantId: productVariantId,
          qty: qty,
          sellerId: sellerId,
        ),
      );

      Constant.session.setData(SessionManager.keyGuestCartItems,
          CartList.CartItemsToJson(cartList), false);
      cartListState = CartListState.loaded;
      notifyListeners();
    }
  }

  getAllCartItems({required BuildContext context}) async {
    if (Constant.session.isUserLoggedIn()) {
      cartList.clear();
      try {
        Map<String, String> params = await Constant.getProductsDefaultParams();
        Map<String, dynamic> getData =
            await getCartListApi(context: context, params: params);
        if (getData[ApiAndParams.status].toString() == "1") {
          List<CartItem> carts =
              (getData[ApiAndParams.data][ApiAndParams.cart] as List)
                  .map((e) => CartItem.fromJson(Map.from(e)))
                  .toList();

          for (int i = 0; i < carts.length; i++) {
            cartList.add(
              CartList(
                productId: carts[i].productId.toString(),
                productVariantId: carts[i].productVariantId.toString(),
                qty: (carts[i].qty).toString(),
                sellerId: carts[i].sellerId.toString(),
              ),
            );
          }
          notifyListeners();
        }
      } catch (e) {
        String message = e.toString();
        showMessage(
          context,
          message,
          MessageType.warning,
        );
      }
    }
  }

  String getItemCartItemQuantity(String productId, String productVariantId) {
    String quantity = "0";
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i].productId == productId &&
          cartList[i].productVariantId == productVariantId) {
        quantity = cartList[i].qty;
      }
    }
    return quantity;
  }

  Future addRemoveCartItem({
    required BuildContext context,
    required Map<String, String> params,
    required bool isUnlimitedStock,
    required double maximumAllowedQuantity,
    required double availableStock,
    required String sellerId,
    required String from,
    required String actionFor,
  }) async {
    cartListState = CartListState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> response = {};
      if (int.parse(params[ApiAndParams.qty].toString()) > 0) {
        if (isUnlimitedStock) {
          if (double.parse(params[ApiAndParams.qty].toString()) >
                  maximumAllowedQuantity &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                maximumProductsQuantityLimitReachedMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else {
            response = await addItemToCartApi(context: context, params: params);

            try {
              if (response[ApiAndParams.status].toString() == "1") {
                context.read<CartProvider>().setSubTotal(
                    double.parse(response[ApiAndParams.subTotal].toString()));

                context.read<CartProvider>().setItemCount(int.parse(
                    response[ApiAndParams.cartItemsCount].toString()));
                addRemoveCartItemFromLocalList(
                    productId: params[ApiAndParams.productId].toString(),
                    productVariantId:
                        params[ApiAndParams.productVariantId].toString(),
                    qty: params[ApiAndParams.qty].toString(),
                    sellerId: sellerId);
              } else {
                if (response.containsKey(ApiAndParams.data)) {
                  cartListState = CartListState.error;
                  notifyListeners();
                  return "one_seller_error_code";
                } else {
                  showMessage(
                    context,
                    response[ApiAndParams.message].toString(),
                    MessageType.warning,
                  );
                  cartListState = CartListState.error;
                  notifyListeners();
                }
              }
            } catch (e) {
              cartListState = CartListState.error;
              notifyListeners();
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  maximumProductsQuantityLimitReachedMessageLabel,
                ),
                MessageType.warning,
              );
            }
          }
        } else {
          if (double.parse(params[ApiAndParams.qty].toString()) >
                  availableStock &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                outOfStockMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else if (double.parse(params[ApiAndParams.qty].toString()) >
                  maximumAllowedQuantity &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                maximumProductsQuantityLimitReachedMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else {
            try {
              response =
                  await addItemToCartApi(context: context, params: params);
              if (response[ApiAndParams.status].toString() == "1") {
                context.read<CartProvider>().setSubTotal(
                    double.parse(response[ApiAndParams.subTotal].toString()));

                context.read<CartProvider>().setItemCount(int.parse(
                    response[ApiAndParams.cartItemsCount].toString()));

                addRemoveCartItemFromLocalList(
                  productId: params[ApiAndParams.productId].toString(),
                  productVariantId:
                      params[ApiAndParams.productVariantId].toString(),
                  qty: params[ApiAndParams.qty].toString(),
                  sellerId: sellerId,
                );
              } else {
                if (response.containsKey(ApiAndParams.data)) {
                  cartListState = CartListState.error;
                  notifyListeners();
                  return "one_seller_error_code";
                } else {
                  showMessage(
                    context,
                    response[ApiAndParams.message].toString(),
                    MessageType.warning,
                  );
                  cartListState = CartListState.error;
                  notifyListeners();
                }
              }
            } catch (e) {
              cartListState = CartListState.error;
              notifyListeners();
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  maximumProductsQuantityLimitReachedMessageLabel,
                ),
                MessageType.warning,
              );
            }
          }
        }
      } else {
        response =
            await removeItemFromCartApi(context: context, params: params);

        params[ApiAndParams.qty] = "0";

        if (response[ApiAndParams.status].toString() == "1") {
          context.read<CartProvider>().setSubTotal(
              double.parse(response[ApiAndParams.subTotal].toString()));

          context.read<CartProvider>().setItemCount(
              int.parse(response[ApiAndParams.cartItemsCount].toString()));
          addRemoveCartItemFromLocalList(
            productId: params[ApiAndParams.productId].toString(),
            productVariantId: params[ApiAndParams.productVariantId].toString(),
            qty: params[ApiAndParams.qty].toString(),
            sellerId: sellerId,
          );
          if (from == "cartList") {
            context.read<CartProvider>().removeItemFromCartList(
                productId: int.parse(params[ApiAndParams.productId].toString()),
                variantId: int.parse(
                    params[ApiAndParams.productVariantId].toString()));
          }
        } else {
          if (response.containsKey(ApiAndParams.data)) {
            cartListState = CartListState.error;
            notifyListeners();
            return "one_seller_error_code";
          } else {
            showMessage(
              context,
              response[ApiAndParams.message].toString(),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          }
        }
      }

      if ((await Vibration.hasVibrator())) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      showMessage(
        context,
        e.toString(),
        MessageType.warning,
      );
      cartListState = CartListState.error;
      notifyListeners();
    }
  }

  Future addRemoveGuestCartItem({
    required BuildContext context,
    required Map<String, String> params,
    required bool isUnlimitedStock,
    required double maximumAllowedQuantity,
    required double availableStock,
    required String sellerId,
    String? from = "",
    String? actionFor = "",
  }) async {
    cartListState = CartListState.loading;
    notifyListeners();

    try {
      if (int.parse(params[ApiAndParams.qty].toString()) > 0) {
        if (isUnlimitedStock) {
          if (double.parse(params[ApiAndParams.qty].toString()) >
                  maximumAllowedQuantity &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                maximumProductsQuantityLimitReachedMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else {
            try {
              if (Constant.oneSellerCart == "1" &&
                  await allCartItemsHasSameSeller()) {
                addRemoveCartItemFromLocalList(
                  productId: params[ApiAndParams.productId].toString(),
                  productVariantId:
                      params[ApiAndParams.productVariantId].toString(),
                  qty: params[ApiAndParams.qty].toString(),
                  sellerId: sellerId,
                ).then(
                  (value) => context
                      .read<CartProvider>()
                      .getGuestCartListProvider(context: context),
                );
              } else if (Constant.oneSellerCart == "0") {
                addRemoveCartItemFromLocalList(
                  productId: params[ApiAndParams.productId].toString(),
                  productVariantId:
                      params[ApiAndParams.productVariantId].toString(),
                  qty: params[ApiAndParams.qty].toString(),
                  sellerId: sellerId,
                ).then(
                  (value) => context
                      .read<CartProvider>()
                      .getGuestCartListProvider(context: context),
                );
              } else {
                cartListState = CartListState.error;
                notifyListeners();
                return "one_seller_error_code";
              }
            } catch (e) {
              cartListState = CartListState.error;
              notifyListeners();
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  maximumProductsQuantityLimitReachedMessageLabel,
                ),
                MessageType.warning,
              );
            }
          }
        }
        else {
          if (double.parse(params[ApiAndParams.qty].toString()) >
                  availableStock &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                outOfStockMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else if (double.parse(params[ApiAndParams.qty].toString()) >
                  maximumAllowedQuantity &&
              actionFor == "add") {
            showMessage(
              context,
              getTranslatedValue(
                context,
                maximumProductsQuantityLimitReachedMessageLabel,
              ),
              MessageType.warning,
            );
            cartListState = CartListState.error;
            notifyListeners();
          } else {
            try {
              if (Constant.oneSellerCart == "1" &&
                  await allCartItemsHasSameSeller()) {
                addRemoveCartItemFromLocalList(
                  productId: params[ApiAndParams.productId].toString(),
                  productVariantId:
                      params[ApiAndParams.productVariantId].toString(),
                  qty: params[ApiAndParams.qty].toString(),
                  sellerId: sellerId,
                ).then(
                  (value) => context
                      .read<CartProvider>()
                      .getGuestCartListProvider(context: context),
                );
              } else if (Constant.oneSellerCart == "0") {
                addRemoveCartItemFromLocalList(
                  productId: params[ApiAndParams.productId].toString(),
                  productVariantId:
                      params[ApiAndParams.productVariantId].toString(),
                  qty: params[ApiAndParams.qty].toString(),
                  sellerId: sellerId,
                ).then(
                  (value) => context
                      .read<CartProvider>()
                      .getGuestCartListProvider(context: context),
                );
              } else {
                cartListState = CartListState.error;
                notifyListeners();
                return "one_seller_error_code";
              }
            } catch (e) {
              cartListState = CartListState.error;
              notifyListeners();
              showMessage(
                context,
                getTranslatedValue(
                  context,
                  maximumProductsQuantityLimitReachedMessageLabel,
                ),
                MessageType.warning,
              );
            }
          }
        }
      } else {
        params[ApiAndParams.qty] = "0";

        addRemoveCartItemFromLocalList(
          productId: params[ApiAndParams.productId].toString(),
          productVariantId: params[ApiAndParams.productVariantId].toString(),
          qty: params[ApiAndParams.qty].toString(),
          sellerId: sellerId,
        ).then(
          (value) => context
              .read<CartProvider>()
              .getGuestCartListProvider(context: context),
        );
        if (from == "cartList") {
          context.read<CartProvider>().removeItemFromCartList(
              productId: int.parse(params[ApiAndParams.productId].toString()),
              variantId:
                  int.parse(params[ApiAndParams.productVariantId].toString()));
        }
      }

      Constant.session.setData(SessionManager.keyGuestCartItems,
          CartList.CartItemsToJson(cartList), false);

      if ((await Vibration.hasVibrator())) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      showMessage(
        context,
        e.toString(),
        MessageType.warning,
      );
      cartListState = CartListState.error;
      notifyListeners();
    }
  }

  Future clearCart({required BuildContext context}) async {
    cartList.clear();
    context.read<CartProvider>().setSubTotal(0.0);
    context.read<CartProvider>().setItemCount(0);
    notifyListeners();
    await removeItemFromCartApi(
        context: context, params: {ApiAndParams.removeAllCartItems: "1"});
  }

  Future allCartItemsHasSameSeller() async {
    bool isSameSeller = true;
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i].sellerId != cartList[0].sellerId) {
        isSameSeller = false;
        break;
      }
    }
    return isSameSeller;
  }

  Future setGuestCartItems() async {
    cartList = Constant.session.getGuestCartItems();
    notifyListeners();
  }
}
