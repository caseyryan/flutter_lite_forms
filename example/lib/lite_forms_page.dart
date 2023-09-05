// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/login_page.dart';
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
                    LiteTextFormField<String>(
                      name: 'login',
                      validator: (value) {
                        if (value?.isNotEmpty != true) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      initialValue: 'Gogi',
                      initialValueDeserializer: (value) {
                        return 'User $value';
                      },
                      serializer: (value) {
                        print(value);
                        return '$value+`RRR`';
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Login',
                        errorStyle: TextStyle(
                          fontSize: 0.0,
                          color: Colors.transparent,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (validateLiteForm(formName)) {
                          final formData = getFormData(formName);
                          print(formData);
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
