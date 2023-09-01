import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LanguageSwitchComponent extends StatelessWidget {
  LanguageSwitchComponent({super.key, required this.tile});

  Widget tile;

  SettingsController settingsController = Get.find<SettingsController>();

  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'en_US', title: 'en_US'),
  ];

  initOptions() {
    // print("init language options ${settingsController.settings.language}");
    options.clear();
    for (var lang in settingsController.locales) {
      options.add(S2Choice<String>(
          value: lang['locale'] ?? '', title: "${lang['name']}".tr));
    }
  }

  // GlobalKey childController = GlobalKey();

  @override
  Widget build(BuildContext context) {
    initOptions();
    return SmartSelect.single(
      // key: childController,
      choiceType: S2ChoiceType.radios,
      selectedValue: settingsController.settings.language,
      modalType: S2ModalType.bottomSheet,
      title: "Language Settings".tr,
      onChange: (value) {
        // await settingsController.setSettingsLanguage(value.value);
        settingsController.settingsLanguage = value.value;
      },
      choiceItems: options,
      tileBuilder: ((context, state) {
        return S2Tile(
            value: const Text('aa'),
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
