import 'package:project/helper/utils/generalImports.dart';

import 'package:project/models/userProfile.dart';

enum ProfileState { initial, loading, loaded }

class UserProfileProvider extends ChangeNotifier {
  ProfileState profileState = ProfileState.initial;

  Future updateUserProfile({required BuildContext context, required String selectedImagePath, required Map<String, String> params}) async {
    var returnValue;
    try {
      profileState = ProfileState.loading;
      notifyListeners();

      List<String> fileParamsNames = [];
      List<String> fileParamsFilesPath = [];
      if (selectedImagePath.isNotEmpty) {
        fileParamsNames.add(ApiAndParams.profile);
        fileParamsFilesPath.add(selectedImagePath);
      }

      await getUpdateProfileApi(
              apiName: ApiAndParams.apiUpdateProfile,
              params: params,
              fileParamsNames: fileParamsNames,
              fileParamsFilesPath: fileParamsFilesPath,
              context: context)
          .then(
        (value) async {
          if (value != {}) {
            if (value.isNotEmpty) {
              if (value[ApiAndParams.status].toString() == "1") {
                await getUserDetail(context: context).then(
                  (value) {
                    if (value[ApiAndParams.status].toString() == "1") {
                      context.read<UserProfileProvider>().updateUserDataInSession(value, context);
                    }
                  },
                ).then(
                  (value) {
                    returnValue = true;
                  },
                );
              } else {
                showMessage(
                  context,
                  value[ApiAndParams.message],
                  MessageType.warning,
                );
                profileState = ProfileState.loaded;
                notifyListeners();

                returnValue = value[ApiAndParams.message];
              }
            }
          } else {
            showMessage(
              context,
              value[ApiAndParams.message],
              MessageType.warning,
            );
            profileState = ProfileState.loaded;
            notifyListeners();

            returnValue = value;
          }
        },
      );
    } catch (e) {
      showMessage(context, e.toString(), MessageType.warning);
      profileState = ProfileState.loaded;
      notifyListeners();
      returnValue = "";
    }
    return returnValue;
  }

  Future<int?> loginApi({required BuildContext context, required Map<String, String> params}) async {
    int status = 0;
    //status = 0//error
    //sttaus = 1//verify use successfull
    //status = 2//email_not_verified
    //status = 3//user_exist_password_blank
    try {
      UserProfile? userProfile;
      await getLoginApi(context: context, params: params).then((mainData) async {
        userProfile = UserProfile.fromJson(mainData);
        if (mainData[ApiAndParams.status].toString() == "1") {
          if (userProfile?.data != null) {
            userProfile = UserProfile.fromJson(mainData);
            if (userProfile?.status.toString() == "1") {
              await setUserDataInSession(mainData, context);
            }
            status = 1;
          } else {
            status = 0;
          }
          if (mainData[ApiAndParams.message].toString() == "user_deactivated") {
            status = 5;
          }
        } else if (mainData[ApiAndParams.message].toString() == "email_not_verified") {
          showMessage(context, getTranslatedValue(context, mainData[ApiAndParams.message].toString()), MessageType.warning);
          status = 2;
        } else if (mainData[ApiAndParams.message].toString() == "user_exist_password_blank") {
          status = 3;
        } else if (mainData[ApiAndParams.message].toString() == "invalid_password") {
          showMessage(context, getTranslatedValue(context, mainData[ApiAndParams.message].toString()), MessageType.warning);
          status = 4;
        } else {
          status = 0;
        }
      });
    } catch (e) {
      status = 0;
      print("userProfile?.data != null:${e}");
    }
    return status;
  }

  Future sendCustomOTPSmsProvider({required BuildContext context, required Map<String, String> params}) async {
    try {
      Map<String, dynamic> data = await sendCustomOTPSmsApi(context: context, params: params);

      return data[ApiAndParams.status].toString();
    } catch (e) {
      return "0";
    }
  }

  Future verifyUserProvider({required BuildContext context, required Map<String, String> params}) async {
    try {
      Map<String, dynamic> data = await getUserVerifyApi(context: context, params: params);

      return data;
    } catch (e) {
      return "0";
    }
  }

  Future verifyUserExistProvider({required BuildContext context, required Map<String, String> params}) async {
    try {
      Map<String, dynamic> data = await getVerifyUserExistApi(context: context, params: params);

      return data;
    } catch (e) {
      return "0";
    }
  }

  Future changePasswordProvider({required BuildContext context, required Map<String, String> params}) async {
    try {
      Map<String, dynamic> data = await changePasswordApi(context: context, params: params);

      return data;
    } catch (e) {
      return "0";
    }
  }

