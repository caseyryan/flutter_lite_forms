// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

class SignupFormPage extends StatelessWidget {
  const SignupFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    const formName = 'signupForm';
    return Scaffold(
      appBar: AppBar(),
      body: LiteFormGroup(
        /// autoDispose: false will store the form
        /// (despite that the LiteFormGroup might be disposed of) until
        /// you call clearForm from anywhere
        /// passing 'signupForm' key there
        /// this might come useful if you create a multipage onboarding
        /// and want to send the accumulated data to the backend in the end
        autoDispose: false,
        name: formName,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 20.0),
                    LiteTextFormField(
                      maxLines: 1,
                      textEntryType: LiteTextEntryType.onModalRoute,
                      useSmoothError: true,
                      name: 'login',
                      validator: (value) async {
                        if (value?.isNotEmpty != true) {
                          return 'Login cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (kDebugMode) {
                          print('VALUE: $value');
                        }
                      },
                      initialValue: 'Konstantin',
                      initialValueDeserializer: (value) {
                        if (value is String) {
                          return value;
                        }
                        return value.toString();
                      },
                      serializer: (value) {
                        return 'Mr. $value';
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                    const SizedBox(height: 20.0),
                    LitePasswordField(
                      name: 'password',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      paddingBottom: 20.0,
                      initialValue: 'Hedgehog2*',
                      settings: PasswordSettings(
                        // validator: (value) async {
                        //   if (value?.isNotEmpty != true) {
                        //     return 'Password cannot be empty';
                        //   }
                        //   return null;
                        // },
                        requirements: PasswordRequirements.defaultRequirements(),
                        // checkerBuilder: (
                        //   digitsOk,
                        //   upperCaseOk,
                        //   lowerCaseOk,
                        //   specialCharsOk,
                        //   lengthOk,
                        //   passwordsMatch,
                        // ) {
                        //   if (kDebugMode) {
                        //     print(
                        //       'digitsOk: $digitsOk, upperCaseOk: $upperCaseOk, lowerCaseOk: $lowerCaseOk, specialCharsOk: $specialCharsOk, lengthOk: $lengthOk, passwordsMatch: $passwordsMatch',
                        //     );
                        //   }
                        //   return Container(
                        //     height: 100.0,
                        //     width: double.infinity,
                        //     color: Colors.blue,
                        //   );
                        // },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    LiteDatePicker(
                      textAlign: TextAlign.center,
                      dateInputType: DateInputType.both,
                      name: 'dateOfBirth',

                      /// notice that you can pass DateTime object here or
                      /// a String representation of a date. Both cases
                      /// will be processed by initialValueDeserializer below
                      /// and the LiteDatePicker will get a valid DateTime
                      /// object as an input
                      // initialValue: DateTime.now(),
                      initialValue: DateTime.now().toIso8601String(),
                      pickerType: LiteDatePickerType.material,
                      autovalidateMode: AutovalidateMode.disabled,
                      initialValueDeserializer: (value) {
                        if (value is DateTime) {
                          return value;
                        }
                        if (value is String) {
                          return DateTime.tryParse(value);
                        }
                        return value;
                      },
                      validator: (value) async {
                        // return 'Date is incorrect';
                        return null;
                      },
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (await validateLiteForm(formName)) {
                          final formData = getFormData(formName);
                          if (kDebugMode) {
                            print(formData);
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              maintainState: false,
                              builder: (context) {
                                return ProfilePage();
                              },
                            ),
                          );
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
