import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../../viewmodels/app_settings_provider.dart';
import '../../../../widgets/dynamic_logo_widget.dart';
import '../view_models/sign_up_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpViewModel _viewModel;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = SignUpViewModel();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _placeController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = context.watch<AppSettingsProvider>();
    final appName = settings.appName.isNotEmpty ? settings.appName : 'Zenvora LMS';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Premium Header Section with Gradients
                Container(
                  width: double.infinity,
                  height: size.height * 0.40,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradientOf(context),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Zenvora Logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const DynamicLogoWidget(
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Empowering Oil & Gas Education',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ),

                // Card Layout Container Overlay
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.cardLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Photo Picker Section inside form card
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: AppTheme.primaryBlue,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profile.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade200,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.person,
                                          size: 48,
                                          color: Colors.grey.shade600,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error Message Card
                        if (_viewModel.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _viewModel.errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Form Fields
                        // 1. Full Name
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.setFullName,
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 2. Email Address
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.setEmail,
                          decoration: const InputDecoration(
                            hintText: 'Email address',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3. Phone Number
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.setPhone,
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4. Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _viewModel.obscurePassword,
                          textInputAction: TextInputAction.next,
                          onChanged: _viewModel.setPassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: AppTheme.textLight,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _viewModel.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textLight,
                              ),
                              onPressed: _viewModel.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 5. Place
                        TextFormField(
                          controller: _placeController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: _viewModel.setPlace,
                          decoration: const InputDecoration(
                            hintText: 'Place / Location',
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Terms Checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _viewModel.acceptTerms,
                                onChanged: (val) {
                                  if (val != null) {
                                    _viewModel.setAcceptTerms(val);
                                  }
                                },
                                activeColor: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: AppTheme.textMedium,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(text: 'I accept '),
                                    TextSpan(
                                      text: 'Terms',
                                      style: TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Create Account Button
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _viewModel.isLoading
                                ? null
                                : AppTheme.primaryGradientOf(context),
                            color: _viewModel.isLoading
                                ? AppTheme.textLight
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (!_viewModel.isLoading)
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _viewModel.isLoading
                                ? null
                                : () => _viewModel.createAccount(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            child: _viewModel.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text('Create Account'),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: AppTheme.textMedium,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
