import 'package:project/helper/utils/generalImports.dart';

Future getLiveOrderTrackingDataApi({
  required BuildContext context,
  required Map<String, String> params,
}) async {
  try {
    var response = await sendApiRequest(
        apiName: ApiAndParams.apiLiveTracking,
        params: params,
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
