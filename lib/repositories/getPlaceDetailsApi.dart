import 'package:project/helper/utils/generalImports.dart';
Future<Map<String, dynamic>> getPlaceDetailsApi({
  required BuildContext context,
  required String placeId,
}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiGooglePlacesDetails,
      params: {ApiAndParams.placeId: placeId, ApiAndParams.source: Constant.appKey},
      isPost: false,
      context: context,
    );

    return json.decode(response);
  } catch (e, stackTrace) {
    debugPrint("Error in getPlaceDetailsApi: $e");
    debugPrint(stackTrace.toString());

    return {
      "success": false,
      "message": e.toString(),
    };
  }
}
