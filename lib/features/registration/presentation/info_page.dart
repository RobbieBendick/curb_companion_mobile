import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/features/registration/presentation/registration_state_notifier.dart';
import 'package:curb_companion/utils/helpers/input_formatters.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:curb_companion/features/registration/presentation/next_button.dart';
import 'package:curb_companion/utils/helpers/string_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class InfoPage extends ConsumerStatefulWidget {
  final Function goNext;
  const InfoPage({super.key, required this.goNext});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends ConsumerState<InfoPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  dynamic registrationNotifier;
  @override
  void initState() {
    registrationNotifier = ref.read(registrationStateProvider.notifier);
    _nameController.text = registrationNotifier.registrationModel.firstName;
    _surnameController.text = registrationNotifier.registrationModel.surname;
    _dateController.text =
        registrationNotifier.registrationModel.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy')
                .format(registrationNotifier.registrationModel.dateOfBirth!)
            : "";
    _phoneController.text = registrationNotifier.registrationModel.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      registrationNotifier = ref.watch(registrationStateProvider.notifier);
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              req: true,
              hintText: 'Name',
              controller: _nameController,
              onChanged: (value) {
                registrationNotifier.registrationModel.firstName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else if (!value.isValidName) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              req: true,
              hintText: 'Surname',
              controller: _surnameController,
              onChanged: (value) {
                registrationNotifier.registrationModel.surname = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your surname';
                } else if (!value.isValidName) {
                  return 'Please enter a valid surname';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5),
                      width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintStyle: const TextStyle(color: Colors.black),
              ),
              hint: const Text("<Select a gender>"),
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
                DropdownMenuItem(
                  value: "Other",
                  child: Text("Other"),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                registrationNotifier.registrationModel.gender =
                    value.toString();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: TextFormField(
                controller:
                    _dateController, //editing controller of this TextField
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(0.5),
                        width: 2.0),
                  ),
                  hintText: 'Date of birth (MM-DD-YYYY)',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(.8)),
                    onPressed: () async {
                      //when click we have to show the datepicker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,

                        // 15 years ago
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365 * 15),
                        ),
                        // 120 years ago
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365 * 120),
                        ),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        registrationNotifier.registrationModel.dateOfBirth =
                            pickedDate;
                        String formattedDate =
                            DateFormat('MM-dd-yyyy').format(pickedDate);

                        setState(
                          () {
                            _dateController.text = formattedDate;
                          },
                        );
                      }
                    },
                  ),
                ),
                inputFormatters: [
                  DateInputFormatter(),
                ],
                readOnly: false, // when true user cannot edit text
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: CustomTextField(
                req: true,
                hintText: 'Phone number',
                controller: _phoneController,
                onChanged: (value) {
                  registrationNotifier.registrationModel.phoneNumber = value;
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  PhoneInputFormatter(
                    defaultCountryCode: 'US',
                    allowEndlessPhone: false,
                  )
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!value.isValidPhone) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: NextButton(
                    goNext: widget.goNext,
                    validate: () => _formKey.currentState!.validate()),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
