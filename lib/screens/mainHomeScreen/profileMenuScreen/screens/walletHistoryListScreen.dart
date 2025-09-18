import 'package:project/helper/utils/generalImports.dart';


class WalletHistoryListScreen extends StatefulWidget {
  const WalletHistoryListScreen({Key? key}) : super(key: key);

  @override
  State<WalletHistoryListScreen> createState() =>
      _WalletHistoryListScreenState();
}

class _WalletHistoryListScreenState extends State<WalletHistoryListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<WalletHistoryProvider>().hasMoreData) {
          callApi(false);
        }
      }
    }
  }

  Future callApi(bool resetLimitOffset) async {
    if (resetLimitOffset) {
      context.read<WalletHistoryProvider>().offset = 0;
      context.read<WalletHistoryProvider>().walletHistories.clear();
    }

    await getUserDetail(context: context).then(
      (value) {
        if (value[ApiAndParams.status].toString() == "1") {
          context
              .read<UserProfileProvider>()
              .updateUserDataInSession(value, context);
        }
      },
    );

    await context.read<WalletHistoryProvider>().getWalletHistoryProvider(
        params: {ApiAndParams.type: ApiAndParams.transactionId},
        context: context);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      callApi(true);
    });

    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: myWalletLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
        refreshCallback: () {
          context.read<CartListProvider>().getAllCartItems(context: context);
          return callApi(true);
        },
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(10),
              margin: EdgeInsetsDirectional.only(
                  start: 10, end: 10, top: 10, bottom: 5),
              decoration: DesignConfig.boxDecoration(
                Theme.of(context).cardColor,
                10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextLabel(
                          jsonKey: walletBalanceLabel,
                          style: TextStyle(
                            color: ColorsRes.appColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Consumer<SessionManager>(
                          builder: (context, sessionManager, child) {
                            return CustomTextLabel(
                              text:
                                  "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                                      .currency,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorsRes.appColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  gradientBtnWidget(
                    context,
                    7,
                    callback: () {
                      Navigator.pushNamed(context, walletRechargeScreen)
                          .then((value) {
                        if (value is bool && value == true) {
                          callApi(true).then((value) => setState(() {}));
                        }
                      });
                    },
                    otherWidgets: Padding(
                      padding: EdgeInsetsDirectional.only(start: 10, end: 10),
                      child: CustomTextLabel(
                        jsonKey: walletRechargeLabel,
                        style: TextStyle(
                          color: ColorsRes.appColorWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    height: 40,
                  ),
                ],
              ),
            ),
            Consumer<WalletHistoryProvider>(
              builder: (context, walletHistoryProvider, _) {
                if (walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.initial ||
                    walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loading) {
                  return getTransactionListShimmer();
                } else if (walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loaded ||
                    walletHistoryProvider.walletHistoryState ==
                        WalletHistoryState.loadingMore) {
                  return Column(
                    children: List.generate(
                        walletHistoryProvider.walletHistories.length, (index) {
                      return getWalletHistoryItemWidget(
                          walletHistoryProvider.walletHistories[index]);
                    }),
                  );
                } else {
                  return DefaultBlankItemMessageScreen(
                    image: "no_transaction",
                    title: emptyWalletHistoryLabel,
                    description: emptyWalletTransactionHistoryLabel,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  getWalletHistoryItemWidget(WalletHistoryData walletHistory) {
    String message = "";
    if (walletHistory.orderId == "null" &&
        walletHistory.orderItemId == "null") {
      message = walletHistory.message.toString();
    } else if ((walletHistory.orderId != null ||
            walletHistory.orderId != "null") &&
        (walletHistory.orderItemId != null ||
            walletHistory.orderItemId != "null") &&
        walletHistory.type.toString().toLowerCase() == "debit") {
      String orderId = (walletHistory.orderId.toString() != "null")
          ? "-${getTranslatedValue(context, orderIdLabel)}:${walletHistory.orderId.toString()}"
          : "";
      message = "${getTranslatedValue(context, orderPlacedLabel)}${orderId}";
    } else if ((walletHistory.orderId != null ||
            walletHistory.orderId != "null") &&
        (walletHistory.orderItemId != null ||
            walletHistory.orderItemId != "null") &&
        walletHistory.type.toString().toLowerCase() == "credit") {
      String orderDetail = (walletHistory.measurement.toString() != "null" &&
              walletHistory.measurementUnit.toString() != "null" &&
              walletHistory.productName.toString() != "null" &&
              walletHistory.orderId.toString() != "null")
          ? " [${getTranslatedValue(context, orderIdLabel)}:${walletHistory.orderId.toString()},${getTranslatedValue(context, itemLabel)}:${walletHistory.productName}(${walletHistory.measurement}${walletHistory.measurementUnit})]"
          : "";
      message = "${walletHistory.message}${orderDetail}";
    }

    return Container(
      padding: EdgeInsets.all(Constant.size10),
      margin: EdgeInsets.symmetric(
          vertical: Constant.size5, horizontal: Constant.size10),
      decoration: DesignConfig.boxDecoration(
        Theme.of(context).cardColor,
        10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextLabel(
                  text: "ID #${walletHistory.id}",
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ),
              getSizedBox(width: Constant.size5),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: Constant.size5, horizontal: Constant.size10),
                decoration: DesignConfig.boxDecoration(
                  walletHistory.type?.toLowerCase() == "credit"
                      ? ColorsRes.appColorGreen.withValues(alpha:0.1)
                      : ColorsRes.appColorRed.withValues(alpha:0.1),
                  5,
                  bordercolor: walletHistory.type?.toLowerCase() == "credit"
                      ? ColorsRes.appColorGreen
                      : ColorsRes.appColorRed,
                  isboarder: true,
                  borderwidth: 1,
                ),
                child: CustomTextLabel(
                  jsonKey: walletHistory.type == "credit" ? creditLabel : debitLabel,
                  style: TextStyle(
                    color: walletHistory.type?.toLowerCase() == "credit"
                        ? ColorsRes.appColorGreen
                        : ColorsRes.appColorRed,
                  ),
                ),
              ),
            ],
          ),
          getSizedBox(height: Constant.size5),
          getDivider(height: 1, color: ColorsRes.grey, thickness: 0),
          getSizedBox(height: Constant.size5),
          CustomTextLabel(
            jsonKey: messageLabel,
            style: TextStyle(
              color: ColorsRes.grey,
            ),
            softWrap: true,
          ),
          getSizedBox(height: Constant.size2),
          CustomTextLabel(
            text: message,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ColorsRes.mainTextColor,
            ),
            softWrap: true,
          ),
          getSizedBox(height: Constant.size20),
          CustomTextLabel(
            jsonKey: dateAndTimeLabel,
            style: TextStyle(
              color: ColorsRes.grey,
            ),
            softWrap: true,
          ),
          getSizedBox(height: Constant.size2),
          CustomTextLabel(
            text: walletHistory.createdAt.toString().formatDate(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ColorsRes.mainTextColor,
            ),
            softWrap: true,
          ),
          getSizedBox(height: Constant.size5),
          getDivider(height: 1, color: ColorsRes.grey, thickness: 0),
          getSizedBox(height: Constant.size5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextLabel(
                jsonKey: amountLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.mainTextColor,
                ),
                softWrap: true,
              ),
              CustomTextLabel(
                text: walletHistory.amount?.currency,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: ColorsRes.appColor),
                softWrap: true,
              ),
            ],
          )
        ],
      ),
    );
  }

  getTransactionListShimmer() {
    return Column(
      children: List.generate(20, (index) => transactionItemShimmer()),
    );
  }

  transactionItemShimmer() {
    return CustomShimmer(
      margin: EdgeInsets.symmetric(
          vertical: Constant.size10, horizontal: Constant.size10),
      height: 180,
      width: context.width,
    );
  }
}
