import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getTransactionApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  params[ApiAndParams.type] = ApiAndParams.transactionsType;

  var response = await sendApiRequest(
      apiName: ApiAndParams.apiTransaction,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
