import 'package:flutter/material.dart';

enum EnrollmentStep {
  options,
  manualSuccess,
  onlineMethods,
  onlineSuccess,
}

enum PaymentType {
  manual,
  online,
}

enum OnlinePaymentMethod {
  upi,
  card,
  netBanking,
}

class EnrollmentModalViewModel extends ChangeNotifier {
  EnrollmentStep _currentStep = EnrollmentStep.options;
  PaymentType _selectedPaymentType = PaymentType.manual;
  OnlinePaymentMethod _selectedOnlineMethod = OnlinePaymentMethod.upi;
  bool _isDescriptionExpanded = false;

  // Getters
  EnrollmentStep get currentStep => _currentStep;
  PaymentType get selectedPaymentType => _selectedPaymentType;
  OnlinePaymentMethod get selectedOnlineMethod => _selectedOnlineMethod;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  void setPaymentType(PaymentType type) {
    _selectedPaymentType = type;
    notifyListeners();
  }

  void setOnlineMethod(OnlinePaymentMethod method) {
    _selectedOnlineMethod = method;
    notifyListeners();
  }

  void toggleDescriptionExpanded() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  void proceedFromOptions() {
    if (_selectedPaymentType == PaymentType.manual) {
      _currentStep = EnrollmentStep.manualSuccess;
    } else {
      _currentStep = EnrollmentStep.onlineMethods;
    }
    notifyListeners();
  }

  void proceedToPayment() {
    _currentStep = EnrollmentStep.onlineSuccess;
    notifyListeners();
  }

  void goBack() {
    if (_currentStep == EnrollmentStep.onlineMethods) {
      _currentStep = EnrollmentStep.options;
      notifyListeners();
    }
  }

  String getOnlineMethodTitle(OnlinePaymentMethod method) {
    switch (method) {
      case OnlinePaymentMethod.upi:
        return 'UPI';
      case OnlinePaymentMethod.card:
        return 'Credit / Debit Card';
      case OnlinePaymentMethod.netBanking:
        return 'Net Banking';
    }
  }

  String getOnlineMethodSubtitle(OnlinePaymentMethod method) {
    switch (method) {
      case OnlinePaymentMethod.upi:
        return 'Google Pay, PhonePe, Paytm, BHIM UPI';
      case OnlinePaymentMethod.card:
        return 'Visa, MasterCard, RuPay, Amex';
      case OnlinePaymentMethod.netBanking:
        return 'All major Indian banks supported';
    }
  }
}
