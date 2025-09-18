/* import 'package:project/helper/utils/generalImports.dart';

enum NotificationState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class NotificationProvider extends ChangeNotifier {
  NotificationState itemsState = NotificationState.initial;
  String message = '';
  late NotificationList notificationList;
  List<NotificationListData> notifications = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getNotificationProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      itemsState = NotificationState.loading;
    } else {
      itemsState = NotificationState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getNotificationApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        notificationList = NotificationList.fromJson(getData);
        totalData = int.parse(notificationList.total);
        List<NotificationListData> tempNotifications = notificationList.data;

        notifications.addAll(tempNotifications);
      }

      if (notifications.isNotEmpty) {
        hasMoreData = totalData > notifications.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        itemsState = NotificationState.loaded;

        notifyListeners();
      } else {
        itemsState = NotificationState.error;

        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      itemsState = NotificationState.error;
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }
}
 */
import 'package:project/helper/utils/generalImports.dart';
enum NotificationState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}
class NotificationProvider extends ChangeNotifier {
  NotificationState itemsState = NotificationState.initial;
  String message = '';
  late NotificationList notificationList;
  List<NotificationListData> notifications = [];
  bool hasMoreData = true;
  int totalData = 0;
  int offset = 0;
  bool _isFetching = false; // To prevent duplicate fetches

  Future<void> getNotificationProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    if (_isFetching || !hasMoreData) return; // Prevent multiple calls
    _isFetching = true;

    if (offset == 0) {
      itemsState = NotificationState.loading;
    } else {
      itemsState = NotificationState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData = await getNotificationApi(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        notificationList = NotificationList.fromJson(getData);
        totalData = int.tryParse(notificationList.total) ?? 0;

        List<NotificationListData> tempNotifications = notificationList.data;

        notifications.addAll(tempNotifications);

        hasMoreData = notifications.length < totalData;

        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        itemsState = NotificationState.loaded;
      } else {
        hasMoreData = false;
        if (notifications.isEmpty) {
          itemsState = NotificationState.error;
        } else {
          itemsState = NotificationState.loaded;
        }
      }
    } catch (e) {
      message = e.toString();
      itemsState = NotificationState.error;
      showMessage(context, message, MessageType.warning);
    }

    _isFetching = false;
    notifyListeners();
  }
}
