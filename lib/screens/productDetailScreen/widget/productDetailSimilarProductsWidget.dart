import 'package:project/helper/utils/generalImports.dart';


/* class ProductDetailSimilarProductsWidget extends StatefulWidget {
  final String tags;
  final String slug;

  ProductDetailSimilarProductsWidget({
    super.key,
    required this.tags,
    required this.slug,
  });

  @override
  State<ProductDetailSimilarProductsWidget> createState() =>
      _ProductDetailSimilarProductsWidgetState();
}

class _ProductDetailSimilarProductsWidgetState
    extends State<ProductDetailSimilarProductsWidget> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData) {
          callApi();
        }
      }
    }
  }

  callApi() async {
    try {
      if (widget.slug.isEmpty || widget.tags.toString() == "null") {
        return;
      }
      context.read<ProductListProvider>().offset = 0;

      context.read<ProductListProvider>().products = [];

      Map<String, String> params = await Constant.getProductsDefaultParams();

      params[ApiAndParams.sort] = "0";
      params[ApiAndParams.tagNames] = widget.tags.toString();
      params[ApiAndParams.tagSlug] = widget.slug.toString();

      await context
          .read<ProductListProvider>()
          .getProductListProvider(context: context, params: params);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      scrollController.addListener(scrollListener);
      callApi();
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
    return Consumer<ProductListProvider>(
      builder: (context, productListProvider, _) {
        if (productListProvider.products.length > 0 &&
            (productListProvider.productState == ProductState.loaded ||
                productListProvider.productState == ProductState.loadingMore)) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsetsDirectional.only(
                  start: Constant.size10,
                  end: Constant.size10,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Container(
                    width: context.width,
                    child: CustomTextLabel(
                      jsonKey: similarProductsLabel,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              getSizedBox(height: 5),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(minWidth: context.width),
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 5),
                  child: Row(
                    children: List.generate(productListProvider.products.length,
                        (index) {
                      ProductListItem product =
                          productListProvider.products[index];
                      return Row(
                        children: [
                          HomeScreenProductListItem(
                            product: product,
                            position: index,
                          ),
                          if (productListProvider.productState ==
                              ProductState.loadingMore)
                            getProductItemShimmer(
                                context: context, isGrid: true),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        } else if (productListProvider.productState == ProductState.loading) {
          return Container();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
} */
class ProductDetailSimilarProductsWidget extends StatefulWidget {
  final String tags;
  final String slug;

  const ProductDetailSimilarProductsWidget({
    super.key,
    required this.tags,
    required this.slug,
  });

  @override
  State<ProductDetailSimilarProductsWidget> createState() => _ProductDetailSimilarProductsWidgetState();
}

class _ProductDetailSimilarProductsWidgetState extends State<ProductDetailSimilarProductsWidget> {
  final ScrollController scrollController = ScrollController();
  bool isInitialLoad = true;

  void scrollListener() {
    final triggerFetchMoreSize = 0.8 * scrollController.position.maxScrollExtent;
    if (scrollController.offset >= triggerFetchMoreSize && scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      final provider = context.read<ProductListProvider>();
      if (provider.hasMoreData && provider.productState != ProductState.loadingMore) {
        fetchSimilarProducts(isPagination: true); // Call for next page
      }
    }
  }

  Future<void> fetchSimilarProducts({bool isPagination = false}) async {
    try {
      if (widget.slug.isEmpty || widget.tags.toLowerCase() == "null") return;

      final provider = context.read<ProductListProvider>();

      if (!isPagination) {
        provider.offset = 0;
        provider.products.clear();
      }

      Map<String, String> params = await Constant.getProductsDefaultParams();
      params[ApiAndParams.sort] = "0";
      params[ApiAndParams.tagNames] = widget.tags;
      params[ApiAndParams.tagSlug] = widget.slug;

      await provider.getProductListProvider(context: context, params: params);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSimilarProducts(isPagination: false);
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
    return Consumer<ProductListProvider>(
      builder: (context, productListProvider, _) {
        final products = productListProvider.products;

        if (products.isEmpty && productListProvider.productState == ProductState.loading) {
          return const SizedBox.shrink(); // Initial loading can have a shimmer here if needed
        }

        if (products.isEmpty) {
          return const SizedBox.shrink(); // No similar products
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: Constant.size10),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: CustomTextLabel(
                jsonKey: similarProductsLabel,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.mainTextColor,
                ),
              ),
            ),
            const SizedBox(height: 5),
            RepaintBoundary(
              child: SizedBox(
                height: context.width * 0.8,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      ...List.generate(products.length, (index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: HomeScreenProductListItem(
                            product: products[index],
                            position: index,
                          ),
                        );
                      }),
                      if (productListProvider.productState == ProductState.loadingMore)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: getProductItemShimmer(
                            context: context,
                            isGrid: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

