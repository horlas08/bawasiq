import 'package:project/helper/utils/generalImports.dart';

Widget backgroundOverlayImageWidget() {
  return PositionedDirectional(
    bottom: 0,
    start: 0,
    end: 0,
    top: 0,
    child: Image.asset(
      Constant.getAssetsPath(0, "bg_overlay.png"),
      fit: BoxFit.fill,
    ),
  );
}
