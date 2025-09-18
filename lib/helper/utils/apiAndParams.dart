class ApiAndParams {
  //============== api ===========
  static String apiLogin = "login";
  static String apiSendSms = "send_sms";
  static String apiVerifyUser = "verify_user";
  static String apiRegister = "register";
  static String apiVerifyEmail = "verify_email";
  static String apiForgotPasswordOTP = "forgot_password_otp";
  static String apiForgotPassword = "forgot_password";
  static String apiSliders = "sliders";
  static String apiCategories = "categories";
  static String apiLiveTracking = "live_tracking";
  static String apiCountries = "countries";
  static String apiBrands = "brands";
  static String apiSellers = "sellers";
  static String apiProducts = "products";
  static String apiRatingsList = "$apiProducts/ratings_list";
  static String apiRatingAdd = "$apiProducts/rating/add";
  static String apiRatingUpdate = "$apiProducts/rating/update";
  static String apiRatingImages = "$apiProducts/rating/image_list";
  static String apiAppSettings = "settings";
  static String apiTimeSlotsSettings = "$apiAppSettings/time_slots";
  static String apiPaymentMethodsSettings = "$apiAppSettings/payment_methods";
  static String apiCity = "city";
  static String apiShop = "shop";
  static String apiFavorite = "favorites";
  static String apiAddProductToFavorite = "favorites/add";
  static String apiRemoveProductFromFavorite = "favorites/remove";
  static String apiProductDetail = "product_by_id";
  static String apiFaq = "faqs";
  static String apiNotification = "notifications";
  static String apiUpdateProfile = "edit_profile";
  static String apiUserDetails = "user_details";
  static String apiCart = "cart";
  static String apiGuestCart = "$apiCart/guest_cart";
  static String apiGuestCartBulkAddToCartWhileLogin =
      "$apiCart/bulk_add_to_cart_items";
  static String apiCartAdd = "$apiCart/add";
  static String apiCartRemove = "$apiCart/remove";
  static String apiOrdersHistory = "orders";
  static String apiUpdateOrderStatus = "update_order_status";
  
  static String apiPromoCode = "promo_code";
  static String apiAddress = "address";
  static String apiAddressAdd = "$apiAddress/add";
  static String apiAddressUpdate = "$apiAddress/update";
  static String apiAddressRemove = "$apiAddress/delete";
  static String apiPlaceOrder = "place_order";
  static String apiInitiateTransaction = "initiate_transaction";
  static String apiAddTransaction = "add_transaction";
  static String apiDeleteAccount = "delete_account";
  static String apiTransaction = "get_user_transactions";
  static String apiNotificationSettings = "mail_settings";
  static String apiNotificationSettingsUpdate = "$apiNotificationSettings/save";
  static String apiDownloadOrderInvoice = "invoice_download";
  static String apiPaytmTransactionToken = "paytm_txn_token";
  static String apiAddFcmToken = "add_fcm_token";
  static String apiLogout = "logout";
  static String apiUpdateFcmToken = "update_fcm_token";
  static String apiSystemLanguages = "system_languages";
  static String apiDeleteOrder = "delete_order";
  static String apiVerifyUserExist = "verify_user_exist";
  static String apiResetPassword = "reset_password";
  static String apiOrderStatusPhonepe = "order_status_phonepe";
  static String apiGooglePlacesAutocomplete = 'google_places_autocomplete';
  static String apiGooglePlacesDetails = 'google_places_details';
  static String apiGoogleMapsGeocoding = 'google_maps_geocoding';

//============ api params ============

//general
  static String id = "id";
  static String slug = "slug";
  static String barcode = "barcode";
  static String tagSlug = "tag_slug";
  static String tagNames = "tag_names";
  static String user = "user";
  static String status = "status";
  static String message = "message";
  static String imageUrl = "image_url";
  static String mobile = "mobile";
  static String data = "data";
  static String cityName = "name";
  static String latitude = "latitude";
  static String longitude = "longitude";
  static String cityId = "city_id";
  static String search = "search";
  static String total = "total";
  static String limit = "limit";
  static String offset = "offset";
  static String sort = "sort";
  static String totalMinPrice = "min_price";
  static String totalMaxPrice = "max_price";
  static String brandIds = "brand_ids";
  static String sizes = "sizes";
  static String unitIds = "unit_ids";
  static String categoryIds = "category_ids";
  static String isCheckout = "is_checkout";
  static String promoCodeId = "promocode_id";
  static String removeAllCartItems = "is_remove_all";
  static String cartCount = "cart_count";
  static String phone = "phone";
  static String otp = "otp";
  static String code = "code";
  static List<String> productListSortTypes = [
    "",
    "new",
    "old",
    "high",
    "low",
    "discount",
    "popular"
  ];
  static String categoryId = "category_id";
  static String sectionId = "section_id";
  static String brandId = "brand_id";
  static String sellerId = "seller_id";
  static String countryId = "country_id";
  static String cartItemsCount = "cart_items_count";
  static String productId = "product_id";
  static String productVariantId = "product_variant_id";
  static String qty = "qty";
  static String cart = "cart";
  static String saveForLater = "save_for_later";
  static String amount = "amount";
  static String phoneAuthType = "phone_auth_type";
  static String otpVerifyMethod = "otp_verify_method";

  static String address = "address";
  static String landmark = "landmark";
  static String area = "area";
  static String pinCode = "pincode";
  static String city = "city";
  static String state = "state";
  static String country = "country";
  static String alternateMobile = "alternate_mobile";
  static String isDefault = "is_default";

  static String productVariantIds = "product_variant_id";
  static String quantity = "quantity";
  static String quantities = "quantities";
  static String variant_ids = "variant_ids";
  static String deliveryCharge = "delivery_charge";
  static String finalTotal = "final_total";
  static String paymentMethod = "payment_method";
  static String addressId = "address_id";
  static String deliveryTime = "delivery_time";
  static String orderId = "order_id";
  static String walletAmount = "wallet_amount";
  static String subTotal = "sub_total";
  static String walletUsed = "wallet_used";
  static String walletBalance = "wallet_balance";

  static String deviceType = "device_type";
  static String appVersion = "app_version";
  static String transactionId = "transaction_id";
  static String type = "type";
  static String requestFrom = "request_from";

//login
  static String fcmToken = "fcm_token";
  static String platform = "platform";

  // phone, google,apple
  static String loginTypePhone = "phone";
  static String loginTypeGoogle = "google";
  static String loginTypeApple = "apple";

//category
  static String description = "description";
  static String parentId = "parent_id";
  static String level = "level";
  static String allChilds = "all_childs";

  //user
  static String name = "name";
  static String email = "email";
  static String password = "password";
  static String passwordConfirmation = "password_confirmation";
  static String profile = "profile";
  static String countryCode = "country_code";
  static String balance = "balance";
  static String userBalance = "user_balance";
  static String referralCode = "referral_code";
  static String friendsCode = "friends_code";
  static String createdAt = "created_at";
  static String updatedAt = "updated_at";
  static String accessToken = "access_token";
  static String oldPassword = "old_password";
  static String newPasswordConfirmation = "new_password_confirmation";
  static String newPassword = "new_password";

  //slider
  static String typeId = "type_id";
  static String image = "image";
  static String sliderUrl = "slider_url";
  static String typeName = "type_name";

  //Notification setting api params
  static String statusIds = "status_ids";
  static String mailStatuses = "mail_statuses";
  static String mobileStatuses = "mobile_statuses";
  static String smsStatuses = "mobile_statuses";

  //Language api params
  static String system_type = "system_type";
  static String is_default = "is_default";

  // Orders params
  static String active = "1";
  static String previous = "0";
  static String orderNote = "order_note";

  // Transaction history
  static String transactionsType = "transactions";
  static String walletType = "wallet";
  static String orderType = "order";

  //Rating Add Update
  static String rate = "rate";
  static String review = "review";
  static String deleteImageIds = "deleteImageIds";

  static String token = "token";

  static String initialCountryCode = "initialCountryCode";

  // address
  static String suggestions = "suggestions";
  static String error = "error";
  static String placeId = "place_id";
  static String input = "input";
  static String predictions = "predictions";
  static String source = "source";
}
