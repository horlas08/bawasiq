import 'package:project/helper/utils/generalImports.dart';

enum CategoryState {
  initial,
  loading,
  loadingMore,
  loaded,
  empty,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<CategoryItem> categories = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    params[ApiAndParams.limit] =
        (Constant.defaultDataLoadLimitAtOnce + 20).toString();
    params[ApiAndParams.offset] = offset.toString();

    if (offset == 0) {
      categoryState = CategoryState.loading;
      notifyListeners();
    } else {
      categoryState = CategoryState.loadingMore;
      notifyListeners();
    }
    try {
      Map<String, dynamic> categoryData =
          await getCategoryList(context: context, params: params);

      if (categoryData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(categoryData[ApiAndParams.total].toString());
        List<CategoryItem> tempCategories =
            List.from(categoryData[ApiAndParams.data])
                .map((e) => CategoryItem.fromJson(e))
                .toList();

        categories.addAll(tempCategories);

        hasMoreData = totalData > categories.length;
        if (hasMoreData) {
          offset += (Constant.defaultDataLoadLimitAtOnce + 20);
        }

        categoryState = CategoryState.loaded;
        notifyListeners();
      } else {
        message = categoryData[ApiAndParams.message];
        categoryState = CategoryState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      notifyListeners();
      rethrow;
    }
  }
}
