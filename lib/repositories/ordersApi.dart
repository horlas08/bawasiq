import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> fetchOrders(
    {required Map<String, String> params,
    required BuildContext context}) async {
  final response = await sendApiRequest(
      apiName: ApiAndParams.apiOrdersHistory,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> updateOrderStatus(
    {required Map<String, String> params,
    required BuildContext context}) async {
  final response = await sendApiRequest(
      apiName: ApiAndParams.apiUpdateOrderStatus,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future deleteAwaitingOrderApi(
    {required Map<String, String> params,
    required BuildContext context}) async {
  final response = await sendApiRequest(
      apiName: ApiAndParams.apiDeleteOrder,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
