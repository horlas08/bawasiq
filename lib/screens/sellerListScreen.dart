import 'package:project/helper/utils/generalImports.dart';


class SellerListScreen extends StatefulWidget {
  const SellerListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerListScreen> createState() => _SellerListScreenState();
}

class _SellerListScreenState extends State<SellerListScreen> {
  @override
  void initState() {
    super.initState();
    //fetch Seller List from api
    Future.delayed(Duration.zero).then((value) async {
      callApi();
    });
  }

  callApi() async {
    context.read<SellerListProvider>().getSellerApiProvider(
        context: context, params: await Constant.getProductsDefaultParams());
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
          jsonKey: sellersLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [],
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          context.read<CartListProvider>().getAllCartItems(context: context);
          return callApi();
        },
        child: ListView(
          children: [
            sellerWidget(),
          ],
        ),
      ),
    );
  }

//SellerList ui
  Widget sellerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<SellerListProvider>(
          builder: (context, sellerListProvider, _) {
            if (sellerListProvider.sellerState == SellerState.loaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    itemCount: sellerListProvider.sellers.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: Constant.size10, vertical: Constant.size10),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      SellerItem seller = sellerListProvider.sellers[index];

                      return SellerItemContainer(
                        seller: seller,
                        voidCallBack: () {
                          Navigator.pushNamed(context, productListScreen,
                              arguments: [
                                "seller",
                                seller.id.toString(),
                                seller.name
                              ]);
                        },
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ],
              );
            } else if (sellerListProvider.sellerState == SellerState.loading) {
              return getSellerShimmer(context: context, count: 9);
            } else {
              return NoInternetConnectionScreen(
                height: context.height * 0.65,
                message: sellerListProvider.message,
                callback: () {
                  callApi();
                },
              );
            }
          },
        ),
      ],
    );
  }
}
