class PaymentMethods {
  PaymentMethods({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final String status;
  late final String message;
  late final String total;
  late final PaymentMethodsData data;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = PaymentMethodsData.fromJson(json['data']);
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

class PaymentMethodsData {
  String? stripeSecretKey;
  String? stripePublishableKey;
  String? paymentMethodSettings;
  String? codPaymentMethod;
  String? codMode;
  String? paypalPaymentMethod;
  String? razorpayPaymentMethod;
  String? razorpayKey;
  String? razorpaySecretKey;
  String? paystackPaymentMethod;
  String? paystackPublicKey;
  String? paystackSecretKey;
  String? paystackCurrencyCode;
  String? midtransPaymentMethod;
  String? stripePaymentMethod;
  String? stripeCurrencyCode;
  String? stripeMode;
  String? paytmPaymentMethod;
  String? paytmMode;
  String? paytmMerchantKey;
  String? paytmMerchantId;
  String? phonePePaymentMethod;
  String? cashfreePaymentMethod;
  String? cashfreeMode;
  String? paytabsPaymentMethod;

  PaymentMethodsData({
    this.stripeSecretKey,
    this.stripePublishableKey,
    this.paymentMethodSettings,
    this.codPaymentMethod,
    this.codMode,
    this.paypalPaymentMethod,
    this.razorpayPaymentMethod,
    this.razorpayKey,
    this.razorpaySecretKey,
    this.paystackPaymentMethod,
    this.paystackPublicKey,
    this.paystackSecretKey,
    this.paystackCurrencyCode,
    this.midtransPaymentMethod,
    this.stripePaymentMethod,
    this.stripeCurrencyCode,
    this.stripeMode,
    this.paytmPaymentMethod,
    this.paytmMode,
    this.paytmMerchantKey,
    this.paytmMerchantId,
    this.phonePePaymentMethod,
    this.cashfreePaymentMethod,
    this.cashfreeMode,
    this.paytabsPaymentMethod,
  });

  PaymentMethodsData.fromJson(Map<String, dynamic> json) {
    stripeSecretKey = json['stripe_secret_key'].toString();
    stripePublishableKey = json['stripe_publishable_key'].toString();
    paymentMethodSettings = json['payment_method_settings'].toString();
    codPaymentMethod = json['cod_payment_method'].toString();
    codMode = json['cod_mode'].toString();
    paypalPaymentMethod = json['paypal_payment_method'].toString();
    razorpayPaymentMethod = json['razorpay_payment_method'].toString();
    razorpayKey = json['razorpay_key'].toString();
    razorpaySecretKey = json['razorpay_secret_key'].toString();
    paystackPaymentMethod = json['paystack_payment_method'].toString();
    paystackPublicKey = json['paystack_public_key'].toString();
    paystackSecretKey = json['paystack_secret_key'].toString();
    paystackCurrencyCode = json['paystack_currency_code'].toString();
    midtransPaymentMethod = json['midtrans_payment_method'].toString();
    stripePaymentMethod = json['stripe_payment_method'].toString();
    stripeCurrencyCode = json['stripe_currency_code'].toString();
    stripeMode = json['stripe_mode'].toString();
    paytmPaymentMethod = json['paytm_payment_method'].toString();
    paytmMode = json['paytm_mode'].toString();
    paytmMerchantKey = json['paytm_merchant_key'].toString();
    paytmMerchantId = json['paytm_merchant_id'].toString();
    phonePePaymentMethod = json['phonepay_payment_method'].toString();
    cashfreePaymentMethod = json['cashfree_payment_method'].toString();
    cashfreeMode = json['cashfree_mode'].toString();
    paytabsPaymentMethod = json['paytabs_payment_method'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_secret_key'] = this.stripeSecretKey;
    data['stripe_publishable_key'] = this.stripePublishableKey;
    data['payment_method_settings'] = this.paymentMethodSettings;
    data['cod_payment_method'] = this.codPaymentMethod;
    data['cod_mode'] = this.codMode;
    data['paypal_payment_method'] = this.paypalPaymentMethod;
    data['razorpay_payment_method'] = this.razorpayPaymentMethod;
    data['razorpay_key'] = this.razorpayKey;
    data['razorpay_secret_key'] = this.razorpaySecretKey;
    data['paystack_payment_method'] = this.paystackPaymentMethod;
    data['paystack_public_key'] = this.paystackPublicKey;
    data['paystack_secret_key'] = this.paystackSecretKey;
    data['paystack_currency_code'] = this.paystackCurrencyCode;
    data['midtrans_payment_method'] = this.midtransPaymentMethod;
    data['stripe_payment_method'] = this.stripePaymentMethod;
    data['stripe_currency_code'] = this.stripeCurrencyCode;
    data['stripe_mode'] = this.stripeMode;
    data['paytm_payment_method'] = this.paytmPaymentMethod;
    data['paytm_mode'] = this.paytmMode;
    data['paytm_merchant_key'] = this.paytmMerchantKey;
    data['paytm_merchant_id'] = this.paytmMerchantId;
    data['phonepay_payment_method'] = this.phonePePaymentMethod;
    data['cashfree_payment_method'] = this.cashfreePaymentMethod;
    data['cashfree_mode'] = this.cashfreeMode;
    data['paytabs_payment_method'] = this.paytabsPaymentMethod;
    return data;
  }
}
