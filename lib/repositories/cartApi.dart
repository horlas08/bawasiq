import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCartListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiCart,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> getGuestCartListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiGuestCart,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> addItemToCartApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiCartAdd,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> addGuestCartBulkToCartWhileLogin(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiGuestCartBulkAddToCartWhileLogin,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> removeItemFromCartApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiCartRemove,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
