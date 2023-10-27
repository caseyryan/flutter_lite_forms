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
        allowUnfocusOnTapOutside: false,
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
                    LiteSearchField(
                      paddingTop: 20.0,
                      onSearch: (value) {
                        if (kDebugMode) {
                          print('Searching for: $value');
                        }
                      },
                      settings: LiteSearchFieldSettings(
                        searchTriggerType: SearchTriggerType.automatic,
                        iconPosition: LiteSearchFieldIconPosition.left,
                      ),
                    ),
                    Row(
                      children: [
                        LiteImagePicker(
                          key: Key('image'),
                          name: 'image',
                          aspectRatio: 4.0 / 3.0,
                          paddingTop: 20.0,
                          paddingRight: 10.0,
                          constraints: BoxConstraints(
                            maxWidth: 180.0,
                            maxHeight: 100.0,
                          ),
                        ),
                        LiteImagePicker(
                          key: Key('image2'),
                          name: 'image2',
                          aspectRatio: 6.0 / 4.0,
                          imageSpacing: 3.0,
                          paddingTop: 20.0,
                          maxImages: 4,
                          paddingRight: 10.0,
                          constraints: BoxConstraints(
                            maxWidth: 220.0,
                            maxHeight: 200.0,
                          ),
                        ),
                        
                      ],
                    ),
                    LiteTextFormField(
                      readOnly: false,
                      paddingTop: 20.0,
                      maxLines: 1,
                      textEntryType: LiteTextEntryType.normal,
                      useSmoothError: true,
                      name: 'login',
                      validators: [
                        (value) async {
                          if (value?.toString().isNotEmpty != true) {
                            return 'Login cannot be empty';
                          }
                          return null;
                        },
                      ],
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
                    // const SizedBox(height: 600.0),
                    LiteCountrySelector(
                      readOnly: false,
                      name: 'countries',
                      paddingTop: 20.0,
                      initialValue: 'italy',
                      serializer: (value) {
                        if (value is List) {
                          return value.map((e) => e.payload.name).toList();
                        }
                        return value;
                      },
                      dropSelectorType: LiteDropSelectorViewType.menu,
                    ),
                    LitePhoneInputField(
                      name: 'phone',
                      readOnly: false,
                      paddingTop: 20.0,
                      paddingBottom: 20.0,
                      initialValue: '+79517773344',
                      // defaultCountry: 'russia',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // phoneInputType: LitePhoneInputType.autodetectCode,
                      phoneInputType: LitePhoneInputType.manualCode,
                      serializer: LiteSerializers.phoneDataToFormattedString,
                      // serializer: LiteSerializers.phoneDataToUnformattedString,
                      // serializer: LiteSerializers.fullPhoneDataWithCountry,
                      validators: [
                        LiteValidators.phoneValidator,
                      ],
                    ),
                    LiteDropSelector(
                      paddingTop: 20.0,
                      readOnly: false,
                      name: 'classes',
                      initialValue: [
                        // 'Airplane Mode',
                        'ActivateIntent',
                      ],

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      dropSelectorType: LiteDropSelectorViewType.menu,
                      // dropSelectorType: LiteDropSelectorViewType.bottomsheet,
                      // dropSelectorActionType: LiteDropSelectorActionType.multiselect,
                      // dropSelectorActionType: LiteDropSelectorActionType.singleSelect,
                      dropSelectorActionType: LiteDropSelectorActionType.multiselect,
                      settings: LiteDropSelectorSettings(
                        bottomLeftRadius: 10.0,
                        bottomRightRadius: 10.0,
                        topLeftRadius: 10.0,
                        topRightRadius: 10.0,
                        sheetPadding: EdgeInsets.all(12.0),
                        // chipBuilder: (item, removeItem) {
                        //   return GestureDetector(
                        //     onTap: () {
                        //       removeItem(item);
                        //     },
                        //     child: Container(
                        //       width: 40.0,
                        //       height: 20.0,
                        //       color: Colors.red,
                        //     ),
                        //   );
                        // },
                        menuSearchConfiguration: MenuSearchConfiguration(
                          searchFieldVisibility: SearchFieldVisibility.always,
                        ),
                      ),
                      // items: [
                      //   LiteDropSelectorItem(
                      //     title: 'Airplane Mode',
                      //     payload: 'airplane mode',
                      //     iconBuilder: (context, item, isSelected) {
                      //       if (isSelected) {
                      //         return Icon(
                      //           Icons.airplanemode_active,
                      //           color: Colors.green,
                      //         );
                      //       }
                      //       return Icon(
                      //         Icons.airplanemode_inactive,
                      //         color: Colors.red,
                      //       );
                      //     },
                      //   ),
                      //   LiteDropSelectorItem(
                      //     title: 'Notifications',
                      //     payload: 'notifications',
                      //     iconBuilder: (context, item, isSelected) {
                      //       if (isSelected) {
                      //         return Icon(
                      //           Icons.notifications_active,
                      //           color: Colors.lightGreen,
                      //         );
                      //       }
                      //       return Icon(
                      //         Icons.notifications_off,
                      //         color: Colors.orange,
                      //       );
                      //     },
                      //   ),
                      // ],

                      items: [
                        'ActivateIntent',
                        'Align',
                        'Alignment',
                        'AlignmentDirectional',
                        'AlignmentGeometry',
                        'AlignmentGeometryTween',
                        'AlignmentTween',
                        'AlignTransition',
                        'AlwaysScrollableScrollPhysics',
                        'AlwaysStoppedAnimation',
                        'AndroidView',
                        'AndroidViewSurface',
                        'Animatable',
                        'AnimatedAlign',
                        // 'AnimatedBuilder',
                        // 'AnimatedContainer',
                        // 'AnimatedCrossFade',
                        // 'AnimatedDefaultTextStyle',
                        // 'AnimatedFractionallySizedBox',
                        // 'AnimatedGrid',
                        // 'AnimatedGridState',
                      ],
                      validators: [
                        (Object? value) async {
                          // return 'invalid';
                          // await Future.delayed(const Duration(seconds: 1));
                          if (value is List<LiteDropSelectorItem>) {
                            if (value.any((e) => e.title.contains('Airplane'))) {
                              return 'No planes allowed here';
                            }
                          }
                          return null;
                        }
                      ],
                      serializer: (value) {
                        if (value is List) {
                          return value.map(
                            (e) {
                              if (e is LiteDropSelectorItem) {
                                return e.title;
                              } else if (e is String) {
                                return e;
                              }
                              return null;
                            },
                          ).toList();
                        }
                        return value;
                      },
                      initialValueDeserializer: (value) {
                        return value;
                      },
                    ),
                    // const SizedBox(height: 20.0),
                    LitePasswordField(
                      paddingTop: 20.0,
                      readOnly: false,
                      name: 'password',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      paddingBottom: 20.0,
                      initialValue: 'Qwert123*',
                      settings: PasswordSettings(
                        passwordFieldCheckType: PasswordFieldCheckType.repeatPassword,
                        // validator: (value) async {
                        //   if (value?.isNotEmpty != true) {
                        //     return 'Password cannot be empty';
                        //   }
                        //   return null;
                        // },
                        // requirements: PasswordRequirements.defaultRequirements(),
                        requirements: PasswordRequirements(
                          minLowerCaseLetters: 1,
                          minDigits: 0,
                        ),
                      ),
                    ),
                    LiteDatePicker(
                      readOnly: false,
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
                      validators: [
                        (value) async {
                          // return 'Date is incorrect';
                          return null;
                        },
                      ],
                    ),
                    LiteSwitch(
                      readOnly: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'switch',
                      customLiteToggleBuilder: simpleSquareToggleBuilder,
                      reactionArea: LiteSwitchReactionArea.full,
                      switchPosition: LiteSwitchPosition.left,
                      useMarkdown: true,
                      childPadding: EdgeInsets.only(
                        left: 8.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      text:
                          'Read and accept our [Privacy Policy](https://github.com/caseyryan/flutter_lite_forms)',
                      paddingTop: 20.0,
                      initialValue: false,
                      type: LiteSwitchType.adaptive,
                      validators: [
                        (value) {
                          if (value == false) {
                            return 'You must accept the Privacy Policy';
                          }
                          return null;
                        }
                      ],
                      initialValueDeserializer: (value) {
                        if (value is String) {
                          return value == 'true';
                        }
                        return value;
                      },
                      serializer: (value) {
                        return value == true ? 'Yes' : 'No';
                      },
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (await validateLiteForm(formName)) {
                          final formData = getFormData(
                            formName: formName,
                            applySerializers: true,
                          );
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
                    SizedBox(
                      height: 2000,
                    )
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
