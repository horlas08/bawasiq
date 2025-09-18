import 'package:project/helper/utils/generalImports.dart';

class OrderTrackerItemContainer extends StatelessWidget {
  final List<List> listOfStatus;
  final int index;
  final bool isLast;

  const OrderTrackerItemContainer(
      {super.key,
      required this.index,
      required this.isLast,
      required this.listOfStatus});

  @override
  Widget build(BuildContext context) {
    List statusImages = [
      "status_icon_awaiting_payment",
      "status_icon_received",
      "status_icon_process",
      "status_icon_shipped",
      "status_icon_out_for_delivery",
      "status_icon_delivered",
      "status_icon_cancel",
      "status_icon_returned",
    ];

    String currentImage = "";

    switch (Constant.getOrderActiveStatusLabelFromCode(
            listOfStatus[index].first.toString(), context)
        .toString()
        .toLowerCase()) {
      case "payment pending":
        currentImage = statusImages[0];
      case "received":
        currentImage = statusImages[1];
      case "processed":
        currentImage = statusImages[2];
      case "shipped":
        currentImage = statusImages[3];
      case "out for delivery":
        currentImage = statusImages[4];
      case "delivered":
        currentImage = statusImages[5];
      case "cancelled":
        currentImage = statusImages[6];
      case "returned":
        currentImage = statusImages[7];
      default:
        "";
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              child: CircleAvatar(
                child: defaultImg(
                  image: currentImage,
                  height: 22,
                  width: 22,
                  iconColor: (listOfStatus.length > index)
                      ? ColorsRes.appColorWhite
                      : ColorsRes.subTitleMainTextColor,
                ),
                radius: 20,
                backgroundColor: (listOfStatus.length > index)
                    ? ColorsRes.appColor
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              radius: 24,
              backgroundColor: (listOfStatus.length > index)
                  ? ColorsRes.appColorDark
                  : ColorsRes.lightGrey,
            ),
            if (!isLast)
              Container(
                height: 50,
                width: 10,
                color: (!isLast)
                    ? (listOfStatus.length > index + 1)
                        ? ColorsRes.appColor
                        : ColorsRes.lightGrey
                    : ColorsRes.appColor,
              )
          ],
        ),
        getSizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: CustomTextLabel(
              //Your order has been received on 13-06-2023 10:25 PM
              text: (listOfStatus.length > index)
                  ? "Your order has been ${Constant.getOrderActiveStatusLabelFromCode(listOfStatus[index].first.toString(), context)} on ${listOfStatus[index].last.toString().formatDate()}"
                  : Constant.getOrderActiveStatusLabelFromCode(
                      (index + listOfStatus.length + 1).toString(), context),
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
