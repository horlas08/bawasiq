import 'package:project/helper/utils/generalImports.dart';


class BrandWidget extends StatelessWidget {
  const BrandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, homeScreenProvider, _) {
        if (homeScreenProvider.homeScreenData.brands != null &&
            homeScreenProvider.homeScreenData.brands!.isNotEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            padding: EdgeInsetsDirectional.only(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleHeaderWithViewAllOption(
                  title: getTranslatedValue(context, shopByBrandsLabel),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      brandListScreen,
                    );
                  },
                ),
                GridView.builder(
                  itemCount: homeScreenProvider.homeScreenData.brands?.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.size10, vertical: Constant.size10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    BrandItem? brand =
                        homeScreenProvider.homeScreenData.brands?[index];
                    return BrandItemContainer(
                      brand: brand,
                      voidCallBack: () {
                        Navigator.pushNamed(
                          context,
                          productListScreen,
                          arguments: [
                            "brand",
                            brand?.id.toString(),
                            brand?.name.toString(),
                          ],
                        );
                      },
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,),
                )
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },

    );
  }
}
