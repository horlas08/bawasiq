import 'package:project/helper/utils/generalImports.dart';

class OfferImagesWidget extends StatelessWidget {
  final List<OfferImages>? offerImages;

  OfferImagesWidget({super.key, this.offerImages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        offerImages!.length,
        (index) {
          return GestureDetector(
            onTap: () async {
              if (offerImages?[index].type == "offer_url") {
                if (await canLaunchUrl(
                    Uri.parse(offerImages?[index].offerUrl ?? ""))) {
                  await launchUrl(Uri.parse(offerImages?[index].offerUrl ?? ""),
                      mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch ${offerImages?[index].offerUrl}';
                }
              } else if (offerImages?[index].type == "category") {
                /* Navigator.pushNamed(
                  context,
                  productListScreen,
                  arguments: [
                    "category",
                    offerImages?[index].typeId.toString(),
                    offerImages?[index].typeName
                  ],
                ); */
                if (offerImages![index].category!.hasChild!) {
                  Navigator.pushNamed(context, categoryListScreen,
                      arguments: [ScrollController(), offerImages![index].typeName, offerImages![index].typeId.toString()]);
                } else {
                  Navigator.pushNamed(context, productListScreen,
                      arguments: ["category", offerImages![index].typeId.toString(), offerImages![index].typeName]);
                }
              } else if (offerImages?[index].type == "product") {
                Navigator.pushNamed(
                  context,
                  productDetailScreen,
                  arguments: [
                    offerImages?[index].typeId.toString(),
                    offerImages?[index].typeName,
                    null
                  ],
                );
              }
            },
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: Constant.size10,
                  end: Constant.size10,
                  top: Constant.size5,
                  bottom: Constant.size5),
              child: ClipRRect(
                borderRadius: Constant.borderRadius10,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: setNetworkImg(
                  image: offerImages?[index].imageUrl ?? "",
                  boxFit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
