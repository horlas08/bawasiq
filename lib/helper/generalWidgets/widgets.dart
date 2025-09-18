import 'package:project/helper/utils/generalImports.dart';

Widget gradientBtnWidget(BuildContext context, double borderRadius,
    {required Function callback,
    String title = "",
    Widget? otherWidgets,
    double? height,
    double? width,
    Color? color1,
    Color? color2}) {
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: Container(
      height: height ?? 45,
      width: width,
      alignment: Alignment.center,
      decoration: DesignConfig.boxGradient(
        borderRadius,
        color1: color1,
        color2: color2,
      ),
      child: otherWidgets ??= CustomTextLabel(
        text: title,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
            color: ColorsRes.mainIconColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500)),
      ),
    ),
  );
}

getDarkLightIcon({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? isActive,
}) {
  String dark =
      (Constant.session.getBoolData(SessionManager.isDarkTheme)) == true
          ? "_dark"
          : "";
  String active = (isActive ??= false) == true ? "_active" : "";

  return defaultImg(
      height: height,
      width: width,
      image: "$image$active${dark}${AppAssets.icon}",
      iconColor: iconColor,
      boxFit: boxFit,
      padding: padding);
}

List getHomeBottomNavigationBarIcons({required bool isActive}) {
  return [
    getDarkLightIcon(
        image: "home",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "category",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "wishlist",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "profile",
        isActive: isActive,
        padding: EdgeInsetsDirectional.zero),
  ];
}

Widget setNetworkImg({
  double? height,
  double? width,
  String image = AppAssets.placeholderIcon,
  Color? iconColor,
  BoxFit? boxFit,
  BorderRadius? borderRadius,
}) {
  if (image.trim().isNotEmpty && !image.contains("http")) {
    image = "${Constant.hostUrl}storage/$image";
  }

  return image.trim().isEmpty
      ? defaultImg(
          image: AppAssets.placeholderIcon,
          height: height,
          width: width,
          boxFit: boxFit,
        )
      : Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: CachedNetworkImageProvider(image),
              fit: boxFit,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: image,
            height: height,
            width: width,

            fit: boxFit,
            placeholderFadeInDuration: Duration(milliseconds: 300),
            placeholder: (context, url) => defaultImg(
              image: AppAssets.placeholderIcon,
              boxFit: boxFit,
              height: 100,
              width: 100
            ),
            errorWidget: (context, _, __) =>
                const Icon(Icons.broken_image, size: 40),
          ),
        );
}

Widget defaultImg({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? requiredRTL = true,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.all(0),
    child: (image.contains("png") ||
            image.contains("jpeg") ||
            image.contains("jpg"))
        ? Image.asset(Constant.getAssetsPath(0, image))
        : SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          ),
  );
}

Widget getSizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: child,
  );
}

Widget getDivider(
    {Color? color,
    double? endIndent,
    double? height,
    double? indent,
    double? thickness}) {
  return Divider(
    color: color ?? ColorsRes.subTitleMainTextColor,
    endIndent: endIndent ?? 0,
    indent: indent ?? 0,
    height: height,
    thickness: thickness,
  );
}

Widget getLoadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: ColorsRes.appColorTransparent,
    color: ColorsRes.appColor,
    strokeWidth: 2,
  );
}

// CategorySimmer
Widget getCategoryShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// CategorySimmer
Widget getRatingPhotosShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getBrandShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getSellerShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

AppBar getAppBar(
    {required BuildContext context,
    bool? centerTitle,
    required Widget title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    GestureTapCallback? onTap}) {
  return AppBar(
    leading: showBackButton ?? true
        ? GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              color: ColorsRes.appColorTransparent,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: SizedBox(
                  child: defaultImg(
                    boxFit: BoxFit.contain,
                    image: AppAssets.icArrowBackIcon,
                    iconColor: ColorsRes.mainTextColor,
                  ),
                  height: 10,
                  width: 10,
                ),
              ),
            ),
          )
        : null,
    automaticallyImplyLeading: true,
    elevation: 0,
    titleSpacing: 0,
    title: Row(
      children: [
        if (showBackButton == false || !Navigator.of(context).canPop())
          getSizedBox(
            width: 10,
          ),
        Expanded(child: title),
      ],
    ),
    centerTitle: centerTitle ?? false,
    surfaceTintColor: ColorsRes.appColorTransparent,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    actions: actions ?? [],
  );
}

