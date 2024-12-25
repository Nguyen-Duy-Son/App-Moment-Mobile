class Validator {
  static bool validateNullOrEmpty(String text) => (text).isEmpty;

  // static bool validateEmail(String? email) => RegExp(
  //         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
  //     .hasMatch(email?.trim() ?? "");

  static bool validateEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(
      r'^[\w.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$', // Loại bỏ escape dư thừa cho dấu chấm
    ).hasMatch(email.trim());
  }

  static bool validatePhone(String? phone) {
    return RegExp(r"^(?:\+|0)?[0-9]{9,15}$").hasMatch(phone?.trim() ?? "");
  }

  static bool validateFullName(String fullName) {
    if (fullName.isEmpty) return false;
    return RegExp(
      r'^[a-zA-ZÀ-ỹ\u00C0-\u1EF9\s\-]+$', // General Latin characters with accents
    ).hasMatch(fullName);
  }

  static bool validateEmoji(String string) {
    return RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(string.trim());
  }

  static bool validatePassword(String password) {
    // Regular expression để kiểm tra
    final RegExp hasUppercase = RegExp(r'[A-Z]');
    final RegExp hasLowercase = RegExp(r'[a-z]');
    final RegExp hasDigit = RegExp(r'[0-9]');
    final RegExp hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    // Kiểm tra mật khẩu có ít nhất 1 ký tự hoa, 1 ký tự thường, 1 chữ số, và 1 ký tự đặc biệt
    if (!hasUppercase.hasMatch(password) ||
        !hasLowercase.hasMatch(password) ||
        !hasDigit.hasMatch(password) ||
        !hasSpecialCharacter.hasMatch(password)) {
      return false;
    }
    return true;
  }

  static bool isEmailOrPhone(String input) {
    // Regex kiểm tra email
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    final RegExp phoneRegex = RegExp(r"^[1-9]+$");

    // Kiểm tra chuỗi đầu vào có khớp với regex email hoặc số điện thoại
    return emailRegex.hasMatch(input) || phoneRegex.hasMatch(input) || input.length >= 10;
  }

  static bool validateLimit(String val, int lth) {
    return val.length <= lth ? false : true;
  }

  static bool validatePasswordLength(String val) {
    // Kiểm tra mật khẩu có ít nhất 8 ký tự nhỏ hơn 14 kí tự
    return val.length < 8 || val.length > 14 ? false : true;
  }

  static bool validateMinCharacter(String val, int lth) {
    return val.length >= lth ? false : true;
  }
}
