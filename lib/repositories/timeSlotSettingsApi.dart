import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getTimeSlotSettingsApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiTimeSlotsSettings,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}
