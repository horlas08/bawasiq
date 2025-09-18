import 'package:project/helper/utils/generalImports.dart';

class SectionProductListStyle3 extends StatelessWidget {
  final List<ProductListItem> products;

  const SectionProductListStyle3({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(products.length, (index) {
        return ProductListItemContainer(product: products[index]);
      }),
    );
  }
}
