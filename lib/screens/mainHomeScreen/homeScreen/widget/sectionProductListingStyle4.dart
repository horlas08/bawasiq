import 'package:project/helper/utils/generalImports.dart';

class SectionProductListStyle4 extends StatelessWidget {
  final List<ProductListItem> products;
  final String image;

  const SectionProductListStyle4(
      {super.key, required this.products, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image.toString().isNotEmpty || image.toString() != "null")
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: Constant.size10,
                end: Constant.size10,
                top: Constant.size5,
                bottom: Constant.size5),
            child: ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: setNetworkImg(
                image: image,
                boxFit: BoxFit.fitWidth,
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(products.length, (index) {
              ProductListItem product = products[index];
              return HomeScreenProductListItem(
                product: product,
                position: index,
              );
            }),
          ),
        ),
      ],
    );
  }
}
