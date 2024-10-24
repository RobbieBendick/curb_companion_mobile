import 'package:curb_companion/features/forgot_password/presentation/forgot_password_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuccessPage extends ConsumerStatefulWidget {
  const SuccessPage({super.key});

  @override
  SuccessPageState createState() => SuccessPageState();
}

Widget _passwordChanged(BuildContext context, WidgetRef ref, bool mounted) {
  return SliverFillRemaining(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
      const SizedBox(height: 20),
      Text(
        "Your password has successfully been changed!",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () async {
          var forgotPasswordNotifier =
              ref.read(forgotPasswordStateProvider.notifier);
          // ignore: use_build_context_synchronously
          if (await ref.read(userStateProvider.notifier).login(LoginModel(
              email: forgotPasswordNotifier.forgotPasswordModel.email,
              password:
                  forgotPasswordNotifier.forgotPasswordModel.newPassword))) {
            if (!mounted) return;
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.authScreen);
          }
        },
        child: const Text("Finish"),
      )
    ],
  ));
}

Widget _passwordError(BuildContext context) {
  return SliverFillRemaining(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline,
          size: 100, color: Theme.of(context).colorScheme.error),
      const SizedBox(height: 20),
      Text(
        "There was an error changing your password. Please try again.",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Try Again"),
      )
    ],
  ));
}

class SuccessPageState extends ConsumerState<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(forgotPasswordStateProvider.notifier);

        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              title: Text("Success"),
            ),
            if (state is PasswordReset) _passwordChanged(context, ref, mounted),
            if (state is ResetPasswordError)
              _passwordError(
                context,
              ),
          ],
        );
      },
    );
  }
}
