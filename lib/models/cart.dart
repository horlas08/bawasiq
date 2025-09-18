class Cart {
  Cart({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final String status;
  late final String message;
  late final String total;
  late final CartData data;

  Cart.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = CartData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['status'] = status;
    itemData['message'] = message;
    itemData['total'] = total;
    itemData['data'] = data.toJson();
    return itemData;
  }
}

class CartData {
  CartData({
    required this.subTotal,
    required this.cart,
  });

  late final String subTotal;
  late final List<CartItem> cart;

  CartData.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'].toString();
    cart = List.from(json['cart']).map((e) => CartItem.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['sub_total'] = subTotal;
    itemData['cart'] = cart.map((e) => e.toJson()).toList();
    return itemData;
  }
}

class CartItem {
  CartItem({
    required this.productId,
    required this.sellerId,
    required this.productVariantId,
    required this.qty,
    required this.isDeliverable,
    required this.measurement,
    required this.discountedPrice,
    required this.price,
    required this.stock,
    required this.totalAllowedQuantity,
    required this.name,
    required this.unit_code,
    required this.status,
    required this.imageUrl,
  });

  late final String productId;
  late final String sellerId;
  late final String productVariantId;
  late final String qty;
  late final String isDeliverable;
  late final String isUnlimitedStock;
  late final String measurement;
  late final String discountedPrice;
  late final String price;
  late final String stock;
  late final String totalAllowedQuantity;
  late final String name;
  late final String unit_code;
  late final String status;
  late final String imageUrl;

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    sellerId = json['seller_id'].toString();
    productVariantId = json['product_variant_id'].toString();
    qty = json['qty'].toString();
    isDeliverable = json['is_deliverable'].toString();
    isUnlimitedStock = json['is_unlimited_stock'].toString();
    measurement = json['measurement'].toString();
    discountedPrice = json['discounted_price'].toString();
    price = json['price'].toString();
    stock = json['stock'].toString();
    totalAllowedQuantity = json['total_allowed_quantity'].toString();
    name = json['name'].toString();
    unit_code = json['unit_code'].toString();
    status = json['status'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['seller_id'] = sellerId;
    data['product_variant_id'] = productVariantId;
    data['qty'] = qty;
    data['is_deliverable'] = isDeliverable;
    data['is_deliverable'] = isUnlimitedStock;
    data['measurement'] = measurement;
    data['discounted_price'] = discountedPrice;
    data['price'] = price;
    data['stock'] = stock;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['name'] = name;
    data['unit_code'] = unit_code;
    data['status'] = status;
    data['image_url'] = imageUrl;
    return data;
  }
}
