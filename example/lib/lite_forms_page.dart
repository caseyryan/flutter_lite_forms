// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

class LiteFormsPage extends StatelessWidget {
  const LiteFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const formName = 'signupForm';
    return Scaffold(
      appBar: AppBar(),
      body: LiteFormGroup(
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
                      useSmoothError: true,
                      name: 'login',
                      validator: (value) async {
                        if (value?.isNotEmpty != true) {
                          await Future.delayed(Duration(milliseconds: 1000));
                          return 'Field is required';
                        }
                        return null;
                      },
                      initialValue: 'Kostyan',
                      initialValueDeserializer: (value) {
                        return 'User $value';
                      },
                      serializer: (value) {
                        return 'Serialized value: $value';
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                    const SizedBox(height: 20.0),
                    LiteDatePicker(
                      textAlign: TextAlign.center,
                      dateInputType: DateInputType.time,
                      name: 'dateOfBirth',
                      initialValue: DateTime.now(),
                      pickerType: LiteDatePickerType.material,
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
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        }
                      },
                      child: Text('Login Page'),
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
