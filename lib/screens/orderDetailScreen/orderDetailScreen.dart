import 'package:project/helper/utils/generalImports.dart';

import 'package:project/screens/orderDetailScreen/widgets/orderBillingDetailsWidget.dart';
import 'package:project/screens/orderDetailScreen/widgets/orderDeliveryAddressWidget.dart';
import 'package:project/screens/orderDetailScreen/widgets/orderInformationWidget.dart';
import 'package:project/screens/orderDetailScreen/widgets/orderInvoiceWidget.dart';
import 'package:project/screens/orderDetailScreen/widgets/orderProductsWidget.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  final String from;

  const OrderDetailScreen(
      {super.key, required this.orderId, required this.from});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order order;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await callApi();
    });
    super.initState();
  }

  Future callApi() async {
    context.read<CurrentOrderProvider>().getCurrentOrder(
        params: {ApiAndParams.orderId: widget.orderId},
        context: context).then((value) {
      if (value is Order) {
        order = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          Navigator.pop(context, order);
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: orderSummaryLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
        ),
        body: Consumer<CurrentOrderProvider>(
          builder: (context, currentOrderProvider, child) {
            if (currentOrderProvider.currentOrderState ==
                    CurrentOrderState.loaded ||
                currentOrderProvider.currentOrderState ==
                    CurrentOrderState.silentLoading) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Order details container
                      OrderInformationWidget(order: order),
                      // Download invoice button
                      OrderInvoiceWidget(order: order),
                      // Order details container
                      OrderProductsWidget(
                        order: order,
                        voidCallback: () {
                          callApi();
                        },
                        from: widget.from,
                      ),
                      // Delivery address container
                      OrderDeliveryAddressWidget(
                        order: order,
                        from: widget.from,
                      ),
                      // Billing details container
                      OrderBillingDetailsWidget(order: order),
                    ],
                  ),
                ),
              );
            } else if (currentOrderProvider.currentOrderState ==
                CurrentOrderState.loading) {
              return ListView(
                children: List.generate(
                  20,
                  (index) {
                    return CustomShimmer(
                      height: 120,
                      width: context.width,
                      borderRadius: 10,
                      margin: EdgeInsetsDirectional.only(
                        top: 10,
                        start: 10,
                        end: 10,
                      ),
                    );
                  },
                ),
              );
            } else {
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
                    callApi();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
