import 'app_helpers.dart';
import 'tr_keys.dart';

class AppValidators {
  static bool isValidEmail(String email) => RegExp(
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$",
      ).hasMatch(email);

  static bool checkEmail(String email) => RegExp(
    "/^[0-9 ()+-]+\$/"
  ).hasMatch(email);

  static bool isValidPassword(String password) => password.length > 5;


  static String? isNotEmptyValidator(String? title) {
    if (title?.isEmpty ?? true) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    return null;
  }

  static String? emailCheck(String? text) {
    if (text == null || text.trim().isEmpty) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    if (!isValidEmail(text)) {
      return AppHelpers.getTranslation(TrKeys.emailIsNotValid);
    }
    return null;
  }

  static bool isValidConfirmPassword(String password,String confirmPassword) => password == confirmPassword;

  static bool arePasswordsTheSame(String password, String confirmPassword) =>
      password == confirmPassword;
}