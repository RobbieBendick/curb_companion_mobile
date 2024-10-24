import 'package:curb_companion/features/registration/presentation/registration_state_notifier.dart';
import 'package:curb_companion/features/registration/presentation/back_button.dart';
import 'package:curb_companion/features/registration/presentation/next_button.dart';
import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/utils/helpers/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerStatefulWidget {
  final Function goBack;
  final Function goNext;
  const AccountPage({super.key, required this.goNext, required this.goBack});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends ConsumerState<AccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(registrationStateProvider.notifier);
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  onChanged: (value) {
                    notifier.registrationModel.email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.isValidEmail) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  secureText: true,
                  onChanged: (value) {
                    notifier.registrationModel.password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value != _confirmPasswordController.text) {
                      return 'Passwords do not match';
                    } else if (!value.isValidPassword) {
                      return 'Password must be valid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: CustomTextField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  secureText: true,
                  onChanged: (value) {
                    notifier.registrationModel.confirmPassword = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    } else if (!value.isValidPassword) {
                      return 'Password must be valid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (notifier is RegistrationError)
                Text((notifier as RegistrationError).errorMessage,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              if (notifier is RegistrationError) const SizedBox(height: 20),
              const Spacer(),
              CCBackButton(goBack: widget.goBack),
              NextButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // create user
                    await notifier.registerUser();
                  }
                },
                goNext: widget.goNext,
                validate: () => _formKey.currentState!.validate(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
