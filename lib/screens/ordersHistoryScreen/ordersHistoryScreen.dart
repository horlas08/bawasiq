import 'package:project/helper/utils/generalImports.dart';

import 'package:project/screens/ordersHistoryScreen/activeOrdersListScreen.dart';
import 'package:project/screens/ordersHistoryScreen/previousOrdersListScreen.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  int currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      ChangeNotifierProvider<ActiveOrdersProvider>(
        create: (context) => ActiveOrdersProvider(),
        child: const ActiveOrderListScreen(),
      ),
      ChangeNotifierProvider<PreviousOrdersProvider>(
        create: (context) => PreviousOrdersProvider(),
        child: const PreviousOrderListScreen(),
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: ordersHistoryLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: true),
      body: Column(
        children: [
          getSizedBox(height: 10),
          Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsetsDirectional.all(10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: OrderTypeButtonWidget(
                      isActive: currentIndex == 0,
                      child: Center(
                        child: CustomTextLabel(
                          jsonKey: activeOrdersLabel,
                          softWrap: true,
                          style: TextStyle(
                            color: currentIndex == 0
                                ? ColorsRes.appColorWhite
                                : ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: OrderTypeButtonWidget(
                      isActive: currentIndex == 1,
                      child: Center(
                        child: CustomTextLabel(
                          jsonKey: previousOrdersLabel,
                          softWrap: true,
                          style: TextStyle(
                            color: currentIndex == 1
                                ? ColorsRes.appColorWhite
                                : ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
