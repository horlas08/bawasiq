import 'package:project/helper/utils/generalImports.dart';

enum UpdateOrderStatus { initial, inProgress, success, failure }

class UpdateOrderStatusProvider extends ChangeNotifier {
  UpdateOrderStatus _updateOrderStatus = UpdateOrderStatus.initial;
  String errorMessage = "";

  UpdateOrderStatus getUpdateOrderStatus() {
    return _updateOrderStatus;
  }

  Future updateStatus({
    required Order order,
    String? orderItemId,
    required String status,
    required String reason,
    required BuildContext context,
    required String from,
  }) async {
    try {
      _updateOrderStatus = UpdateOrderStatus.inProgress;
      notifyListeners();

      late PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {
        "order_id": order.id.toString(),
        "order_item_id": orderItemId ?? "",
        "status": status,
        "device_type": Platform.isAndroid
            ? "android"
            : Platform.isIOS
                ? "ios"
                : "other",
        "app_version": packageInfo.version.toString(),
      };

      if (from == "cancel") {
        params["cancellation_reason"] = reason;
      } else if (from == "return") {
        params["reason"] = reason;
      }

      if (orderItemId == null) {
        params.remove("order_item_id");
      }

      Map<String, dynamic> result = await updateOrderStatus(
        params: params,
        context: context,
      );

      showMessage(
        context,
        result[ApiAndParams.message],
        result[ApiAndParams.status].toString() == "1"
            ? MessageType.success
            : MessageType.warning,
      );

      if (result[ApiAndParams.status].toString() == "1") {
        _updateOrderStatus = UpdateOrderStatus.success;
        notifyListeners();
        return true;
      } else {
        _updateOrderStatus = UpdateOrderStatus.failure;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      showMessage(
        context,
        errorMessage,
        MessageType.error,
      );
      _updateOrderStatus = UpdateOrderStatus.failure;
      notifyListeners();
      return false;
    }
  }
}