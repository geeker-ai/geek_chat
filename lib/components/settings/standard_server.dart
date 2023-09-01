import 'package:flutter/material.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:get/get.dart';

class StandardServerSettingsComponent extends StatelessWidget {
  const StandardServerSettingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return GetBuilder<SettingsController>(builder: (controller) {
      return Wrap(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const ListTile(
            title: Text('API Host'),
          ),
          // Padding(padding: paddingOnly())
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 10),
            child: TextFormField(
              initialValue: '',
              decoration: const InputDecoration(
                labelText: 'API Host',
                // errorText: 'Error!',
                // border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 10),
            child: TextFormField(
              initialValue: '',
              decoration: const InputDecoration(labelText: 'API Key'),
            ),
          )
        ],
      );
    });
  }
}
