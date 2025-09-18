import 'package:project/helper/utils/generalImports.dart';


class ReturnProductDialog extends StatelessWidget {
  final Order order;
  final String orderItemId;

  const ReturnProductDialog({
    required this.order,
    required this.orderItemId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldReasonController = TextEditingController();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          if (context
                  .read<UpdateOrderStatusProvider>()
                  .getUpdateOrderStatus() ==
              UpdateOrderStatus.inProgress) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
      },
      child: AlertDialog(
        surfaceTintColor: ColorsRes.appColorTransparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomTextLabel(
          jsonKey: sureToReturnProductLabel,
        ),
        content: TextField(
          controller: textFieldReasonController,
          autofocus: true,
          focusNode: FocusNode(),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: getTranslatedValue(context, enterReasonLabel),
            hintStyle: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
          ),
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          Consumer<UpdateOrderStatusProvider>(builder: (context, provider, _) {
            if (provider.getUpdateOrderStatus() ==
                UpdateOrderStatus.inProgress) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: CustomTextLabel(
                    jsonKey: noLabel,
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (textFieldReasonController.text.isNotEmpty) {
                      context
                          .read<UpdateOrderStatusProvider>()
                          .updateStatus(
                            order: order,
                            orderItemId: orderItemId,
                            status: Constant.orderStatusCode[7],
                            context: context,
                            reason: textFieldReasonController.text,
                            from: "return",
                          )
                          .then((value) {
                        Navigator.pop(context, value);
                      });
                    } else {
                      showMessage(
                          context,
                          getTranslatedValue(context, reasonRequiredLabel),
                          MessageType.warning);
                    }
                  },
                  child: CustomTextLabel(
                    jsonKey: yesLabel,
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

Widget ReturnProductButton(
    {required String orderItemId,
    required VoidCallback voidCallback,
    required BuildContext context,
    required Order order}) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) =>
              ChangeNotifierProvider<UpdateOrderStatusProvider>(
                create: (context) => UpdateOrderStatusProvider(),
                child: ReturnProductDialog(
                  order: order,
                  orderItemId: orderItemId,
                ),
              )).then((value) {
        if (value != null) {
          if (value) {
            voidCallback();
          }
        }
      });
    },
    child: Container(
      alignment: Alignment.center,
      child: CustomTextLabel(
        jsonKey: returnLabel,
        style: TextStyle(color: ColorsRes.appColor),
      ),
    ),
  );
}