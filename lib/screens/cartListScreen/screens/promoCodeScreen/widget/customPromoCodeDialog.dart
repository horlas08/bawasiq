import 'package:project/helper/utils/generalImports.dart';


class CustomPromoCodeDialog extends StatefulWidget {
  final String couponCode;
  final double couponAmount;

  const CustomPromoCodeDialog(
      {Key? key, required this.couponCode, required this.couponAmount})
      : super(key: key);

  @override
  State<CustomPromoCodeDialog> createState() => _CustomPromoCodeDialogState();
}

class _CustomPromoCodeDialogState extends State<CustomPromoCodeDialog> {
  @override
  void initState() {
    Timer(
        Duration(
            milliseconds:
                Constant.discountCouponDialogVisibilityTimeInMilliseconds), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: ColorsRes.appColorTransparent,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          defaultImg(
            image: AppAssets.couponIcon,
            height: context.width * 0.3,
            width: context.width * 0.3,
          ),
          RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            // maxLines: 1,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "\"${widget.couponCode}\" ",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorsRes.appColor,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                TextSpan(
                  text: "${getTranslatedValue(context, couponAppliedLabel)}\n\n",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                TextSpan(
                  text: getTranslatedValue(context, youSavedLabel),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                TextSpan(
                  text: "${widget.couponAmount.toString().currency}\n\n",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorsRes.appColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                TextSpan(
                  text: getTranslatedValue(context, withThisPromoCodeLabel),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ColorsRes.subTitleMainTextColor,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
          getSizedBox(height: 10),
        ],
      ),
    );
  }
}
