class Validators {
    static bool _isDecimal(String s) {
      try {
        double.parse(s);
        return true;
      } catch(e) {
        return false;
      }
      
    }


  static String? validEmail(val) {
    if (val!.isEmpty || !val.contains('@')) {
      return 'Invalid email!';
    }
    return null;
  }

  static String? validIsNumeric(val) {
    if (!_isDecimal(val)) {
      return 'Please enter a numeric value.';
    }
    return null;
  }

  static String? validHasText(val) {
    if (val!.isEmpty) {
      return 'Please enter a value.';
    }
    return null;
  }

  static String? validUserName(val) {
    if (val!.isEmpty) {
      return 'Please enter a value.';
    }
    if (val!.length < 4) {
      return 'User name needs to have at leaset four characters.';
    }
    return null;
  }

    static String? validText(val) {
    if (val!.isEmpty) {
      return 'Please enter some text.';
    }
    return null;
  }


  static String? validPassword(val) {
    RegExp regExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[!@$%^&(){}:;<>,.?/~_+-]).{10,}$');

    if (val!.isEmpty) {
      return 'Please enter a value.';
    }
    if (val!.length < 10) {
      return 'The password needs to have at least 10 characters.';
    }
    if (!regExp.hasMatch(val)) {
      return 'The password does not meet the complexity requirements.';
    }
    return null;
  }
}