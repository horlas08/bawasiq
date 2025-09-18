import 'package:project/helper/utils/generalImports.dart';

Widget getPriceRangeWidget(
    double minPrice, double maxPrice, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomTextLabel(
        text:
            "Minimum Selected Range\n${context.watch<ProductFilterProvider>().currentRangeValues.start.toString().currency}",
      ),
      getSizedBox(
        height: 25,
      ),
      CustomTextLabel(
        text:
            "Maximum Selected Range\n${context.watch<ProductFilterProvider>().currentRangeValues.end.toString().currency}",
      ),
      getSizedBox(
        height: 25,
      ),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
            thumbColor: ColorsRes.appColorTransparent,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
        child: RangeSlider(
          values: context.watch<ProductFilterProvider>().currentRangeValues,
          divisions: (maxPrice.toInt() - minPrice.toInt()),
          activeColor: ColorsRes.appColor,
          inactiveColor: ColorsRes.grey,
          min: minPrice,
          max: maxPrice,
          onChanged: (value) {
            context.read<ProductFilterProvider>().setPriceRange(value);
          },
        ),
      ),
    ],
  );
}
