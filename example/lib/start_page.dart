// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/signup_form_page.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/lite_forms.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LiteFormGroup(
        name: 'profileForm',
        autoDispose: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the LiteForms!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50.0),
              MaterialButton(
                color: Colors.blue[50],
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      maintainState: false,
                      builder: (context) {
                        return SignupFormPage();
                      },
                    ),
                  );
                },
                child: Text('Check it out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}