import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/registration/presentation/registration_state_notifier.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationPage4 extends ConsumerStatefulWidget {
  const RegistrationPage4({super.key});

  @override
  RegistrationPage4State createState() => RegistrationPage4State();
}

class RegistrationPage4State extends ConsumerState<RegistrationPage4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
        const SizedBox(height: 20),
        Text(
          "Your account has been created!",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: ElevatedButton(
              onPressed: () async {
                var userNotifier = ref.read(userStateProvider.notifier);
                var registrationNotifier =
                    ref.read(registrationStateProvider.notifier);

                // ignore: use_build_context_synchronously
                if (await userNotifier.login(LoginModel(
                    email: registrationNotifier.registrationModel.email,
                    password:
                        registrationNotifier.registrationModel.password))) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.homeScreen);
                }
              },
              child: const Text("Login")),
        )
      ],
    );
  }
}
