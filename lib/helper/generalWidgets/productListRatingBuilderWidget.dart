import 'package:project/helper/utils/generalImports.dart';

class ProductListRatingBuilderWidget extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double? size;
  final double? spacing;
  final double? fontSize;

  ProductListRatingBuilderWidget({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.size,
    this.spacing,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if(totalRatings == 0){
      return Container(
        height: 19,
      );
    }else{
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  5,
                      (index) {
                    return defaultImg(
                      image: AppAssets.rateIcon,
                      iconColor: (averageRating.toInt() > index)
                          ? ColorsRes.activeRatingColor
                          : ColorsRes.deActiveRatingColor,
                      height: size,
                      width: size,
                      padding:
                      EdgeInsetsDirectional.only(end: spacing ?? 0),
                    );
                  },
                ),
                getSizedBox(width: 5),
                CustomTextLabel(
                  text: "(${averageRating})",
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontSize: fontSize ?? 13,
                  ),
                ),
                getSizedBox(width: 5),
              ],
            ),
          ],
        ),
      );
    }
  }
}
