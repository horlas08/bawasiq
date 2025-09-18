import 'dart:io' as io;

import 'package:project/helper/utils/generalImports.dart';


class OrderInvoiceWidget extends StatelessWidget {
  final Order order;

  const OrderInvoiceWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderInvoiceProvider>(
      builder: (context, orderInvoiceProvider, child) {
        return Container(
          width: context.width,
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)),
          child: GestureDetector(
            onTap: () {
              orderInvoiceProvider.getOrderInvoiceApiProvider(
                params: {ApiAndParams.orderId: order.id.toString()},
                context: context,
              ).then(
                (pdfContent) async {
                  try {
                    if (pdfContent != null) {
                      final appDocDirPath = io.Platform.isAndroid
                          ? (await ExternalPath
                              .getExternalStoragePublicDirectory(
                                  ExternalPath.DIRECTORY_DOWNLOAD))
                          : (await getApplicationDocumentsDirectory()).path;

                      final targetFileName =
                          "${getTranslatedValue(context, appNameLabel)}-${getTranslatedValue(context, invoiceLabel)}#${order.id.toString()}.pdf";

                      io.File file = io.File("$appDocDirPath/$targetFileName");

                      // Write down the file as bytes from the bytes got from the HTTP request.
                      await file.writeAsBytes(pdfContent, flush: false);
                      await file.writeAsBytes(pdfContent);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        action: SnackBarAction(
                          label: getTranslatedValue(context, showFileLabel),
                          textColor: ColorsRes.mainTextColor,
                          onPressed: () {
                            OpenFilex.open(file.path);
                          },
                        ),
                        content: CustomTextLabel(
                          jsonKey: fileSavedSuccessfullyLabel,
                          softWrap: true,
                          style: TextStyle(color: ColorsRes.mainTextColor),
                        ),
                        duration: const Duration(seconds: 5),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ));
                    }
                  } catch (_) {}
                },
              );
            },
            child: Row(children: [
              CustomTextLabel(
                jsonKey: downloadInvoiceLabel,
              ),
              const Spacer(),
              if (orderInvoiceProvider.orderInvoiceState ==
                  OrderInvoiceState.loading)
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: ColorsRes.appColor,
                  ),
                ),
              if (orderInvoiceProvider.orderInvoiceState !=
                  OrderInvoiceState.loading)
                Icon(
                  Icons.download_for_offline_outlined,
                )
            ],),
          ),
        );
      },
    );
  }
}
