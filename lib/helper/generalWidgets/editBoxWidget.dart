import 'package:project/helper/utils/generalImports.dart';

Widget editBoxWidget(
  BuildContext context,
  TextEditingController edtController,
  Function validationFunction,
  String label,
  String errorLabel,
  TextInputType inputType, {
  Widget? tailIcon,
  Widget? leadingIcon,
  bool? isLastField,
  bool? isEditable = true,
  bool? isReadOnly,
  List<TextInputFormatter>? inputFormatters,
  TextInputAction? optionalTextInputAction,
  int? minLines,
  int? maxLines,
  int? maxLength,
  FloatingLabelBehavior? floatingLabelBehavior,
  Color? fillColor,
  bool? obscureText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        enabled: isEditable,
        readOnly: isReadOnly ?? false,
        style: TextStyle(
          color: ColorsRes.mainTextColor,
        ),
        maxLength: maxLength,
        buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => Container(),
        maxLines: maxLines,
        minLines: minLines,
        controller: edtController,
        obscureText: obscureText ?? false,
        textInputAction: optionalTextInputAction ?? (isLastField == true ? TextInputAction.done : TextInputAction.next),
        decoration: InputDecoration(
          suffixIcon: tailIcon,
          alignLabelWithHint: true,
          fillColor: fillColor ?? Theme.of(context).cardColor,
          filled: true,
          prefixIcon: leadingIcon ?? null,
          // prefix: tailIcon ?? null,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.appColor,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.5),
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.appColorRed,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.subTitleMainTextColor,
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.5),
              width: 1,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(color: ColorsRes.subTitleMainTextColor),
          isDense: true,
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (Set<WidgetState> states) {
              final Color color = states.contains(WidgetState.error) ? Theme.of(context).colorScheme.error : ColorsRes.appColor;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
          floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.auto,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType,
        inputFormatters: inputFormatters ?? [],
        validator: (String? value) {
          return validationFunction(value ?? "") == null ? null : errorLabel;
        },
      )
    ],
  );
}
