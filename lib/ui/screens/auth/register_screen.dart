import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shartflix/core/theme/colors.dart';
import 'package:shartflix/core/utils/localization_helper.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../core/utils/locale_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthError ||
            current is Unauthenticated ||
            current is RegisterSuccess,
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pop(context);
          } else if (state is AuthError && state.source == 'register') {
            _showSnackbar(state.message);
          }
        },
        child: Stack(
          children: [
            _buildRegisterForm(context),
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
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
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
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                                    border: Border.all(
                                      color: const Color(0xFF505050),
                                    ),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            getText(context, "Kayıt Ol", "Register"),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 42),
                            child: Text(
                              getText(
                                context,
                                "Yeni bir hesap oluşturmak için bilgilerinizi girin.",
                                "Enter your details to create a new account.",
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 45),

                          _buildTextField(
                            controller: nameController,
                            hint: getText(context, "Ad Soyad", "Full Name"),
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            hint: getText(context, "E-Posta", "Email"),
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: passwordController,
                            hint: getText(context, "Şifre", "Password"),
                            icon: Icons.lock_outline,
                            obscure: obscurePassword,
                            toggleObscure: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: confirmPasswordController,
                            hint: getText(
                              context,
                              "Şifre Tekrar",
                              "Confirm Password",
                            ),
                            icon: Icons.lock_outline,
                            obscure: obscureConfirmPassword,
                            toggleObscure: () => setState(
                              () => obscureConfirmPassword =
                                  !obscureConfirmPassword,
                            ),
                          ),
                          const SizedBox(height: 19),

                          Row(
                            children: [
                              Checkbox(
                                value: agreeTerms,
                                onChanged: (v) =>
                                    setState(() => agreeTerms = v!),
                                activeColor: AppColors.primaryRed,
                                checkColor: AppColors.whiteText,
                              ),
                              Expanded(
                                child: Text(
                                  getText(
                                    context,
                                    "Kullanım şartlarını kabul ediyorum",
                                    "I accept the terms of use",
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: agreeTerms
                                  ? () {
                                      if (_validateForm()) {
                                        context.read<AuthBloc>().add(
                                          RegisterRequested(
                                            nameController.text,
                                            emailController.text,
                                            passwordController.text,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                getText(context, "Kayıt Ol", "Register"),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 140),

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: getText(
                                  context,
                                  "Zaten bir hesabın var mı? ",
                                  "Already have an account? ",
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                                children: [
                                  TextSpan(
                                    text: getText(
                                      context,
                                      "Giriş Yap!",
                                      "Login!",
                                    ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? textInputType = TextInputType.text,
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white70,
                ),
                onPressed: toggleObscure,
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        border: Theme.of(context).inputDecorationTheme.border,
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
      ),
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

  bool _validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.split(' ').length < 2) {
      _showSnackbar(
        getText(
          context,
          "Lütfen ad ve soyadınızı girin",
          "Please enter your full name",
        ),
      );
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnackbar(
        getText(
          context,
          "Geçerli bir e-posta adresi girin",
          "Please enter a valid email address",
        ),
      );
      return false;
    }

    if (password != confirmPassword) {
      _showSnackbar(
        getText(context, "Şifreler eşleşmiyor", "Passwords do not match"),
      );
      return false;
    }

    if (password.length < 6) {
      _showSnackbar(
        getText(
          context,
          "Şifre en az 6 karakter olmalı",
          "Password must be at least 6 characters",
        ),
      );
      return false;
    }

    return true;
  }
}
