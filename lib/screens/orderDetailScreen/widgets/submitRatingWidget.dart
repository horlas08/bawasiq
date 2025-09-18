import 'package:project/helper/utils/generalImports.dart';


class SubmitRatingWidget extends StatefulWidget {
  final double? size;
  final Order order;
  final int itemIndex;

  const SubmitRatingWidget({
    super.key,
    this.size,
    required this.order,
    required this.itemIndex,
  });

  @override
  State<SubmitRatingWidget> createState() => _SubmitRatingWidgetState();
}

class _SubmitRatingWidgetState extends State<SubmitRatingWidget> {
  TextEditingController productReview = TextEditingController();
  double rate = 0;
  List<String> selectedProductOtherImages = [];
  List<String> productDeletedOtherImages = [];
  List<String> fileParamsNames = [];
  List<ItemRatingImages> productRatingImages = [];
  late ItemRating ratings;

  @override
  void initState() {
    try {
      ratings = widget.order.items![widget.itemIndex].itemRating!.first;
      if (ratings.toJson().isNotEmpty) {
        productReview.text = ratings.review.toString();
        productRatingImages = ratings.images ?? [];
        rate = ratings.rate.toString().toDouble;
      } else {
        productReview.text = "";
        rate = 0.0;
      }
    } catch (e) {
      productReview.text = "";
      productRatingImages = [];
      rate = 0.0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    onRatingUpdate: (value) {
                      rate = value;
                    },
                    allowHalfRating: false,
                    initialRating: rate,
                    glow: false,
                    itemCount: 5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star_rounded,
                      color: ColorsRes.appColorAmber,
                    ),
                  ),
                ),
                SizedBox(height: Constant.size15),
                editBoxWidget(
                  context,
                  productReview,
                  optionalValidation,
                  getTranslatedValue(
                    context,
                    reviewLabel,
                  ),
                  getTranslatedValue(
                    context,
                    writeYourReviewsHereLabel,
                  ),
                  TextInputType.multiline,
                  optionalTextInputAction: TextInputAction.newline,
                  maxLines: 4,
                  minLines: 1,
                ),
                SizedBox(height: Constant.size15),
                CustomTextLabel(
                  jsonKey: attachmentsLabel,
                ),
                getSizedBox(height: 5),
                GestureDetector(
                  onTap: () async {
                    await hasStoragePermissionGiven().then(
                      (value) async {
                        if (await Permission.storage.isGranted ||
                            await Permission.storage.isLimited ||
                            await Permission.photos.isGranted ||
                            await Permission.photos.isLimited) {
                          ImagePicker().pickMultiImage().then(
                            (value) {
                              for (int i = 0; i < value.length; i++) {
                                selectedProductOtherImages
                                    .add(value[i].path.toString());
                                fileParamsNames.add("image[$i]");
                              }
                              setState(() {});
                            },
                          );
                        } else if (await Permission
                            .storage.isPermanentlyDenied) {
                          if (!Constant.session.getBoolData(SessionManager
                              .keyPermissionGalleryHidePromptPermanently)) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    PermissionHandlerBottomSheet(
                                      titleJsonKey: storagePermissionTitleLabel,
                                      messageJsonKey:
                                          storagePermissionMessageLabel,
                                      sessionKeyForAskNeverShowAgain: SessionManager
                                          .keyPermissionGalleryHidePromptPermanently,
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    );
                  },
                  child: DottedBorder(
                    /* dashPattern: [5],
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    color: ColorsRes.subTitleMainTextColor,
                    radius: Radius.circular(10),
                    borderType: BorderType.RRect, */
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: [5],
                      strokeWidth: 2,
                      radius: Radius.circular(10),
                      color: ColorsRes.subTitleMainTextColor,
                      // padding: EdgeInsets.all(16),
                    ),
                    child: Container(
                      height: 100,
                      color: ColorsRes.appColorTransparent,
                      padding: EdgeInsetsDirectional.all(10),
                      child: Center(
                        child: Column(
                          children: [
                            defaultImg(
                              image: AppAssets.uploadIcon,
                              iconColor: ColorsRes.subTitleMainTextColor,
                              height: 40,
                              width: 40,
                            ),
                            CustomTextLabel(
                              jsonKey: uploadImagesHereLabel,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorsRes.subTitleMainTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                getSizedBox(height: 15),
                if (selectedProductOtherImages.isNotEmpty)
                  CustomTextLabel(
                    jsonKey: newAttachmentsLabel,
                  ),
                if (selectedProductOtherImages.isNotEmpty)
                  getSizedBox(height: 5),
                if (selectedProductOtherImages.isNotEmpty)
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      runSpacing: 15,
                      spacing: constraints.maxWidth * 0.05,
                      children: List.generate(
                        selectedProductOtherImages.length,
                        (index) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorsRes.subTitleMainTextColor,
                                ),
                                color: Theme.of(context).cardColor,
                              ),
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxWidth * 0.3,
                              child: Center(
                                child: imgWidget(
                                  fileName: selectedProductOtherImages[index],
                                  width: 105,
                                  height: 105,
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              end: -10,
                              top: -10,
                              child: IconButton(
                                onPressed: () {
                                  selectedProductOtherImages.removeAt(index);
                                  fileParamsNames.removeAt(index);
                                  setState(() {});
                                },
                                icon: CircleAvatar(
                                  backgroundColor: ColorsRes.appColorRed,
                                  maxRadius: 10,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: ColorsRes.appColorWhite,
                                    size: 15,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                getSizedBox(height: 15),
                if (productRatingImages.isNotEmpty)
                  CustomTextLabel(
                    jsonKey: existAttachmentsLabel,
                  ),
                if (productRatingImages.isNotEmpty) getSizedBox(height: 5),
                if (productRatingImages.isNotEmpty)
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      runSpacing: 15,
                      spacing: constraints.maxWidth * 0.05,
                      children: List.generate(
                        productRatingImages.length,
                        (index) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsRes.subTitleMainTextColor,
                                  ),
                                  color: Theme.of(context).cardColor),
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxWidth * 0.3,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: Constant.borderRadius10,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: setNetworkImg(
                                    image: productRatingImages[index]
                                        .imageUrl
                                        .toString(),
                                    width: 110,
                                    height: 110,
                                    boxFit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              end: -10,
                              top: -10,
                              child: IconButton(
                                onPressed: () {
                                  productDeletedOtherImages.add(
                                    productRatingImages[index].id.toString(),
                                  );
                                  productRatingImages.removeAt(index);
                                  setState(() {});
                                },
                                icon: CircleAvatar(
                                  backgroundColor: ColorsRes.appColorRed,
                                  maxRadius: 10,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: ColorsRes.appColorWhite,
                                    size: 15,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                getSizedBox(height: 15),
              ],
            ),
          ),
        ),
        Consumer<RatingListProvider>(builder: (context, ratingListProvider, _) {
          return gradientBtnWidget(
            context,
            10,
            callback: () {
              try {
                if (productReview.text.toString().isNotEmpty) {
                  Map<String, String> params = {
                    ApiAndParams.rate: rate.toString(),
                    ApiAndParams.review: productReview.text.toString(),
                  };

                  if (widget
                          .order.items![widget.itemIndex].itemRating!.isEmpty ||
                      widget.order.items?[widget.itemIndex].itemRating ==
                          null) {
                    params[ApiAndParams.productId] = widget
                            .order.items?[widget.itemIndex].productId
                            .toString() ??
                        "";
                  } else {
                    params[ApiAndParams.id] = widget
                            .order.items?[widget.itemIndex].itemRating?.first.id
                            .toString() ??
                        "";
                  }

                  if (productDeletedOtherImages.isNotEmpty) {
                    params[ApiAndParams.deleteImageIds] =
                        productDeletedOtherImages.toList().toString();
                  }

                  ratingListProvider
                      .addOrUpdateRating(
                    context: context,
                    fileParamsFilesPath: selectedProductOtherImages,
                    fileParamsNames: fileParamsNames,
                    params: params,
                    isAdd: (widget.order.items![widget.itemIndex].itemRating!
                                .isEmpty ||
                            widget.order.items?[widget.itemIndex].itemRating ==
                                null)
                        ? true
                        : false,
                  )
                      .then((value) {
                    if (value is ItemRating) {
                      Navigator.pop(context, value);
                    } else {
                      Navigator.pop(context, null);
                    }
                  });
                } else {
                  showMessage(
                      context,
                      getTranslatedValue(context, reviewShouldNotEmptyLabel),
                      MessageType.error);
                }
              } catch (e) {
                showMessage(context, e.toString(), MessageType.error);
              }
            },
            otherWidgets: ratingListProvider.ratingAddUpdateState ==
                    RatingAddUpdateState.loading
                ? Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: ColorsRes.appColorWhite,
                    ),
                  )
                : CustomTextLabel(
                    jsonKey: (widget.order.items![widget.itemIndex].itemRating!
                                .isEmpty ||
                            widget.order.items?[widget.itemIndex].itemRating ==
                                null)
                        ? addLabel
                        : updateLabel,
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          );
        }),
        SizedBox(height: Constant.size15),
      ],
    );
  }

  imgWidget({required String fileName, double? height, double? width}) {
    return GestureDetector(
      onTap: () {
        try {
          OpenFilex.open(fileName);
        } catch (e) {
          showMessage(context, e.toString(), MessageType.error);
        }
      },
      child: fileName.split(".").last == "pdf"
          ? Center(
              child: defaultImg(
                image: AppAssets.pdfIcon,
                height: 50,
                width: 50,
              ),
            )
          : ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image(
                image: FileImage(
                  File(
                    fileName,
                  ),
                ),
                width: width ?? 90,
                height: height ?? 90,
                fit: BoxFit.fill,
              ),
            ),
    );
  }
}
