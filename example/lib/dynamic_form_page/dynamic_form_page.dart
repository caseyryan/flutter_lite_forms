// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

import 'dynamic_form_controller.dart';

class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({super.key});

  @override
  State<DynamicFormPage> createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  final DynamicFormController _controller = DynamicFormController();

  @override
  Widget build(BuildContext context) {
    const formName = 'dynamicForm';
    return LiteState<DynamicFormController>(
      controller: _controller,
      builder: (BuildContext c, DynamicFormController controller) {
        return Scaffold(
          appBar: AppBar(),
          body: LiteFormGroup(
            autoDispose: false,
            allowUnfocusOnTapOutside: false,
            name: formName,
            builder: (c, scrollController) {
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          LiteSwitch(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            name: 'usePhone',
                            label: 'Privacy Policy',
                            reactionArea: LiteSwitchReactionArea.full,
                            switchPosition: LiteSwitchPosition.left,
                            useMarkdown: true,
                            childPadding: EdgeInsets.only(
                              left: 8.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            onChanged: controller.onPhoneUseChange,
                            text: 'Use phone',
                            paddingTop: 20.0,
                            initialValue: false,
                            type: LiteSwitchType.adaptive,
                          ),
                          Row(
                            children: [
                              LiteFilePicker(
                                name: 'profileImage',
                                aspectRatio: 4.0 / 3.0,
                                paddingTop: 20.0,
                                paddingRight: 10.0,
                                serializer: LiteSerializers.filesToMapList,
                                sources: [
                                  FileSource.camera,
                                  FileSource.gallery,
                                ],
                                constraints: BoxConstraints(
                                  maxWidth: 180.0,
                                  maxHeight: 100.0,
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
                            initialValue: 'Konstantin',
                            initialValueDeserializer: (value) {
                              if (value is String) {
                                return value;
                              }
                              return value.toString();
                            },
                            autovalidateMode: AutovalidateMode.always,
                          ),
                          // // const SizedBox(height: 600.0),
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
                          if (controller.isWithPhone)
                            LitePhoneInputField(
                              name: 'phone',
                              readOnly: false,
                              paddingTop: 20.0,
                              paddingBottom: 20.0,
                              initialValue: '+79517773344',
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              // phoneInputType: LitePhoneInputType.autodetectCode,
                              phoneInputType: LitePhoneInputType.manualCode,
                              serializer: LiteSerializers.phoneDataToFormattedString,
                              validators: [
                                LiteValidator.phone(),
                              ],
                            ),
                          LiteDropSelector(
                            paddingTop: 20.0,
                            readOnly: false,
                            name: 'settings',
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            dropSelectorType: LiteDropSelectorViewType.menu,
                            dropSelectorActionType:
                                LiteDropSelectorActionType.multiselect,
                            settings: LiteDropSelectorSettings(
                              bottomLeftRadius: 10.0,
                              bottomRightRadius: 10.0,
                              topLeftRadius: 10.0,
                              topRightRadius: 10.0,
                              sheetPadding: EdgeInsets.all(12.0),
                              menuSearchConfiguration: MenuSearchConfiguration(
                                searchFieldVisibility: SearchFieldVisibility.always,
                              ),
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
                          LiteDatePicker(
                            paddingTop: 20.0,
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
                            initialValue: DateTime(2000).toIso8601String(),
                            // pickerType: LiteDatePickerType.material,
                            autovalidateMode: AutovalidateMode.disabled,
                            validators: [
                              LiteValidator.dateOfBirth(
                                minAgeYears: 18,
                              ),
                            ],
                            initialValueDeserializer: (value) {
                              if (value is DateTime) {
                                return value;
                              }
                              if (value is String) {
                                return DateTime.tryParse(value);
                              }
                              return value;
                            },
                          ),

                          // LiteSwitch(
                          //   readOnly: false,
                          //   autovalidateMode: AutovalidateMode.onUserInteraction,
                          //   name: 'policy',
                          //   label: 'Privacy Policy',
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
                          //     LiteValidator.required(
                          //         errorText: 'You must accept our Privacy Policy'),
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
                          // const SizedBox(height: 1500,),
                          MaterialButton(
                            onPressed: () async {
                              if (await validateLiteForm(formName)) {
                                final formData = await getFormData(
                                  formName: formName,
                                  applySerializers: true,
                                );

                                // final dob = getValue('$formName.dateOfBirth');
                                // print(dob);
                                if (kDebugMode) {
                                  print(formData);
                                }
                              }
                            },
                            child: Text('Print Form Data'),
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
      },
    );
  }
}
