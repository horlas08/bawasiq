import 'package:project/helper/utils/generalImports.dart';

class ProductFilterProvider extends ChangeNotifier {
  RangeValues currentRangeValues = const RangeValues(0, 0);
  List<String> selectedBrands = [];
  List<String> selectedSizes = [];
  List<String> selectedCategories = [];
  int currentSelectedFilterIndex = 0;
  double maxPrice = 0;
  double minPrice = 0;

  resetAllFilters() {
    //Temp filters will be cleared
    Constant.resetTempFilters();

    selectedBrands.clear();
    selectedSizes.clear();
    selectedCategories.clear();
    notifyListeners();
  }

  setCurrentIndex(int index) {
    currentSelectedFilterIndex = index;
    notifyListeners();
  }

  setMinMaxPriceRange(double _minPrice, double _maxPrice) {
    minPrice = _minPrice;
    maxPrice = _maxPrice;
    notifyListeners();
  }

  setPriceRange(RangeValues value) {
    currentRangeValues = value;
    Constant.currentRangeValues = value;
    notifyListeners();
  }

  setCategories(List<String> value) {
    selectedCategories = value.toSet().toList();
    Constant.selectedCategories = value.toSet().toList();
    notifyListeners();
  }

  addRemoveBrandIds(String id) {
    if (selectedBrands.contains(id)) {
      selectedBrands.remove(id);
      Constant.selectedBrands.remove(id);
    } else {
      selectedBrands.add(id);
      Constant.selectedBrands.add(id);
    }
    notifyListeners();
  }

  addRemoveCategories(String id) {
    selectedCategories.toSet().toList();
    Constant.selectedCategories.toSet().toList();

    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
      Constant.selectedCategories.remove(id);
    } else {
      selectedCategories.add(id);
      Constant.selectedCategories.add(id);
    }
    notifyListeners();
  }

  addRemoveSizes(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
      Constant.selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
      Constant.selectedSizes.add(size);
    }
    notifyListeners();
  }
}
