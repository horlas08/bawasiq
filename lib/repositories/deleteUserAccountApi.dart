import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getDeleteAccountApi(
    {required BuildContext context}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiDeleteAccount,
      params: {},
      isPost: true,
      context: context);

  return json.decode(response);
}
