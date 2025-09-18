import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/liveOrderTrackingApi.dart';

enum LiveOrderTrackingState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class LiveOrderTrackingProvider extends ChangeNotifier {
  LiveOrderTrackingState liveOrderTrackingState =
      LiveOrderTrackingState.initial;
  String message = '';
  late LiveOrderTrackingData liveOrderTrackingData;

  double deliveryBoyLatitude = 0;
  double deliveryBoyLongitude = 0;

  Future getLiveOrderTrackingApiProvider(
      {required Map<String, String> params,
      required BuildContext context}) async {
    if (deliveryBoyLatitude == 0 && deliveryBoyLongitude == 0) {
      liveOrderTrackingState = LiveOrderTrackingState.loading;
      notifyListeners();
    }

    try {
      Map<String, dynamic> data =
          await getLiveOrderTrackingDataApi(context: context, params: params);
      if (data[ApiAndParams.status].toString() == "1") {
        liveOrderTrackingData =
            LiveOrderTrackingData.fromJson(data[ApiAndParams.data]);
        deliveryBoyLatitude =
            liveOrderTrackingData.latitude.toString().toDouble;
        deliveryBoyLongitude =
            liveOrderTrackingData.longitude.toString().toDouble;

        if (liveOrderTrackingData.latitude.toString().toDouble == 0 &&
            liveOrderTrackingData.longitude.toString().toDouble == 0) {
          message = Constant.somethingWentWrong;
          liveOrderTrackingState = LiveOrderTrackingState.empty;
          notifyListeners();
        } else {
          liveOrderTrackingState = LiveOrderTrackingState.loaded;
          notifyListeners();
        }
      } else {
        message = Constant.somethingWentWrong;
        liveOrderTrackingState = LiveOrderTrackingState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      liveOrderTrackingState = LiveOrderTrackingState.error;
      notifyListeners();
    }
  }
}
