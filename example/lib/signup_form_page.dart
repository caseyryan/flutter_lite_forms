// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector_enum.dart';
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
                    // LiteSearchField(
                    //   paddingTop: 20.0,
                    //   onSearch: (value) {
                    //     if (kDebugMode) {
                    //       print('Searching for: $value');
                    //     }
                    //   },
                    //   settings: LiteSearchFieldSettings(
                    //     searchTriggerType: SearchTriggerType.automatic,
                    //     iconPosition: LiteSearchFieldIconPosition.left,
                    //   ),
                    // ),
                    // LiteTextFormField(
                    //   paddingTop: 20.0,
                    //   maxLines: 1,
                    //   textEntryType: LiteTextEntryType.normal,
                    //   useSmoothError: true,
                    //   name: 'login',
                    //   validators: [
                    //     (value) async {
                    //       if (value?.toString().isNotEmpty != true) {
                    //         return 'Login cannot be empty';
                    //       }
                    //       return null;
                    //     },
                    //   ],
                    //   onChanged: (value) {
                    //     if (kDebugMode) {
                    //       print('VALUE: $value');
                    //     }
                    //   },
                    //   initialValue: 'Konstantin',
                    //   initialValueDeserializer: (value) {
                    //     if (value is String) {
                    //       return value;
                    //     }
                    //     return value.toString();
                    //   },
                    //   serializer: (value) {
                    //     return 'Mr. $value';
                    //   },
                    //   autovalidateMode: AutovalidateMode.always,
                    // ),
                    const SizedBox(height: 300.0),
                    // const SizedBox(height: 20.0),
                    LiteDropSelector(
                      name: 'classes',
                      initialValue: [
                        'ActivateIntent',
                        // 'Alignment',
                      ],
                      // menuItemBuilder: (index, item, isLast) {
                      //   return Container(
                      //     height: 40.0,
                      //     width: 300.0,
                      //     color: Colors.red,
                      //   );
                      // },
                      // dropSelectorType: LiteDropSelectorViewType.adaptive,
                      // menuItemBuilder: (index, item, isSelected) {
                      //   return Container(
                      //     width: 200.0,
                      //     height: 60.0,
                      //     color: Colors.red.withOpacity(index / 10.0),
                      //   );
                      // },
                      dropSelectorType: LiteDropSelectorViewType.menu,
                      // dropSelectorActionType: LiteDropSelectorActionType.multiselect,
                      // dropSelectorActionType: LiteDropSelectorActionType.singleSelect,
                      dropSelectorActionType: LiteDropSelectorActionType.simple,
                      settings: LiteDropSelectorSheetSettings(
                        // veilColor: Colors.red,
                        bottomLeftRadius: 10.0,
                        padding: EdgeInsets.all(8.0),
                        menuSearchConfiguration: MenuSearchConfiguration(
                          searchFieldVisibility: SearchFieldVisibility.adaptive,
                        ),
                        // buttonHeight: 40.0
                      ),
                      items: [
                        LiteDropSelectorItem(
                          title: 'Airplane Mode',
                          payload: 'airplane mode',
                          iconBuilder: (context, item, isSelected) {
                            if (isSelected) {
                              return Icon(
                                Icons.airplanemode_active,
                                color: Colors.green,
                              );
                            }
                            return Icon(
                              Icons.airplanemode_inactive,
                              color: Colors.red,
                            );
                          },
                        ),
                        LiteDropSelectorItem(
                          title: 'Notifications',
                          payload: 'notifications',
                          iconBuilder: (context, item, isSelected) {
                            if (isSelected) {
                              return Icon(
                                Icons.notifications_active,
                                color: Colors.lightGreen,
                              );
                            }
                            return Icon(
                              Icons.notifications_off,
                              color: Colors.orange,
                            );
                          },
                        ),
                      ],

                      // items: [
                      //   'ActivateIntent',
                      //   'Align',
                      //   'Alignment',
                      //   'AlignmentDirectional',
                      //   'AlignmentGeometry',
                      //   'AlignmentGeometryTween',
                      //   'AlignmentTween',
                      //   'AlignTransition',
                      //   'AlwaysScrollableScrollPhysics',
                      //   'AlwaysStoppedAnimation',
                      //   'AndroidView',
                      //   'AndroidViewSurface',
                      //   'Animatable',
                      //   'AnimatedAlign',
                      //   'AnimatedBuilder',
                      //   'AnimatedContainer',
                      //   'AnimatedCrossFade',
                      //   'AnimatedDefaultTextStyle',
                      //   'AnimatedFractionallySizedBox',
                      //   'AnimatedGrid',
                      //   'AnimatedGridState',
                      // ],
                      validators: [
                        (value) {
                          if (value == null) {
                            return 'Gender must be selected';
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
                    // LitePasswordField(
                    //   name: 'password',
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   paddingBottom: 20.0,
                    //   initialValue: 'Qwert123*',
                    //   settings: PasswordSettings(
                    //     passwordFieldCheckType: PasswordFieldCheckType.repeatPassword,
                    //     // validator: (value) async {
                    //     //   if (value?.isNotEmpty != true) {
                    //     //     return 'Password cannot be empty';
                    //     //   }
                    //     //   return null;
                    //     // },
                    //     // requirements: PasswordRequirements.defaultRequirements(),
                    //     requirements: PasswordRequirements(
                    //       minLowerCaseLetters: 1,
                    //       minDigits: 0,
                    //     ),
                    //   ),
                    // ),
                    // LiteDatePicker(
                    //     textAlign: TextAlign.center,
                    //     dateInputType: DateInputType.both,
                    //     name: 'dateOfBirth',

                    //     /// notice that you can pass DateTime object here or
                    //     /// a String representation of a date. Both cases
                    //     /// will be processed by initialValueDeserializer below
                    //     /// and the LiteDatePicker will get a valid DateTime
                    //     /// object as an input
                    //     // initialValue: DateTime.now(),
                    //     initialValue: DateTime.now().toIso8601String(),
                    //     pickerType: LiteDatePickerType.material,
                    //     autovalidateMode: AutovalidateMode.disabled,
                    //     initialValueDeserializer: (value) {
                    //       if (value is DateTime) {
                    //         return value;
                    //       }
                    //       if (value is String) {
                    //         return DateTime.tryParse(value);
                    //       }
                    //       return value;
                    //     },
                    //     validators: [
                    //       (value) async {
                    //         // return 'Date is incorrect';
                    //         return null;
                    //       },
                    //     ]),
                    // LiteSwitch(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   name: 'switch',
                    //   // customLiteToggleBuilder: simpleSquareToggleBuilder,
                    //   reactionArea: LiteSwitchReactionArea.full,
                    //   switchPosition: LiteSwitchPosition.left,
                    //   useMarkdown: true,
                    //   childPadding: EdgeInsets.only(
                    //     left: 8.0,
                    //     top: 10.0,
                    //     bottom: 10.0,
                    //   ),
                    //   text:
                    //       'Read and accept our [Privacy Policy](https://github.com/caseyryan/flutter_lite_forms)',
                    //   paddingTop: 20.0,
                    //   initialValue: false,
                    //   type: LiteSwitchType.adaptive,
                    //   validators: [
                    //     (value) {
                    //       if (value == false) {
                    //         return 'You must accept the Privacy Policy';
                    //       }
                    //       return null;
                    //     }
                    //   ],
                    //   initialValueDeserializer: (value) {
                    //     if (value is String) {
                    //       return value == 'true';
                    //     }
                    //     return value;
                    //   },
                    //   serializer: (value) {
                    //     return value == true ? 'Yes' : 'No';
                    //   },
                    // ),
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
