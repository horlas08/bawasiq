import 'package:project/helper/utils/generalImports.dart';


Widget buildDottedDivider(BuildContext context) {
  return Row(
    children: [
      getSizedBox(width: Constant.size20),
      Expanded(
        child: DashedDivider(height: 1),
      ),
      CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        radius: 15,
        child: CustomTextLabel(
          jsonKey: or_Label,
          style:
          TextStyle(color: ColorsRes.subTitleMainTextColor, fontSize: 12),
        ),
      ),
      Expanded(
        child: DashedDivider(height: 1),
      ),
      getSizedBox(width: Constant.size20),
    ],
  );
}