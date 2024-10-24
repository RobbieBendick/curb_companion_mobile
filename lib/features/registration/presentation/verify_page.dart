import 'package:curb_companion/features/registration/presentation/registration_state_notifier.dart';
import 'package:curb_companion/features/registration/presentation/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPage extends ConsumerStatefulWidget {
  final Function goNext;
  final Function goBack;
  const VerifyPage({super.key, required this.goNext, required this.goBack});

  @override
  VerifyPageState createState() => VerifyPageState();
}

class VerifyPageState extends ConsumerState<VerifyPage> {
  final _pinCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var notifier = ref.watch(registrationStateProvider.notifier);
    return Consumer(
      builder: (context, ref, child) {
        return Form(
            key: _formKey,
            child: Column(
              children: [
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _pinCodeController,
                  onChanged: (String value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      // resend code
                      await notifier
                          .emailVerification(notifier.registrationModel.email);
                    },
                    child: Text('Resend Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        )),
                  ),
                ),
                if (notifier is EmailVerificationError)
                  Text(
                    (notifier as EmailVerificationError).errorMessage,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                if (notifier is EmailVerificationError)
                  const SizedBox(height: 20),
                const Spacer(),
                CCBackButton(goBack: widget.goBack),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: ElevatedButton(
                    child: const Text('Verify'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await notifier
                            .verifyEmail(_pinCodeController.text)) {
                          widget.goNext();
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ));
      },
    );
  }
}
