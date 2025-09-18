import 'package:project/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getUserDetail(
    {required BuildContext context}) async {
      try{
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiUserDetails,
    params: {},
    isPost: false,
    context: context,
  );

  return json.decode(response);
  }catch(e){
    throw e.toString();
  }
}
