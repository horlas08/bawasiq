import 'package:image_picker_platform_interface/src/types/image_source.dart' as ip;
import 'package:project/helper/utils/generalImports.dart';

/// An optimized version of the EditProfile screen with improved structure,
/// performance, and maintainability.
class EditProfile extends StatefulWidget {
  final String? from;
  final Map<String, String>? loginParams;

  const EditProfile({Key? key, this.from, this.loginParams}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController editUserNameTextEditingController;
  late TextEditingController editEmailTextEditingController;
  late TextEditingController editMobileTextEditingController;
  final TextEditingController editPasswordTextEditingController = TextEditingController();
  final TextEditingController editConfirmPasswordTextEditingController = TextEditingController();
  late TextEditingController editFriendsCodeTextEditingController;

  CountryCode? selectedCountryCode;
  bool isLoading = false;
  String tempName = "";
  String tempEmail = "";
  String tempMobile = "";
  String selectedImagePath = "";

  bool isEditable = false;
  bool showOtpWidget = false;

  final pinController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String otpVerificationId = "";
  int? forceResendingToken;
  String resendOtpVerificationId = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize user data and controllers
  Future<void> _initializeData() async {
    if (Constant.session.isUserLoggedIn()) {
      isEditable = Constant.session.getData(SessionManager.keyLoginType) == "phone";
    } else {
      isEditable = widget.loginParams?[ApiAndParams.type] == "phone";
    }

    tempName = widget.from == "header" ? Constant.session.getData(SessionManager.keyUserName) : widget.loginParams?[ApiAndParams.name] ?? "";
    tempEmail = widget.from == "header" ? Constant.session.getData(SessionManager.keyEmail) : widget.loginParams?[ApiAndParams.email] ?? "";
    tempMobile = widget.from == "header" ? Constant.session.getData(SessionManager.keyPhone) : widget.loginParams?[ApiAndParams.mobile] ?? "";

    editUserNameTextEditingController = TextEditingController(text: tempName);
    editEmailTextEditingController = TextEditingController(text: tempEmail);
    editMobileTextEditingController = TextEditingController(text: tempMobile);
    editFriendsCodeTextEditingController = TextEditingController();

    selectedImagePath = "";
    setState(() {});
  }

  /// Toggle OTP widget visibility
  void toggleOtpWidget(bool showMobileWidget) {
    setState(() {
      showOtpWidget = showMobileWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: (widget.from == "register" || widget.from == "email_register")
              ? getTranslatedValue(context, registerLabel)
              : getTranslatedValue(context, editProfileLabel),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        showBackButton: widget.from != "register",
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: Constant.size10, vertical: Constant.size15),
        children: [
          ProfileImageWidget(
            selectedImagePath: selectedImagePath,
            onImageSelected: (path) {
              setState(() {
                selectedImagePath = path;
              });
            },
            showEditButton: widget.from != "register",
            sessionImageUrl: Constant.session.getData(SessionManager.keyUserImage),
          ),
          Container(
            decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.size10, vertical: Constant.size15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserInfoFormWidget(
                    formKey: _formKey,
                    userNameController: editUserNameTextEditingController,
                    emailController: editEmailTextEditingController,
                    mobileController: editMobileTextEditingController,
                    passwordController: editPasswordTextEditingController,
                    confirmPasswordController: editConfirmPasswordTextEditingController,
                    friendsCodeController: editFriendsCodeTextEditingController,
                    showOtpWidget: showOtpWidget,
                    pinController: pinController,
                    isEditable: isEditable,
                    from: widget.from,
                    onCountryCodeSelected: (CountryCode? code) {
                      if (code != null) {
                        selectedCountryCode = code;
                      }
                    },
                    tempEmail: tempEmail,
                  ),
                  const SizedBox(height: 50),
                  ProceedButtonWidget(
                    formKey: _formKey,
                    from: widget.from,
                    showOtpWidget: showOtpWidget,
                    userNameController: editUserNameTextEditingController,
                    emailController: editEmailTextEditingController,
                    mobileController: editMobileTextEditingController,
                    passwordController: editPasswordTextEditingController,
                    confirmPasswordController: editConfirmPasswordTextEditingController,
                    friendsCodeController: editFriendsCodeTextEditingController,
                    pinController: pinController,
                    selectedCountryCode: selectedCountryCode,
                    selectedImagePath: selectedImagePath,
                    loginParams: widget.loginParams,
                    isEditable: isEditable,
                    onOtpWidgetToggle: toggleOtpWidget,
                    onFirebaseLoginProcess: firebaseLoginProcess,
                    onVerifyOtp: verifyOtp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle Firebase login process
  Future<void> firebaseLoginProcess() async {
    if (editMobileTextEditingController.text.isEmpty || selectedCountryCode == null) {
      showMessage(
        context,
        getTranslatedValue(context, enterValidMobileLabel),
        MessageType.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
        await firebaseAuth.verifyPhoneNumber(
          timeout: Duration(minutes: 1, seconds: 30),
          phoneNumber: '${selectedCountryCode!.dialCode}${editMobileTextEditingController.text}',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            showMessage(context, e.message!, MessageType.warning);
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              isLoading = false;
              otpVerificationId = verificationId;
              forceResendingToken = resendToken;
            });
            toggleOtpWidget(true);
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
        await context.read<UserProfileProvider>().sendCustomOTPSmsProvider(
          context: context,
          params: {ApiAndParams.phone: "${selectedCountryCode?.dialCode}${editMobileTextEditingController.text}"},
        ).then(
          (value) {
            if (value == "1") {
              toggleOtpWidget(true);
            } else {
              setState(() {
                isLoading = false;
              });
              showMessage(
                context,
                getTranslatedValue(context, smsGatewayErrorLabel),
                MessageType.warning,
              );
            }
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  /// Verify OTP code
  Future<void> verifyOtp() async {
    if (pinController.text.isEmpty) {
      showMessage(
        context,
        getTranslatedValue(context, otpRequiredLabel),
        MessageType.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (context.read<AppSettingsProvider>().settingsData!.firebaseAuthentication == "1") {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendOtpVerificationId.isNotEmpty ? resendOtpVerificationId : otpVerificationId,
          smsCode: pinController.text,
        );

        await firebaseAuth.signInWithCredential(credential).then((value) {
          if (editFriendsCodeTextEditingController.text.trim().isNotEmpty) {
            widget.loginParams?[ApiAndParams.friendsCode] = editFriendsCodeTextEditingController.text.trim();
          }
          
          context.read<UserProfileProvider>().registerAccountApi(context: context, params: widget.loginParams ?? {}).then(
            (value) {
              if (value == "1") {
                toggleOtpWidget(true);
              }
            },
          );
        }).catchError((e) {
          showMessage(
            context,
            getTranslatedValue(context, enterValidOtpLabel),
            MessageType.warning,
          );
          setState(() {
            isLoading = false;
          });
        });
      } else if (Constant.customSmsGatewayOtpBased == "1") {
        final Map<String, String> params = {
          ApiAndParams.otp: pinController.text,
          ApiAndParams.phone: editMobileTextEditingController.text,
          ApiAndParams.countryCode: selectedCountryCode?.dialCode.toString() ?? "",
        };

        if (editFriendsCodeTextEditingController.text.trim().isNotEmpty) {
          params[ApiAndParams.friendsCode] = editFriendsCodeTextEditingController.text;
        }
        
        await context.read<UserProfileProvider>().verifyUserProvider(context: context, params: params).then((value) {
          if (value["status"].toString() == "1") {
            if (value["message"] == "otp_valid_but_user_not_found") {
              context.read<UserProfileProvider>().registerAccountApi(context: context, params: widget.loginParams ?? {}).then(
                (value) {
                  // Handle registration result
                },
              );
            } else {
              showMessage(context, value["message"], MessageType.warning);
            }
          } else {
            showMessage(context, value["message"], MessageType.warning);
          }
        });
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    editUserNameTextEditingController.dispose();
    editEmailTextEditingController.dispose();
    editMobileTextEditingController.dispose();
    editPasswordTextEditingController.dispose();
    editConfirmPasswordTextEditingController.dispose();
    editFriendsCodeTextEditingController.dispose();
    pinController.dispose();
    super.dispose();
  }
}

/// Widget for displaying and managing profile image
class ProfileImageWidget extends StatelessWidget {
  final String selectedImagePath;
  final String sessionImageUrl;
  final Function(String) onImageSelected;
  final bool showEditButton;

  const ProfileImageWidget({
    Key? key,
    required this.selectedImagePath,
    required this.onImageSelected,
    required this.showEditButton,
    required this.sessionImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 15, end: 15),
            child: ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: selectedImagePath.isEmpty
                  ? setNetworkImg(
                      height: 100,
                      width: 100,
                      boxFit: BoxFit.cover,
                      image: sessionImageUrl,
                    )
                  : Image.file(
                      File(selectedImagePath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (showEditButton)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: Container(
                  decoration: DesignConfig.boxGradient(5),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsetsDirectional.only(end: 8, top: 8),
                  child: defaultImg(
                    image: AppAssets.editIcon,
                    iconColor: ColorsRes.mainIconColor,
                    height: 15,
                    width: 15,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  /// Show bottom sheet with image picker options
  Future<void> _showImagePickerOptions(BuildContext context) async {
    final XFile? result = await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      backgroundColor: Theme.of(context).cardColor,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20),
              child: Column(
                children: [
                  getSizedBox(height: 20),
                  Center(
                    child: CustomTextLabel(
                      jsonKey: selectOptionLabel,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                            TextStyle(
                              letterSpacing: 0.5,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                    ),
                  ),
                  getSizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImagePickerOption(
                        context,
                        Icons.image_rounded,
                        galleryLabel,
                        () => _pickImageFromGallery(context),
                      ),
                      getSizedBox(width: 10),
                      _buildImagePickerOption(
                        context,
                        Icons.camera_alt_rounded,
                        takePhotoLabel,
                        () => _pickImageFromCamera(context),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );

    if (result != null) {
      _cropImage(context, result.path);
    }
  }

  /// Build image picker option button
  Widget _buildImagePickerOption(
    BuildContext context,
    IconData icon,
    String tooltipLabel,
    VoidCallback onPressed,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 50),
      splashColor: ColorsRes.appColor,
      splashRadius: 50,
      color: ColorsRes.subTitleMainTextColor,
      tooltip: getTranslatedValue(context, tooltipLabel),
    );
  }

  /// Pick image from gallery
  Future<XFile?> _pickImageFromGallery(BuildContext context) async {
    if (await Permission.storage.isGranted ||
        await Permission.storage.isLimited ||
        await Permission.photos.isGranted ||
        await Permission.photos.isLimited) {
      return await ImagePicker().pickImage(source: ip.ImageSource.gallery);
    } else if (await Permission.storage.isPermanentlyDenied) {
      if (!Constant.session.getBoolData(SessionManager.keyPermissionGalleryHidePromptPermanently)) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                PermissionHandlerBottomSheet(
                  titleJsonKey: storagePermissionTitleLabel,
                  messageJsonKey: storagePermissionMessageLabel,
                  sessionKeyForAskNeverShowAgain: SessionManager.keyPermissionGalleryHidePromptPermanently,
                ),
              ],
            );
          },
        );
      }
    }
    return null;
  }

  /// Pick image from camera
  Future<XFile?> _pickImageFromCamera(BuildContext context) async {
    final status = await hasCameraPermissionGiven(context);
    
    if (Platform.isAndroid) {
      if (status.isGranted) {
        return await ImagePicker().pickImage(
          source: ip.ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          maxHeight: 512,
          maxWidth: 512,
        );
      } else if (status.isDenied) {
        await Permission.camera.request();
      } else if (status.isPermanentlyDenied) {
        if (!Constant.session.getBoolData(SessionManager.keyPermissionCameraHidePromptPermanently)) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  PermissionHandlerBottomSheet(
                    titleJsonKey: cameraPermissionTitleLabel,
                    messageJsonKey: cameraPermissionMessageLabel,
                    sessionKeyForAskNeverShowAgain: SessionManager.keyPermissionCameraHidePromptPermanently,
                  ),
                ],
              );
            },
          );
        }
      }
    } else if (Platform.isIOS) {
      return await ImagePicker().pickImage(
        source: ip.ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxHeight: 512,
        maxWidth: 512,
      );
    }
    return null;
  }

  /// Crop selected image
  Future<void> _cropImage(BuildContext context, String filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      compressFormat: ImageCompressFormat.png,
      maxHeight: 512,
      maxWidth: 512,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Theme.of(context).cardColor,
          toolbarWidgetColor: ColorsRes.mainTextColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeControlsWidgetColor: ColorsRes.appColor,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: false,
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      onImageSelected(croppedFile.path);
    }
  }
}

/// Widget for user information form
class UserInfoFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController friendsCodeController;
  final TextEditingController pinController;
  final bool showOtpWidget;
  final bool isEditable;
  final String? from;
  final String tempEmail;
  final ValueChanged<CountryCode?> onCountryCodeSelected;

  const UserInfoFormWidget({
    Key? key,
    required this.formKey,
    required this.userNameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.friendsCodeController,
    required this.pinController,
    required this.showOtpWidget,
    required this.isEditable,
    required this.from,
    required this.tempEmail,
    required this.onCountryCodeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildUserNameField(context),
          SizedBox(height: Constant.size15),
          _buildEmailField(context),
          SizedBox(height: Constant.size15),
          _buildMobileField(context),
          if (from == "email_register" || from == "mobile_register") ..._buildPasswordFields(context),
          if (from != "header") ..._buildFriendsCodeField(context),
        ],
      ),
    );
  }

  /// Build username input field
  Widget _buildUserNameField(BuildContext context) {
    return editBoxWidget(
      context,
      userNameController,
      emptyValidation,
      getTranslatedValue(context, userNameLabel),
      getTranslatedValue(context, enterUserNameLabel),
      TextInputType.text,
    );
  }

  /// Build email input field
  Widget _buildEmailField(BuildContext context) {
    return editBoxWidget(
      context,
      emailController,
      from == "mobile_register" ? (value) => null : emailValidation,
      getTranslatedValue(context, emailLabel),
      getTranslatedValue(context, enterValidEmailLabel),
      TextInputType.emailAddress,
      isEditable: (tempEmail.isEmpty || isEditable),
    );
  }

  /// Build mobile number input field with country code picker
  Widget _buildMobileField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsRes.subTitleMainTextColor, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          CountryCodePicker(
            onInit: onCountryCodeSelected,
            onChanged: onCountryCodeSelected,
            enabled: !isEditable,
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
              prefixIcon: Icon(Icons.search_rounded, color: ColorsRes.subTitleMainTextColor),
            ),
            searchStyle: TextStyle(color: ColorsRes.subTitleMainTextColor),
            dialogTextStyle: TextStyle(color: ColorsRes.mainTextColor),
          ),
          Icon(Icons.keyboard_arrow_down, color: ColorsRes.grey, size: 15),
          getSizedBox(width: Constant.size10),
          Expanded(
            child: TextField(
              controller: mobileController,
              enabled: (!isEditable || mobileController.text.isEmpty),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: ColorsRes.mainTextColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(color: ColorsRes.grey.withValues(alpha: 0.5)),
                hintText: getTranslatedValue(context, phoneNumberHintLabel),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build password and confirm password fields
  List<Widget> _buildPasswordFields(BuildContext context) {
    return [
      SizedBox(height: Constant.size15),
      ChangeNotifierProvider<PasswordShowHideProvider>(
        create: (context) => PasswordShowHideProvider(),
        child: Consumer<PasswordShowHideProvider>(
          builder: (context, provider, child) {
            return editBoxWidget(
              context,
              passwordController,
              emptyValidation,
              getTranslatedValue(context, passwordLabel),
              getTranslatedValue(context, enterValidPasswordLabel),
              maxLines: 1,
              obscureText: provider.isPasswordShowing(),
              tailIcon: GestureDetector(
                onTap: () => provider.togglePasswordVisibility(),
                child: defaultImg(
                  image: provider.isPasswordShowing() == true ? AppAssets.hidePasswordIcon : AppAssets.showPasswordIcon,
                  iconColor: ColorsRes.grey,
                  width: 13,
                  height: 13,
                  padding: EdgeInsetsDirectional.all(12),
                ),
              ),
              optionalTextInputAction: TextInputAction.next,
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
              confirmPasswordController,
              emptyValidation,
              getTranslatedValue(context, confirmPasswordLabel),
              getTranslatedValue(context, enterValidConfirmPasswordLabel),
              maxLines: 1,
              obscureText: provider.isPasswordShowing(),
              tailIcon: GestureDetector(
                onTap: () => provider.togglePasswordVisibility(),
                child: defaultImg(
                  image: provider.isPasswordShowing() == true ? AppAssets.hidePasswordIcon : AppAssets.showPasswordIcon,
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
      if (showOtpWidget)
        AnimatedOpacity(
          opacity: showOtpWidget ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: showOtpWidget,
            child: Column(
              children: [
                SizedBox(height: Constant.size15),
                otpPinWidget(context: context, pinController: pinController),
              ],
            ),
          ),
        ),
      SizedBox(height: Constant.size15),
    ];
  }

  /// Build friends code field
  List<Widget> _buildFriendsCodeField(BuildContext context) {
    return [
      SizedBox(height: Constant.size15),
      editBoxWidget(
        context,
        friendsCodeController,
        (value) => null,
        getTranslatedValue(context, friendsCodeLabel),
        getTranslatedValue(context, enterFriendsCodeLabel),
        TextInputType.text,
      ),
    ];
  }
}

/// Widget for proceed button with validation and action handling
class ProceedButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? from;
  final bool showOtpWidget;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController friendsCodeController;
  final TextEditingController pinController;
  final CountryCode? selectedCountryCode;
  final String selectedImagePath;
  final Map<String, String>? loginParams;
  final bool isEditable;
  final Function(bool) onOtpWidgetToggle;
  final Function() onFirebaseLoginProcess;
  final Function() onVerifyOtp;

  const ProceedButtonWidget({
    Key? key,
    required this.formKey,
    required this.from,
    required this.showOtpWidget,
    required this.userNameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.friendsCodeController,
    required this.pinController,
    required this.selectedCountryCode,
    required this.selectedImagePath,
    required this.loginParams,
    required this.isEditable,
    required this.onOtpWidgetToggle,
    required this.onFirebaseLoginProcess,
    required this.onVerifyOtp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, _) {
        return userProfileProvider.profileState == ProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : gradientBtnWidget(
                context,
                10,
                title: getTranslatedValue(
                  context,
                  (!showOtpWidget && from == "email_register")
                      ? sendOtpLabel
                      : (from == "register_header" || from == "email_register" || from == "mobile_register")
                          ? registerLabel
                          : updateLabel,
                ),
                callback: () => _handleButtonPress(context, userProfileProvider),
              );
      },
    );
  }

  /// Handle button press based on current state
  Future<void> _handleButtonPress(BuildContext context, UserProfileProvider userProfileProvider) async {
    try {
      if (await _validateFields(context)) {
        formKey.currentState!.save();
        if (formKey.currentState!.validate()) {
          await _processFormSubmission(context, userProfileProvider);
        }
      }
    } catch (e) {
      userProfileProvider.changeState();
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  /// Validate form fields
  Future<bool> _validateFields(BuildContext context) async {
    bool checkInternet = await checkInternetConnection();
    if (!checkInternet) {
      showMessage(context, getTranslatedValue(context, checkInternetLabel), MessageType.warning);
      return false;
    }

    String? userNameValidate = await emptyValidation(userNameController.text);
    String? mobileValidate = await phoneValidation(mobileController.text);
    String? emailValidate = await emailValidation(emailController.text);
    String? passwordValidate = await emptyValidation(passwordController.text);

    if (userNameValidate == "") {
      showMessage(context, getTranslatedValue(context, enterValidUserNameLabel), MessageType.warning);
      return false;
    } else if (from != "mobile_register" && emailValidate == "") {
      showMessage(context, getTranslatedValue(context, enterValidEmailLabel), MessageType.warning);
      return false;
    } else if (isEditable && mobileValidate == "") {
      showMessage(context, getTranslatedValue(context, enterValidMobileLabel), MessageType.warning);
      return false;
    } else if (from == "email_register" && passwordValidate == "") {
      showMessage(context, getTranslatedValue(context, enterValidPasswordLabel), MessageType.warning);
      return false;
    } else if (from == "email_register" && (passwordController.text != confirmPasswordController.text)) {
      showMessage(context, getTranslatedValue(context, passwordConfirmMismatchLabel), MessageType.warning);
      return false;
    } else if (from == "email_register" && passwordController.text.length <= 5) {
      showMessage(context, getTranslatedValue(context, passwordTooShortLabel), MessageType.warning);
      return false;
    }

    return true;
  }

  /// Process form submission based on current state and form type
  Future<void> _processFormSubmission(BuildContext context, UserProfileProvider userProfileProvider) async {
    // Update login params with form values
    Map<String, String> params = loginParams?.cast<String, String>() ?? {};
    params[ApiAndParams.name] = userNameController.text.trim();

    if (loginParams?[ApiAndParams.type] == "phone" || Constant.session.getData(SessionManager.keyLoginType) == "phone") {
      if (emailController.text.isNotEmpty) {
        params[ApiAndParams.email] = emailController.text.trim();
      }
    } else {
      params[ApiAndParams.email] = emailController.text.trim();
    }

    if (loginParams?[ApiAndParams.type] != "phone" || Constant.session.getData(SessionManager.keyLoginType) != "phone") {
      if (mobileController.text.isNotEmpty) {
        params[ApiAndParams.mobile] = mobileController.text.trim();
      }
    } else {
      params[ApiAndParams.mobile] = mobileController.text.trim();
    }

    if (from == "email_register" || from == "mobile_register") {
      params[ApiAndParams.password] = passwordController.text.trim();
    }

    // Handle different form types and states
    if (from == "email_register" && !showOtpWidget) {
      if (friendsCodeController.text.trim().isNotEmpty) {
        params[ApiAndParams.friendsCode] = friendsCodeController.text.trim();
      }
      await userProfileProvider.registerAccountApi(context: context, params: params).then(
        (value) {
          if (value == "1") {
            onOtpWidgetToggle(true);
          }
        },
      );
    } else if (from == "mobile_register" && !showOtpWidget) {
      await onFirebaseLoginProcess();
    } else if (from == "mobile_register" && showOtpWidget) {
      params[ApiAndParams.type] = from == "mobile_register" ? "phone" : "email";
      params[ApiAndParams.fcmToken] = Constant.session.getData(SessionManager.keyFCMToken);
      await onVerifyOtp();
    } else if (from == "email_register" && showOtpWidget) {
      if (pinController.text.isEmpty) {
        showMessage(context, getTranslatedValue(context, otpRequiredLabel), MessageType.warning);
      } else {
        await userProfileProvider
            .verifyRegisteredEmailProvider(
          context: context,
          params: {
            ApiAndParams.email: emailController.text,
            ApiAndParams.code: pinController.text,
          },
          from: "otp_register",
        )
            .then((value) {
          if (value) {
            Navigator.pop(context);
          }
        });
      }
    } else if (from == "register" || from == "register_header" || from == "add_to_cart_register") {
      await _handleRegistration(context, userProfileProvider, params);
    } else {
      await _handleProfileUpdate(context, userProfileProvider);
    }
  }

  /// Handle user registration
  Future<void> _handleRegistration(BuildContext context, UserProfileProvider userProfileProvider, Map<String, String> params) async {
    if (selectedCountryCode != null) {
      params[ApiAndParams.countryCode] = selectedCountryCode!.dialCode.toString();
    } else {
      showMessage(context, getTranslatedValue(context, "Please select a country code"), MessageType.warning);
      return;
    }
    
    if (friendsCodeController.text.trim().isNotEmpty) {
      params[ApiAndParams.friendsCode] = friendsCodeController.text.trim();
    }

    await userProfileProvider.registerAccountApi(context: context, params: params).then(
      (value) async {
        if (value != "0") {
          if (context.read<CartListProvider>().cartList.isNotEmpty) {
            await addGuestCartBulkToCartWhileLogin(
              context: context,
              params: Constant.setGuestCartParams(
                cartList: context.read<CartListProvider>().cartList,
              ),
            ).then(
              (value) {
                if (from == "add_to_cart_register") {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
                }
              },
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
          }

          if (Constant.session.isUserLoggedIn()) {
            await context.read<CartProvider>().getCartListProvider(context: context);
          } else if (context.read<CartListProvider>().cartList.isNotEmpty) {
            await context.read<CartProvider>().getGuestCartListProvider(context: context);
          }
        }
      },
    );
  }

  /// Handle profile update
  Future<void> _handleProfileUpdate(BuildContext context, UserProfileProvider userProfileProvider) async {
    Map<String, String> params = {};
    params[ApiAndParams.name] = userNameController.text.trim();
    params[ApiAndParams.email] = emailController.text.trim();
    params[ApiAndParams.mobile] = mobileController.text.trim();
    
    if (selectedCountryCode != null) {
      params[ApiAndParams.countryCode] = selectedCountryCode!.dialCode.toString();
    } else {
      showMessage(context, getTranslatedValue(context, "Please select a country code"), MessageType.warning);
      return;
    }

    await userProfileProvider.updateUserProfile(context: context, selectedImagePath: selectedImagePath, params: params).then(
      (value) async {
        if (value is bool) {
          if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
              Constant.session.getData(SessionManager.keyLongitude) == "0" &&
              Constant.session.getData(SessionManager.keyAddress) == "") {
            Navigator.of(context).pushNamedAndRemoveUntil(
              confirmLocationScreen,
              (Route<dynamic> route) => false,
              arguments: [null, "location"],
            );
          } else {
            if (from == "header") {
              if (context.read<CartListProvider>().cartList.isNotEmpty) {
                await addGuestCartBulkToCartWhileLogin(
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
            } else if (from == "add_to_cart") {
              await addGuestCartBulkToCartWhileLogin(
                context: context,
                params: Constant.setGuestCartParams(
                  cartList: context.read<CartListProvider>().cartList,
                ),
              ).then(
                (value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            } else {
              showMessage(
                context,
                getTranslatedValue(context, profileUpdatedSuccessfullyLabel),
                MessageType.success,
              );
            }
          }
          userProfileProvider.changeState();
        } else {
          userProfileProvider.changeState();
          showMessage(context, value.toString(), MessageType.warning);
        }

        if (Constant.session.isUserLoggedIn()) {
          await context.read<CartProvider>().getCartListProvider(context: context);
        } else if (context.read<CartListProvider>().cartList.isNotEmpty) {
          await context.read<CartProvider>().getGuestCartListProvider(context: context);
        }
      },
    );
  }
}

/// Utility class for form validation
class FormValidator {
  /// Validate username
  static Future<bool> validateUsername(BuildContext context, String username) async {
    if (username.trim().isEmpty) {
      showMessage(context, getTranslatedValue(context, enterValidUserNameLabel), MessageType.warning);
      return false;
    }
    return true;
  }

  /// Validate email
  static Future<bool> validateEmail(BuildContext context, String email, {bool required = true}) async {
    if (!required && email.trim().isEmpty) {
      return true;
    }
    
    if (email.trim().isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      showMessage(context, getTranslatedValue(context, enterValidEmailLabel), MessageType.warning);
      return false;
    }
    return true;
  }

  /// Validate mobile number
  static Future<bool> validateMobile(BuildContext context, String mobile, {bool required = true}) async {
    if (!required && mobile.trim().isEmpty) {
      return true;
    }
    
    if (mobile.trim().isEmpty || mobile.length < Constant.minimumRequiredMobileNumberLength) {
      showMessage(context, getTranslatedValue(context, enterValidMobileLabel), MessageType.warning);
      return false;
    }
    return true;
  }

  /// Validate password
  static Future<bool> validatePassword(BuildContext context, String password, String confirmPassword) async {
    if (password.trim().isEmpty) {
      showMessage(context, getTranslatedValue(context, enterValidPasswordLabel), MessageType.warning);
      return false;
    } else if (password.length <= 5) {
      showMessage(context, getTranslatedValue(context, passwordTooShortLabel), MessageType.warning);
      return false;
    } else if (password != confirmPassword) {
      showMessage(context, getTranslatedValue(context, passwordConfirmMismatchLabel), MessageType.warning);
      return false;
    }
    return true;
  }

  /// Validate OTP
  static Future<bool> validateOtp(BuildContext context, String otp) async {
    if (otp.trim().isEmpty) {
      showMessage(context, getTranslatedValue(context, otpRequiredLabel), MessageType.warning);
      return false;
    }
    return true;
  }
}