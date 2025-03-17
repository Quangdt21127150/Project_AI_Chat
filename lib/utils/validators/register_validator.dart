String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập email';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Email không hợp lệ';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty || value.length < 6) {
    return 'Mật khẩu phải có ít nhất 6 ký tự';
  }

  // pattern for validate password, it must have at least 1 uppercase letter, at least 1 number
  String pattern = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Mật khẩu phải chứa ít nhất 1 chữ hoa và 1 số';
  }
  return null;
}

String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Vui lòng xác nhận mật khẩu';
  }
  if (confirmPassword != password) {
    return 'Mật khẩu xác nhận không khớp';
  }
  return null;
}
