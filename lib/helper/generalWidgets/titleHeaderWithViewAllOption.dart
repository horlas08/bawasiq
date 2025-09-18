import 'package:project/helper/utils/generalImports.dart';


class TitleHeaderWithViewAllOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const TitleHeaderWithViewAllOption(
      {super.key, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 25,
                    decoration: BoxDecoration(
                      color: ColorsRes.appColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  getSizedBox(width: 5),
                  Expanded(
                    child: CustomTextLabel(
                      text: title,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                getSizedBox(
                  height: Constant.size5,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 10),
                  child: CustomTextLabel(
                    jsonKey: subtitle,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              CustomTextLabel(
                jsonKey: seeAllLabel,
                softWrap: true,
                style: TextStyle(
                  color: ColorsRes.mainTextColor,
                  fontSize: 14,
                ),
              ),
              getSizedBox(width: 5),
              Icon(
                Icons.arrow_circle_right,
                color: ColorsRes.appColor,
              ),
            ],
          ),
        ),
        getSizedBox(width: 15),
      ],
    );
  }
}
