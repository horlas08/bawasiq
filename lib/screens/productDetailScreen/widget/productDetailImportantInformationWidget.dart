import 'package:project/helper/utils/generalImports.dart';


Widget ProductDetailImportantInformationWidget(
  BuildContext context,
  ProductData product,
) {
  String productType = product.indicator.toString();
  String cancelableStatus = product.cancelableStatus.toString();
  String returnStatus = product.returnStatus.toString();
  return Container(
    padding: EdgeInsetsDirectional.all(10),
    margin: EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
    decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
    child: Column(
      children: [
        if (productType != "null" && productType != "0")
          Row(
            children: [
              defaultImg(
                height: 22,
                width: 22,
                image: productType == "1"
                    ? AppAssets.productVegIndicatorIcon
                    : AppAssets.productNonVegIndicatorIcon,
              ),
              getSizedBox(width: 10),
              CustomTextLabel(
                jsonKey: productType == "1" ? vegetarianLabel : nonVegetarianLabel,
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        getSizedBox(height: Constant.size10),
        Row(
          children: [
            defaultImg(
              height: 22,
              width: 22,
              image: cancelableStatus == "1"
                  ? AppAssets.productCancellableIcon
                  : AppAssets.productNonCancellableIcon,
            ),
            getSizedBox(width: 10),
            Expanded(
              child: CustomTextLabel(
                text: (cancelableStatus == "1")
                    ? "${getTranslatedValue(context, productCancellableTillLabel)} ${Constant.getOrderActiveStatusLabelFromCode(product.tillStatus, context)}"
                    : getTranslatedValue(context, nonCancellableLabel),
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        getSizedBox(height: Constant.size10),
        Row(
          children: [
            defaultImg(
              height: 22,
              width: 22,
              image: returnStatus == "1"
                  ? AppAssets.productReturnableIcon
                  : AppAssets.productNonReturnableIcon,
            ),
            getSizedBox(width: 10),
            Expanded(
              child: CustomTextLabel(
                text: (returnStatus == "1")
                    ? "${getTranslatedValue(context, productReturnableTillLabel)} ${product.returnDays} ${getTranslatedValue(context, daysLabel)}"
                    : getTranslatedValue(context, nonReturnableLabel),
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
