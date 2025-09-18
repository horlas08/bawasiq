import 'dart:math' as math;
import 'package:project/helper/utils/generalImports.dart';


class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  bool isCreatingLink = false;
  List workflowlist = [];

  @override
  void initState() {
    addList();
    super.initState();
  }

  addList() {
    Future.delayed(Duration.zero, () {
      workflowlist = [
        {"icon": AppAssets.referStep1Icon, "info": getTranslatedValue(context, inviteFriendsToSignupLabel)},
        {"icon": AppAssets.referStep2Icon, "info": getTranslatedValue(context, friendsDownloadAppLabel)},
        {"icon": AppAssets.referStep3Icon, "info": getTranslatedValue(context, friendsPlaceFirstOrderLabel)},
        {"icon": AppAssets.referStep4Icon, "info": getTranslatedValue(context, youWillGetRewardAfterDeliveredLabel)},
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: referAndEarnLabel,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            height: context.height,
            width: context.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: topImage()),
                CustomTextLabel(
                  jsonKey: referAndEarnLabel,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.merge(
                        TextStyle(
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                ),
                SizedBox(height: Constant.size10),
                CustomTextLabel(
                  jsonKey: referSharePrefixDescriptionLabel,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.merge(
                        TextStyle(
                          letterSpacing: 0.5,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                ),
                SizedBox(height: Constant.size25),
                CustomTextLabel(
                  jsonKey: yourReferralCodeLabel,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                          letterSpacing: 0.5,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: Constant.session.getData(SessionManager.keyReferralCode).toString()),
                    );
                    showMessage(
                      context,
                      getTranslatedValue(context, referCodeCopiedLabel),
                      MessageType.success,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(bottom: Constant.size20, top: Constant.size10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: context.width / 3,
                          height: context.height / 20,
                          decoration: DesignConfig.boxDecoration(
                            ColorsRes.appColor.withValues(alpha: 0.2),
                            5,
                          ),
                          child: DashedRect(
                            color: ColorsRes.appColor,
                            strokeWidth: 1.0,
                            gap: 10,
                          ),
                        ),
                        CustomTextLabel(
                          text: Constant.session.getData(SessionManager.keyReferralCode).toString(),
                          softWrap: true,
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: ColorsRes.appColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Constant.size10),
                btnWidget(),
              ],
            ),
          ),
          if (isCreatingLink == true)
            PositionedDirectional(
              top: 0,
              end: 0,
              start: 0,
              bottom: 0,
              child: Container(
                color: ColorsRes.appColorBlack.withValues(alpha: 0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
        ],
      ),
    );
  }

  Widget btnWidget() {
    return gradientBtnWidget(
      context,
      10,
      callback: () {
        if (!isCreatingLink) {
          setState(() => isCreatingLink = true);
          shareCode();
        }
      },
      otherWidgets: CustomTextLabel(
        jsonKey: shareLabel,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(
              TextStyle(
                color: ColorsRes.mainTextColor,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    );
  }

  void shareCode() async {
    String prefixMessage = getTranslatedValue(context, referAndEarnSharePrefixMessageLabel);
    String shareMessage = Platform.isAndroid ? Constant.playStoreUrl : Constant.appStoreUrl;

    await SharePlus.instance.share(
      ShareParams(
        text: "$prefixMessage ${Constant.session.getData(SessionManager.keyReferralCode)}\n$shareMessage",
        subject: "Refer and earn app",
      ),
    );

    setState(() => isCreatingLink = false);
  }

  Widget topImage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.size8),
      child: defaultImg(image: AppAssets.referAndEarnIcon),
    );
  }

  Widget howWorksWidget() {
    return Card(
      elevation: 0,
      color: ColorsRes.appColor.withValues(alpha: 0.2),
      surfaceTintColor: ColorsRes.appColor.withValues(alpha: 0.2),
      shape: DesignConfig.setRoundedBorder(8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: ColorsRes.appColorTransparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          title: CustomTextLabel(
            jsonKey: howItWorksLabel,
            softWrap: true,
            style: Theme.of(context).textTheme.titleMedium!.merge(
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
          ),
          children: [
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: Constant.size8, vertical: Constant.size10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workflowlist.length,
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsetsDirectional.only(top: 3, bottom: 5, start: index % 2 == 0 ? 5 : 17),
                alignment: Alignment.centerLeft,
                child: index % 2 == 0
                    ? defaultImg(image: AppAssets.rfArrowRightIcon)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: defaultImg(image: AppAssets.rfArrowRightIcon),
                      ),
              ),
              itemBuilder: (context, index) => Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorsRes.appColorBlack,
                    child: defaultImg(image: workflowlist[index]['icon']),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextLabel(
                      text: workflowlist[index]['info'],
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge!.merge(
                            TextStyle(
                              color: ColorsRes.mainTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
