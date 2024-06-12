class AppValidator {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email";
    }

    // Regular expression pattern for validating email addresses
    RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    return null;
  }

  String? validateRecipientName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a recipient name";
    }
    return null;
  }

  String? validateRecipientNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a recipient number";
    }
    return null;
  }

  String? validateParcelColor(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a parcel color";
    }
    return null;
  }

  String? validateSize(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a parcel size";
    }
    return null;
  }

  String? validateTrackingNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a tracking number";
    }
    return null;
  }

}