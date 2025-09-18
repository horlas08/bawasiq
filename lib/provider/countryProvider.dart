import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/countryApi.dart';

enum CountryState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class CountryProvider extends ChangeNotifier {
  CountryState countryState = CountryState.initial;
  String message = '';
  List<CountryItem> countries = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getCountryProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      countryState = CountryState.loading;
    } else {
      countryState = CountryState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getCountryApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());
        List<CountryItem> tempCountries = (getData['data'] as List)
            .map((e) => CountryItem.fromJson(Map.from(e)))
            .toList();

        countries.addAll(tempCountries);

        hasMoreData = totalData > countries.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        countryState = CountryState.loaded;
        notifyListeners();
      } else {
        countryState = CountryState.error;
        message = getData[ApiAndParams.message].toString();
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      countryState = CountryState.error;
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
