import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getCityByLatLongApi({
  required BuildContext context,
  required Map<String, dynamic> params,
}) async {
  try {
    var response = await sendApiRequest(
      apiName: ApiAndParams.apiCity,
      params: params,
      isPost: false,
      context: context,
    );

    return json.decode(response);
  } catch (e, stackTrace) {
    debugPrint("Error in getCityByLatLongApi: $e");
    debugPrint(stackTrace.toString());

    // Returning an empty map or custom error response
    return {
      "success": false,
      "message": "Something went wrong. Please try again.",
      "error": e.toString(),
    };
  }
}

