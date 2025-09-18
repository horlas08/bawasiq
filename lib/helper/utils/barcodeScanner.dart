import 'dart:ui';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:project/helper/styles/scannerOverlayPainter.dart';
import 'package:project/helper/utils/generalImports.dart';


class BarCodeScanner extends StatefulWidget {
  const BarCodeScanner({
    super.key,
  });

  @override
  State<BarCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<BarCodeScanner>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /// Scanner controller
  late MobileScannerController controller;
  bool loading = false;
  bool isCameraHidden = false;
  bool isFirstTimeError =
      true; //if false the error won't redirect to settings screen
  ValueNotifier<String?> lastScannedErrorBarcode = ValueNotifier(null);
  late AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1));

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Finally, start the scanner itself.
    controller = MobileScannerController(autoStart: false);

    controller.stop().then((_) {
      controller.start();
    });
    animationController.forward();
    animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    lastScannedErrorBarcode.dispose();
    animationController.dispose();
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  Future<void> checkForForeverDeniedPermissionAndRedirectToSettings() async {
    final permissionStatus = await Permission.camera.status;
    if (!(permissionStatus == PermissionStatus.granted)) {
      final afterAskStatus = await Permission.camera.request();
      if (!(afterAskStatus == PermissionStatus.granted)) {
        openAppSettings();
        showMessage(
            context,
            getTranslatedValue(
                context, allowCameraPermissionToScanQrLabel),
            MessageType.error);
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, "-1");
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: getAppBar(
            context: context,
            title: CustomTextLabel(
              jsonKey: searchProductLabel,
            ),
          ),
          backgroundColor: ColorsRes.appColorBlack,
          body: Stack(
            children: [
              isCameraHidden
                  ? const SizedBox()
                  : MobileScanner(
                      controller: controller,
                      key: UniqueKey(),
                      errorBuilder: (BuildContext, MobileScannerException) {
                        if (isFirstTimeError) {
                          Future.delayed(const Duration(seconds: 2), () {
                            if (context.mounted) {
                              checkForForeverDeniedPermissionAndRedirectToSettings();
                            }
                          });
                          isFirstTimeError = false;
                        }
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error,
                                  size: 30,
                                  color: ColorsRes.appColorRed,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslatedValue(
                                      context, cameraOpenErrorLabel),
                                  style: TextStyle(color: ColorsRes.appColorWhite),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onDetect: (BarcodeCapture barcode) async {
                        await HapticFeedback.vibrate();
                        Navigator.pop(context, barcode.barcodes.first.rawValue);

                        //!Do not remove it
                        animationController.dispose();
                        await controller.dispose();
                      },
                    ),
              ValueListenableBuilder(
                valueListenable: lastScannedErrorBarcode,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      /* Container(
                        decoration: ShapeDecoration(
                          shape: OverlayShape(
                            borderColor:
                                value != null ? ColorsRes.appColorRed : ColorsRes.appColorWhite,
                            borderRadius: 16,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: 0.0,
                            cutOutHeight: 300,
                            cutOutWidth: 300,
                            overlayColor: const Color.fromRGBO(0, 0, 0, 80),
                          ),
                        ),
                      ) */
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ScannerOverlayPainter(
                            cutOutSize: Size(300, 300),
                            borderColor: value != null ? ColorsRes.appColorRed : ColorsRes.appColorWhite,
                            overlayColor: const Color.fromRGBO(0, 0, 0, 80),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return Center(
                            child: Container(
                              width: 290,
                              height: 300,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: lerpDouble(
                                        0, 292, animationController.value),
                                    child: Container(
                                      width: 300,
                                      height: 8,
                                      color: ColorsRes.appColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}