import 'package:project/helper/utils/generalImports.dart';

Widget ProductDetailAddToCartButtonWidget({
  required BuildContext context,
  required ProductData product,
  Color? bgColor,
  double? padding,
}) {
  return Container(
    color: bgColor,
    padding:
        EdgeInsetsDirectional.only(top: padding ?? 0, bottom: padding ?? 0),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: padding ?? 0),
            child: GestureDetector(
              onTap: () {
                if (product.variants.length > 1) {
                  {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      shape: DesignConfig.setRoundedBorderSpecific(20,
                          istop: true),
                      backgroundColor: Theme.of(context).cardColor,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size15,
                              end: Constant.size15,
                              top: Constant.size15,
                              bottom: Constant.size15),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size15,
                                    end: Constant.size15),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: Constant.borderRadius10,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: setNetworkImg(
                                            boxFit: BoxFit.fill,
                                            image: product.imageUrl,
                                            height: 70,
                                            width: 70)),
                                    getSizedBox(
                                      width: Constant.size10,
                                    ),
                                    Expanded(
                                      child: CustomTextLabel(
                                        text: product.name,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: ColorsRes.mainTextColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: Constant.size15,
                                    end: Constant.size15,
                                    top: Constant.size15,
                                    bottom: Constant.size15),
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: product.variants.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: RichText(
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  // maxLines: 1,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: ColorsRes
                                                              .mainTextColor,
                                                          decorationThickness:
                                                              2),
                                                      text:
                                                          "${product.variants[index].measurement} ",
                                                    ),
                                                    WidgetSpan(
                                                      child: CustomTextLabel(
                                                        text: product
                                                            .variants[index]
                                                            .stockUnitName,
                                                        softWrap: true,
                                                        //superscript is usually smaller in size
                                                        // textScaleFactor: 0.7,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ColorsRes
                                                              .mainTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text: double.parse(product
                                                                    .variants[
                                                                        index]
                                                                    .discountedPrice) !=
                                                                0
                                                            ? " | "
                                                            : "",
                                                        style: TextStyle(
                                                            color: ColorsRes
                                                                .mainTextColor)),
                                                    TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorsRes.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationThickness:
                                                              2),
                                                      text: double.parse(product
                                                                  .variants[
                                                                      index]
                                                                  .discountedPrice) !=
                                                              0
                                                          ? product
                                                              .variants[index]
                                                              .price
                                                              .currency
                                                          : "",
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                              CustomTextLabel(
                                                text: double.parse(product
                                                            .variants[index]
                                                            .discountedPrice) !=
                                                        0
                                                    ? product
                                                        .variants[index]
                                                        .discountedPrice
                                                        .currency
                                                    : product.variants[index]
                                                        .price.currency,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: ColorsRes.appColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ProductCartButton(
                                          productId: product.id.toString(),
                                          productVariantId: product
                                              .variants[index].id
                                              .toString(),
                                          count: int.parse(product
                                                      .variants[index]
                                                      .status) ==
                                                  0
                                              ? -1
                                              : int.parse(product
                                                  .variants[index].cartCount),
                                          isUnlimitedStock:
                                              product.isUnlimitedStock == "1",
                                          maximumAllowedQuantity: double.parse(
                                              product.totalAllowedQuantity
                                                  .toString()),
                                          availableStock: double.parse(
                                              product.variants[index].stock),
                                          isGrid: false,
                                          sellerId: product.sellerId.toString(),
                                          from: "product_details",
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Constant.size7),
                                      child: getDivider(
                                        color: ColorsRes.grey,
                                        height: 5,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
              child: Container(
                margin: EdgeInsetsDirectional.only(end: 10),
                decoration: BoxDecoration(
                  borderRadius: Constant.borderRadius5,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Container(
                  padding: product.variants.length > 1
                      ? EdgeInsets.zero
                      : EdgeInsets.all(5),
                  alignment: AlignmentDirectional.center,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (product.variants.length > 1) Spacer(),
                      CustomTextLabel(
                        text:
                            "${product.variants[0].measurement} ${product.variants[0].stockUnitName}",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      if (product.variants.length > 1) Spacer(),
                      if (product.variants.length > 1)
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                          child: defaultImg(
                            image: AppAssets.icDropDownIcon,
                            height: 10,
                            width: 10,
                            boxFit: BoxFit.cover,
                            iconColor: ColorsRes.mainTextColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: padding ?? 0),
            child: Consumer<SelectedVariantItemProvider>(
                builder: (context, selectedVariantItemProvider, _) {
              return ProductCartButton(
                productId: product.id.toString(),
                productVariantId: product
                    .variants[selectedVariantItemProvider.getSelectedIndex()].id
                    .toString(),
                count: int.parse(product
                            .variants[
                                selectedVariantItemProvider.getSelectedIndex()]
                            .status) ==
                        0
                    ? -1
                    : int.parse(product
                        .variants[
                            selectedVariantItemProvider.getSelectedIndex()]
                        .cartCount),
                isUnlimitedStock: product.isUnlimitedStock == "1",
                maximumAllowedQuantity:
                    double.parse(product.totalAllowedQuantity.toString()),
                availableStock: double.parse(product
                    .variants[selectedVariantItemProvider.getSelectedIndex()]
                    .stock),
                isGrid: false,
                sellerId: product.sellerId.toString(),
                from: "product_details",
              );
            }),
          ),
        ),
      ],
    ),
  );
}
