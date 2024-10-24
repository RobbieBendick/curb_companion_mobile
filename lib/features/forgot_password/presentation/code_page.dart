import 'package:curb_companion/features/forgot_password/presentation/forgot_password_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodePage extends ConsumerStatefulWidget {
  final Function goNext;
  final Function goBack;

  const CodePage({super.key, required this.goNext, required this.goBack});

  @override
  CodePageState createState() => CodePageState();
}

class CodePageState extends ConsumerState<CodePage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _codeController.text =
        ref.read(forgotPasswordStateProvider.notifier).forgotPasswordModel.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var notifier = ref.watch(forgotPasswordStateProvider.notifier);

      return Form(
          key: _formKey,
          child: Column(
            children: [
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _codeController,
                onChanged: (String value) {
                  notifier.forgotPasswordModel.code = value;
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
              const SizedBox(height: 20),
              if (notifier is EmailVerificationError)
                Column(
                  children: [
                    Text(
                      (notifier as EmailVerificationError).errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('Resend'),
                    onPressed: () async {
                      if (await notifier
                          .sendEmail(notifier.forgotPasswordModel.email)) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email sent!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Back'),
                    onPressed: () {
                      widget.goBack();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Verify'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await notifier.verifyEmail(
                          notifier.forgotPasswordModel.email,
                          notifier.forgotPasswordModel.code,
                        )) {
                          widget.goNext();
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ));
    });
  }
}