Widget getProductListShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : Column(
          children: List.generate(20, (index) {
            return const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: CustomShimmer(
                width: double.maxFinite,
                height: 125,
              ),
            );
          }),
        );
}

Widget getProductItemShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 2,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
}

//Search widgets for the multiple screen
Widget getSearchWidget({
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, productSearchScreen);
    },
    child: Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: ListTile(
                dense: true,
                title: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText:
                        getTranslatedValue(context, productSearchHintLabel),
                    hintStyle: TextStyle(
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                    iconColor: ColorsRes.subTitleMainTextColor,
                  ),
                ),
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.search,
                    color: ColorsRes.subTitleMainTextColor,
                  ),
                  onPressed: null,
                ),
                trailing: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: defaultImg(
                    image: AppAssets.voiceSearchIcon,
                    height: 24,
                    iconColor: ColorsRes.subTitleMainTextColor,
                    width: 24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: Constant.size10),
          ChangeNotifierProvider<ProductDetailProvider>(
            create: (context) => ProductDetailProvider(),
            builder: (context, child) {
              return GestureDetector(
                onTap: () async {
                  print("Tapped");
                  await hasCameraPermissionGiven(context).then(
                    (value) async {
                      if (value.isGranted) {
                        Navigator.pushNamed(context, barCodeScanner).then(
                          (value) {
                            if (value != "-1" && value != null) {
                              Navigator.pushNamed(
                                context,
                                productDetailScreen,
                                arguments: [
                                  value.toString(),
                                  getTranslatedValue(
                                      navigatorKey.currentContext!,
                                      appNameLabel),
                                  null,
                                  "barcode",
                                ],
                              );
                            }
                          },
                        );
                        /*
                          if (value != "-1") {
                            Navigator.pushNamed(
                              context,
                              productDetailScreen,
                              arguments: [
                                value.toString(),
                                getTranslatedValue(
                                    navigatorKey.currentContext!,
                                    appNameLabel),
                                null,
                                "barcode",
                              ],
                            );
                          }
                        */
                      } else if (value.isDenied) {
                        await Permission.camera.request();
                      } else if (value.isPermanentlyDenied) {
                        if (!Constant.session.getBoolData(SessionManager
                            .keyPermissionCameraHidePromptPermanently)) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  PermissionHandlerBottomSheet(
                                    titleJsonKey: cameraPermissionTitleLabel,
                                    messageJsonKey:
                                        cameraPermissionMessageLabel,
                                    sessionKeyForAskNeverShowAgain: SessionManager
                                        .keyPermissionCameraHidePromptPermanently,
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
                child: Container(
                  decoration: DesignConfig.boxGradient(10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: defaultImg(
                    image: AppAssets.barcodeScannerIcon,
                    iconColor: ColorsRes.appColorWhite,
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget setRefreshIndicator(
    {required RefreshCallback refreshCallback, required Widget child}) {
  return RefreshIndicator(
    onRefresh: refreshCallback,
    child: child,
    backgroundColor: ColorsRes.appColorTransparent,
    color: ColorsRes.appColor,
    triggerMode: RefreshIndicatorTriggerMode.anywhere,
  );
}

Widget setNotificationIcon({required BuildContext context}) {
  return IconButton(
    onPressed: () {
      Navigator.pushNamed(context, notificationListScreen);
    },
    icon: defaultImg(
      image: AppAssets.notificationIcon,
      iconColor: ColorsRes.appColor,
    ),
  );
}

Widget getOverallRatingSummary(
    {required BuildContext context,
    required ProductRatingData productRatingData,
    required String totalRatings}) {
  return Row(
    children: [
      Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsRes.appColor,
            maxRadius: 45,
            minRadius: 20,
            child: CustomTextLabel(
              text: "${productRatingData.averageRating.toString().toDouble}",
              style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          getSizedBox(height: 10),
          CustomTextLabel(
            text:
                "${getTranslatedValue(context, ratingLabel)}\n${totalRatings.toString().toInt}",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Container(
        margin: EdgeInsetsDirectional.only(start: 20, end: 20),
        color: ColorsRes.subTitleMainTextColor,
        height: 165,
        width: 0.7,
      ),
      Expanded(
        child: Column(
          children: [
            PercentageWiseRatingBar(
              context: context,
              index: 4,
              totalRatings: productRatingData.fiveStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fiveStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 3,
              totalRatings: productRatingData.fourStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fourStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 2,
              totalRatings: productRatingData.threeStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.threeStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 1,
              totalRatings: productRatingData.twoStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.twoStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 0,
              totalRatings: productRatingData.oneStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.oneStarRating.toString().toInt,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget PercentageWiseRatingBar({
  required double ratingPercentage,
  required int totalRatings,
  required int index,
  required BuildContext context,
}) {
  return Column(
    children: [
      Row(
        children: [
          CustomTextLabel(
            text: "${index + 1}",
          ),
          getSizedBox(width: 5),
          Icon(
            Icons.star_rounded,
            color: ColorsRes.appColorAmber,
          ),
          getSizedBox(width: 5),
          Expanded(
            child: Container(
              height: 5,
              width: context.width * 0.4,
              decoration: BoxDecoration(
                color: ColorsRes.mainTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 5,
                  width: (context.width * 0.34) * ratingPercentage,
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          getSizedBox(width: 10),
          CustomTextLabel(
            text: "$totalRatings",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      getSizedBox(height: 10),
    ],
  );
}

double calculatePercentage(
    {required int totalRatings, required int starsWiseRatings}) {
  double percentage = 0.0;

  percentage = (starsWiseRatings * 100) / totalRatings;
  return percentage / 100;
}

Widget getRatingReviewItem({required ProductRatingList rating}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(
              start: 5,
            ),
            decoration: BoxDecoration(
              color: ColorsRes.appColor,
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                CustomTextLabel(
                  text: rating.rate,
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.star_rate_rounded,
                  color: ColorsRes.appColorAmber,
                  size: 20,
                )
              ],
            ),
          ),
          getSizedBox(width: 7),
          CustomTextLabel(
            text: rating.user?.name.toString() ?? "",
            style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 15),
            softWrap: true,
          )
        ],
      ),
      getSizedBox(height: 10),
      if (rating.review.toString().length > 100)
        ExpandableText(
          text: rating.review.toString(),
          max: 0.2,
          color: ColorsRes.subTitleMainTextColor,
        ),
      if (rating.review.toString().length <= 100)
        CustomTextLabel(
          text: rating.review.toString(),
          style: TextStyle(
            color: ColorsRes.subTitleMainTextColor,
          ),
        ),
      getSizedBox(height: 10),
      if (rating.images != null && rating.images!.length > 0)
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            runSpacing: 10,
            spacing: constraints.maxWidth * 0.017,
            children: List.generate(
              rating.images!.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, fullScreenProductImageScreen, arguments: [
                      index,
                      rating.images?.map((e) => e.imageUrl.toString()).toList()
                    ]);
                  },
                  child: ClipRRect(
                    borderRadius: Constant.borderRadius2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      image: rating.images?[index].imageUrl ?? "",
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      getSizedBox(height: 10),
      CustomTextLabel(
        text: rating.updatedAt.toString().formatDate(),
        style: TextStyle(
          color: ColorsRes.subTitleMainTextColor,
        ),
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget CheckoutShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CustomShimmer(
        margin: EdgeInsetsDirectional.all(Constant.size10),
        borderRadius: 7,
        width: double.maxFinite,
        height: 150,
      ),
      const CustomShimmer(
        width: 250,
        height: 25,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            10,
            (index) {
              return const CustomShimmer(
                width: 50,
                height: 80,
                borderRadius: 10,
                margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              );
            },
          ),
        ),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: 250,
        height: 25,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
    ],
  );
}

Widget DeliveryChargeShimmer() {
  return Padding(
    padding: EdgeInsets.all(Constant.size10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 20,
                width: 80,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 22,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 22,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
      ],
    ),
  );
}

Widget DashedDivider({Color? color, double? height}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      const dashWidth = 5.0;
      final dashHeight = height;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: color ?? ColorsRes.subTitleMainTextColor),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );
}

Widget getHomeScreenShimmer(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: Constant.size10, horizontal: Constant.size10),
    child: Column(
      children: [
        CustomShimmer(
          height: context.height * 0.26,
          width: context.width,
        ),
        getSizedBox(
          height: Constant.size10,
        ),
        CustomShimmer(
          height: Constant.size10,
          width: context.width,
        ),
        getSizedBox(
          height: Constant.size10,
        ),
        getCategoryShimmer(
            context: context, count: 6, padding: EdgeInsets.zero),
        getSizedBox(
          height: Constant.size10,
        ),
        Column(
          children: List.generate(5, (index) {
            return Column(
              children: [
                const CustomShimmer(height: 50),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Constant.size10,
                            horizontal: Constant.size5),
                        child: CustomShimmer(
                          height: 210,
                          width: context.width * 0.4,
                        ),
                      );
                    }),
                  ),
                )
              ],
            );
          }),
        )
      ],
    ),
  );
}

Widget ProductListViewListingWidget({required List<ProductListItem> products}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      products.length,
      (index) {
        return ProductListItemContainer(product: products[index]);
      },
    ),
  );
}

Widget ProductGridViewListingWidget({required List<ProductListItem> products}) {
  return GridView.builder(
    itemCount: products.length,
    padding: EdgeInsetsDirectional.only(
        start: Constant.size10,
        end: Constant.size10,
        bottom: Constant.size10,
        top: Constant.size5),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return ProductGridItemContainer(product: products[index]);
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 0.55,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
  );
}

Widget ProductWidget({VoidCallback? voidCallBack, required String from}) {
  return Consumer<ProductListProvider>(
    builder: (context, productListProvider, _) {
      List<ProductListItem> products = productListProvider.products;
      if (productListProvider.productState == ProductState.initial ||
          productListProvider.productState == ProductState.loading) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productListProvider.productState == ProductState.loaded ||
          productListProvider.productState == ProductState.loadingMore) {
        return Column(
          children: [
            (context
                            .read<ProductChangeListingTypeProvider>()
                            .getListingType() ==
                        true &&
                    from == "product_listing")
                ? /* GRID VIEW UI */ ProductGridViewListingWidget(
                    products: products)
                : /* LIST VIEW UI */ ProductListViewListingWidget(
                    products: products),
            if (productListProvider.productState == ProductState.loadingMore)
              getProductItemShimmer(
                  context: context,
                  isGrid: context
                      .read<ProductChangeListingTypeProvider>()
                      .getListingType()),
            if (context.watch<CartProvider>().totalItemsCount > 0)
              getSizedBox(height: 65),
          ],
        );
      } else if (productListProvider.productState == ProductState.empty &&
          from == "product_listing") {
        return DefaultBlankItemMessageScreen(
          title: emptyProductListMessageLabel,
          description: emptyProductListDescriptionLabel,
          image: "no_product_icon",
        );
      } else if (from != "product_listing") {
        return Container();
      } else {
        return NoInternetConnectionScreen(
          height: context.height * 0.65,
          message: productListProvider.message,
          callback: voidCallBack,
        );
      }
    },
  );
}

getDefaultPinTheme() {
  PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

getFocusedPinTheme() {
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ).copyDecorationWith(
    border: Border.all(color: ColorsRes.mainTextColor),
    borderRadius: BorderRadius.circular(10),
  );
}

getSubmittedPinTheme(BuildContext context) {
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ).copyWith(
    decoration: PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: ColorsRes.mainTextColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsRes.mainTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ).decoration?.copyWith(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: ColorsRes.appColor,
          ),
        ),
  );
}

Widget otpPinWidget(
    {required BuildContext context,
    required TextEditingController pinController,
    VoidCallback? onCompleted}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Pinput(
      defaultPinTheme: getFocusedPinTheme(),
      focusedPinTheme: getFocusedPinTheme(),
      submittedPinTheme: getSubmittedPinTheme(context),
      /* onClipboardFound: (value) {
        pinController.setText(value);
      }, */
      controller: pinController,
      length: 6,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      hapticFeedbackType: HapticFeedbackType.heavyImpact,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.singleLineFormatter
      ],
      autofocus: true,
      closeKeyboardWhenCompleted: true,
      pinAnimationType: PinAnimationType.slide,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      animationCurve: Curves.bounceInOut,
      enableSuggestions: true,
      pinContentAlignment: AlignmentDirectional.center,
      isCursorAnimationEnabled: true,
      onCompleted: (value) {
        onCompleted?.call();
      },
    ),
  );
}
