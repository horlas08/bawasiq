import 'package:project/helper/utils/generalImports.dart';

Future getRatingsList(
    {required BuildContext context,
    required Map<String, String> params}) async {
  try {
    var response = await sendApiRequest(
        apiName: ApiAndParams.apiRatingsList,
        params: params,
        isPost: false,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getRatingsAddUpdate({
  required BuildContext context,
  required Map<String, String> params,
  required List<String> fileParamsNames,
  required List<String> fileParamsFilesPath,
  required bool isAdd,
}) async {
  try {
    var response = await sendApiMultiPartRequest(
        apiName:
            isAdd ? ApiAndParams.apiRatingAdd : ApiAndParams.apiRatingUpdate,
        params: params,
        fileParamsFilesPath: fileParamsFilesPath,
        fileParamsNames: fileParamsNames,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}

Future getRatingsImages({
  required BuildContext context,
  required Map<String, String> params,
}) async {
  try {
    var response = await sendApiRequest(
        apiName: ApiAndParams.apiRatingImages,
        params: params,
        isPost: true,
        context: context);
    return json.decode(response);
  } catch (e) {
    rethrow;
  }
}
