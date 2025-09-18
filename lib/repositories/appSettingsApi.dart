import 'package:project/helper/utils/generalImports.dart';

Future getAppSettings({required BuildContext context}) async {
  try {
    var response = await sendApiRequest(
        apiName: ApiAndParams.apiAppSettings,
        params: {},
        isPost: false,
        context: context);
    print(json.decode(response));
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
