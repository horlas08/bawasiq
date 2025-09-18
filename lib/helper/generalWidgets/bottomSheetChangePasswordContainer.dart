import 'package:project/helper/utils/generalImports.dart';


class BottomSheetChangePasswordContainer extends StatefulWidget {
  BottomSheetChangePasswordContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetChangePasswordContainer> createState() =>
      _BottomSheetChangePasswordContainerState();
}

class _BottomSheetChangePasswordContainerState
    extends State<BottomSheetChangePasswordContainer> {
      final TextEditingController editOldPasswordTextEditingController = TextEditingController();
  final TextEditingController editPasswordTextEditingController = TextEditingController();
  final TextEditingController editConfirmPasswordTextEditingController = TextEditingController();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context.read<ThemeProvider>().setSelectedTheme(
          currentTheme: Constant.session.getData(SessionManager.appThemeName));
    });
    super.initState();
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
      String? oldpasswordValidate = await emptyValidation(
        editOldPasswordTextEditingController.text,
      );

      String? passwordValidate = await emptyValidation(
        editPasswordTextEditingController.text,
      );

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
        } else if(oldpasswordValidate == ""){
          showMessage(
          context,
          getTranslatedValue(
            context,
            enterValidPasswordLabel,
          ),
          MessageType.warning,
        );
        return false;
        }else if (editPasswordTextEditingController.text.length <= 5) {
          showMessage(
            context,
            getTranslatedValue(
              context,
              passwordTooShortLabel,
            ),
            MessageType.warning,
          );
          return false;
        } else if (editPasswordTextEditingController.text != editConfirmPasswordTextEditingController.text) {
          showMessage(
            context,
            getTranslatedValue(
              context,
              passwordConfirmMismatchLabel,
            ),
            MessageType.warning,
          );
          return false;
        }else {
          return true;
        }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Padding(
          padding: EdgeInsetsDirectional.only(start: Constant.size10, end: Constant.size10, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSizedBox(
                height: 20,
              ),
              Center(
                child: CustomTextLabel(
                  jsonKey: changePasswordLabel,
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
              getSizedBox(
                height: 10,
              ),
              ChangeNotifierProvider<PasswordShowHideProvider>(
                create: (context) => PasswordShowHideProvider(),
                child: Consumer<PasswordShowHideProvider>(
                  builder: (context, provider, child) {
                    return editBoxWidget(
                      context,
                      editOldPasswordTextEditingController,
                      emptyValidation,
                      getTranslatedValue(
                        context,
                        oldPasswordLabel,
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
              SizedBox(height: Constant.size15),
              Consumer<UserProfileProvider>(
                builder: (context, userProfileProvider, _) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(start: Constant.size10, end: Constant.size10, bottom: Constant.size10),
                    child: gradientBtnWidget(
                      context,
                      Constant.size10,
                      callback: () async {
                        if (await fieldValidation() == true) {
                        await context.read<UserProfileProvider>().changePasswordProvider(context: context, params: {
                          ApiAndParams.oldPassword: editOldPasswordTextEditingController.text,
                          ApiAndParams.newPassword: editPasswordTextEditingController.text,
                          ApiAndParams.newPasswordConfirmation: editConfirmPasswordTextEditingController.text.toString(),
                        }).then((value) {
                          if (value[ApiAndParams.status].toString() == "1") {
                              showMessage(
                                context,
                                getTranslatedValue(
                                  context,
                                  value[ApiAndParams.message].toString(),
                                ),
                                MessageType.warning,
                              );
                            Navigator.pop(context);
                          } else {
                            showMessage(
                              context,
                              getTranslatedValue(
                                context,
                                value[ApiAndParams.message].toString(),
                              ),
                              MessageType.warning,
                            );
                            setState(() {});
                          }
                        });
                        }
                      },
                      otherWidgets: userProfileProvider.profileState == ProfileState.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorsRes.appColorWhite,
                              ),
                            )
                          : CustomTextLabel(
                              jsonKey: updateLabel,
                              softWrap: true,
                              style: Theme.of(context).textTheme.titleMedium!.merge(
                                    TextStyle(color: ColorsRes.appColorWhite, letterSpacing: 0.5, fontWeight: FontWeight.w500),
                                  ),
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
