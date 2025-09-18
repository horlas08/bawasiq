import 'package:project/helper/utils/generalImports.dart';


class OrderDeliveryAddressWidget extends StatelessWidget {
  final Order order;
  final String from;

  const OrderDeliveryAddressWidget(
      {super.key, required this.order, required this.from});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextLabel(
          jsonKey: from == "previousOrders" ? deliveredAtLabel : deliveryToLabel,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        getSizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsetsDirectional.all(10),
          width: context.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          child: CustomTextLabel(
            text: order.orderAddress,
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    );
  }
}
