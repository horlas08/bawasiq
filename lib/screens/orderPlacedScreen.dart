import 'package:project/helper/utils/generalImports.dart';


class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        context.read<CartListProvider>().clearCart(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          return;
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(Constant.size10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              defaultImg(
                image: AppAssets.orderPlacedIcon,
                height: context.width * 0.4,
                width: context.width * 0.4,
              ),
              getSizedBox(
                height: Constant.size20,
              ),
              CustomTextLabel(
                jsonKey: orderPlaceMessageLabel,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.merge(
                      TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
              ),
              getSizedBox(
                height: Constant.size20,
              ),
              CustomTextLabel(
                jsonKey: orderPlaceDescriptionLabel,
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                      TextStyle(
                          letterSpacing: 0.5, color: ColorsRes.mainTextColor),
                    ),
              ),
              getSizedBox(
                height: Constant.size20,
              ),
              FittedBox(
                child: gradientBtnWidget(
                  context,
                  5,
                  callback: () {
                    Navigator.of(context).popUntil(
                      (Route<dynamic> route) => route.isFirst,
                    );
                  },
                  otherWidgets: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextLabel(
                      jsonKey: continueShoppingLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ColorsRes.appColorWhite,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ),
              getSizedBox(
                height: Constant.size20,
              ),
              FittedBox(
                child: gradientBtnWidget(
                  context,
                  5,
                  callback: () {
                    Navigator.of(context).popUntil(
                      (Route<dynamic> route) => route.isFirst,
                    );
                    Navigator.pushNamed(context, orderHistoryScreen);
                  },
                  otherWidgets: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextLabel(
                      jsonKey: viewAllOrdersLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ColorsRes.appColorWhite,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
