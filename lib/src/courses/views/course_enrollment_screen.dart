import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/routes/app_routes.dart';
import '../models/course_model.dart';

class CourseEnrollmentScreen extends StatefulWidget {
  final Course? course;

  const CourseEnrollmentScreen({super.key, this.course});

  @override
  State<CourseEnrollmentScreen> createState() => _CourseEnrollmentScreenState();
}

class _CourseEnrollmentScreenState extends State<CourseEnrollmentScreen> {
  late Course _course;
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? _selectedPaymentMethod;
  String _couponCode = '';
  double _discountAmount = 0.0;
  bool _couponApplied = false;
  String? _couponError;
  String? _couponSuccessMessage;
  
  bool _isLoadingUserData = true;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
    },
    {
      'id': 'upi',
      'name': 'UPI',
      'icon': Icons.account_balance_wallet,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'icon': Icons.account_balance,
    },
    {
      'id': 'wallet',
      'name': 'Wallet',
      'icon': Icons.wallet,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.course != null) {
      _course = widget.course!;
    } else {
      final args = ModalRoute.of(context)?.settings.arguments;
      _course = (args is Course) ? args : getMockCourses().first;
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefsService = UserPreferencesService();
      final name = await prefsService.getFullName();
      final email = await prefsService.getEmail();
      
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
        _isLoadingUserData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingUserData = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _getInstructorName() {
    switch (_course.id) {
      case 'c1':
        return 'John Mathew';
      case 'c2':
        return 'Dr. Robert Carter';
      case 'c3':
        return 'Prof. Angela Miller';
      case 'c4':
        return 'HSE Specialist Kim';
      default:
        return 'John Mathew';
    }
  }

  String _getDuration() {
    switch (_course.id) {
      case 'c1':
        return '12 Weeks';
      case 'c2':
        return '8 Weeks';
      case 'c3':
        return '10 Weeks';
      case 'c4':
        return '6 Weeks';
      default:
        return '12 Weeks';
    }
  }

  void _applyCoupon() {
    final code = _couponCode.trim().toUpperCase();
    setState(() {
      _couponError = null;
      _couponSuccessMessage = null;
    });

    if (code.isEmpty) {
      setState(() {
        _couponError = 'Please enter a coupon code';
      });
      return;
    }

    // Simulate validation
    if (code == 'EASYLEARN10') {
      setState(() {
        _discountAmount = _course.price * 0.10;
        _couponApplied = true;
        _couponSuccessMessage = '10% discount applied successfully!';
      });
    } else if (code == 'WELCOME20') {
      setState(() {
        _discountAmount = _course.price * 0.20;
        _couponApplied = true;
        _couponSuccessMessage = '20% discount applied successfully!';
      });
    } else {
      setState(() {
        _couponError = 'Invalid coupon code. Try EASYLEARN10 or WELCOME20';
        _discountAmount = 0.0;
        _couponApplied = false;
      });
    }
  }

  double get _totalPrice {
    final total = _course.price - _discountAmount;
    return total < 0 ? 0.0 : total;
  }

  void _processPayment() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the student information errors.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method to proceed.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    // Set course to enrolled
    setState(() {
      _course.isEnrolled = true;
      _course.progress = 0.0;
    });

    // Extract selected payment method name
    final selectedMethod = _paymentMethods.firstWhere(
      (m) => m['id'] == _selectedPaymentMethod,
    );

    // Navigate to Success screen
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.enrollmentSuccess,
      arguments: {
        'course': _course,
        'paymentMethod': selectedMethod['name'],
        'paidAmount': _totalPrice,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Course Enrollment',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoadingUserData
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    
                    // 1. Course Summary Card
                    _buildSectionHeader('Course Summary'),
                    _buildCourseSummaryCard(),
                    const SizedBox(height: 24),
                    
                    // 2. Student Information Section
                    _buildSectionHeader('Student Information'),
                    _buildStudentInformationSection(),
                    const SizedBox(height: 24),
                    
                    // 3. Payment Method Section
                    _buildSectionHeader('Payment Method'),
                    _buildPaymentMethodSection(),
                    const SizedBox(height: 24),
                    
                    // 4. Coupon Section
                    _buildSectionHeader('Have a Coupon?'),
                    _buildCouponSection(),
                    const SizedBox(height: 24),
                    
                    // 5. Payment Summary Section
                    _buildSectionHeader('Payment Summary'),
                    _buildPaymentSummarySection(),
                    const SizedBox(height: 24),
                    
                    // 6. Order Summary Card
                    _buildSectionHeader('Order Summary'),
                    _buildOrderSummaryCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      // Bottom Fixed Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: AppTheme.brandBlueGreenGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.brandEmeraldGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 2.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildCourseSummaryCard() {
    final instructor = _getInstructorName();
    final duration = _getDuration();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(
                  _course.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.borderLight,
                      child: const Icon(
                        Icons.school_outlined,
                        color: AppTheme.textLight,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _course.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Instructor: $instructor',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Duration: $duration',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_course.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInformationSection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Full Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, size: 22),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Email Address Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined, size: 22),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Phone Number Field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined, size: 22),
                hintText: 'e.g. +1 555-0199',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: _paymentMethods.map((method) {
        final isSelected = _selectedPaymentMethod == method['id'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.borderLight,
              width: isSelected ? 1.8 : 0.8,
            ),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                _selectedPaymentMethod = method['id'];
              });
            },
            leading: Icon(
              method['icon'] as IconData,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.textMedium,
              size: 24,
            ),
            title: Text(
              method['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
                fontSize: 14.5,
              ),
            ),
            trailing: Radio<String>(
              value: method['id'] as String,
              groupValue: _selectedPaymentMethod,
              activeColor: AppTheme.primaryBlue,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCouponSection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      onChanged: (value) {
                        _couponCode = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter coupon (e.g. EASYLEARN10)',
                        prefixIcon: Icon(Icons.local_offer_outlined, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_couponError != null) ...[
              const SizedBox(height: 8),
              Text(
                _couponError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
            if (_couponSuccessMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _couponSuccessMessage!,
                style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummarySection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Course Price', '\$${_course.price.toStringAsFixed(2)}'),
            if (_couponApplied) ...[
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Coupon Discount',
                '-\$${_discountAmount.toStringAsFixed(2)}',
                valueColor: AppTheme.accentGreen,
              ),
            ],
            const SizedBox(height: 12),
            _buildSummaryRow('Tax', '\$0.00'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: AppTheme.borderLight, height: 1),
            ),
            _buildSummaryRow(
              'Total',
              '\$${_totalPrice.toStringAsFixed(2)}',
              isBold: true,
              valueColor: AppTheme.primaryBlue,
              fontSize: 16.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    double fontSize = 14,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: isBold ? AppTheme.textDark : AppTheme.textMedium,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
            color: valueColor ?? (isBold ? AppTheme.textDark : AppTheme.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard() {
    final selectedMethodText = _paymentMethods.firstWhere(
      (m) => m['id'] == _selectedPaymentMethod,
      orElse: () => {'name': 'Not selected'},
    )['name'] as String;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _course.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selected Payment:',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
                ),
                Text(
                  selectedMethodText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _selectedPaymentMethod != null ? AppTheme.primaryBlue : Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Final Amount:',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
                ),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

