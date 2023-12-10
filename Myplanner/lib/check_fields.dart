class CheckFields {

  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  static bool containsUppercaseLetter(String value) {
    return RegExp(r'[A-Z]').hasMatch(value);
  }

  static bool containsLowercaseLetter(String value) {
    return RegExp(r'[a-z]').hasMatch(value);
  }

  static bool containsNumber(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }
}