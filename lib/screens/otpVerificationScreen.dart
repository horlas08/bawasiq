import 'package:project/helper/utils/generalImports.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String otpVerificationId;
  final String phoneNumber;
  final FirebaseAuth firebaseAuth;
  final CountryCode selectedCountryCode;
  final String? from;

  const OtpVerificationScreen({
    Key? key,
    required this.otpVerificationId,
    required this.phoneNumber,
    required this.firebaseAuth,
    required this.selectedCountryCode,
    this.from,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<OtpVerificationScreen> {
  int otpLength = 6;
  bool isLoading = false;
  String resendOtpVerificationId = "";
  int? forceResendingToken;

  /// Create Controller
  final pinController = TextEditingController();

  static const _duration = Duration(minutes: 1, seconds: 30);
  Timer? _timer;
  Duration _remaining = _duration;

  void startTimer() {
    _remaining = _duration;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO REMOVE DEMO OTP FROM HERE
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        startTimer();
        if (widget.phoneNumber == "9876543210") {
          pinController.setText("123456");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            top: 0,
            child: Image.asset(
              Constant.getAssetsPath(0, "bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            top: 0,
            child: Image.asset(
              Constant.getAssetsPath(0, "bg_overlay.png"),
              fit: BoxFit.fill,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: otpWidgets(),
          ),
        ],
      ),
    );
  }

  Widget resendOtpWidget() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall!.merge(
            TextStyle(
              fontWeight: FontWeight.w400,
              color: ColorsRes.mainTextColor,
            ),
          ),
          text: (_timer != null && _timer!.isActive)
              ? "${getTranslatedValue(
            context,
            resendOtpInLabel,
          )} "
              : "",
          children: <TextSpan>[
            TextSpan(
                text: _timer != null && _timer!.isActive
                    ? '${_remaining.inMinutes.toString().padLeft(2, '0')}:${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}'
                    : getTranslatedValue(
                  context,
                  resendOtpLabel,
                ),
                style: TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  verifyOtp() async {
    if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
      isLoading = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendOtpVerificationId.isNotEmpty
              ? resendOtpVerificationId
              : widget.otpVerificationId,
          smsCode: pinController.text);

      widget.firebaseAuth.signInWithCredential(credential).then((value) {
        User? user = value.user;
        backendApiProcess(user);
      }).catchError((e) {
        showMessage(
          context,
          getTranslatedValue(
            context,
            enterValidOtpLabel,
          ),
          MessageType.warning,
        );
        setState(() {
          isLoading = false;
        });
      });
    } else if (Constant.customSmsGatewayOtpBased == "1") {
      await context
          .read<UserProfileProvider>()
          .verifyUserProvider(context: context, params: {
        ApiAndParams.otp: pinController.text,
        ApiAndParams.phone: widget.phoneNumber,
        ApiAndParams.countryCode:
        widget.selectedCountryCode.dialCode.toString(),
      }).then((value) {
        customSMSBackendApiProcess();
      });
    }
    setState(() {});
  }

  otpWidgets() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextLabel(
            jsonKey: enterVerificationCodeLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 30,
              color: ColorsRes.mainTextColor,
            ),
          ),
          CustomTextLabel(
            jsonKey: otpSendMessageLabel,
          ),
          CustomTextLabel(
            text: "${widget.selectedCountryCode}-${widget.phoneNumber}",
          ),
          const SizedBox(height: 60),
          otpPinWidget(
              context: context,
              pinController: pinController,
              onCompleted: verifyOtp),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: _timer != null && _timer!.isActive
                ? null
                : () {
              startTimer();
              if (Constant.customSmsGatewayOtpBased == "1") {
                context
                    .read<UserProfileProvider>()
                    .sendCustomOTPSmsProvider(
                  context: context,
                  params: {
                    ApiAndParams.phone:
                    "${widget.selectedCountryCode.dialCode}${widget.phoneNumber}",
                  },
                ).then((value) {
                  if (value[ApiAndParams.status].toString() == "1") {
                    if (value.containKey(ApiAndParams.data)) {
                      backendApiProcess(null);
                    } else {
                      Map<String, String> params = {
                        ApiAndParams.id: widget.phoneNumber,
                        ApiAndParams.type: "phone",
                        ApiAndParams.name: "",
                        ApiAndParams.email: "",
                        ApiAndParams.countryCode: widget
                            .selectedCountryCode.dialCode
                            ?.replaceAll("+", "")
                            .toString() ??
                            "",
                        ApiAndParams.mobile: widget.phoneNumber,
                        ApiAndParams.type: "phone",
                        ApiAndParams.platform:
                        Platform.isAndroid ? "android" : "ios",
                        ApiAndParams.fcmToken: Constant.session
                            .getData(SessionManager.keyFCMToken),
                        ApiAndParams.initialCountryCode: widget.selectedCountryCode.code!
                      };

                      Navigator.of(context).pushReplacementNamed(
                          editProfileScreen,
                          arguments: [widget.from ?? "register", params]);
                    }
                  }
                });
              } else if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
                firebaseLoginProcess();
              }
              setState(() {});
            },
            child: resendOtpWidget(),
          ),
          const SizedBox(height: 60),
        ]),
      ),
    );
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Map<String, String> params = {
        ApiAndParams.id: widget.phoneNumber,
        ApiAndParams.type: "phone",
        ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
        ApiAndParams.fcmToken:
        Constant.session.getData(SessionManager.keyFCMToken),
        ApiAndParams.phoneAuthType: (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword=="1")?"phone_auth_password":"phone_auth_otp",
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) async {
        if (value == 1) {
          if (widget.from == "add_to_cart") {
            addGuestCartBulkToCartWhileLogin(
              context: context,
              params: Constant.setGuestCartParams(
                cartList: context.read<CartListProvider>().cartList,
              ),
            ).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
            if (context.read<CartListProvider>().cartList.isNotEmpty) {
              addGuestCartBulkToCartWhileLogin(
                context: context,
                params: Constant.setGuestCartParams(
                  cartList: context.read<CartListProvider>().cartList,
                ),
              ).then(
                    (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                  mainHomeScreen,
                      (Route<dynamic> route) => false,
                ),
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                mainHomeScreen,
                    (Route<dynamic> route) => false,
              );
            }
          }

          if (Constant.session.isUserLoggedIn()) {
            await context
                .read<CartProvider>()
                .getCartListProvider(context: context);
          } else {
            if (context.read<CartListProvider>().cartList.isNotEmpty) {
              await context
                  .read<CartProvider>()
                  .getGuestCartListProvider(context: context);
            }
          }
        } else {
          Map<String, String> params = {
            ApiAndParams.id: widget.phoneNumber,
            ApiAndParams.type: "phone",
            ApiAndParams.name: user.displayName ?? "",
            ApiAndParams.email: user.email ?? "",
            ApiAndParams.countryCode: widget.selectedCountryCode.dialCode
                ?.replaceAll("+", "")
                .toString() ??
                "",
            ApiAndParams.mobile: user.phoneNumber
                .toString()
                .replaceAll(widget.selectedCountryCode.dialCode.toString(), ""),
            ApiAndParams.type: "phone",
            ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
            ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken),
          };

          Navigator.of(context).pushReplacementNamed(editProfileScreen,
              arguments: [widget.from ?? "register", params]);
        }
      });
    }
  }

  customSMSBackendApiProcess() async {
    Map<String, String> params = {
      ApiAndParams.id: widget.phoneNumber,
      ApiAndParams.type: "phone",
      ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
      ApiAndParams.fcmToken:
      Constant.session.getData(SessionManager.keyFCMToken),
      ApiAndParams.phoneAuthType: (context.read<AppSettingsProvider>().settingsData!.phoneAuthPassword=="1")?"phone_auth_password":"phone_auth_otp",
    };

    await context
        .read<UserProfileProvider>()
        .loginApi(context: context, params: params)
        .then((value) async {
      if (value == 1) {
        if (widget.from == "add_to_cart") {
          addGuestCartBulkToCartWhileLogin(
            context: context,
            params: Constant.setGuestCartParams(
              cartList: context.read<CartListProvider>().cartList,
            ),
          ).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
          if (context.read<CartListProvider>().cartList.isNotEmpty) {
            addGuestCartBulkToCartWhileLogin(
              context: context,
              params: Constant.setGuestCartParams(
                cartList: context.read<CartListProvider>().cartList,
              ),
            ).then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                mainHomeScreen,
                    (Route<dynamic> route) => false,
              ),
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              mainHomeScreen,
                  (Route<dynamic> route) => false,
            );
          }
        }

        if (Constant.session.isUserLoggedIn()) {
          await context
              .read<CartProvider>()
              .getCartListProvider(context: context);
        } else {
          if (context.read<CartListProvider>().cartList.isNotEmpty) {
            await context
                .read<CartProvider>()
                .getGuestCartListProvider(context: context);
          }
        }
      } else {
        Map<String, String> params = {
          ApiAndParams.id: widget.phoneNumber,
          ApiAndParams.type: "phone",
          ApiAndParams.name:  "",
          ApiAndParams.email: "",
          ApiAndParams.countryCode: widget.selectedCountryCode.dialCode
              ?.replaceAll("+", "")
              .toString() ??
              "",
          ApiAndParams.mobile: widget.phoneNumber,
          ApiAndParams.type: "phone",
          ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
          ApiAndParams.fcmToken:
          Constant.session.getData(SessionManager.keyFCMToken),
        };

        Navigator.of(context).pushReplacementNamed(editProfileScreen,
            arguments: [widget.from ?? "register", params]);
      }
    });
  }

  Future checkOtpValidation() async {
    bool checkInternet = await checkInternetConnection();
    String? msg;
    if (checkInternet) {
      if (pinController.text.length == 1) {
        msg = getTranslatedValue(
          context,
          enterOtpLabel,
        );
      } else if (pinController.text.length <= otpLength) {
        msg = getTranslatedValue(
          context,
          enterValidOtpLabel,
        );
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        msg = "";
      }
    } else {
      msg = getTranslatedValue(
        context,
        checkInternetLabel,
      );
    }
    return msg;
  }

  firebaseLoginProcess() async {
    if (widget.phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
        '${widget.selectedCountryCode.dialCode} - ${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {
          pinController.setText(credential.smsCode ?? "");
        },
        verificationFailed: (FirebaseAuthException e) {
          showMessage(
            context,
            e.message!,
            MessageType.warning,
          );
          if (mounted) {
            isLoading = false;
            setState(() {});
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          if (mounted) {
            isLoading = false;
            setState(() {
              resendOtpVerificationId = verificationId;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            isLoading = false;
            setState(() {
              // isLoading = false;
            });
          }
        },
        forceResendingToken: forceResendingToken,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
