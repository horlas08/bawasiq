import 'package:project/helper/utils/generalImports.dart';

import 'package:project/screens/ordersHistoryScreen/widgets/orderListShimmer.dart';

class PreviousOrderListScreen extends StatefulWidget {
  const PreviousOrderListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PreviousOrderListScreen> createState() =>
      _PreviousOrderListScreenState();
}

class _PreviousOrderListScreenState extends State<PreviousOrderListScreen>
    with TickerProviderStateMixin {
  late ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<PreviousOrdersProvider>().hasMoreData) {
          context
              .read<PreviousOrdersProvider>()
              .getOrders(params: {}, context: context);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PreviousOrdersProvider>().getOrders(
          params: {ApiAndParams.type: ApiAndParams.previous}, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreviousOrdersProvider>(
        builder: (_, previousOrdersProvider, __) {
          if (previousOrdersProvider.previousOrdersState ==
                  PreviousOrdersState.loaded ||
              previousOrdersProvider.previousOrdersState ==
                  PreviousOrdersState.loadingMore) {
            return setRefreshIndicator(
              refreshCallback: () async {
                context.read<PreviousOrdersProvider>().orders.clear();
                context.read<PreviousOrdersProvider>().offset = 0;
                await context.read<PreviousOrdersProvider>().getOrders(
                    params: {ApiAndParams.type: ApiAndParams.previous},
                    context: context);
              },
              child: ListView(
                controller: scrollController,
                children: [
                  ...List.generate(
                    previousOrdersProvider.orders.length,
                    (index) {
                      Order order = previousOrdersProvider.orders[index];
                      return OrderItemContainer(
                        order: order,
                        from: "previousOrders",
                      );
                    },
                  ),
                  if (previousOrdersProvider.previousOrdersState ==
                      PreviousOrdersState.loadingMore)
                    OrderContainerShimmer(),
                ],
              ),
            );
          }
          if (previousOrdersProvider.previousOrdersState ==
              PreviousOrdersState.loading) {
            return OrderListShimmer();
          }
          if (previousOrdersProvider.previousOrdersState ==
              PreviousOrdersState.empty) {
            return Container(
              alignment: Alignment.center,
              height: context.height,
              width: context.width,
              child: DefaultBlankItemMessageScreen(
                image: "no_order_icon",
                title: emptyPreviousOrdersMessageLabel,
                description: emptyPreviousOrdersDescriptionLabel,
                buttonTitle: goBackLabel,
                callback: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
          if (previousOrdersProvider.previousOrdersState ==
              PreviousOrdersState.error) {
            return Container(
              alignment: Alignment.center,
              height: context.height,
              width: context.width,
              child: DefaultBlankItemMessageScreen(
                height: context.height,
                image: "something_went_wrong",
                title: getTranslatedValue(
                    context, somethingWentWrongTitleLabel),
                description: getTranslatedValue(
                    context, somethingWentWrongDescriptionLabel),
                buttonTitle: getTranslatedValue(context, tryAgainLabel),
                callback: () async {
                  await context.read<PreviousOrdersProvider>().getOrders(
                      params: {ApiAndParams.type: ApiAndParams.previous},
                      context: context);
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
