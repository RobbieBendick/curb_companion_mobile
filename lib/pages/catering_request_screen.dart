import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/utils/helpers/string_validators.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:flutter/material.dart';

class CateringRequestScreen extends StatelessWidget {
  const CateringRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subjectController = TextEditingController();
    String subjectText = subjectController.text;

    final descriptionController = TextEditingController();
    String descriptionText = descriptionController.text;

    final emailController = TextEditingController();
    String emailText = emailController.text;

    final formKey = GlobalKey<FormState>();

    return Material(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text("Catering Request"),
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
          ),
          SliverFillRemaining(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "Send a catering request.",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: CustomTextField(
                      hintText: 'Email',
                      controller: emailController,
                      onChanged: (value) {
                        emailText = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email.';
                        } else if (!value.isValidEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: CustomTextField(
                      hintText: 'Subject',
                      controller: subjectController,
                      onChanged: (value) {
                        subjectText = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: CustomTextField(
                      hintText: 'Description',
                      controller: descriptionController,
                      onChanged: (value) {
                        descriptionText = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        return null;
                      },
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await RestApiService.sendCateringRequest(
                              emailText, subjectText, descriptionText);
                        }
                      },
                      child: const Text("Send"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CateringCard extends StatefulWidget {
  final String cardTitle;
  final String cardDescription;

  const CateringCard({
    Key? key,
    required this.cardTitle,
    required this.cardDescription,
  }) : super(key: key);

  @override
  CateringCardState createState() => CateringCardState();
}

class CateringCardState extends State<CateringCard> {
  Color cardBorderColor = Colors.black.withOpacity(0.3);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              cardBorderColor = Theme.of(context).primaryColor;
            });
          },
          onTapUp: (_) {
            setState(() {
              cardBorderColor = Colors.black.withOpacity(0.3);
            });
          },
          onTapCancel: () {
            setState(() {
              cardBorderColor = Colors.black.withOpacity(0.3);
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              border: Border.all(
                color: cardBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.cardTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    widget.cardDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
