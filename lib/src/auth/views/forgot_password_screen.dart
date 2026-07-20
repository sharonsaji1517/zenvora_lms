import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../view_models/forgot_password_view_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final ForgotPasswordViewModel _viewModel;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ForgotPasswordViewModel();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Top Brand Logo Banner (Teal Gradient)
                Container(
                  width: double.infinity,
                  height: size.height * 0.38,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: SafeArea(
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
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            height: 64,
                            width: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Card Layout Container Overlay
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLight,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Reset Password',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Enter your email address and we will send you a link to reset your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textMedium,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Error message
                        if (_viewModel.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                            ),
                            child: Text(
                              _viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Success message
                        if (_viewModel.successMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
                            ),
                            child: Text(
                              _viewModel.successMessage!,
                              style: const TextStyle(color: AppTheme.secondaryBlue, fontSize: 13, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onChanged: _viewModel.setEmail,
                          decoration: const InputDecoration(
                            hintText: 'Email address',
                            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textLight),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Submit Button
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _viewModel.isLoading ? null : AppTheme.primaryGradient,
                            color: _viewModel.isLoading ? AppTheme.textLight : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (!_viewModel.isLoading)
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _viewModel.isLoading
                                ? null
                                : () => _viewModel.sendResetLink(context),
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
                                : const Text('Submit Reset Link'),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Back to Login
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: const Text(
                            'Back to Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
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
