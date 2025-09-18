import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getPlaceOrderApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiPlaceOrder,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}
