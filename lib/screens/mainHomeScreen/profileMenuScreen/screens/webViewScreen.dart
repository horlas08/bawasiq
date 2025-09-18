import 'package:project/helper/utils/generalImports.dart';

import 'package:quill_html_editor/quill_html_editor.dart';

class WebViewScreen extends StatefulWidget {
  final String dataFor;

  const WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool privacyPolicyExpanded = false;
  bool returnExchangePolicyExpanded = false;
  bool shippingPolicyExpanded = false;
  bool cancellationPolicyExpanded = false;
  late QuillEditorController quillEditorController;

  @override
  void initState() {
    quillEditorController = QuillEditorController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = "";
    if (widget.dataFor ==
        getTranslatedValue(
          context,
          contactUsLabel,
        )) {
      htmlContent = Constant.contactUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          aboutUsLabel,
        )) {
      htmlContent = Constant.aboutUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          termsAndConditionsLabel,
        )) {
      htmlContent = Constant.termsConditions;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          privacyPolicyLabel,
        )) {
      htmlContent = Constant.privacyPolicy;
    }

    return Scaffold(
      appBar: getAppBar(
          title: CustomTextLabel(
            text: widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: widget.dataFor ==
                getTranslatedValue(
                  context,
                  policiesLabel,
                )
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                      top: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: privacyPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => privacyPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: privacyPolicyLabel,
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        privacyPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.privacyPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: returnExchangePolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => returnExchangePolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: returnAndExchangesPolicyLabel,
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        returnExchangePolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(
                              Constant.returnAndExchangesPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: shippingPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => shippingPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: shoppingPolicyLabel,
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        shippingPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.shippingPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: cancellationPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => cancellationPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: cancellationPolicyLabel,
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        cancellationPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.cancellationPolicy),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(Constant.size10),
                child: _getHtmlContainer(htmlContent),
              ),
      ),
    );
  }

  Widget _getHtmlContainer(String htmlContent) {
    return QuillHtmlEditor(
      text: htmlContent,
      hintText: getTranslatedValue(context, descriptionGoesHereLabel),
      isEnabled: false,
      ensureVisible: false,
      minHeight: 10,
      autoFocus: false,
      textStyle: TextStyle(color: ColorsRes.mainTextColor),
      hintTextStyle: TextStyle(color: ColorsRes.subTitleMainTextColor),
      hintTextAlign: TextAlign.start,
      padding: const EdgeInsets.only(left: 10, top: 10),
      hintTextPadding: const EdgeInsets.only(left: 20),
      backgroundColor: Theme.of(context).cardColor,
      inputAction: InputAction.newline,
      loadingBuilder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: ColorsRes.appColor,
          ),
        );
      },
      controller: quillEditorController,
    );
  }
}
