import 'package:project/helper/utils/generalImports.dart';

import 'package:project/models/ratingImages.dart';
import 'package:project/repositories/ratingsAndReview.dart';

enum RatingState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

enum RatingImagesState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

enum RatingAddUpdateState {
  initial,
  loading,
  loaded,
  loadingMore,
  empty,
  error,
}

class RatingListProvider extends ChangeNotifier {
  RatingState ratingState = RatingState.initial;
  RatingImagesState ratingImagesState = RatingImagesState.initial;
  RatingAddUpdateState ratingAddUpdateState = RatingAddUpdateState.initial;
  String message = '';
  List<ProductRatingList> ratings = [];
  late ProductRatingData productRatingData;
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  List<String> images = [];
  int imagesOffset = 0;
  int totalImages = 0;
  bool hasMoreImages = false;

  Future getRatingApiProvider({
    required Map<String, String> params,
    required BuildContext context,
    String? limit,
  }) async {
    if (offset == 0) {
      ratingState = RatingState.loading;
    } else {
      ratingState = RatingState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          limit ?? Constant.defaultImagesLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> ratingData =
          await getRatingsList(context: context, params: params);
      if (ratingData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(ratingData[ApiAndParams.total].toString());
        ProductRating productRating = ProductRating.fromJson(ratingData);
        productRatingData = productRating.data!;

        List<ProductRatingList> tempRatings =
            productRating.data?.ratingList ?? [];

        ratings.addAll(tempRatings);

        hasMoreData = totalData > ratings.length;
        if (hasMoreData) {
          offset += Constant.defaultImagesLoadLimitAtOnce;
        }

        ratingState = RatingState.loaded;
        notifyListeners();
      } else {
        message = ratingData[ApiAndParams.message];
        ratingState = RatingState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ratingState = RatingState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future getRatingImagesApiProvider({
    required Map<String, String> params,
    required BuildContext context,
    String? limit,
  }) async {
    if (imagesOffset == 0) {
      ratingImagesState = RatingImagesState.loading;
    } else {
      ratingImagesState = RatingImagesState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] =
          limit ?? Constant.defaultImagesLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = imagesOffset.toString();

      Map<String, dynamic> ratingImages =
          await getRatingsImages(context: context, params: params);

      if (ratingImages[ApiAndParams.status].toString() == "1") {
        totalImages = int.parse(ratingImages[ApiAndParams.total].toString());
        RatingImages productRatingImages = RatingImages.fromJson(ratingImages);
        List<String> tempRatingsImages = productRatingImages.data ?? [];

        images.addAll(tempRatingsImages);

        hasMoreImages = totalImages > images.length;
        if (hasMoreImages) {
          imagesOffset += Constant.defaultImagesLoadLimitAtOnce;
        }

        ratingImagesState = RatingImagesState.loaded;
        notifyListeners();
      } else {
        message = ratingImages[ApiAndParams.message];
        ratingImagesState = RatingImagesState.empty;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ratingImagesState = RatingImagesState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future addOrUpdateRating({
    required BuildContext context,
    required List<String> fileParamsFilesPath,
    required List<String> fileParamsNames,
    required Map<String, String> params,
    required bool isAdd,
  }) async {
    ratingAddUpdateState = RatingAddUpdateState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> ratingData = await getRatingsAddUpdate(
          context: context,
          params: params,
          fileParamsFilesPath: fileParamsFilesPath,
          fileParamsNames: fileParamsNames,
          isAdd: isAdd);

      if (ratingData[ApiAndParams.status].toString() == "1") {
        ratingAddUpdateState = RatingAddUpdateState.loaded;
        notifyListeners();

        showMessage(
            context,
            getTranslatedValue(
                context,
                isAdd
                    ? ratingAddedLabel
                    : ratingUpdatedLabel),
            MessageType.success);

        return ItemRating.fromJson(ratingData[ApiAndParams.data][0]);
      } else {
        message = ratingData[ApiAndParams.message];
        showMessage(context, message, MessageType.warning);
        ratingAddUpdateState = RatingAddUpdateState.empty;
        notifyListeners();
        return null;
      }
    } catch (e) {
      message = e.toString();
      showMessage(context, message, MessageType.warning);
      ratingAddUpdateState = RatingAddUpdateState.error;
      notifyListeners();
      rethrow;
    }
  }
}
