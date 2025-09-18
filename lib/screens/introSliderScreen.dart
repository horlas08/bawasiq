import 'package:project/helper/utils/generalImports.dart';


class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {
  int currentPosition = 0;

  /// Intro slider list ...
  /// You can add or remove items from below list as well
  /// Add svg images into asset > svg folder and set name here without any extension and image should not contains space
  static List introSlider = [];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness:
            Constant.session.getBoolData(SessionManager.isDarkTheme)
                ? Brightness.dark
                : Brightness.light,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    introSlider = [
      {
        "image": "${AppAssets.introSlider1Icon}${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": introTitle1Label,
        "description": introDescription1Label,
      },
      {
        "image": "${AppAssets.introSlider2Icon}${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": introTitle2Label,
        "description": introDescription2Label,
      },
      {
        "image": "${AppAssets.introSlider3Icon}${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": introTitle3Label,
        "description": introDescription3Label,
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(top: Platform.isAndroid?false:true,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              getSizedBox(height: constraints.maxHeight * 0.04),
              dotWidget(),
              getSizedBox(height: constraints.maxHeight * 0.04),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                child: CustomTextLabel(
                  jsonKey: introSlider[currentPosition]["title"],
                  softWrap: true,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              getSizedBox(height: constraints.maxHeight * 0.02),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                child: CustomTextLabel(
                  jsonKey: introSlider[currentPosition]["description"],
                  softWrap: true,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor.withValues(alpha:0.76),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              getSizedBox(height: constraints.maxHeight * 0.04),
              Expanded(
                child: defaultImg(
                  padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                  image: introSlider[currentPosition]["image"],
                  height: constraints.maxHeight * 0.4,
                ),
              ),
              if (currentPosition == 0)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, loginAccountScreen);
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsetsDirectional.only(start: 20, end: 10),
                          decoration: DesignConfig.boxDecoration(
                            Theme.of(context).scaffoldBackgroundColor,
                            10,
                            bordercolor: ColorsRes.mainTextColor,
                            borderwidth: 1,
                            isboarder: true,
                          ),
                          child: Center(
                            child: CustomTextLabel(
                              jsonKey: skipLabel,
                              style: TextStyle(
                                color: ColorsRes.mainTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          currentPosition++;
                          setState(() {});
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsetsDirectional.only(start: 10, end: 20),
                          decoration:
                              DesignConfig.boxDecoration(ColorsRes.appColor, 10),
                          child: Row(
                            children: [
                              getSizedBox(width: 20),
                              Spacer(),
                              CustomTextLabel(
                                jsonKey: nextLabel,
                                style: TextStyle(
                                  color: ColorsRes.appColorWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              defaultImg(
                                image: AppAssets.icArrowForwardIcon,
                                iconColor: ColorsRes.appColorWhite,
                              ),
                              getSizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if (currentPosition == 1)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          currentPosition--;
                          setState(() {});
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsetsDirectional.only(start: 20, end: 10),
                          decoration: DesignConfig.boxDecoration(
                            Theme.of(context).scaffoldBackgroundColor,
                            10,
                            bordercolor: ColorsRes.mainTextColor,
                            borderwidth: 1,
                            isboarder: true,
                          ),
                          child: Center(
                            child: CustomTextLabel(
                              jsonKey: backLabel,
                              style: TextStyle(
                                color: ColorsRes.mainTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          currentPosition++;
                          setState(() {});
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsetsDirectional.only(start: 10, end: 20),
                          decoration:
                              DesignConfig.boxDecoration(ColorsRes.appColor, 10),
                          child: Row(
                            children: [
                              getSizedBox(width: 20),
                              Spacer(),
                              CustomTextLabel(
                                jsonKey: nextLabel,
                                style: TextStyle(
                                  color: ColorsRes.appColorWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              defaultImg(
                                image: AppAssets.icArrowForwardIcon,
                                iconColor: ColorsRes.appColorWhite,
                              ),
                              getSizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if (currentPosition == introSlider.length - 1)
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, loginAccountScreen);
                  },
                  child: Container(
                    height: 45,
                    margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                    decoration:
                        DesignConfig.boxDecoration(ColorsRes.appColor, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextLabel(
                          jsonKey: getStartedLabel,
                          style: TextStyle(
                            color: ColorsRes.appColorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              getSizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  dotWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        introSlider.length,
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            margin: const EdgeInsetsDirectional.only(start: 5, end: 5),
            width: (context.width - 40) / introSlider.length,
            height: 5,
            decoration: DesignConfig.boxDecoration(
              currentPosition >= index
                  ? ColorsRes.appColor
                  : ColorsRes.subTitleMainTextColor,
              10,
            ),
          );
        },
      ),
    );
  }
}
