import 'package:project/helper/utils/generalImports.dart';


class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<OfferImages>> map = {};

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then(
      (value) async {
        await getAppSettings(context: context);

        Map<String, String> params = await Constant.getProductsDefaultParams();
        await context
            .read<HomeScreenProvider>()
            .getHomeScreenApiProvider(context: context, params: params);

        await context
            .read<ProductListProvider>()
            .getProductListProvider(context: context, params: params);

        if (Constant.session.isUserLoggedIn()) {
          await context
              .read<CartProvider>()
              .getCartListProvider(context: context);

          await context
              .read<CartListProvider>()
              .getAllCartItems(context: context);

          await getUserDetail(context: context).then(
            (value) {
              if (value[ApiAndParams.status].toString() == "1") {
                context
                    .read<UserProfileProvider>()
                    .updateUserDataInSession(value, context);
              }
            },
          );
        } else {
          context.read<CartListProvider>().setGuestCartItems();
          if (context.read<CartListProvider>().cartList.isNotEmpty) {
            await context
                .read<CartProvider>()
                .getGuestCartListProvider(context: context);
          }
        }
      },
    );
  }

  scrollListener() async {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger =
        0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (widget.scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData &&
            context.read<ProductListProvider>().productState !=
                ProductState.loadingMore) {
          Map<String, String> params =
              await Constant.getProductsDefaultParams();

          await context
              .read<ProductListProvider>()
              .getProductListProvider(context: context, params: params);
        }
      }
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
        context: context,
        title: DeliveryAddressWidget(),
        centerTitle: false,
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
              Expanded(
                child: setRefreshIndicator(
                  refreshCallback: () async {
                    context
                        .read<CartListProvider>()
                        .getAllCartItems(context: context);
                    Map<String, String> params =
                        await Constant.getProductsDefaultParams();
                    return await context
                        .read<HomeScreenProvider>()
                        .getHomeScreenApiProvider(
                            context: context, params: params);
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: widget.scrollController,
                    child: Consumer<HomeScreenProvider>(
                      builder: (context, homeScreenProvider, _) {
                        map = homeScreenProvider.homeOfferImagesMap;
                        if (homeScreenProvider.homeScreenState ==
                            HomeScreenState.loaded) {
                          for (int i = 0;
                              i <
                                  homeScreenProvider
                                      .homeScreenData.sliders!.length;
                              i++) {
                            precacheImage(
                              NetworkImage(homeScreenProvider
                                      .homeScreenData.sliders?[i].imageUrl ??
                                  ""),
                              context,
                            );
                          }
                          return Column(
                            children: [
                              // Top Sections
                              SectionWidget(position: 'top'),
                              //top offer images
                              if (map.containsKey("top"))
                                OfferImagesWidget(
                                  offerImages: map["top"]!.toList(),
                                ),
                              ChangeNotifierProvider<SliderImagesProvider>(
                                create: (context) => SliderImagesProvider(),
                                child: SliderImageWidget(
                                  sliders: homeScreenProvider
                                          .homeScreenData.sliders ??
                                      [],
                                ),
                              ),
                              // Below Slider Sections
                              SectionWidget(position: 'below_slider'),
                              //below slider offer images
                              if (map.containsKey("below_slider"))
                                OfferImagesWidget(
                                  offerImages: map["below_slider"]!.toList(),
                                ),
                              if (homeScreenProvider
                                          .homeScreenData.categories !=
                                      null &&
                                  homeScreenProvider
                                      .homeScreenData.categories!.isNotEmpty)
                                CategoryWidget(
                                    categories: homeScreenProvider
                                        .homeScreenData.categories),
                              //below category offer images
                              if (map.containsKey("below_category"))
                                OfferImagesWidget(
                                  offerImages: map["below_category"]!.toList(),
                                ),
                              // Below Category Sections
                              SectionWidget(position: 'below_category'),
                              // Shop By Brands
                              BrandWidget(),
                              // Below Shop By Seller Sections
                              SectionWidget(
                                  position: 'custom_below_shop_by_brands'),
                              // Shop By Sellers
                              SellerWidget(),
                              // Below Shop By Seller Sections
                              SectionWidget(position: 'below_shop_by_seller'),
                              // Shop By Country Of Origin
                              CountryOfOriginWidget(),
                              // Below Country Of Origin Sections
                              SectionWidget(
                                  position: 'below_shop_by_country_of_origin'),
                              // All Products Sections
                              getSizedBox(height: 10),
                              TitleHeaderWithViewAllOption(
                                title:
                                    getTranslatedValue(context, allProductsLabel),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    productListScreen,
                                    arguments: ["home", "0", "all_products"],
                                  );
                                },
                              ),
                              getSizedBox(height: 10),
                              ProductWidget(from: "product_listing"),
                              if (context
                                      .watch<CartProvider>()
                                      .totalItemsCount >
                                  0)
                                getSizedBox(height: 65),
                            ],
                          );
                        } else if (homeScreenProvider.homeScreenState ==
                                HomeScreenState.loading ||
                            homeScreenProvider.homeScreenState ==
                                HomeScreenState.initial) {
                          return getHomeScreenShimmer(context);
                        } else {
                          return NoInternetConnectionScreen(
                            height: context.height * 0.65,
                            message: homeScreenProvider.message,
                            callback: () async {
                              Map<String, String> params =
                                  await Constant.getProductsDefaultParams();
                              await context
                                  .read<HomeScreenProvider>()
                                  .getHomeScreenApiProvider(
                                      context: context, params: params);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
