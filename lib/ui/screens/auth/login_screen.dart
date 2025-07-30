import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shartflix/core/theme/colors.dart';
import 'package:shartflix/core/utils/locale_provider.dart';
import 'package:shartflix/core/utils/localization_helper.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError && state.source == 'login') {
            _showSnackbar(state.message);
          } else if (state is RegisterSuccess) {
            emailController.clear();
            passwordController.clear();
            _showSnackbar(state.message, color: Colors.green);
          }
        },
        child: Stack(
          children: [
            _buildLoginForm(context),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 35, left: 35),
                child: Consumer<LocaleProvider>(
                  builder: (context, localeProvider, child) {
                    final isTurkish =
                        localeProvider.locale.languageCode == 'tr';
                    return GestureDetector(
                      onTap: () => localeProvider.toggleLocale(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF505050)),
                        ),
                        child: Text(
                          isTurkish ? "EN" : "TR",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        getText(context, 'Merhabalar', 'Hello'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Text(
                          getText(
                            context,
                            'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                            'Welcome back! Sign in to continue exploring.',
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 45),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          context,
                          getText(context, 'E-Posta', 'Email'),
                          Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          context,
                          getText(context, 'Şifre', 'Password'),
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 19),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: Colors.grey,
                          ),
                          child: Text(
                            getText(
                              context,
                              'Şifremi unuttum',
                              'Forgot password',
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: 11),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_validateLogin()) {
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            getText(context, 'Giriş Yap', 'Sign In'),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(Icons.g_mobiledata, 45, 7),
                          const SizedBox(width: 9),
                          _buildSocialIcon(Icons.apple, 33, 12),
                          const SizedBox(width: 9),
                          _buildSocialIcon(Icons.facebook, 33, 12),
                        ],
                      ),
                      const SizedBox(height: 34),

                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: RichText(
                          text: TextSpan(
                            text: getText(
                              context,
                              'Bir hesabın yok mu? ',
                              'Don\'t have an account? ',
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: getText(context, 'Kayıt Ol!', 'Sign Up!'),
                                style: const TextStyle(
                                  fontFamily: 'EuclidCircularA',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.bodySmall,
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF1C1C1C),
      border: Theme.of(context).inputDecorationTheme.border,
      enabledBorder: Theme.of(context).inputDecorationTheme.border,
    );
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: color,
      ),
    );
  }

  bool _validateLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnackbar(
        getText(context, 'Geçerli bir e-posta girin', 'Enter a valid email'),
      );
      return false;
    }
    if (password.isEmpty) {
      _showSnackbar(
        getText(context, 'Şifre boş olamaz', 'Password cannot be empty'),
      );
      return false;
    }
    return true;
  }

  Widget _buildSocialIcon(IconData icon, double size, double padding) {
    bool isApple = icon == Icons.apple;
    return Container(
      padding: isApple
          ? const EdgeInsets.fromLTRB(12, 11, 12, 13)
          : EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 1, color: const Color(0xFF505050)),
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}
