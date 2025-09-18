import 'package:project/helper/utils/generalImports.dart';


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(5),
      margin: EdgeInsetsDirectional.only(top: 10),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: 10, top: 10, bottom: 10, end: 20),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  maxRadius: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Constant.session.isUserLoggedIn()
                        ? Consumer<UserProfileProvider>(
                            builder: (context, value, child) {
                              return setNetworkImg(
                                height: 75,
                                width: 75,
                                boxFit: BoxFit.cover,
                                image: Constant.session.getData(
                                  SessionManager.keyUserImage,
                                ),
                              );
                            },
                          )
                        : defaultImg(
                            height: 75,
                            width: 75,
                            image: AppAssets.defaultUserIcon,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<UserProfileProvider>(
                            builder: (context, userProfileProvide, _) =>
                                CustomTextLabel(
                              text: Constant.session.isUserLoggedIn()
                                  ? userProfileProvide
                                      .getUserDetailBySessionKey(
                                      isBool: false,
                                      key: SessionManager.keyUserName,
                                    )
                                  : getTranslatedValue(
                                      context,
                                      welcomeLabel,
                                    ),
                              style: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        if (Constant.session.isUserLoggedIn())
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                editProfileScreen,
                                arguments: [
                                  Constant.session.isUserLoggedIn()
                                      ? "header"
                                      : "register_header",
                                  null
                                ],
                              );
                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(end: 10),
                              child: CustomTextLabel(
                                jsonKey: editLabel,
                                style: TextStyle(
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (Constant.session.isUserLoggedIn())
                      getSizedBox(height: 5),
                    if (Constant.session.isUserLoggedIn())
                      CustomTextLabel(
                        jsonKey: Constant.session.getData(
                          SessionManager.keyEmail,
                        ),
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                          fontSize: 13,
                        ),
                      ),
                    if (Constant.session.isUserLoggedIn())
                      getSizedBox(height: 5),
                    if (Constant.session.isUserLoggedIn())
                      CustomTextLabel(
                        jsonKey: Constant.session.isUserLoggedIn()
                            ? Constant.session.getData(
                                SessionManager.keyPhone,
                              )
                            : loginLabel,
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                          fontSize: 13,
                        ),
                      ),
                    if (!Constant.session.isUserLoggedIn())
                      getSizedBox(height: 10),
                    if (!Constant.session.isUserLoggedIn())
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            loginAccountScreen,
                            arguments: "register_header",//"header",
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorsRes.appColorRed,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 15,
                              end: 15,
                              top: 5,
                              bottom: 5,
                            ),
                            child: CustomTextLabel(
                              jsonKey: loginLabel,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
