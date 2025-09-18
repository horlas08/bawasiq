import 'package:project/helper/utils/generalImports.dart';

enum BrandState {
  initial,
  loading,
  loadingMore,
  loaded,
  empty,
  error,
}

class BrandListProvider extends ChangeNotifier {
  BrandState brandState = BrandState.initial;
  String message = '';
  List<BrandItem> brands = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getBrandApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    try {
      if (offset == 0) {
        brandState = BrandState.loading;
        notifyListeners();
      } else {
        brandState = BrandState.loadingMore;
        notifyListeners();
      }

      params[ApiAndParams.limit] =
          "${Constant.defaultDataLoadLimitAtOnce + 20}";
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> brandData =
          await getBrandList(context: context, params: params);

      if (brandData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(brandData[ApiAndParams.total].toString());
        List<BrandItem> tempBrands = List.from(brandData[ApiAndParams.data])
            .map((e) => BrandItem.fromJson(e))
            .toList();

        brands.addAll(tempBrands);

        hasMoreData = totalData > brands.length;
        if (hasMoreData) {
          offset += (Constant.defaultDataLoadLimitAtOnce + 20);
        }

        brandState = BrandState.loaded;
        notifyListeners();
      } else {
        message = brandData[ApiAndParams.status];
        brandState = BrandState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      brandState = BrandState.error;
      notifyListeners();
      rethrow;
    }
  }
}
