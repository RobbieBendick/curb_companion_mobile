import 'package:curb_companion/features/forgot_password/presentation/code_page.dart';
import 'package:curb_companion/features/forgot_password/presentation/email_page.dart';
import 'package:curb_companion/features/forgot_password/presentation/reset_password_page.dart';
import 'package:curb_companion/features/registration/presentation/step_progress_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  List<String> titles = ["Email", "Verify", "Reset"];

  int _curStep = 1;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: StepProgressView(
                      width: MediaQuery.of(context).size.width,
                      curStep: _curStep,
                      color: const Color(0xff50AC02),
                      titles: titles,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _curStep = index + 1;
                        });
                      },
                      children: [
                        EmailPage(
                          goNext: goNext,
                        ),
                        CodePage(
                          goNext: goNext,
                          goBack: goBack,
                        ),
                        ResetPasswordPage(
                          goNext: goNext,
                          goBack: goBack,
                        ),
                        // SuccessPage()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void goNext() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void goBack() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
