import 'package:project/helper/utils/generalImports.dart';

class ProductVariantDropDownMenuList extends StatefulWidget {
  final List<Variants> variants;
  final String from;
  final ProductListItem product;
  final bool isGrid;

  const ProductVariantDropDownMenuList({
    Key? key,
    required this.variants,
    required this.from,
    required this.product,
    required this.isGrid,
  }) : super(key: key);

  @override
  State<ProductVariantDropDownMenuList> createState() =>
      _ProductVariantDropDownMenuListState();
}

class _ProductVariantDropDownMenuListState
    extends State<ProductVariantDropDownMenuList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedVariantItemProvider>(
      builder: (context, selectedVariantItemProvider, _) {
        return widget.variants.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomTextLabel(
                                text: double.parse(widget
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .discountedPrice
                                            .toString()) !=
                                        0
                                    ? widget
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .discountedPrice
                                        .toString()
                                        .currency
                                    : widget
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .price
                                        .toString()
                                        .currency,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              getSizedBox(width: 5),
                              Expanded(
                                child: RichText(
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorsRes.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2),
                                        text: double.parse(widget
                                                    .variants[0].discountedPrice
                                                    .toString()) !=
                                                0
                                            ? widget.variants[0].price
                                                .toString()
                                                .currency
                                            : "",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(height: 5),
                  ProductListRatingBuilderWidget(
                    averageRating:
                        widget.product.averageRating.toString().toDouble,
                    totalRatings: widget.product.ratingCount.toString().toInt,
                    size: 15,
                    spacing: 2,
                  ),
                  getSizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.variants.length > 1) {
                              {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: DesignConfig.setRoundedBorderSpecific(
                                      20,
                                      istop: true),
                                  builder: (BuildContext context) {
                                    return Container(
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
                                                  borderRadius:
                                                      Constant.borderRadius10,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child: setNetworkImg(
                                                    boxFit: BoxFit.cover,
                                                    image: widget
                                                        .product.imageUrl
                                                        .toString(),
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                ),
                                                getSizedBox(
                                                    width: Constant.size10),
                                                Expanded(
                                                  child: CustomTextLabel(
                                                    text: widget.product.name
                                                        .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: ColorsRes
                                                          .mainTextColor,
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
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: widget.variants.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FittedBox(
                                                            child: RichText(
                                                              maxLines: 2,
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              // maxLines: 1,
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: ColorsRes
                                                                              .mainTextColor,
                                                                          decorationThickness:
                                                                              2),
                                                                      text:
                                                                          "${widget.variants[index].measurement} ",
                                                                    ),
                                                                    WidgetSpan(
                                                                      child:
                                                                          CustomTextLabel(
                                                                        text: widget
                                                                            .variants[index]
                                                                            .stockUnitName
                                                                            .toString(),
                                                                        softWrap:
                                                                            true,
                                                                        //superscript is usually smaller in size
                                                                        // textScaleFactor: 0.7,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              ColorsRes.mainTextColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text: double.parse(widget.variants[index].discountedPrice.toString()) !=
                                                                                0
                                                                            ? " | "
                                                                            : "",
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorsRes.mainTextColor)),
                                                                    TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color: ColorsRes
                                                                              .mainTextColor,
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          decorationThickness:
                                                                              2),
                                                                      text: double.parse(widget.variants[index].discountedPrice.toString()) !=
                                                                              0
                                                                          ? widget
                                                                              .variants[index]
                                                                              .price
                                                                              .toString()
                                                                              .currency
                                                                          : "",
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                          CustomTextLabel(
                                                            text: double.parse(widget
                                                                        .variants[
                                                                            index]
                                                                        .discountedPrice
                                                                        .toString()) !=
                                                                    0
                                                                ? widget
                                                                    .variants[
                                                                        index]
                                                                    .discountedPrice
                                                                    .toString()
                                                                    .currency
                                                                : widget
                                                                    .variants[
                                                                        index]
                                                                    .price
                                                                    .toString()
                                                                    .currency,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: ColorsRes
                                                                    .appColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ProductCartButton(
                                                      productId: widget
                                                          .product.id
                                                          .toString(),
                                                      productVariantId: widget
                                                          .variants[index].id
                                                          .toString(),
                                                      count: int.parse(widget
                                                                  .variants[
                                                                      index]
                                                                  .status
                                                                  .toString()) ==
                                                              0
                                                          ? -1
                                                          : int.parse(widget
                                                              .variants[index]
                                                              .cartCount
                                                              .toString()),
                                                      isUnlimitedStock: widget
                                                              .product
                                                              .isUnlimitedStock ==
                                                          "1",
                                                      maximumAllowedQuantity:
                                                          double.parse(widget
                                                              .product
                                                              .totalAllowedQuantity
                                                              .toString()),
                                                      availableStock:
                                                          double.parse(widget
                                                              .variants[index]
                                                              .stock
                                                              .toString()),
                                                      isGrid: false,
                                                      sellerId: widget
                                                          .product.sellerId
                                                          .toString(),
                                                      from: widget.from,
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
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
                            margin: widget.isGrid
                                ? EdgeInsets.zero
                                : EdgeInsetsDirectional.only(end: 10),
                            decoration: BoxDecoration(
                              borderRadius: Constant.borderRadius5,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Container(
                              padding: widget.variants.length > 1
                                  ? EdgeInsets.zero
                                  : EdgeInsets.all(5),
                              alignment: AlignmentDirectional.center,
                              height: 35,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.variants.length > 1) Spacer(),
                                  CustomTextLabel(
                                    text:
                                        "${widget.variants[0].measurement} ${widget.variants[0].stockUnitName}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                  if (widget.variants.length > 1) Spacer(),
                                  if (widget.variants.length > 1)
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 5, end: 5),
                                      child: defaultImg(
                                        image: AppAssets.icDropDownIcon,
                                        height: 10,
                                        width: 10,
                                        boxFit: BoxFit.cover,
                                        iconColor: ColorsRes.mainTextColor,
                                      ),
                                    ),
                                  if (widget.variants.length > 1) Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ProductCartButton(
                          productId: widget.product.id.toString(),
                          productVariantId: widget
                              .variants[selectedVariantItemProvider
                                  .getSelectedIndex()]
                              .id
                              .toString(),
                          count: int.parse(
                                    widget
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .status
                                        .toString(),
                                  ) ==
                                  0
                              ? -1
                              : int.parse(
                                  widget
                                      .variants[selectedVariantItemProvider
                                          .getSelectedIndex()]
                                      .cartCount
                                      .toString(),
                                ),
                          isUnlimitedStock:
                              widget.product.isUnlimitedStock == "1",
                          maximumAllowedQuantity: double.parse(
                            widget.product.totalAllowedQuantity.toString(),
                          ),
                          availableStock: double.parse(
                            widget
                                .variants[selectedVariantItemProvider
                                    .getSelectedIndex()]
                                .stock
                                .toString(),
                          ),
                          isGrid: widget.isGrid,
                          sellerId: widget.product.sellerId.toString(),
                          from: widget.from,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
