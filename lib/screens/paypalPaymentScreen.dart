import 'package:project/helper/utils/generalImports.dart';


class PayPalPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const PayPalPaymentScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  WebViewController? webViewController;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            showMessage(
                context,
                getTranslatedValue(context,
                    noBackDuringPaymentMessageLabel),
                MessageType.warning);
            return;
          } else {
            Navigator.pop(context, {"paymentStatus": "Failed"});
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: appNameLabel,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: true,
          onTap: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              showMessage(
                  context,
                  getTranslatedValue(context,
                      noBackDuringPaymentMessageLabel),
                  MessageType.warning);
              return;
            } else {
              Navigator.pop(context, {"paymentStatus": "Failed"});
            }
          },
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith(Constant.baseUrl)) {
                    String redirectUrl = request.url.split("?")[0];
                    String paymentStatus = redirectUrl.split("/").last;
                    if (paymentStatus.toLowerCase() == "success") {
                      Navigator.pop(context, true);
                      return NavigationDecision.navigate;
                    } else if (paymentStatus.toLowerCase() == "fail") {
                      Navigator.pop(context, false);
                      return NavigationDecision.navigate;
                    }
                  }
                  return NavigationDecision.navigate;
                },
                onUrlChange: (request) {
                  if (request.url != null) {
                    if (request.url!.startsWith(Constant.baseUrl)) {
                      String redirectUrl = request.url!.split("?")[0];
                      String paymentStatus = redirectUrl.split("/").last;
                      if (paymentStatus.toLowerCase() == "pending" ||
                          paymentStatus.toLowerCase() == "fail" ||
                          paymentStatus.toLowerCase() == "success") {
                        Navigator.pop(context, paymentStatus.toLowerCase());
                      }
                    }
                  }
                },
              ),
            )
            ..loadRequest(Uri.parse(widget.paymentUrl.toString())),
        ),
      ),
    );
  }
}
