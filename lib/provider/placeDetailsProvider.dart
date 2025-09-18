import 'package:flutter/material.dart';
import 'package:project/helper/utils/apiAndParams.dart';
import 'package:project/helper/utils/constant.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/PlaceDetailsModel.dart';
import 'package:project/repositories/getPlaceDetailsApi.dart';

enum PlaceDetailsState {
  initial,
  loading,
  loaded,
  error,
}

class PlaceDetailsProvider extends ChangeNotifier {
  PlaceDetailsState placeDetailsState = PlaceDetailsState.initial;
  PlaceDetailsModel? placeDetails;
  String message = '';

  Future<void> fetchPlaceDetails({
    required BuildContext context,
    required String placeId,
  }) async {
    placeDetailsState = PlaceDetailsState.loading;
    placeDetails = null;
    message = '';
    notifyListeners();

    try {
      final sessionManager = context.read<SessionManager>();
      // 1. Try from cache first
      if (Constant.placeSelectionMap.containsKey(placeId)) {
        placeDetails = Constant.placeSelectionMap[placeId];
        if (placeDetails != null) {
          placeDetailsState = PlaceDetailsState.loaded;
          notifyListeners();
          return;
        }
      }else{
      // 2. If not cached, call API
      final response = await getPlaceDetailsApi(
        context: context,
        placeId: placeId,
      );

      if (response[ApiAndParams.error] == true) {
        message = response[ApiAndParams.message] ?? Constant.somethingWentWrong;
        placeDetailsState = PlaceDetailsState.error;
      } else {
        placeDetails = PlaceDetailsModel.fromJson(response[ApiAndParams.data]);
        placeDetailsState = PlaceDetailsState.loaded;
        // Save in Constant & session
          Constant.placeSelectionMap[placeId] = placeDetails!;
          await sessionManager.savePlaceDetails();
      }
      }
    } catch (e) {
      message = e.toString();
      placeDetailsState = PlaceDetailsState.error;
    }

    notifyListeners();
  }

  void clearDetails() {
    placeDetails = null;
    message = '';
    placeDetailsState = PlaceDetailsState.initial;
    notifyListeners();
  }
}
