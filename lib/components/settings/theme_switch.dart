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
import 'package:geek_chat/models/theme.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ThemeSwitchComponent extends StatelessWidget {
  Widget tile = const Text('');
  ThemeSwitchComponent({super.key, required this.tile}) {}

  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'ion', title: 'Ionic'),
    S2Choice<String>(value: 'flu', title: 'Flutter'),
    S2Choice<String>(value: 'rea', title: 'React Native'),
  ];

  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    // init theme
    options.clear();
    for (GCThemeMode theme in settingsController.themeModes) {
      options.add(S2Choice<String>(value: theme.name, title: theme.name.tr));
    }

    return SmartSelect.single(
      choiceType: S2ChoiceType.radios,
      selectedValue: settingsController.settings.theme,
      modalType: S2ModalType.bottomSheet,
      title: "Theme Settings".tr,
      onChange: (value) {
        settingsController.settingsTheme = value.value;
      },
      choiceItems: options,
      tileBuilder: ((context, state) {
        return S2Tile(
            value: const Text(''),
            isTwoLine: true,
            dense: true,
            hideValue: true,
            trailing: const Icon(Icons.chevron_right_outlined),
            padding: const EdgeInsets.only(
                left: 0.0, top: 0.0, right: 18.0, bottom: 0),
            onTap: () {
              state.showModal();
            },
            title: tile);
      }),
    );
  }
}
