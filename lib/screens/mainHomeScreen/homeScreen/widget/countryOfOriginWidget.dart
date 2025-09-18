import 'package:project/helper/utils/generalImports.dart';


class CountryOfOriginWidget extends StatelessWidget {
  CountryOfOriginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, _) {
      if (homeScreenProvider.homeScreenData.countries != null &&
          homeScreenProvider.homeScreenData.countries!.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          padding: EdgeInsetsDirectional.only(top: 10),
          margin: EdgeInsetsDirectional.only(
            top: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleHeaderWithViewAllOption(
                title: getTranslatedValue(context, countryOfOriginLabel),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    countryListScreen,
                  );
                },
              ),
              GridView.builder(
                itemCount: homeScreenProvider.homeScreenData.countries?.length,
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  CountryItem? country =
                      homeScreenProvider.homeScreenData.countries?[index];
                  return CountryItemContainer(
                    country: country,
                    voidCallBack: () {
                      Navigator.pushNamed(context, productListScreen,
                          arguments: [
                            "country",
                            country?.id.toString(),
                            country?.name
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
