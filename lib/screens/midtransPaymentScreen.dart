import 'package:project/helper/utils/generalImports.dart';


class MidtransPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const MidtransPaymentScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<MidtransPaymentScreen> createState() => _MidtransPaymentScreenState();
}

class _MidtransPaymentScreenState extends State<MidtransPaymentScreen> {
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
            Navigator.pop(context, "202");
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
              Navigator.pop(context, "202");
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
                  return NavigationDecision.navigate;
                },
                onUrlChange: (request) {
                  if (request.url != null) {
                    Map<String, dynamic> queryParams =
                        extractQueryParameters(request.url!);
                    if (queryParams.keys.contains("status_code")) {
                      Navigator.pop(
                          context, queryParams["status_code"].toString());
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

  Map<String, dynamic> extractQueryParameters(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters;
  }
}
