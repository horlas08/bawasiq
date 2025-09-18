import 'package:project/helper/utils/generalImports.dart';


class NoInternetConnectionScreen extends StatelessWidget {
  final String message;
  final double? height;
  final Function? callback;

  const NoInternetConnectionScreen({
    super.key,
    required this.message,
    this.height,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBlankItemMessageScreen(
        height: height ?? context.height,
        image: message == Constant.noInternetConnection
            ? "no_internet_icon"
            : "something_went_wrong",
        title: message == Constant.noInternetConnection
            ? noInternetTitleLabel
            : somethingWentWrongTitleLabel,
        description: message == Constant.noInternetConnection
            ? noInternetDescriptionLabel
            : somethingWentWrongDescriptionLabel,
        buttonTitle: tryAgainLabel,
        callback: callback);
  }
}