  Future<String> registerAccountApi({required BuildContext context, required Map<String, String> params}) async {
    profileState = ProfileState.loading;
    notifyListeners();
    String status = "0";
    await getRegisterApi(context: context, params: params).then((mainData) async {
      if (mainData[ApiAndParams.status].toString() == "1") {
        if (!mainData.containsKey("data") && mainData[ApiAndParams.message].toString() == "verification_mail_sent_successfully") {
          status = "1";
          profileState = ProfileState.loaded;
          notifyListeners();
          showMessage(
            context,
            verificationMailSentLabel,
            MessageType.success,
          );
        } else {
          UserProfile userProfile = UserProfile.fromJson(mainData);
          if (mainData[ApiAndParams.message].toString() == "success") {
            await setUserDataInSession(mainData, context).then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
            });
          }
          if (userProfile.status.toString() == "1") {
            await setUserDataInSession(mainData, context);
            showMessage(
              context,
              getTranslatedValue(context, mainData[ApiAndParams.message]),
              MessageType.success,
            );
            status = userProfile.status ?? "0";
          } else {
            showMessage(
              context,
              getTranslatedValue(context, mainData[ApiAndParams.message]),
              MessageType.warning,
            );
            status = "0";
          }
          profileState = ProfileState.loaded;
          notifyListeners();
        }
      } else {
        status = "0";
        if (mainData[ApiAndParams.message].toString() == "user_already_exist") {
          showMessage(
            context,
            getTranslatedValue(context, getTranslatedValue(context, mainData[ApiAndParams.message])),
            MessageType.warning,
          );
        } else {
          showMessage(
            context,
            getTranslatedValue(context, getTranslatedValue(context, mainData[ApiAndParams.message])),
            MessageType.warning,
          );
        }
        profileState = ProfileState.loaded;
        notifyListeners();
      }
    });
    profileState = ProfileState.loaded;
    notifyListeners();
    return status;
  }

  Future<bool> verifyRegisteredEmailProvider({required BuildContext context, required Map<String, String> params, required String from}) async {
    return await verifyRegisteredEmailApi(context: context, params: params).then(
      (mainData) async {
        if (mainData[ApiAndParams.status].toString() == "1") {
          showMessage(
            context,
            getTranslatedValue(context, mainData[ApiAndParams.message]),
            MessageType.success,
          );
          if (mainData[ApiAndParams.message].toString() == "success") {
            await setUserDataInSession(mainData, context).then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
            });
          }
          return true;
        } else {
          showMessage(
            context,
            getTranslatedValue(context, mainData[ApiAndParams.message]),
            MessageType.warning,
          );
        }
        return false;
      },
    );
  }

  Future setUserDataInSession(Map<String, dynamic> mainData, BuildContext context) async {
    Map<String, dynamic> data = await mainData[ApiAndParams.data] as Map<String, dynamic>;
    Map<String, dynamic> userData = await data[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session.setUserData(
      context: context,
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile].toString().isNotEmpty ? userData[ApiAndParams.mobile] : Constant.session.getData(SessionManager.keyPhone),
      referralCode: userData[ApiAndParams.referralCode],
      status: int.parse(userData[ApiAndParams.status].toString()),
      token: data[ApiAndParams.accessToken],
      balance: userData[ApiAndParams.balance].toString(),
      type: userData[ApiAndParams.type].toString(),
    );
    profileState = ProfileState.loaded;
    notifyListeners();
  }

  Future updateUserDataInSession(Map<String, dynamic> mainData, BuildContext context) async {
    Map<String, dynamic> userData = await mainData[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setUserData(
      context: context,
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile],
      referralCode: userData[ApiAndParams.referralCode],
      status: int.parse(userData[ApiAndParams.status].toString()),
      token: Constant.session.getData(SessionManager.keyToken),
      balance: userData[ApiAndParams.balance].toString(),
      type: Constant.session.getData(SessionManager.keyLoginType),
    );

    profileState = ProfileState.loaded;
    notifyListeners();
  }

  getUserDetailBySessionKey({required bool isBool, required String key}) {
    return isBool == true ? Constant.session.getBoolData(key) : Constant.session.getData(key);
  }

  changeState() {
    profileState = ProfileState.initial;
    notifyListeners();
  }
}

void sendOTPForgotPassword(BuildContext context, String email) async {
  try {
    Map<String, dynamic> data = await sendCustomOTPSmsApi(context: context, params: {ApiAndParams.email: email});

    if (data[ApiAndParams.status].toString() == "1") {
      showMessage(
        context,
        getTranslatedValue(
          context,
          otpSendMessageLabel,
        ),
        MessageType.warning,
      );
    }
  } catch (e) {
    rethrow;
  }
}
