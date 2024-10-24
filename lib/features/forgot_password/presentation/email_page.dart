import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/features/forgot_password/presentation/forgot_password_state_notifier.dart';
import 'package:curb_companion/utils/helpers/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPage extends ConsumerStatefulWidget {
  final Function goNext;

  const EmailPage({super.key, required this.goNext});

  @override
  EmailPageState createState() => EmailPageState();
}

class EmailPageState extends ConsumerState<EmailPage> {
  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  dynamic notifier;

  @override
  void initState() {
    notifier = ref.read(forgotPasswordStateProvider.notifier);

    _emailController.text = notifier.forgotPasswordModel.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, child) {
        var watcher = ref.watch(forgotPasswordStateProvider.notifier);
        return Form(
          key: _emailFormKey,
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
                onChanged: (value) {
                  watcher.forgotPasswordModel.email = value;
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
              if (watcher is EmailVerificationError)
                Text(
                  (watcher as EmailVerificationError).errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Verify'),
                onPressed: () async {
                  if (_emailFormKey.currentState!.validate()) {
                    if (await watcher
                        .sendEmail(watcher.forgotPasswordModel.email)) {
                      widget.goNext();
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
