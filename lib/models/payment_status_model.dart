class PaymentStatusModel {
  final bool success;
  final PaymentDetailsModel? payment;
  final bool courseAccess;

  PaymentStatusModel({
    required this.success,
    this.payment,
    required this.courseAccess,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      success: json['success'] == true,
      payment: json['payment'] != null && json['payment'] is Map<String, dynamic>
          ? PaymentDetailsModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      courseAccess: json['course_access'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'payment': payment?.toJson(),
      'course_access': courseAccess,
    };
  }

  int? get paymentId => payment?.id;
  int? get courseId => payment?.courseId;
  String? get gateway => payment?.gateway;
  String? get amount => payment?.amount;
  String? get currency => payment?.currency;
  String? get status => payment?.status;
  String? get message => payment?.message;
  String? get paidAt => payment?.paidAt;
}

class PaymentDetailsModel {
  final int id;
  final int? courseId;
  final String? gateway;
  final String? amount;
  final String? currency;
  final String? status;
  final String? message;
  final String? paidAt;

  PaymentDetailsModel({
    required this.id,
    this.courseId,
    this.gateway,
    this.amount,
    this.currency,
    this.status,
    this.message,
    this.paidAt,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course_id']?.toString() ?? ''),
      gateway: json['gateway']?.toString(),
      amount: json['amount']?.toString(),
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      paidAt: json['paid_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'gateway': gateway,
      'amount': amount,
      'currency': currency,
      'status': status,
      'message': message,
      'paid_at': paidAt,
    };
  }
}
