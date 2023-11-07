// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LiteFormGroup(
        name: 'profileForm',
        autoDispose: true,
        builder: (c, scrollController) {
          return CustomScrollView(
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
                        name: 'firstName',
                      ),
                      MaterialButton(
                        onPressed: () async {
                          /// Here we print the data of from the previous form
                          /// It is possible because it had an autoDispose value set to false.
                          final data = await getFormData(
                            formName: 'signupForm',
                          );
                          if (kDebugMode) {
                            print(data);
                          }
                        },
                        child: Text('Print Signup Form'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
