import 'package:project/helper/utils/generalImports.dart';
Future<Map<String, dynamic>> getPlaceSuggestionsApi({
  required BuildContext context,
  required String input,
}) async {
  try {

    var response = await sendApiRequest(
      apiName: ApiAndParams.apiGooglePlacesAutocomplete,
      params: {ApiAndParams.input:input, ApiAndParams.source: Constant.appKey},
      isPost: false,
      context: context,
    );
    return json.decode(response);

  } catch (e) {
    debugPrint("Error in getPlaceSuggestionsApi: $e");
    return {
      "error": true,
      "message": e.toString(),
    };
  }
}
