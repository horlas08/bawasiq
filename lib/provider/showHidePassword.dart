import 'package:project/helper/utils/generalImports.dart';

class PasswordShowHideProvider extends ChangeNotifier {
  //Variant current selected index provider
  bool showPassword = false;

  isPasswordShowing() {
    return showPassword;
  }

  togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }
}
