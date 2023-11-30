class BottomSwitcherOption {
  BottomSwitcherOption({
    required this.id,
    required this.name,
    required this.additionalText,
    required this.disabled,
  });
  String id;
  String name;
  String additionalText;
  bool disabled;
}

class GroupedBottomSwitcherOption {
  GroupedBottomSwitcherOption(
      {required this.groupName, required this.groupDesc});
  String groupName;
  String groupDesc;
  List<BottomSwitcherOption> options = [];
}
