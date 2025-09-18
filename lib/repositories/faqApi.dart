import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getFaqApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiFaq,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
