class Validation {
  // Name text field validation
  static nameValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Name";
    }
  }

  // Email text field validation
  static emailValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Email";
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Please enter valid email";
    }

    return null;
  }

  // Phone text field validation
  static phoneValidation(value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{11}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Enter Your Phone Number";
    } else if (!regExp.hasMatch(value)) {
      return "Enter Valid Phone Number";
    }
  }

  // Password text field validation
  static passwordValidation(value) {
    if (value.isEmpty) {
      return "Enter your password";
    } else if (value.length < 8) {
      return "Password at least 8 Characters";
    }
  }

  // Confirm Password text field validation
  static confirmPasswordValidation(value) {

  }

  static wifiPasswordValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Password";
    } else if (value.length < 8) {
      return "Password must be at least 8 Characters";
    }
  }

  static wifiNameValidation(value) {
    if (value.isEmpty) {
      return "Enter your wifi network name";
    }
  }

  static deviceVenueNameValidation(value) {
    if (value.isEmpty) {
      return "Please enter venue name";
    }
  }

  static deviceAddressValidation(value) {
    if (value.isEmpty) {
      return "Please enter address";
    }
  }

  static deviceCountryValidation(value) {
    if (value.isEmpty) {
      return "Please enter country name";
    }
  }

  static deviceCityValidation(value) {
    if (value.isEmpty) {
      return "Please enter city name";
    }
  }

  static deviceStateValidation(value) {
    if (value.isEmpty) {
      return "Please enter state name";
    }
  }

  static devicePostalCodeValidation(value) {
    if (value.isEmpty) {
      return "Please enter postal code";
    }
  }

  static deviceVenueValidation(value) {
    if (value.isEmpty) {
      return "Please select venue";
    }
  }

  static deviceDeviceLocationValidation(value) {
    if (value.isEmpty) {
      return "Please enter device location";
    }
  }

  static deviceNameValidation(value) {
    if (value.isEmpty) {
      return "Please enter device name";
    }
  }

  static unitNumberValidation(value) {
    if (value.isEmpty) {
      return "Please enter unit number";
    }
  }

}
