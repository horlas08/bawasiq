import 'package:project/helper/utils/generalImports.dart';

//This is api for the razorpay transaction
Future<Map<String, dynamic>> getInitiatedTransactionApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  if (Platform.isAndroid) {
    params[ApiAndParams.requestFrom] = "android";
  } else if (Platform.isIOS) {
    params[ApiAndParams.requestFrom] = "ios";
  } else {
    params[ApiAndParams.requestFrom] = Platform.operatingSystem;
  }
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiInitiateTransaction,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}

// phonepe
Future<Map<String, dynamic>> getOrderStatusPhonepeApi({required BuildContext context, required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(apiName: ApiAndParams.apiOrderStatusPhonepe, params: params, isPost: false, context: context);
  return json.decode(response);
}

//This is api for the razorpay transaction
Future<Map<String, dynamic>> getPaytmTransactionTokenApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiPaytmTransactionToken,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}
