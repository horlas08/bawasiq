import 'package:project/helper/utils/generalImports.dart';


class PromoCodeListScreen extends StatefulWidget {
  final double amount;

  const PromoCodeListScreen({Key? key, required this.amount}) : super(key: key);

  @override
  State<PromoCodeListScreen> createState() => _PromoCodeListScreenState();
}

class _PromoCodeListScreenState extends State<PromoCodeListScreen> {
  @override
  void initState() {
    super.initState();

    //fetch PromoCodeList from api
    Future.delayed(Duration.zero).then((value) async {
      await context.read<PromoCodeProvider>().getPromoCodeProvider(
        params: {ApiAndParams.amount: widget.amount.toString()},
        context: context,
      );
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: promoCodesLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: true),
      body: setRefreshIndicator(
        refreshCallback: () async {
          context.read<CartListProvider>().getAllCartItems(context: context);
          await context.read<PromoCodeProvider>().getPromoCodeProvider(
            params: {ApiAndParams.amount: widget.amount.toString()},
            context: context,
          );
        },
        child: SingleChildScrollView(
          child: Consumer<PromoCodeProvider>(
            builder: (context, promoCodeProvider, _) {
              return promoCodeProvider.promoCodeState == PromoCodeState.loading
                  ? promoCodeListShimmer()
                  : promoCodeProvider.promoCodeState == PromoCodeState.loaded
                      ? Column(
                          children: List.generate(
                            promoCodeProvider.promoCode.data.length,
                            (index) => promoCodeItemWidget(
                              promoCodeProvider.promoCode.data[index],
                            ),
                          ),
                        )
                      : DefaultBlankItemMessageScreen(
                          image: "no_promo_code",
                          title: noCouponAvailableTitleLabel,
                          description:
                              noCouponAvailableMessageLabel,
                          buttonTitle: goBackLabel,
                          callback: () {
                            Navigator.pop(context);
                          },
                        );
            },
          ),
        ),
      ),
    );
  }

  promoCodeItemWidget(PromoCodeData promoCode) {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      child: Container(
        padding: EdgeInsetsDirectional.all(Constant.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: setNetworkImg(
                boxFit: BoxFit.cover,
                image: promoCode.imageUrl,
                height: 50,
                width: 50,
              ),
            ),
            getSizedBox(
              height: Constant.size7,
            ),
            CustomTextLabel(
              text: promoCode.promoCodeMessage,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                color: ColorsRes.mainTextColor,
              ),
            ),
            getSizedBox(
              height: Constant.size7,
            ),
            CustomTextLabel(
              text: promoCode.isApplicable == "0"
                  ? promoCode.message
                  : "You will save ${promoCode.discount.currency} on this coupon",
              softWrap: true,
              style: TextStyle(
                color: promoCode.isApplicable == "0"
                    ? ColorsRes.appColorRed
                    : ColorsRes.subTitleMainTextColor,
              ),
            ),
            getSizedBox(height: Constant.size7),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: Constant.size12,
                    ),
                    child: promoCodeWidget(
                      promoCode.promoCode,
                      promoCode.isApplicable == "0"
                          ? ColorsRes.grey
                          : ColorsRes.appColor,
                    ),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (promoCode.isApplicable == "1" &&
                          Constant.selectedCoupon != promoCode.promoCode) {
                        context
                            .read<PromoCodeProvider>()
                            .applyPromoCode(promoCode);
                        Navigator.pop(context, true);
                      } else {
                        context.read<PromoCodeProvider>().removePromoCode();
                        Navigator.pop(context, false);
                      }
                    },
                    child: Constant.selectedCoupon != promoCode.promoCode
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Constant.size5,
                              horizontal: Constant.size7,
                            ),
                            decoration: DesignConfig.boxDecoration(
                              promoCode.isApplicable == "0"
                                  ? ColorsRes.grey.withValues(alpha: 0.2)
                                  : ColorsRes.appColorLightHalfTransparent,
                              5,
                              bordercolor: promoCode.isApplicable == "0"
                                  ? ColorsRes.grey
                                  : ColorsRes.appColor,
                              isboarder: true,
                              borderwidth: 1,
                            ),
                            child: Center(
                              child: CustomTextLabel(
                                jsonKey: applyLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: promoCode.isApplicable == "0"
                                          ? ColorsRes.grey
                                          : ColorsRes.appColor,
                                    ),
                              ),
                            ),
                          )
                        : Center(
                            child: CustomTextLabel(
                              jsonKey: appliedLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: ColorsRes.appColor,
                                  ),
                            ),
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  promoCodeWidget(String promoCode, Color color) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return DottedBorder(
          /* color: color,
          borderType: BorderType.RRect,
          radius: Radius.circular(5), */
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(5),
            color: color,
          ),
          child: Container(
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: color.withValues(alpha: 0.2),
            ),
            child: CustomTextLabel(
              textAlign: TextAlign.center,
              softWrap: true,
              text: promoCode,
            ),
          ),
        );
      },
    );
  }

  promoCodeListShimmer() {
    return Column(
      children: List.generate(10, (index) {
        return const CustomShimmer(
          height: 150,
          width: double.maxFinite,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(5),
        );
      }),
    );
  }
}