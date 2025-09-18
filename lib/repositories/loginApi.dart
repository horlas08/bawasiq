import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getLoginApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiLogin,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> sendCustomOTPSmsApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiSendSms,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> getUserVerifyApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiVerifyUser,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> getVerifyUserExistApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiVerifyUserExist,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> getRegisterApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiRegister,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> verifyRegisteredEmailApi (
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiVerifyEmail,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> sendOTPForgotPasswordApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiForgotPasswordOTP,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> forgotPasswordApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiForgotPassword,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> changePasswordApi({required BuildContext context, required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiResetPassword,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}
