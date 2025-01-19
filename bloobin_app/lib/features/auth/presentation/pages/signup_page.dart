import 'package:bloobin_app/common_widgets/custom_auth_button.dart';
import 'package:bloobin_app/common_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void handleSignUp() {
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      print(
          'Email: $email, Password: $password, Confirm Password: $confirmPassword');

      // TODO: SignUp handler, route back to login
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bloobin_signup.png',
                  height: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create account',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: 'Re-enter password',
                ),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: CustomAuthButton(
                        buttonText: 'Create', onPressed: handleSignUp)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
