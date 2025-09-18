import 'package:project/helper/utils/generalImports.dart';

import 'package:project/screens/productListFilterScreen/widget/filterCategoryList.dart';

class ProductListFilterScreen extends StatefulWidget {
  final List<Brands> brands;
  final List<Sizes> sizes;
  final double totalMaxPrice;
  final double totalMinPrice;
  final List<String> selectedCategoryId;

  const ProductListFilterScreen({
    Key? key,
    required this.brands,
    required this.sizes,
    required this.totalMaxPrice,
    required this.totalMinPrice,
    required this.selectedCategoryId,
  }) : super(key: key);

  @override
  State<ProductListFilterScreen> createState() =>
      _ProductListFilterScreenState();
}

class _ProductListFilterScreenState extends State<ProductListFilterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await setTempValues().then((value) =>
          context.read<ProductFilterProvider>().currentRangeValues =
              RangeValues(widget.totalMinPrice, widget.totalMaxPrice));
      context.read<ProductFilterProvider>().setCurrentIndex(0);
      context
          .read<ProductFilterProvider>()
          .setMinMaxPriceRange(widget.totalMinPrice, widget.totalMaxPrice);
      context
          .read<ProductFilterProvider>()
          .setCategories(widget.selectedCategoryId);
    });
  }

  Future<bool> setTempValues() async {
    context.read<ProductFilterProvider>().currentRangeValues =
        Constant.currentRangeValues;
    context.read<ProductFilterProvider>().selectedBrands =
        Constant.selectedBrands;
    context.read<ProductFilterProvider>().selectedSizes =
        Constant.selectedSizes;
    context.read<ProductFilterProvider>().selectedCategories =
        Constant.selectedCategories;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List lblFilterTypesList = [];
    lblFilterTypesList.add(filterTypeCategoryLabel);
    if (widget.brands.isNotEmpty) {
      lblFilterTypesList.add(filterTypeBrandLabel);
    }

    if (widget.sizes.isNotEmpty) {
      lblFilterTypesList.add(filterTypePackSizeLabel);
    }

    if (widget.totalMaxPrice <= 0 && widget.totalMinPrice <= 0) {
      lblFilterTypesList.add(filterTypePriceLabel);
    }

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: filterLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            Navigator.pop(context, false);
          }
        },
        child: Stack(
          children: [
            //Filter list screen
            PositionedDirectional(
              top: 10,
              bottom: 10,
              start: 10,
              end: (context.width * 0.6) - 10,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        lblFilterTypesList.length,
                        (index) {
                          return (index == 2 &&
                                  widget.totalMinPrice == widget.totalMaxPrice)
                              ? const SizedBox.shrink()
                              : ListTile(
                                  onTap: () {
                                    context
                                        .read<ProductFilterProvider>()
                                        .setCurrentIndex(index);
                                  },
                                  selected: context
                                          .watch<ProductFilterProvider>()
                                          .currentSelectedFilterIndex ==
                                      index,
                                  selectedTileColor:
                                      Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(10),
                                      bottomStart: Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  title: CustomTextLabel(
                                    jsonKey: lblFilterTypesList[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                  splashColor: ColorsRes.appColorLight,
                                );
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProductFilterProvider>().resetAllFilters();
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsDirectional.only(end: 10, bottom: 32),
                      child: CustomTextLabel(
                        jsonKey: cleanAllLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: ColorsRes.mainTextColor,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Filter list's values screen
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: context.width * 0.4,
              end: 0,
              child: Container(
                decoration:
                    DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
                margin: EdgeInsetsDirectional.only(
                    start: 5, top: 10, bottom: 10, end: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: context
                                  .watch<ProductFilterProvider>()
                                  .currentSelectedFilterIndex ==
                              0
                          ? ChangeNotifierProvider<CategoryListProvider>(
                              create: (context) => CategoryListProvider(),
                              child: FilterCategoryList(
                                categoryName: null,
                                categoryId: null,
                              ),
                            )
                          : context
                                      .watch<ProductFilterProvider>()
                                      .currentSelectedFilterIndex ==
                                  1
                              ? getBrandWidget(widget.brands, context)
                              : context
                                          .watch<ProductFilterProvider>()
                                          .currentSelectedFilterIndex ==
                                      2
                                  ? getSizeWidget(widget.sizes, context)
                                  : widget.totalMinPrice != widget.totalMaxPrice
                                      ? getPriceRangeWidget(
                                          widget.totalMinPrice,
                                          widget.totalMaxPrice,
                                          context)
                                      : const SizedBox.shrink(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 45,
                        margin: const EdgeInsets.all(20),
                        // padding: const EdgeInsets.all(20),
                        decoration: DesignConfig.boxGradient(10),
                        child: Center(
                          child: CustomTextLabel(
                            jsonKey: applyLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: ColorsRes.appColorWhite,
                                  fontSize: 15,
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
