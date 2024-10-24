import 'package:curb_companion/features/registration/presentation/account_page.dart';
import 'package:curb_companion/features/registration/presentation/info_page.dart';
import 'package:curb_companion/features/registration/presentation/registration_page4.dart';
import 'package:curb_companion/features/registration/presentation/step_progress_view.dart';
import 'package:curb_companion/features/registration/presentation/verify_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  int _curStep = 1;
  List<String> titles = ["Info", "Account", "Verify"];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
        ),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: StepProgressView(
                      width: MediaQuery.of(context).size.width,
                      curStep: _curStep,
                      color: const Color(0xff50AC02).withOpacity(.8),
                      titles: titles),
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
                      InfoPage(goNext: goNext),
                      AccountPage(goNext: goNext, goBack: goBack),
                      VerifyPage(goNext: goNext, goBack: goBack),
                      const RegistrationPage4()
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
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
