import 'package:project/helper/utils/generalImports.dart';

class SectionProductListStyle2 extends StatelessWidget {
  final List<ProductListItem> products;

  const SectionProductListStyle2({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: products.length,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            ProductListItem product = products[index];
            return HomeScreenProductListItem(
              product: product,
              position: index,
              padding: 0,
              borderRadius: 0,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.55,
            crossAxisCount: 2,
          ),
        )
        // child: SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: List.generate(products.length, (index) {
        //       ProductListItem product = products[index];
        //       return HomeScreenProductListItem(
        //         product: product,
        //         position: index,
        //       );
        //     }),
        //   ),
        // ),
        );
  }
}
