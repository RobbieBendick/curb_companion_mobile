// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:provider/provider.dart' as provider;
import 'package:curb_companion/features/theme/app/theme_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ShapeBorder? _buttonShape = ShapeBorder.lerp(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      0.5);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Consumer(builder: (
        context,
        reff,
        child,
      ) {
        var userState = ref.watch(userStateProvider.notifier);
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 88,
                    ),
                    Image.asset(provider.Provider.of<ThemeService>(context,
                                listen: false)
                            .isDarkMode()
                        ? 'assets/images/logo_with_name_dark.png'
                        : 'assets/images/logo_with_name.png'),
                    const SizedBox(height: 88),
                    CustomTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      secureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    if (userState is UserError)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            userState.errorMessage,
                            style: const TextStyle(
                                color: Color.fromARGB(225, 255, 122, 120)),
                          ),
                        ],
                      ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await ref.read(userStateProvider.notifier).login(
                                  LoginModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                        child: userState is LoggingIn
                            ? const CircularProgressIndicator(
                                strokeWidth: 1,
                              )
                            : const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Forgot your password?",
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to forgot_password screen
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordScreen);
                          },
                          child: Text(
                            "Reset it here",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.registrationScreen);
                          },
                          child: Text(
                            "Sign up here",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        if (ref
                                .watch(locationStateProvider.notifier)
                                .lastKnownLocation ==
                            null) {
                          Navigator.pushNamed(
                              context, Routes.locationServicesScreen);
                        }
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.homeScreen, (route) => false);
                      },
                      child: Text(
                        "Continue as guest",
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
