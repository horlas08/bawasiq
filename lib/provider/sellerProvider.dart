import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/sellerApi.dart';

enum SellerState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class SellerListProvider extends ChangeNotifier {
  SellerState sellerState = SellerState.initial;
  String message = '';
  List<SellerItem> sellers = [];

  getSellerApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    sellerState = SellerState.loading;
    notifyListeners();
    try {
      Map<String, dynamic> sellerData =
          await getSellerList(context: context, params: params);

      if (sellerData[ApiAndParams.status].toString() == "1") {
        sellers = List.from(sellerData[ApiAndParams.data])
            .map((e) => SellerItem.fromJson(e))
            .toList();

        sellerState = SellerState.loaded;
        notifyListeners();
      } else {
        message = sellerData[ApiAndParams.message].toString();
        sellerState = SellerState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      sellerState = SellerState.error;
      notifyListeners();
      rethrow;
    }
  }
}
