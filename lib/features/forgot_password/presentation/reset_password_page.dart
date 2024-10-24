import 'package:curb_companion/features/forgot_password/presentation/forgot_password_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/forgot_password/domain/forgot_password_reset_request.dart';
import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final Function goNext;
  final Function goBack;

  const ResetPasswordPage(
      {super.key, required this.goNext, required this.goBack});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _resetPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    var notifier = ref.read(forgotPasswordStateProvider.notifier);

    _passwordController.text = notifier.forgotPasswordModel.newPassword;
    _confirmPasswordController.text =
        notifier.forgotPasswordModel.confirmPassword;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        var notifierWatcher = ref.watch(forgotPasswordStateProvider.notifier);
        return Form(
          key: _resetPasswordFormKey,
          child: Column(
            children: [
              CustomTextField(
                secureText: true,
                hintText: 'New Password',
                controller: _passwordController,
                onChanged: (value) {
                  notifierWatcher.forgotPasswordModel.newPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                secureText: true,
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                onChanged: (value) {
                  notifierWatcher.forgotPasswordModel.confirmPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (notifierWatcher is ResetPasswordError)
                Text(
                  (notifierWatcher as ResetPasswordError).errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                      child: const Text("Go back"),
                      onPressed: () => widget.goBack()),
                  ElevatedButton(
                    child: const Text('Verify'),
                    onPressed: () async {
                      if (_resetPasswordFormKey.currentState!.validate()) {
                        if (await notifierWatcher.resetPassword(
                          ForgotPasswordResetRequest(
                              email: notifierWatcher.forgotPasswordModel.email,
                              code: notifierWatcher.forgotPasswordModel.code,
                              newPassword: notifierWatcher
                                  .forgotPasswordModel.newPassword,
                              confirmPassword: notifierWatcher
                                  .forgotPasswordModel.confirmPassword),
                        )) {
                          // Go to login page
                          if (!mounted) return;
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                              context, Routes.authScreen);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
