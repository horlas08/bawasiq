import 'package:project/helper/utils/generalImports.dart';

class QuickUseWidget extends StatelessWidget {
  const QuickUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Constant.session.isUserLoggedIn()
        ? Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: AppAssets.ordersIcon,
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: allOrdersLabel,
                    onClickAction: () {
                      Navigator.pushNamed(
                        context,
                        orderHistoryScreen,
                      );
                    },
                    padding: const EdgeInsetsDirectional.only(
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: AppAssets.homeMapIcon,
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: addressLabel,
                    onClickAction: () => Navigator.pushNamed(
                      context,
                      addressListScreen,
                      arguments: "quick_widget",
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: defaultImg(
                      image: AppAssets.cartIcon,
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    label: cartLabel,
                    onClickAction: () {
                      if (Constant.session.isUserLoggedIn()) {
                        Navigator.pushNamed(context, cartScreen);
                      } else {
                        // loginUserAccount(context, "cart");
                        Navigator.pushNamed(context, cartScreen);
                      }
                    },
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                    ),
                    context: context,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
