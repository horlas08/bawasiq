import 'package:project/helper/utils/generalImports.dart';


class BrandListScreen extends StatefulWidget {
  const BrandListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<BrandListProvider>().hasMoreData) {
          brandListApiCall();
        }
      }
    }
  }

  brandListApiCall(){
    context.read<BrandListProvider>().getBrandApiProvider(params: {
      ApiAndParams.latitude: Constant.session.getData(SessionManager.keyLatitude),
      ApiAndParams.longitude: Constant.session.getData(SessionManager.keyLongitude),
    }, context: context);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    Future.delayed(Duration.zero).then((value) {
      brandListApiCall();
    });
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: brandsLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [],
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          context.read<CartListProvider>().getAllCartItems(context: context);
          context.read<BrandListProvider>().brands.clear();
          context.read<BrandListProvider>().offset = 0;
          return brandListApiCall();
        },
        child: ListView(
          controller: scrollController,
          children: [
            brandWidget(),
          ],
        ),
      ),
    );
  }

//brandList ui
  Widget brandWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<BrandListProvider>(
          builder: (context, brandListProvider, _) {
            if (brandListProvider.brandState == BrandState.loaded ||
                brandListProvider.brandState == BrandState.loadingMore) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: brandListProvider.brands.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.size10, vertical: Constant.size10),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      BrandItem brand = brandListProvider.brands[index];

                      return BrandItemContainer(
                        brand: brand,
                        voidCallBack: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "brand",
                              brand.id.toString(),
                              brand.name
                            ],
                          );
                        },
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                  ),
                  if (brandListProvider.brandState == BrandState.loadingMore)
                    getBrandShimmer(context: context, count: 3),
                ],
              );
            } else if (brandListProvider.brandState == BrandState.loading) {
              return getBrandShimmer(context: context, count: 9);
            } else {
              return NoInternetConnectionScreen(
                height: context.height * 0.65,
                message: brandListProvider.message,
                callback: () {
                  brandListApiCall();
                },
              );
            }
          },
        ),
      ],
    );
  }
}
