import 'package:project/helper/utils/generalImports.dart';

class SocialMediaLoginButtonWidget extends StatelessWidget {
  final String text;
  final String logo;
  final VoidCallback onPressed;
  final Color? logoColor;

  const SocialMediaLoginButtonWidget({
    super.key,
    required this.text,
    required this.logo,
    required this.onPressed,
    this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: ColorsRes.mainTextColor),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            defaultImg(
              image: logo,
              height: 24,
              width: 24,
              iconColor: logoColor,
              boxFit: BoxFit.fitWidth,
              requiredRTL: false,
            ),
            getSizedBox(width: 10),
            CustomTextLabel(
              jsonKey: text,
              style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
