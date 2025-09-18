import 'package:project/helper/utils/generalImports.dart';


class CountryListScreen extends StatefulWidget {
  const CountryListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<CountryProvider>().hasMoreData) {
          context
              .read<CountryProvider>()
              .getCountryProvider(params: {}, context: context);
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
    //fetch countryList from api
    Future.delayed(Duration.zero).then((value) {
      Map<String, String> params = {};
      context
          .read<CountryProvider>()
          .getCountryProvider(context: context, params: params);
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: countryOfOriginLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [],
          showBackButton: true),
      body: Column(
        children: [
          getSearchWidget(
            context: context,
          ),
          Expanded(
            child: setRefreshIndicator(
              refreshCallback: () {
                context
                    .read<CartListProvider>()
                    .getAllCartItems(context: context);
                Map<String, String> params = {};
                return context
                    .read<CountryProvider>()
                    .getCountryProvider(context: context, params: params);
              },
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [countryWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //countryList ui
  Widget countryWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<CountryProvider>(
          builder: (context, countryListProvider, _) {
            if (countryListProvider.countryState == CountryState.error) {
              return DefaultBlankItemMessageScreen(
                title: "empty_product_list_message",
                description: "empty_product_list_description",
                image: "no_product_icon",
              );
            }
            if (countryListProvider.countryState == CountryState.loaded ||
                countryListProvider.countryState == CountryState.loadingMore) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    itemCount: countryListProvider.countries.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.size10, vertical: Constant.size10),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      CountryItem country =
                          countryListProvider.countries[index];

                      return CountryItemContainer(
                        country: country,
                        voidCallBack: () {
                          Navigator.pushNamed(context, productListScreen,
                              arguments: [
                                "country",
                                country.id.toString(),
                                country.name,
                              ]);
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
                  if (countryListProvider.countryState ==
                      CountryState.loadingMore)
                    getCategoryShimmer(context: context, count: 3),
                ],
              );
            } else if (countryListProvider.countryState ==
                CountryState.loading) {
              return getCategoryShimmer(context: context, count: 9);
            } else {
              return NoInternetConnectionScreen(
                height: context.height * 0.65,
                message: countryListProvider.message,
                callback: () {
                  Map<String, String> params = {};

                  context
                      .read<CountryProvider>()
                      .getCountryProvider(context: context, params: params);
                },
              );
            }
          },
        ),
      ],
    );
  }
}
