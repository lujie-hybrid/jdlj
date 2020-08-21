class JdValidate {
  ///手机号验证
  static bool isPhoneLegal(String str) {
    return RegExp(r"^1(3|4|5|6|7|8|9)\d{9}$").hasMatch(str);
  }

  ///验证码验证
  static bool isCodeLegal(String str) {
    return RegExp(r"^\d{4}$").hasMatch(str);
  }

  ///密码验证
  static bool isPwdLegal(String str) {
    return RegExp(r"^[a-zA-Z]\w{5,17}$").hasMatch(str);
  }

  ///密码验证
  static bool isNameLegal(String str) {
    return RegExp(r"^[\u4e00-\u9fa5]{0,}$").hasMatch(str);
  }
}
