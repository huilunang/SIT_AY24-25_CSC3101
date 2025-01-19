import 'package:bloobin_app/common_widgets/custom_auth_button.dart';
import 'package:bloobin_app/common_widgets/custom_text_field.dart';
import 'package:bloobin_app/features/auth/presentation/pages/signup_page.dart';
import 'package:bloobin_app/navigation/main_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void handleSignIn() {
      final email = emailController.text;
      final password = passwordController.text;

      // TODO: SignIn handler, route, localstorage
      print('Email: $email, Password: $password');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/bloobin_signin.png',
                  height: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome back! Please enter your details.',
                  style: TextStyle(color: colorScheme.outline),
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                ),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: CustomAuthButton(
                        buttonText: 'Login', onPressed: handleSignIn)),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: TextStyle(color: colorScheme.outline),
                      children: [
                        TextSpan(
                          text: 'Create account →',
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
