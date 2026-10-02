import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../models/course_model.dart';
import '../../../../models/payment_status_model.dart';

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
  final ApiService _apiService = ApiService();
  late Razorpay _razorpay;
  BuildContext? _context;
  EnrollmentStep _currentStep = EnrollmentStep.options;
  PaymentType _selectedPaymentType = PaymentType.manual;
  OnlinePaymentMethod _selectedOnlineMethod = OnlinePaymentMethod.upi;
  bool _isDescriptionExpanded = false;
  bool _isEnrolling = false;

  Map<String, dynamic>? _paymentDetails;
  int? _paymentId;
  PaymentStatusModel? _paymentStatus;
  String? _gateway;
  String? _paymentErrorMessage;
  CourseModel? _course;

  EnrollmentModalViewModel() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  // Getters
  EnrollmentStep get currentStep => _currentStep;
  PaymentType get selectedPaymentType => _selectedPaymentType;
  OnlinePaymentMethod get selectedOnlineMethod => _selectedOnlineMethod;
  bool get isDescriptionExpanded => _isDescriptionExpanded;
  bool get isEnrolling => _isEnrolling;
  Map<String, dynamic>? get paymentDetails => _paymentDetails;
  int? get paymentId => _paymentId ?? dynamicPaymentId;
  PaymentStatusModel? get paymentStatus => _paymentStatus;
  String? get gateway => _gateway;
  String? get paymentErrorMessage => _paymentErrorMessage;

  int? get dynamicPaymentId {
    if (_paymentId != null) return _paymentId;
    final rawId = _paymentDetails?['payment_id'] ?? _paymentDetails?['id'];
    if (rawId is int) return rawId;
    if (rawId != null) return int.tryParse(rawId.toString());
    return null;
  }

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

  Future<void> enrollCourse(BuildContext context, CourseModel course) async {
    _course = course;
    _isEnrolling = true;
    notifyListeners();

    try {
      final response = await _apiService.enrollCourse(course.id);
      _isEnrolling = false;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['payment_required'] == false) {
          course.isEnrolled = true;
          course.progress = 0.0;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'] ?? 'Successfully enrolled')),
            );
            Navigator.pop(context, true); // return true to indicate success
          }
        } else {
          _gateway = data['gateway'];
          _paymentDetails = data['payment'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(data['payment'])
              : null;
          final rawId = _paymentDetails?['payment_id'] ?? _paymentDetails?['id'];
          if (rawId is int) {
            _paymentId = rawId;
          } else if (rawId != null) {
            _paymentId = int.tryParse(rawId.toString());
          }
          if (kDebugMode) {
            debugPrint('Enrollment initiated: payment_id = $_paymentId, gateway = $_gateway');
          }
          // Keep response available, navigate to onlineMethods for next step
          _currentStep = EnrollmentStep.onlineMethods;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Enrollment failed')),
          );
        }
      }
    } catch (e) {
      _isEnrolling = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error occurred.')),
        );
      }
    }
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

  void proceedToPayment(BuildContext context) async {
    _paymentErrorMessage = null;
    _context = context;
    if (_gateway == 'razorpay' && _paymentDetails != null) {
      final prefs = UserPreferencesService();
      final email = await prefs.getEmail();
      final name = await prefs.getFullName();
      
      final options = {
        'key': _paymentDetails!['key_id'],
        'amount': _paymentDetails!['amount'], 
        'name': 'Zenvora',
        'order_id': _paymentDetails!['order_id'],
        'description': 'Course Enrollment',
        'prefill': {
          'name': name,
          'email': email,
        },
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error starting Razorpay: ${e.toString()}');
      }
    } else {
      _currentStep = EnrollmentStep.onlineSuccess;
      notifyListeners();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Capture the Razorpay success data
    if (_paymentDetails != null) {
      _paymentDetails!['razorpay_payment_id'] = response.paymentId;
      _paymentDetails!['razorpay_order_id'] = response.orderId;
      _paymentDetails!['razorpay_signature'] = response.signature;

      if (kDebugMode) {
        debugPrint('--- RAZORPAY SUCCESS CALLBACK ---');
        debugPrint('Zenvora payment_id: ${dynamicPaymentId ?? _paymentDetails!['payment_id']}');
        debugPrint('razorpay_payment_id: ${response.paymentId}');
        debugPrint('razorpay_order_id: ${response.orderId}');
        debugPrint('razorpay_signature: ${response.signature}');
        debugPrint('---------------------------------');
      }

      _verifyPayment();
    }
  }

  Future<void> _verifyPayment() async {
    final pId = dynamicPaymentId;
    if (pId == null) {
      _paymentErrorMessage = 'Payment ID is missing.';
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(_paymentErrorMessage!)),
        );
      }
      return;
    }

    _isEnrolling = true;
    _paymentErrorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.verifyRazorpayPayment(
        paymentId: pId,
        razorpayPaymentId: _paymentDetails!['razorpay_payment_id'],
        razorpayOrderId: _paymentDetails!['razorpay_order_id'],
        razorpaySignature: _paymentDetails!['razorpay_signature'],
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          // Backend verification source of truth: Call Payment Status API
          await _checkPaymentStatusAndFinalize(pId, fallbackSuccessMessage: data['message']);
        } else {
          _paymentErrorMessage = data['message'] ?? 'Payment verification failed.';
          if (_context != null && _context!.mounted) {
            ScaffoldMessenger.of(_context!).showSnackBar(
              SnackBar(content: Text(_paymentErrorMessage!)),
            );
          }
        }
      } else {
        _paymentErrorMessage = data['message'] ?? 'Payment verification failed.';
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(content: Text(_paymentErrorMessage!)),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error during payment verification: $e');
      }
      _paymentErrorMessage = 'Network error during verification.';
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(_paymentErrorMessage!)),
        );
      }
    } finally {
      _isEnrolling = false;
      notifyListeners();
    }
  }

  Future<void> _checkPaymentStatusAndFinalize(
    int paymentId, {
    String? fallbackSuccessMessage,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('Calling Payment Status API for paymentId: $paymentId');
      }

      final statusResponse = await _apiService.getPaymentStatus(paymentId);

      if (kDebugMode) {
        debugPrint('--- PAYMENT STATUS API RESPONSE ---');
        debugPrint('Status Code: ${statusResponse.statusCode}');
        debugPrint('Body: ${statusResponse.body}');
        debugPrint('-----------------------------------');
      }

      if (statusResponse.statusCode == 200) {
        final statusJson = jsonDecode(statusResponse.body);
        if (statusJson is Map<String, dynamic>) {
          _paymentStatus = PaymentStatusModel.fromJson(statusJson);

          if (_paymentStatus!.courseAccess == true) {
            if (_course != null) {
              _course!.isEnrolled = true;
              _course!.progress = 0.0;
            }
            if (_context != null && _context!.mounted) {
              ScaffoldMessenger.of(_context!).showSnackBar(
                SnackBar(
                  content: Text(
                    _paymentStatus!.payment?.message ??
                        fallbackSuccessMessage ??
                        'Payment verified and course enrolled successfully.',
                  ),
                ),
              );
              Navigator.pop(_context!, true);
            }
          } else {
            // course_access == false
            final statusStr = _paymentStatus!.payment?.status;
            final msg = _paymentStatus!.payment?.message;
            _paymentErrorMessage = (statusStr != null && statusStr != 'completed')
                ? 'Payment status: $statusStr. Course access not granted yet.'
                : (msg ?? 'Course access has not been granted yet.');

            if (_context != null && _context!.mounted) {
              ScaffoldMessenger.of(_context!).showSnackBar(
                SnackBar(content: Text(_paymentErrorMessage!)),
              );
            }
          }
        } else {
          _paymentErrorMessage = 'Unexpected response format from payment status API.';
          if (_context != null && _context!.mounted) {
            ScaffoldMessenger.of(_context!).showSnackBar(
              SnackBar(content: Text(_paymentErrorMessage!)),
            );
          }
        }
      } else if (statusResponse.statusCode == 401) {
        _paymentErrorMessage = 'Session expired or unauthorized. Please log in again.';
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(content: Text(_paymentErrorMessage!)),
          );
        }
      } else if (statusResponse.statusCode == 404) {
        _paymentErrorMessage = 'Payment record not found on server.';
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(content: Text(_paymentErrorMessage!)),
          );
        }
      } else {
        String msg = 'Failed to verify payment status (Code: ${statusResponse.statusCode}).';
        try {
          final errJson = jsonDecode(statusResponse.body);
          if (errJson is Map<String, dynamic> && errJson['message'] != null) {
            msg = errJson['message'].toString();
          }
        } catch (_) {}
        _paymentErrorMessage = msg;
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(content: Text(_paymentErrorMessage!)),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Exception in Payment Status API check: $e');
      }
      _paymentErrorMessage = 'Network error while checking payment status.';
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(_paymentErrorMessage!)),
        );
      }
    }
  }

  Future<PaymentStatusModel?> checkPaymentStatus(int paymentId) async {
    try {
      final response = await _apiService.getPaymentStatus(paymentId);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          _paymentStatus = PaymentStatusModel.fromJson(data);
          notifyListeners();
          return _paymentStatus;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in checkPaymentStatus: $e');
      }
    }
    return null;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _paymentErrorMessage = response.message ?? 'Payment failed or cancelled.';
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(content: Text(_paymentErrorMessage!)),
      );
    }
    notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet if needed
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
