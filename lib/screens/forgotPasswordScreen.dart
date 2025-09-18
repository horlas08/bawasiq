import 'package:project/helper/utils/generalImports.dart';


// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  bool? showMobileNumberWidget;
  String? from;
  ForgotPasswordScreen({
    Key? key, this.showMobileNumberWidget, this.from
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  CountryCode? selectedCountryCode;
  //TODO REMOVE EMAIL AND PASSWORD
  final TextEditingController editEmailTextEditingController =
      TextEditingController();
  final TextEditingController editPasswordTextEditingController =
      TextEditingController();
  final TextEditingController editConfirmPasswordTextEditingController =
      TextEditingController();
      final TextEditingController editMobileTextEditingController = TextEditingController();
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  bool showPasswordWidget = false;
  bool isLoading = false;
  final pinController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String otpVerificationId = "";
  int? forceResendingToken;
  String resendOtpVerificationId = "";

  void ToggleComponentsWidget(bool showMobileWidget) {
    setState(() {
      showPasswordWidget = showMobileWidget;
    });
  }

  @override
  void initState() {
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
            child: loginWidgets(),
          ),
          PositionedDirectional(
            top: 20,
            start: 0,
            child: backButtonText(),
          ),
        ],
      ),
    );
  }

  Widget backButtonText() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: ColorsRes.appColorTransparent,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: SizedBox(
            child: defaultImg(
              boxFit: BoxFit.contain,
              image: AppAssets.icArrowBackIcon,
              iconColor: ColorsRes.mainTextColor,
            ),
          ),
        ),
      ),
    );
  }

  firebaseLoginProcess() async {
    setState(() {});
    if (editMobileTextEditingController.text.isNotEmpty) {
        if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
          await firebaseAuth.verifyPhoneNumber(
            timeout: Duration(minutes: 1, seconds: 30),
            phoneNumber: '${selectedCountryCode!.dialCode}${editMobileTextEditingController.text}',
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              showMessage(
                context,
                e.message!,
                MessageType.warning,
              );

              setState(() {
                isLoading = false;
              });
            },
            codeSent: (String verificationId, int? resendToken) {
              forceResendingToken = resendToken;
              isLoading = false;
              setState(() {
                otpVerificationId = verificationId;

                /* List<dynamic> firebaseArguments = [
                  firebaseAuth,
                  otpVerificationId,
                  editMobileTextEditingController.text,
                  selectedCountryCode!,
                  widget.from ?? null
                ]; */
                // Navigator.pushNamed(context, otpScreen, arguments: firebaseArguments);
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            forceResendingToken: forceResendingToken,
          );
        } else if (Constant.customSmsGatewayOtpBased == "1") {
          context.read<UserProfileProvider>().sendCustomOTPSmsProvider(
            context: context,
            params: {ApiAndParams.phone: "$selectedCountryCode${editMobileTextEditingController.text}"},
          ).then(
            (value) {
              if (value == "1") {
                /* List<dynamic> firebaseArguments = [
                  firebaseAuth,
                  otpVerificationId,
                  editMobileTextEditingController.text,
                  selectedCountryCode!,
                  widget.from ?? null
                ]; */
                // Navigator.pushNamed(context, otpScreen, arguments: firebaseArguments);
                
              } else {
                setState(() {
                  isLoading = false;
                });
                showMessage(
                  context,
                  getTranslatedValue(
                    context,
                    smsGatewayErrorLabel,
                  ),
                  MessageType.warning,
                );
              }
            },
          );
        }
      }
  }

  Future/* <bool> */ verifyOtp() async {
    if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
      isLoading = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendOtpVerificationId.isNotEmpty ? resendOtpVerificationId : otpVerificationId, smsCode: pinController.text);

      firebaseAuth.signInWithCredential(credential).then((value) {
        // User? user = value.user;
        // backendApiProcess(user);
        // return user!=null;
        forgotPasswordApi(context: context, params: {
          ApiAndParams.mobile: editMobileTextEditingController.text,
          ApiAndParams.countryCode: selectedCountryCode!.dialCode,
          ApiAndParams.password: editPasswordTextEditingController.text,
          ApiAndParams.passwordConfirmation: editConfirmPasswordTextEditingController.text,
          ApiAndParams.type: "phone",
          ApiAndParams.otpVerifyMethod: context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1" ? "firebase" : "twilio"
        }).then(
          (value) {
            isLoading = false;
            setState(() {});
            showMessage(
                context,
                getTranslatedValue(
                  context,
                  value[ApiAndParams.message].toString(),
                ),
                (value[ApiAndParams.status].toString() == "1") ? MessageType.success : MessageType.warning);

            if (value[ApiAndParams.status].toString() == "1") {
              Navigator.pop(context);
            }
          },
        );
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
        // return false;
      });
    } else if (Constant.customSmsGatewayOtpBased == "1") {
      await context.read<UserProfileProvider>().verifyUserProvider(context: context, params: {
        ApiAndParams.otp: pinController.text,
        ApiAndParams.phone: editMobileTextEditingController.text,
        ApiAndParams.countryCode: selectedCountryCode!.dialCode.toString(),
      }).then((value) {
        customSMSBackendApiProcess();
        // return true;
      });
    }
    setState(() {});
    print("");
    // return false;
  }

  customSMSBackendApiProcess() async {
    Map<String, String> params = {
      ApiAndParams.type: "phone",
      ApiAndParams.mobile: editMobileTextEditingController.text,
      ApiAndParams.countryCode: selectedCountryCode!.dialCode.toString(),
    };

    await context.read<UserProfileProvider>().verifyUserProvider(context: context, params: params).then((value) async {
      if (value[ApiAndParams.status].toString() == "1" ) {
        return true;
        }else{
          return false;
        }
    });
  }

  Widget proceedBtn() {
    return (isLoading)
        ? Container(
            height: 55,
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          )
        : gradientBtnWidget(
            context,
            10,
            title: getTranslatedValue(
              context,
              showPasswordWidget ? changePasswordLabel : sendOtpLabel,
            ).toUpperCase(),
            callback: () async {
              if (await fieldValidation() == true) {
                isLoading = true;
                setState(() {});
                if (!showPasswordWidget) {
                  if (widget.showMobileNumberWidget == true) {
                    await context.read<UserProfileProvider>().verifyUserExistProvider(context: context, params: {
                      ApiAndParams.type: "phone",
                      ApiAndParams.mobile: editMobileTextEditingController.text,
                      ApiAndParams.countryCode: selectedCountryCode!.dialCode.toString(),
                    }).then((value) {
                      if (value[ApiAndParams.status].toString() == "1" && value[ApiAndParams.message] == "user_already_exist") {
                        isLoading = false;
                        ToggleComponentsWidget(true);
                        firebaseLoginProcess();
                      }else{
                        showMessage(
                          context,
                          getTranslatedValue(
                            context,
                            value[ApiAndParams.message].toString(),
                          ),
                          MessageType.warning,
                        );
                        isLoading = false;
                        setState(() {});
                      }
                    });
                  }else{
                    sendOTPForgotPasswordApi(params: {ApiAndParams.email: editEmailTextEditingController.text}, context: context).then(
                      (value) {
                        if (value[ApiAndParams.status].toString() == "1") {
                          isLoading = false;
                          ToggleComponentsWidget(true);
                          showMessage(
                            context,
                            getTranslatedValue(
                              context,
                              value[ApiAndParams.message].toString(),
                            ),
                            MessageType.success,
                          );
                        } else {
                          showMessage(
                            context,
                            getTranslatedValue(
                              context,
                              value[ApiAndParams.message].toString(),
                            ),
                            MessageType.warning,
                          );
                          isLoading = false;
                          setState(() {});
                        }
                      },
                    );
                  }
                } else {
                  if(widget.showMobileNumberWidget==true && showPasswordWidget == true){
                    verifyOtp();
                  }else{
                  forgotPasswordApi(context: context, params: {
                    ApiAndParams.email: editEmailTextEditingController.text,
                    ApiAndParams.otp: pinController.text,
                    ApiAndParams.password:
                        editPasswordTextEditingController.text,
                    ApiAndParams.passwordConfirmation:
                        editConfirmPasswordTextEditingController.text
                  }).then(
                    (value) {
                      isLoading = false;
                      setState(() {});
                      showMessage(
                          context,
                          getTranslatedValue(
                            context,
                            value[ApiAndParams.message].toString(),
                          ),
                          (value[ApiAndParams.status].toString() == "1")
                              ? MessageType.success
                              : MessageType.warning);

                      if (value[ApiAndParams.status].toString() == "1") {
                        Navigator.pop(context);
                      }
                    },
                  );
                  }
                }
              }
            },
          );
  }

  Widget loginWidgets() {
    return Container(
      padding: EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextLabel(
            jsonKey: getTranslatedValue(context, forgotPasswordTitleLabel),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 30,
              color: ColorsRes.appColor,
            ),
          ),
          getSizedBox(height: Constant.size20),
          Visibility(
            visible: widget.showMobileNumberWidget == true && widget.from == "user_exist_password_blank",
            child: Text(getTranslatedValue(context, systemUpgradeMessageLabel),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 12,
                color: ColorsRes.appColorRed,
              ),
            ),
          ),
          getSizedBox(height: Constant.size20),
          widget.showMobileNumberWidget!? mobilePasswordWidget() :emailPasswordWidget(),
          getSizedBox(height: Constant.size20),
          proceedBtn(),
          getSizedBox(height: Constant.size20),
        ],
      ),
    );
  }

  emailPasswordWidget() {
    return Column(
      children: [
        editBoxWidget(
          context,
          editEmailTextEditingController,
          emailValidation,
          getTranslatedValue(
            context,
            emailLabel,
          ),
          getTranslatedValue(
            context,
            enterValidEmailLabel,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          maxLines: 1,
          TextInputType.emailAddress,
        ),
        AnimatedOpacity(
          opacity: showPasswordWidget ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: showPasswordWidget,
            child: Column(
              children: [
                SizedBox(height: Constant.size15),
                otpPinWidget(context: context, pinController: pinController),
                SizedBox(height: Constant.size15),
                ChangeNotifierProvider<PasswordShowHideProvider>(
                  create: (context) => PasswordShowHideProvider(),
                  child: Consumer<PasswordShowHideProvider>(
                    builder: (context, provider, child) {
                      return editBoxWidget(
                        context,
                        editPasswordTextEditingController,
                        emptyValidation,
                        getTranslatedValue(
                          context,
                          passwordLabel,
                        ),
                        getTranslatedValue(
                          context,
                          enterValidPasswordLabel,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLines: 1,
                        obscureText: provider.isPasswordShowing(),
                        tailIcon: GestureDetector(
                          onTap: () {
                            provider.togglePasswordVisibility();
                          },
                          child: defaultImg(
                            image: provider.isPasswordShowing() == true
                                ? AppAssets.hidePasswordIcon
                                : AppAssets.showPasswordIcon,
                            iconColor: ColorsRes.grey,
                            width: 13,
                            height: 13,
                            padding: EdgeInsetsDirectional.all(12),
                          ),
                        ),
                        optionalTextInputAction: TextInputAction.done,
                        TextInputType.text,
                      );
                    },
                  ),
                ),
                SizedBox(height: Constant.size15),
                ChangeNotifierProvider<PasswordShowHideProvider>(
                  create: (context) => PasswordShowHideProvider(),
                  child: Consumer<PasswordShowHideProvider>(
                    builder: (context, provider, child) {
                      return editBoxWidget(
                        context,
                        editConfirmPasswordTextEditingController,
                        emptyValidation,
                        getTranslatedValue(
                          context,
                          confirmPasswordLabel,
                        ),
                        getTranslatedValue(
                          context,
                          enterValidConfirmPasswordLabel,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLines: 1,
                        obscureText: provider.isPasswordShowing(),
                        tailIcon: GestureDetector(
                          onTap: () {
                            provider.togglePasswordVisibility();
                          },
                          child: defaultImg(
                            image: provider.isPasswordShowing() == true
                                ? AppAssets.hidePasswordIcon
                                : AppAssets.showPasswordIcon,
                            iconColor: ColorsRes.grey,
                            width: 13,
                            height: 13,
                            padding: EdgeInsetsDirectional.all(12),
                          ),
                        ),
                        optionalTextInputAction: TextInputAction.done,
                        TextInputType.text,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  mobilePasswordWidget() {
    return Column(mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: widget.showMobileNumberWidget! ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: widget.showMobileNumberWidget!,
            child: Container(
              decoration: DesignConfig.boxDecoration(Theme.of(context).scaffoldBackgroundColor, 10,
                  bordercolor: ColorsRes.subTitleMainTextColor, isboarder: true, borderwidth: 1.0),
              child: Row(
                children: [
                  getSizedBox(width: Constant.size5),
                  IgnorePointer(
                    ignoring: isLoading,
                    child: CountryCodePicker(
                      onInit: (countryCode) {
                        selectedCountryCode = countryCode;
                      },
                      onChanged: (countryCode) {
                        selectedCountryCode = countryCode;
                      },
                      initialSelection: Constant.initialCountryCode,
                      textOverflow: TextOverflow.ellipsis,
                      backgroundColor: Theme.of(context).cardColor,
                      textStyle: TextStyle(color: ColorsRes.mainTextColor),
                      dialogBackgroundColor: Theme.of(context).cardColor,
                      dialogSize: Size(context.width, context.height),
                      barrierColor: ColorsRes.subTitleMainTextColor,
                      padding: EdgeInsets.zero,
                      searchDecoration: InputDecoration(
                        iconColor: ColorsRes.subTitleMainTextColor,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
                        ),
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: ColorsRes.subTitleMainTextColor,
                        ),
                      ),
                      searchStyle: TextStyle(
                        color: ColorsRes.subTitleMainTextColor,
                      ),
                      dialogTextStyle: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorsRes.grey,
                    size: 15,
                  ),
                  getSizedBox(width: Constant.size10),
                  Expanded(
                    child: TextField(
                      controller: editMobileTextEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          color: ColorsRes.grey.withValues(alpha: 0.8),
                        ),
                        hintText: getTranslatedValue(context, phoneNumberHintLabel),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        AnimatedOpacity(
          opacity: showPasswordWidget ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: showPasswordWidget,
            child: Column(
              children: [
                SizedBox(height: Constant.size15),
                otpPinWidget(context: context, pinController: pinController),
                SizedBox(height: Constant.size15),
                ChangeNotifierProvider<PasswordShowHideProvider>(
                  create: (context) => PasswordShowHideProvider(),
                  child: Consumer<PasswordShowHideProvider>(
                    builder: (context, provider, child) {
                      return editBoxWidget(
                        context,
                        editPasswordTextEditingController,
                        emptyValidation,
                        getTranslatedValue(
                          context,
                          passwordLabel,
                        ),
                        getTranslatedValue(
                          context,
                          enterValidPasswordLabel,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLines: 1,
                        obscureText: provider.isPasswordShowing(),
                        tailIcon: GestureDetector(
                          onTap: () {
                            provider.togglePasswordVisibility();
                          },
                          child: defaultImg(
                            image: provider.isPasswordShowing() ? AppAssets.hidePasswordIcon : AppAssets.showPasswordIcon,
                            iconColor: ColorsRes.grey,
                            width: 13,
                            height: 13,
                            padding: EdgeInsetsDirectional.all(12),
                          ),
                        ),
                        optionalTextInputAction: TextInputAction.done,
                        TextInputType.text,
                      );
                    },
                  ),
                ),
                SizedBox(height: Constant.size15),
                ChangeNotifierProvider<PasswordShowHideProvider>(
                  create: (context) => PasswordShowHideProvider(),
                  child: Consumer<PasswordShowHideProvider>(
                    builder: (context, provider, child) {
                      return editBoxWidget(
                        context,
                        editConfirmPasswordTextEditingController,
                        emptyValidation,
                        getTranslatedValue(
                          context,
                          confirmPasswordLabel,
                        ),
                        getTranslatedValue(
                          context,
                          enterValidConfirmPasswordLabel,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        maxLines: 1,
                        obscureText: provider.isPasswordShowing(),
                        tailIcon: GestureDetector(
                          onTap: () {
                            provider.togglePasswordVisibility();
                          },
                          child: defaultImg(
                            image: provider.isPasswordShowing() ? AppAssets.hidePasswordIcon : AppAssets.showPasswordIcon,
                            iconColor: ColorsRes.grey,
                            width: 13,
                            height: 13,
                            padding: EdgeInsetsDirectional.all(12),
                          ),
                        ),
                        optionalTextInputAction: TextInputAction.done,
                        TextInputType.text,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> fieldValidation() async {
    bool checkInternet = await checkInternetConnection();
    if (!checkInternet) {
      showMessage(
        context,
        getTranslatedValue(
          context,
          checkInternetLabel,
        ),
        MessageType.warning,
      );
      return false;
    } else {
      /* String? emailValidate = await emailValidation(
        editEmailTextEditingController.text,
      ); */

      String? passwordValidate = await emptyValidation(
        editPasswordTextEditingController.text,
      );

      String? inputValidation;
      String errorMessageKey;

      if (widget.showMobileNumberWidget == true) {
        // Validate mobile number
        inputValidation = await phoneValidation(editMobileTextEditingController.text);
        errorMessageKey = enterValidMobileLabel;
      } else {
        // Validate email
        inputValidation = await emailValidation(editEmailTextEditingController.text);
        errorMessageKey = enterValidEmailLabel;
      }

      if (inputValidation == "") {
        showMessage(
          context,
          getTranslatedValue(context, errorMessageKey),
          MessageType.warning,
        );
        return false;
      }

      /* if (emailValidate == "") {
        showMessage(
          context,
          getTranslatedValue(
            context,
            enterValidEmailLabel,
          ),
          MessageType.warning,
        );
        return false;
      } else  */if (showPasswordWidget) {
        if (passwordValidate == "") {
          showMessage(
            context,
            getTranslatedValue(
              context,
              enterValidPasswordLabel,
            ),
            MessageType.warning,
          );
          return false;
        } else if (editPasswordTextEditingController.text.length <= 5) {
          showMessage(
            context,
            getTranslatedValue(
              context,
              passwordTooShortLabel,
            ),
            MessageType.warning,
          );
          return false;
        } else if(editPasswordTextEditingController.text != editConfirmPasswordTextEditingController.text){
          showMessage(
            context,
            getTranslatedValue(
              context,
              passwordConfirmMismatchLabel,
            ),
            MessageType.warning,
          );
          return false;
        } else if (pinController.text == "") {
          showMessage(
            context,
            getTranslatedValue(
              context,
              otpRequiredLabel,
            ),
            MessageType.warning,
          );
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
