import 'package:flutter/material.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatMessagePage extends StatelessWidget {
  ChatMessagePage({super.key});

  ChatListController chatListController = Get.find<ChatListController>();

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var data = Get.parameters;
    SessionModel session = chatListController.getSessionBysid(data['sid']);
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatListController>(builder: (controller) {
          return Text(session.name);
        }),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: 15,
              controller: scrollController,
              itemBuilder: (BuildContext ctxt, int index) {
                return const Padding(
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: Card(
                    child: Text(
                        "为了正确理解带状态部件中的 ListView.builder(..)，可以使用带状态 Widget 创建一个非常简"),
                  ),
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            padding:
                const EdgeInsets.only(left: 18, top: 0, right: 18, bottom: 0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
              ),
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 1),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(filled: false),
                          onChanged: (value) {},
                          onSubmitted: (String value) {
                            // onSubmit();
                          },
                          onTap: () {
                            //
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      )),
    );
  }
}
