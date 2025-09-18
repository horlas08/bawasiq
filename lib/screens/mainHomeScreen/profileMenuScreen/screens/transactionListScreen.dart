import 'package:project/helper/utils/generalImports.dart';


class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<TransactionProvider>().hasMoreData) {
          context
              .read<TransactionProvider>()
              .getTransactionProvider(params: {}, context: context);
        }
      }
    }
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
      context
          .read<TransactionProvider>()
          .getTransactionProvider(params: {}, context: context);
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
            jsonKey: transactionsLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: setRefreshIndicator(
          refreshCallback: () {
            context.read<CartListProvider>().getAllCartItems(context: context);
            context.read<TransactionProvider>().offset = 0;
            context.read<TransactionProvider>().transactions = [];
            return context
                .read<TransactionProvider>()
                .getTransactionProvider(params: {}, context: context);
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.zero,
            child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, _) {
              if (transactionProvider.itemsState == TransactionState.loading) {
                return getTransactionListShimmer();
              } else if (transactionProvider.itemsState ==
                      TransactionState.loaded ||
                  transactionProvider.itemsState ==
                      TransactionState.loadingMore) {
                List<TransactionData> transactions =
                    transactionProvider.transactions;
                return Column(
                  children: List.generate(transactions.length, (index) {
                    return getTransactionItemWidget(transactions[index]);
                  }),
                );
              } else {
                return DefaultBlankItemMessageScreen(
                  image: "no_transaction",
                  title: emptyTransactionListLabel,
                  description: emptyTransactionDescriptionLabel,
                );
              }
            }),
          )),
    );
  }

  getTransactionItemWidget(TransactionData transaction) {
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
                  text: "ID #${transaction.txnId}",
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
                    vertical: Constant.size5, horizontal: Constant.size7),
                decoration: DesignConfig.boxDecoration(
                    transaction.status.toLowerCase() == "success"
                        ? ColorsRes.appColorGreen.withValues(alpha:0.1)
                        : ColorsRes.appColorRed.withValues(alpha:0.1),
                    5,
                    bordercolor: transaction.status.toLowerCase() == "success"
                        ? ColorsRes.appColorGreen
                        : ColorsRes.appColorRed,
                    isboarder: true,
                    borderwidth: 1),
                child: CustomTextLabel(
                    text: setFirstLetterUppercase(transaction.status),
                    style: TextStyle(
                      color: transaction.status.toLowerCase() == "success"
                          ? ColorsRes.appColorGreen
                          : ColorsRes.appColorRed,
                    )),
              ),
            ],
          ),
          getSizedBox(height: Constant.size5),
          getDivider(height: 1, color: ColorsRes.grey, thickness: 0),
          getSizedBox(height: Constant.size5),
          CustomTextLabel(
            jsonKey: paymentMethodLabel,
            style: TextStyle(
              color: ColorsRes.grey,
            ),
            softWrap: true,
          ),
          getSizedBox(height: Constant.size2),
          CustomTextLabel(
            text: transaction.type,
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
            text: transaction.createdAt.toString().formatDate(),
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
                text: transaction.amount.currency,
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
