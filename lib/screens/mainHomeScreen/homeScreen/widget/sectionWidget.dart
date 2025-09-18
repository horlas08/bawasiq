import 'package:project/helper/utils/generalImports.dart';

class SectionWidget extends StatelessWidget {
  final String position;

  SectionWidget({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, _) {
      if (homeScreenProvider.homeScreenData.sections != null &&
          homeScreenProvider.homeScreenData.sections!.isNotEmpty) {
        return Column(
          children: List.generate(
            homeScreenProvider.homeScreenData.sections?.length ?? 0,
            (index) {
              Sections? section = homeScreenProvider.homeScreenData.sections?[index];
              if (section!.products!.isNotEmpty) {
                if (position.toString() == section.position.toString()) {
                  return Container(
                    decoration: BoxDecoration(
                      color: (section.backgroundColorForDarkTheme.toString() ==
                                  "null" ||
                              section.backgroundColorForDarkTheme
                                  .toString()
                                  .isEmpty ||
                              section.backgroundColorForLightTheme.toString() ==
                                  "null" ||
                              section.backgroundColorForLightTheme
                                  .toString()
                                  .isEmpty)
                          ? Theme.of(context).cardColor
                          : Color(getColorFromHex(
                              section.backgroundColorForDarkTheme.toString(),
                              section.backgroundColorForLightTheme.toString(),
                              context)),
                    ),
                    padding: EdgeInsetsDirectional.only(top: 10),
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //below section offer images
                        if (context
                            .read<HomeScreenProvider>()
                            .homeOfferImagesMap
                            .containsKey("below_section-${section.id}"))
                          OfferImagesWidget(
                            offerImages: context
                                .read<HomeScreenProvider>()
                                .homeOfferImagesMap[
                                    "below_section-${section.id}"]
                                ?.toList(),
                          ),
                        TitleHeaderWithViewAllOption(
                          title: section.title.toString(),
                          subtitle: section.shortDescription.toString(),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              productListScreen,
                              arguments: [
                                "sections",
                                section.id.toString(),
                                section.title
                              ],
                            );
                          },
                        ),
                        if (section.styleApp.toString() == "style_1")
                          SectionProductListStyle1(
                            products: section.products!,
                          ),
                        if (section.styleApp.toString() == "style_2")
                          SectionProductListStyle2(
                            products: section.products!,
                          ),
                        if (section.styleApp.toString() == "style_3")
                          SectionProductListStyle3(
                            products: section.products!,
                          ),
                        if (section.styleApp.toString() == "style_4")
                          SectionProductListStyle4(
                            image: section.bannerApp.toString(),
                            products: section.products!,
                          ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
