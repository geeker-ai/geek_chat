class MessageModel {
  String msgId;
  String? sId;
  String? model;
  String role;
  String content;
  int? updated;
  bool? generating;
  int? msgType; // 1=new, 2=refresh
  bool? synced;
  int? status; // 1 = show, 2=delete

  MessageModel(
      {required this.msgId, required this.role, required this.content});
  // factory MessageModel.fromMessageTable() {
  //   return MessageModel();
  // }
}
