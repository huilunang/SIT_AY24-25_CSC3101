import 'package:bloobin_app/common_widgets/custom_auth_button.dart';
import 'package:bloobin_app/common_widgets/custom_snack_bar.dart';
import 'package:bloobin_app/common_widgets/custom_text_field.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:bloobin_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:bloobin_app/utils/bloc_access_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.show(context, "Signing up...", type: 'success'));
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else if (state is AuthSignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                context, state.errorMessage,
                type: 'error'));
          }
        },
        child: Center(
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
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: 'Re-enter password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      child: CustomAuthButton(
                          buttonText: 'Create',
                          onPressed: () {
                            context.authBloc.add(AuthSignedUp(
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword:
                                    confirmPasswordController.text));
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
