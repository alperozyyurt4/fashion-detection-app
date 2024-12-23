import 'package:fashion/core/constant/app_color.dart';
import 'package:fashion/core/services/auth_service.dart';
import 'package:fashion/features/auth/views/widgets/auth_form_field.dart';
import 'package:fashion/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // FormKey
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              AuthFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                controller: emailController,
                formFocusColor: AppColor.authFormInputBorderColor,
                formHintText: 'Email',
              ),
              AuthFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a  password';
                  }
                  return null;
                },
                controller: passwordController,
                formFocusColor: AppColor.authFormInputBorderColor,
                formHintText: 'Password',
              ),
              CheckboxMenuButton(
                value: false,
                onChanged: (value) {
                  /// Remember me logic
                },
                child: Text('Remember Me'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      User? user = await _authService.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (user != null) {
                        /// Login success
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login Success'),
                          ),
                        );

                        // Navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('User not found'),
                          title: const Text('Error'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
