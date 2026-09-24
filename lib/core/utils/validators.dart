class AppValidators {
  AppValidators._();

  //* Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }
    return null;
  }

  //* Password validator
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }
    return null;
  }

  //* Name validator
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name cannot be empty";
    }
    if (value.trim().length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  //* Expense Amount validator
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Amount is required";
    }
    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return "Enter a valid number";
    }
    if (amount <= 0) {
      return "Amount must be greater than 0";
    }
    return null;
  }

  //* Expense Category validator
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select a category";
    }
    return null;
  }

  //* Expense Date validator
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return "Date is required";
    }
    return null;
  }
}