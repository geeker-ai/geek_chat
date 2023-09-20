# geek_chat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### launch icon
```
flutter pub run flutter_launcher_icons
```

### isar
```
flutter pub run build_runner build
```

### build

build with [Flutter Distributor](https://distributor.leanflutter.org/docs/makers/dmg)

```
dart pub global activate flutter_distributor

export PATH="$PATH":"$HOME/.pub-cache/bin"
```

```
yarn global add appdmg
# or
npm install -g appdmg
```

```
flutter_distributor release --name release
```

### Docs
- https://isar.dev/zh/recipes/string_ids.html
- https://codewithandrea.com/articles/flutter-responsive-layouts-split-view-drawer-navigation/
- https://flutterawesome.com/

[Flutter cli](https://flutter.cn/docs/reference/flutter-cli)


### Todo

- TODO list
  - [ ] About me page
  - [ ] Prompt Page
  - [ ] Clear session messages
  - [ ] Auto sync
  - [ ] Save as pdf
  - [ ] 消息模块 copy, del
  - [ ] 消息模块 code block 美化
  - [ ] 重构 httpRequestWithSSE代码，使用Dio
  - [ ] 重构 ChatListController，解决 currentSession 空安全
  - [ ] 支付接入 stripe，实现应用内支付
  - [ ] 自动发布版本
  - [ ] 自动更新

- v0.0.37
  - [x] logging
  - [x] github action: auto build macos packages.
  - [x] github action: auto build android packages.
  - [ ] Message opt for copy, delete etc.
  - [ ] Updater
  - [ ] Active account

- v0.0.1
  - [x] Support desktop
  - [x] Support mobile
  - [x] Support OpenAI models