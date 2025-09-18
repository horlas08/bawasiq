import 'package:project/helper/utils/generalImports.dart';

class OrderContainerShimmer extends StatelessWidget {
  const OrderContainerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      height: 220,
      width: context.width,
      margin: const EdgeInsetsDirectional.only(top: 10),
    );
  }
}
