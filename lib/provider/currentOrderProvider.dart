import 'package:project/helper/utils/generalImports.dart';

enum CurrentOrderState {
  initial,
  loading,
  silentLoading,
  loaded,
  error,
}

class CurrentOrderProvider extends ChangeNotifier {
  CurrentOrderState currentOrderState = CurrentOrderState.initial;
  String message = '';

  Future getCurrentOrder(
      {required Map<String, String> params,
      required BuildContext context}) async {
    if (currentOrderState == CurrentOrderState.loaded) {
      currentOrderState = CurrentOrderState.silentLoading;
      notifyListeners();
    } else {
      currentOrderState = CurrentOrderState.loading;
      notifyListeners();
    }

    try {
      Map<String, dynamic> getCurrentOrder =
          await fetchOrders(context: context, params: params);
      if (getCurrentOrder[ApiAndParams.status].toString() == "1") {
        currentOrderState = CurrentOrderState.loaded;
        notifyListeners();
        return Order.fromJson(getCurrentOrder[ApiAndParams.data][0]);
      } else {
        showMessage(
            context, getCurrentOrder[message].toString(), MessageType.warning);
        currentOrderState = CurrentOrderState.loaded;
        notifyListeners();
        return null;
      }
    } catch (e) {
      message = e.toString();
      currentOrderState = CurrentOrderState.error;
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      return null;
    }
  }
}
