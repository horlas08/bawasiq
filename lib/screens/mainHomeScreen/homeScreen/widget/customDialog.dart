import 'package:project/helper/utils/generalImports.dart';


class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: ColorsRes.appColorTransparent,
      surfaceTintColor: ColorsRes.appColorTransparent,
      shadowColor: ColorsRes.appColorTransparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              if (Constant.popupBannerType == "product") {
                Navigator.pushNamed(context, productDetailScreen, arguments: [
                  Constant.popupBannerTypeId,
                  getTranslatedValue(context, appNameLabel),
                  null
                ]);
              } else if (Constant.popupBannerType == "category") {
                Navigator.pushNamed(context, productListScreen, arguments: [
                  "category",
                  Constant.popupBannerTypeId,
                  getTranslatedValue(context, appNameLabel)
                ]);
              } else if (Constant.popupBannerType == "popup_url") {
                launchUrl(Uri.parse(Constant.popupBannerUrl),
                    mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 18.0,
              ),
              margin: EdgeInsets.only(top: 13.0, right: 8.0),
              decoration: BoxDecoration(
                color: ColorsRes.appColorTransparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: setNetworkImg(
                        image: Constant.popupBannerImageUrl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            end: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: ColorsRes.appColor,
                  child: Icon(Icons.close, color: ColorsRes.appColorWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
