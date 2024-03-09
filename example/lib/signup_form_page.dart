// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:example/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_timeout/lite_timeout.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_timer_controller.dart';
import 'package:lite_forms/lite_forms.dart';

class SignupFormPage extends StatelessWidget {
  const SignupFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    const formName = 'signupForm';

    return Scaffold(
      appBar: AppBar(),
      body: LiteForm(
        /// autoDispose: false will store the form
        /// (despite that the LiteFormGroup might be disposed of) until
        /// you call clearForm from anywhere
        /// passing 'signupForm' key there
        /// this might come useful if you create a multipage onboarding
        /// and want to send the accumulated data to the backend in the end
        autoDispose: false,
        allowUnfocusOnTapOutside: true,
        name: formName,
        builder: (c, scrollController) {
          return CustomScrollView(
            controller: scrollController,
            cacheExtent: 3000.0,
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

                      LiteDropSelector(
                        initialValue: LiteDropSelectorItem(
                          title: 'I have a 24-word long secret phrase',
                          payload: 24,
                        ),
                        paddingBottom: 12,
                        paddingTop: 12,
                        settings: const DropSelectorSettings(
                          dropSelectorType: DropSelectorType.menu,
                          dropSelectorActionType: DropSelectorActionType.simple,
                          maxMenuWidth: double.infinity,
                        ),
                        name: 'phraseLengthDropSelector',
                        items: [
                          LiteDropSelectorItem(
                            title: 'I have a 24-word long secret phrase',
                            payload: 24,
                          ),
                          LiteDropSelectorItem(
                            title: 'I have a 18-word long secret phrase',
                            payload: 18,
                          ),
                          LiteDropSelectorItem(
                            title: 'I have a 12-word long secret phrase',
                            payload: 12,
                          ),
                        ],
                      ),

                      // LiteDatePicker(
                      //   paddingTop: 20.0,
                      //   readOnly: false,
                      //   textAlign: TextAlign.center,
                      //   dateInputType: DateInputType.both,
                      //   name: 'dateOfBirth',

                      //   /// notice that you can pass DateTime object here or
                      //   /// a String representation of a date. Both cases
                      //   /// will be processed by initialValueDeserializer below
                      //   /// and the LiteDatePicker will get a valid DateTime
                      //   /// object as an input
                      //   // initialValue: DateTime.now(),
                      //   initialValue: DateTime.now().toIso8601String(),
                      //   pickerType: LiteDatePickerType.material,
                      //   autovalidateMode: AutovalidateMode.disabled,
                      //   validators: [
                      //     // LiteValidator.dateOfBirth(
                      //     //   minAgeYears: 18,
                      //     // ),
                      //   ],
                      //   initialValueDeserializer: (value) {
                      //     if (value is DateTime) {
                      //       return value;
                      //     }
                      //     if (value is String) {
                      //       return DateTime.tryParse(value);
                      //     }
                      //     return value;
                      //   },
                      // ),
                      Row(
                        children: [
                          LiteFilePicker(
                            key: Key('image'),
                            name: 'image',
                            width: 250.0,
                            height: 145.0,
                            // aspectRatio: 4.0 / 3.0,
                            paddingTop: 20.0,
                            paddingRight: 10.0,
                            serializer: LiteSerializers.filesToMapList,
                            sources: [
                              FileSource.camera,
                              FileSource.gallery,
                            ],
                            validators: [
                              LiteValidator.alwaysComplaining(),
                            ],
                            // constraints: BoxConstraints(
                            //   maxWidth: 180.0,
                            //   maxHeight: 100.0,
                            // ),
                          ),
                          // LiteFilePicker(
                          //   key: Key('image2'),
                          //   name: 'image2',
                          //   aspectRatio: 6.0 / 4.0,
                          //   imageSpacing: 3.0,
                          //   validators: [
                          //     LiteValidator.required(),
                          //     FileSizeValidator(
                          //       maxSize: FileSize(
                          //         megaBytes: 3,
                          //         kiloBytes: 0,
                          //       ),
                          //     )
                          //   ],
                          //   paddingTop: 20.0,
                          //   allowImages: true,
                          //   allowVideo: true,
                          //   autovalidateMode: AutovalidateMode.onUserInteraction,
                          //   maxFiles: 4,
                          //   paddingRight: 10.0,
                          //   serializer: LiteSerializers.filesToMapList,
                          //   constraints: BoxConstraints(
                          //     maxWidth: 220.0,
                          //     maxHeight: 200.0,
                          //   ),
                          // ),
                        ],
                      ),
                      // LiteTextFormField(
                      //   readOnly: false,
                      //   paddingTop: 20.0,
                      //   maxLines: 1,
                      //   textEntryType: LiteTextEntryType.normal,
                      //   useSmoothError: true,
                      //   name: 'login',
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
                      // const SizedBox(height: 600.0),
                      // LiteCountrySelector(
                      //   readOnly: false,
                      //   name: 'countries',
                      //   paddingTop: 20.0,
                      //   initialValue: 'italy',
                      //   serializer: (value) {
                      //     if (value is List) {
                      //       return value.map((e) => e.payload.name).toList();
                      //     }
                      //     return value;
                      //   },
                      //   dropSelectorType: LiteDropSelectorViewType.menu,
                      // ),
                      // LitePhoneInputField(
                      //   name: 'phone',
                      //   readOnly: false,
                      //   paddingTop: 20.0,
                      //   paddingBottom: 20.0,
                      //   initialValue: '+79517773344',
                      //   phoneCountries: [
                      //     CountryData.find('RU')!,
                      //     CountryData.find('US')!,
                      //   ],
                      //   // defaultCountry: 'russia',
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   // phoneInputType: LitePhoneInputType.autodetectCode,
                      //   phoneInputType: LitePhoneInputType.manualCode,
                      //   serializer: LiteSerializers.phoneDataToFormattedString,
                      //   // serializer: LiteSerializers.phoneDataToUnformattedString,
                      //   // serializer: LiteSerializers.fullPhoneDataWithCountry,
                      //   validators: [
                      //     LiteValidator.phone(),
                      //   ],
                      // ),

                      // LitePhoneInputField(
                      //   name: 'phone2',
                      //   readOnly: false,
                      //   paddingTop: 20.0,
                      //   paddingBottom: 20.0,
                      //   initialValue: '+79517773344',

                      //   // defaultCountry: 'russia',
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   phoneInputType: LitePhoneInputType.autodetectCode,
                      //   // phoneInputType: LitePhoneInputType.manualCode,
                      //   serializer: LiteSerializers.phoneDataToFormattedString,
                      //   validators: [
                      //     // LiteValidator.alwaysComplaining(),
                      //     LiteValidator.phone(),
                      //   ],
                      // ),
                      LiteTimeout(
                        name: 'timer',
                        seconds: 15,
                        autostart: false,
                        onTimeoutUpdate: (secondsLeft) {
                          print('secondsLeft $secondsLeft');
                        },
                      ),
                      LiteDropSelector(
                        paddingTop: 20.0,
                        readOnly: false,
                        name: 'classes',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        menuItemBuilder: (index, item, isLast) {
                          return SizedBox(
                            width: double.infinity,
                            height: 60.0,
                          );
                        },
                        settings: DropSelectorSettings(
                          bottomLeftRadius: 10.0,
                          bottomRightRadius: 10.0,
                          topLeftRadius: 10.0,
                          topRightRadius: 10.0,
                          dropSelectorType: DropSelectorType.menu,
                          // dropSelectorType: LiteDropSelectorViewType.bottomsheet,
                          // dropSelectorActionType: LiteDropSelectorActionType.multiselect,
                          // dropSelectorActionType: LiteDropSelectorActionType.singleSelect,
                          dropSelectorActionType: DropSelectorActionType.multiselect,
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
                        selectorViewBuilder: (
                          context,
                          selectedItems,
                          String? error,
                        ) {
                          print('ERROR: $error');
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                color: Colors.red,
                              ),
                            ],
                          );
                        },
                        initialValue: ['airplane mode'],
                        validators: [
                          LiteValidator.alwaysComplaining(
                            delayMilliseconds: 2000,
                          ),
                        ],
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
                      //   paddingTop: 20.0,
                      //   readOnly: false,
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

                      // LiteSwitch(
                      //   readOnly: false,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   name: 'switch',
                      //   customLiteToggleBuilder: simpleSquareToggleBuilder,
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
                      //     LiteValidator.required(),
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
                            final formData = await getFormData(
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
                      MaterialButton(
                        onPressed: () async {
                          form('signupForm').focusNextField();
                        },
                        child: Text('Next Focus'),
                      ),
                      // const SizedBox(
                      //   height: 1500,
                      // ),
                      SizedBox(height: 20.0),
                      LiteTextFormField(
                        name: 'multiline',
                        maxLines: 4,
                      ),
                      SizedBox(height: 20.0),
                      MaterialButton(
                        onPressed: () async {
                          final value = await form('signupForm').field('phone').get(true);
                          // print(value);
                          // form('signupForm.phone').phone.set(
                          //       '(999) 444 6677',
                          //       country: CountryData.find('GB'),
                          //     );
                          form('signupForm').phone('phone2').set('+44 (999) 444 6677');
                        },
                        child: Text('Set Phone'),
                      ),

                      MaterialButton(
                        onPressed: () async {
                          liteTimerController.resetTimerByName(timerName: 'timer', groupName: formName, numSeconds: 40);
                        },
                        child: Text('Reset Timer'),
                      ),

                      MaterialButton(
                        onPressed: () async {
                          // liteTimerController.startTimerByName(
                          //   timerName: 'timer',
                          //   groupName: formName,
                          // );
                          // final isActive = form('$formName.timer').timer.isActive;
                          // print(isActive);
                          form(formName).timer('timer').start();
                          form(formName).focus('phone2');
                        },
                        child: Text('Start Timer'),
                      ),
                      SizedBox(
                        height: 2000,
                      )
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
