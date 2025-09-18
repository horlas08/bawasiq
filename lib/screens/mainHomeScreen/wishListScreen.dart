import 'package:project/helper/utils/generalImports.dart';


class WishListScreen extends StatefulWidget {
  final ScrollController scrollController;

  const WishListScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<WishListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<WishListScreen> {
  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (widget.scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductWishListProvider>().hasMoreData) {
          callApi(isReset: false);
        }
      }
    }
  }

  @override
  void dispose() {
    try {
      if (mounted) {
        widget.scrollController.removeListener(() {});
        widget.scrollController.dispose();
        Constant.resetTempFilters();
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      try {
        // ignore: unnecessary_null_comparison
        if (mounted && widget.scrollController != null) {
          //fetch productList from api
          widget.scrollController.addListener(scrollListener);

          callApi(isReset: true);
        }
      } catch (_) {}
    });
  }

  callApi({required isReset}) async {
    if (Constant.session.isUserLoggedIn()) {
      if (isReset) {
        context.read<ProductWishListProvider>().offset = 0;
        context.read<ProductWishListProvider>().wishlistProducts = [];
      }
      Map<String, String> params = await Constant.getProductsDefaultParams();

      await context.read<ProductWishListProvider>().getProductWishListProvider(context: context, params: params);
    } else {
      setState(() {
        context.read<ProductWishListProvider>().productWishListState = ProductWishListState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        centerTitle: true,
        title: CustomTextLabel(
          jsonKey: wishListLabel,
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          setNotificationIcon(context: context),
        ],
        showBackButton: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              getSearchWidget(
                context: context,
              ),
              getSizedBox(
                height: Constant.size10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.read<ProductChangeListingTypeProvider>().changeListingType();
                  },
                  child: context.watch<ProductWishListProvider>().wishlistProducts.isNotEmpty
                      ? Card(
                          margin: EdgeInsets.zero,
                          color: Theme.of(context).cardColor,
                          surfaceTintColor: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              defaultImg(
                                image:
                                    context.watch<ProductChangeListingTypeProvider>().getListingType() == false ? AppAssets.gridViewIcon : AppAssets.listViewIcon,
                                height: 17,
                                width: 17,
                                padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 7),
                                iconColor: Theme.of(context).primaryColor,
                              ),
                              CustomTextLabel(
                                text: context.watch<ProductChangeListingTypeProvider>().getListingType() == false
                                    ? getTranslatedValue(
                                        context,
                                        gridViewLabel,
                                      )
                                    : getTranslatedValue(
                                        context,
                                        listViewLabel,
                                      ),
                              )
                            ],
                          ))
                      : const SizedBox.shrink(),
                ),
              ),
              Expanded(
                child: setRefreshIndicator(
                  refreshCallback: () async {
                    context.read<CartListProvider>().getAllCartItems(context: context);
                    callApi(isReset: true);
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: widget.scrollController,
                    child: productWidget(),
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

  productWidget() {
    return Consumer<ProductWishListProvider>(
      builder: (context, productWishlistProvider, _) {
        List<ProductListItem> wishlistProducts = productWishlistProvider.wishlistProducts;
        if (productWishlistProvider.productWishListState == ProductWishListState.initial) {
          return getProductListShimmer(context: context, isGrid: context.read<ProductChangeListingTypeProvider>().getListingType());
        } else if (productWishlistProvider.productWishListState == ProductWishListState.loading) {
          return getProductListShimmer(context: context, isGrid: context.read<ProductChangeListingTypeProvider>().getListingType());
        } else if (productWishlistProvider.productWishListState == ProductWishListState.loaded ||
            productWishlistProvider.productWishListState == ProductWishListState.loadingMore) {
          return Column(
            children: [
              context.read<ProductChangeListingTypeProvider>().getListingType() == true
                  ? /* GRID VIEW UI */ GridView.builder(
                      itemCount: wishlistProducts.length,
                      padding: EdgeInsets.symmetric(horizontal: Constant.size10, vertical: Constant.size10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductGridItemContainer(product: wishlistProducts[index]);
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.60,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    )
                  : /* LIST VIEW UI */ Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(wishlistProducts.length, (index) {
                        return ProductListItemContainer(product: wishlistProducts[index]);
                      }),
                    ),
              if (productWishlistProvider.productWishListState == ProductWishListState.loadingMore)
                getProductItemShimmer(context: context, isGrid: context.read<ProductChangeListingTypeProvider>().getListingType()),
              if (context.watch<CartProvider>().totalItemsCount > 0) getSizedBox(height: 65),
            ],
          );
        } else {
          return DefaultBlankItemMessageScreen(
            height: context.height * 0.65,
            title: emptyWishListMessageLabel,
            description: emptyWishListDescriptionLabel,
            image: "no_wishlist_icon",
          );
        }
      },
    );
  }
}
