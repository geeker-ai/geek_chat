import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ApiServerSwitchComponent extends StatelessWidget {
  ApiServerSwitchComponent({super.key});

  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'openai', title: 'OpenAI'),
    S2Choice<String>(value: 'geekerchat', title: 'Geeker Chat'),
  ];

  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    options.clear();
    for (var item in settingsController.serverList) {
      options.add(S2Choice(value: item['id'] ?? '', title: item['name']));
    }

    return SmartSelect.single(
      choiceType: S2ChoiceType.radios,
      selectedValue: settingsController.settings.provider,
      modalType: S2ModalType.bottomSheet,
      title: "API Server Settings".tr,
      onChange: (value) {
        settingsController.settings.provider = value.value;
        settingsController.update();
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
              left: 0.0, top: 0.0, right: 20.0, bottom: 0),
          onTap: () {
            state.showModal();
          },
          title: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "API Server Settings".tr,
                ),
                Text(settingsController.getProviderServer()),
              ],
            ),
            leading: const Icon(Icons.computer_outlined),
          ),
        );
      }),
    );
  }
}
