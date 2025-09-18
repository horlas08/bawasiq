import 'package:project/helper/utils/generalImports.dart';

class CartList {
  CartList({
    required this.productId,
    required this.productVariantId,
    required this.sellerId,
    required this.qty,
  });

  late final String productId;
  late final String productVariantId;
  late final String sellerId;
  late final String qty;

  CartList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    productVariantId = json['product_variant_id'].toString();
    sellerId = json['seller_id'].toString();
    qty = json['qty'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_variant_id'] = productVariantId;
    data['seller_id'] = sellerId;
    data['qty'] = qty;
    return data;
  }

  // Function to convert List<CartList> to JSON string
  static String CartItemsToJson(List<CartList> cartItems) {
    final List<Map<String, dynamic>> jsonList =
        cartItems.map((cartItem) => cartItem.toJson()).toList();
    return jsonEncode(jsonList);
  }

  // Function to convert JSON string to List<CartList>
  static List<CartList> JsonToCartItems(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => CartList.fromJson(json)).toList();
  }
}
