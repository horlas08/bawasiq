import 'package:project/helper/utils/generalImports.dart';


class OrderInformationWidget extends StatelessWidget {
  final Order order;

  OrderInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final DateTime estimatedDeliveryDate =
        DateTime.parse(order.createdAt.toString());

    estimatedDeliveryDate.add(Duration(days: Constant.estimateDeliveryDays));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextLabel(
          jsonKey: orderInformationLabel,
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
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          width: context.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: orderIdLabel,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsRes.appColorLightHalfTransparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsetsDirectional.only(
                          start: 10, end: 10, top: 5, bottom: 5),
                      child: CustomTextLabel(
                        text: "#${order.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsRes.appColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (order.otp.toString() != "0" && order.otp.toString() != "null")
                getSizedBox(height: 10),
              if (order.otp.toString() != "0" && order.otp.toString() != "null")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      CustomTextLabel(
                        jsonKey: orderOtpLabel,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsRes.appColorLightHalfTransparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 5, bottom: 5),
                        child: CustomTextLabel(
                          text: "${order.otp}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.appColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              getDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CustomTextLabel(
                          jsonKey: orderPlacedOnLabel,
                        ),
                        const Spacer(),
                        CustomTextLabel(
                          text: " ${order.date.toString().formatDate()}",
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextLabel(
                          jsonKey: estimateDeliveryDateLabel,
                        ),
                        const Spacer(),
                        CustomTextLabel(
                          text:
                              " ${estimatedDeliveryDate.toString().formatEstimateDate()}",
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (order.activeStatus.toString() != "1") getDivider(),
              if (order.activeStatus.toString() != "1")
                TrackMyOrderButton(
                  status: order.status ?? [],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
