import 'package:project/helper/utils/generalImports.dart';


class SellerWidget extends StatelessWidget {
  SellerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, _) {
      if (homeScreenProvider.homeScreenData.sellers != null &&
          homeScreenProvider.homeScreenData.sellers!.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          margin: EdgeInsetsDirectional.only(
            top: 10,
          ),
          padding: EdgeInsetsDirectional.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleHeaderWithViewAllOption(
                title: getTranslatedValue(context, shopBySellersLabel),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    sellerListScreen,
                  );
                },
              ),
              GridView.builder(
                itemCount: homeScreenProvider.homeScreenData.sellers?.length,
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  SellerItem? seller = homeScreenProvider.homeScreenData.sellers?[index];
                  return SellerItemContainer(
                    seller: seller,
                    voidCallBack: () {
                      Navigator.pushNamed(context, productListScreen,
                          arguments: [
                            "seller",
                            seller?.id.toString(),
                            seller?.name
                          ]);
                    },
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              )
            ],
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
