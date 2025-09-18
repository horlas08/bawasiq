import 'package:project/helper/utils/generalImports.dart';


class TrackMyOrderButton extends StatelessWidget {
  final List<List<dynamic>> status;

  const TrackMyOrderButton({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status.isNotEmpty) {
          showModalBottomSheet(
            backgroundColor: Theme.of(context).cardColor,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            context: context,
            builder: (context) {
              return OrderTrackingHistoryBottomSheet(
                listOfStatus: status,
              );
            },
          );
        } else {
          showMessage(
              context,
              getTranslatedValue(context, somethingWentWrongLabel),
              MessageType.warning);
        }
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        child: Row(
          children: [
            CustomTextLabel(
              jsonKey: seeAllUpdatesLabel,
              softWrap: true,
              style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.arrow_right,
              color: ColorsRes.mainTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
