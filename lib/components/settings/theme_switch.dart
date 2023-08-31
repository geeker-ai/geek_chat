/*
Widget showLangauageSelector() {
  List<S2Choice<int>> frameworks = [
    S2Choice<int>(value: 1, title: 'Ionic'),
    S2Choice<int>(value: 2, title: 'Flutter'),
    S2Choice<int>(value: 3, title: 'React Native'),
  ];
  return SmartSelect.single(
    // selectedValue: languages,
    selectedValue: SettingsController.to.settings.language,
    title: "Language Settings".tr,
    onChange: (value) {
      print(value);
    },
    choiceItems: frameworks,
  );
}
*/
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class ThemeSwitchComponent extends StatelessWidget {
  ThemeSwitchComponent({super.key});

  // List<S2Choice<int>> frameworks = [
  //   S2Choice<int>(value: 1, title: 'Ionic'),
  //   S2Choice<int>(value: 2, title: 'Flutter'),
  //   S2Choice<int>(value: 3, title: 'React Native'),
  // ];
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'ion', title: 'Ionic'),
    S2Choice<String>(value: 'flu', title: 'Flutter'),
    S2Choice<String>(value: 'rea', title: 'React Native'),
  ];

  @override
  Widget build(BuildContext context) {
    return SmartSelect.single(
      choiceType: S2ChoiceType.radios,
      // selectedValue: SettingsController.to.settings.language,
      selectedValue: '',
      modalType: S2ModalType.bottomSheet,
      title: "Theme Settings".tr,
      onChange: (value) {
        print(value);
      },
      choiceItems: options,
    );
  }
}
