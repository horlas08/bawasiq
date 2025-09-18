import 'package:project/helper/utils/generalImports.dart';

class SectionProductListStyle1 extends StatelessWidget {
  final List<ProductListItem> products;

  const SectionProductListStyle1({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
