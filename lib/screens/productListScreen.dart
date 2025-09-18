import 'package:project/helper/utils/generalImports.dart';

class ProductListScreen extends StatefulWidget {
  final String? title;
  final String from;
  final String id;

  const ProductListScreen({Key? key, this.title, required this.from, required this.id}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isFilterApplied = false;
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData && context.read<ProductListProvider>().productState != ProductState.loadingMore) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required bool isReset}) async {
    try {
      if (isReset) {
        context.read<ProductListProvider>().offset = 0;

        context.read<ProductListProvider>().products = [];
      }

      Map<String, String> params = await Constant.getProductsDefaultParams();

      params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[context.read<ProductListProvider>().currentSortByOrderIndex];
      if (widget.from == "category") {
        params[ApiAndParams.categoryId] = widget.id.toString();
      } else if (widget.from == "brand") {
        params[ApiAndParams.brandId] = widget.id.toString();
      } else if (widget.from == "seller") {
        params[ApiAndParams.sellerId] = widget.id.toString();
      } else if (widget.from == "country") {
        params[ApiAndParams.countryId] = widget.id.toString();
      } else if (widget.from == "sections") {
        params[ApiAndParams.sectionId] = widget.id.toString();
      }

      params = await setFilterParams(params);

      await context.read<ProductListProvider>().getProductListProvider(context: context, params: params);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      scrollController.addListener(scrollListener);
      callApi(isReset: true);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool listType = context.watch<ProductChangeListingTypeProvider>().getListingType();
    List lblSortingDisplayList = [
      sortingDefaultLabel,
      sortingNewestFirstLabel,
      sortingOldestFirstLabel,
      sortingPriceHighToLowLabel,
      sortingPriceLowToHighLabel,
      sortingDiscountHighToLowLabel,
      sortingPopularityLabel
    ];
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: widget.title ??
              getTranslatedValue(
                context,
                productsLabel,
              ),
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              getSearchWidget(
                context: context,
              ),
              getSizedBox(
                height: Constant.size5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(
                            context,
                            productListFilterScreen,
                            arguments: [
                              context.read<ProductListProvider>().productList.brands,
                              double.parse(context.read<ProductListProvider>().productList.totalMaxPrice) != 0
                                  ? double.parse(context.read<ProductListProvider>().productList.totalMaxPrice)
                                  : double.parse(context.read<ProductListProvider>().productList.totalMaxPrice),
                              double.parse(context.read<ProductListProvider>().productList.totalMinPrice) != 0
                                  ? double.parse(context.read<ProductListProvider>().productList.totalMinPrice)
                                  : double.parse(context.read<ProductListProvider>().productList.totalMinPrice),
                              context.read<ProductListProvider>().productList.sizes,
                              Constant.selectedCategories,
                            ],
                          ).then((value) async {
                            if (value == true) {
                              context.read<ProductListProvider>().offset = 0;
                              context.read<ProductListProvider>().products = [];

                              callApi(isReset: true);
                            }
                          });
                        },
                        child: Container(
                            margin: EdgeInsetsDirectional.only(start: 10, end: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                defaultImg(
                                    image: AppAssets.filterIcon,
                                    height: 17,
                                    width: 17,
                                    padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 7),
                                    iconColor: Theme.of(context).primaryColor),
                                CustomTextLabel(
                                  jsonKey: filterLabel,
                                  softWrap: true,
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                          builder: (BuildContext context1) {
                            return Wrap(
                              children: [
                                Container(
                                  decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          PositionedDirectional(
                                            child: GestureDetector(
                                              onTap: () => Navigator.pop(context),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: defaultImg(
                                                  image: AppAssets.icArrowBackIcon,
                                                  iconColor: ColorsRes.mainTextColor,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: CustomTextLabel(
                                              jsonKey: sortByLabel,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium!.merge(
                                                    TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400,
                                                      color: ColorsRes.mainTextColor,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      getSizedBox(height: 10),
                                      Column(
                                        children: List.generate(
                                          ApiAndParams.productListSortTypes.length,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                context.read<ProductListProvider>().products = [];

                                                context.read<ProductListProvider>().offset = 0;

                                                context.read<ProductListProvider>().currentSortByOrderIndex = index;

                                                callApi(isReset: true);
                                              },
                                              child: Container(
                                                padding: EdgeInsetsDirectional.all(10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    context.read<ProductListProvider>().currentSortByOrderIndex == index
                                                        ? Icon(
                                                            Icons.radio_button_checked,
                                                            color: ColorsRes.appColor,
                                                          )
                                                        : Icon(
                                                            Icons.radio_button_off,
                                                            color: ColorsRes.appColor,
                                                          ),
                                                    getSizedBox(width: 10),
                                                    Expanded(
                                                      child: CustomTextLabel(
                                                        jsonKey: lblSortingDisplayList[index],
                                                        softWrap: true,
                                                        style: Theme.of(context).textTheme.titleMedium!.merge(
                                                              TextStyle(
                                                                letterSpacing: 0.5,
                                                                fontSize: 16,
                                                                color: ColorsRes.mainTextColor,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(start: 5, end: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultImg(
                                image: AppAssets.sortingIcon,
                                height: 17,
                                width: 17,
                                padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 7),
                                iconColor: Theme.of(context).primaryColor),
                            CustomTextLabel(
                              jsonKey: sortByLabel,
                              softWrap: true,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<ProductChangeListingTypeProvider>().changeListingType();
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(start: 5, end: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultImg(
                                image:
                                    listType == false ? AppAssets.gridViewIcon : AppAssets.listViewIcon,
                                height: 17,
                                width: 17,
                                padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 7),
                                iconColor: Theme.of(context).primaryColor),
                            CustomTextLabel(
                              text: listType == false
                                  ? getTranslatedValue(
                                      context,
                                      gridViewLabel,
                                    )
                                  : getTranslatedValue(
                                      context,
                                      listViewLabel,
                                    ),
                              softWrap: true,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: setRefreshIndicator(
                  refreshCallback: () async {
                    context.read<CartListProvider>().getAllCartItems(context: context);
                    context.read<ProductListProvider>().offset = 0;
                    context.read<ProductListProvider>().products = [];

                    callApi(isReset: true);
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: ProductWidget(
                      voidCallBack: () {
                        callApi(isReset: false);
                      },
                      from: "product_listing",
                    ),
                  ),
                ),
              )
            ],
          ),
          if (context.watch<CartProvider>().totalItemsCount > 0)
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CartOverlay(),
            ),
        ],
      ),
    );
  }
}
