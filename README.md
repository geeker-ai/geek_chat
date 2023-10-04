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

### build and updater

build with [Flutter Distributor](https://distributor.leanflutter.org/docs/getting-started)

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
flutter_distributor release --name release --skip-clean
```

### Deploy
```
brew install p7zip
```
```
pip install pygithub
pip install pyyaml
```

rclone
```
vim .config/rclone/rclone.conf
```
```
[r2]
type = s3
provider = Cloudflare
access_key_id = xxxx
secret_access_key = xxx
endpoint = https://xxxx.r2.cloudflarestorage.com
acl = private
```

```
python script/deploy.py
```

### Docs
- https://isar.dev/zh/recipes/string_ids.html
- https://codewithandrea.com/articles/flutter-responsive-layouts-split-view-drawer-navigation/
- https://flutterawesome.com/
- [Other Plugins](https://github.com/jahnli/awesome-flutter-plugins)
- https://summerscar.me/2020/11/06/flutter-%E9%A1%B9%E7%9B%AE%E4%BD%BF%E7%94%A8-github-actions/

[Flutter cli](https://flutter.cn/docs/reference/flutter-cli)


### Todo

- TODO list
  - [ ] About me page
  - [ ] Prompt Page
  - [ ] Clear session messages
  - [ ] Auto sync
  - [ ] Save as pdf
  - [ ] Mobile: 消息模块 copy, del
  - [ ] 消息模块 code block 美化
  - [ ] 重构 ChatListController，解决 currentSession 空安全
  - [ ] 支付接入 stripe，实现应用内支付
  - [ ] 自动发布版本
  - [ ] 自动更新
  - [ ] 优化Quote功能，类似微信，可以Quote多条消息
  - [ ] APM
  - [ ] 使用统计接入s

- v0.0.47
  - [ ] 宽屏UI：没有创建Chat的时候，右侧显示问题

- v0.0.46
  - [x] 平板上status bar显示问题
  - [x] 在折叠屏上显示宽屏UI
  - [x] Github Action中增加aab打包和包的签名
  - [x] 更换logo

- v0.0.45
  - [x] 简单的关于页面
  - [x] 手机端消息模块美化

- v0.0.44
  - [x] Updater Tips
  - [x] Active account
  - [x] Client UUID
  - [x] Fix: Message Sequence
  - [x] Mobile: Message style


- v0.0.43
  - [x] logging
  - [x] github action: auto build macos package.
  - [x] github action: auto build android package.
  - [x] github action: auto build windows package.
  - [x] Desktop: Message opt for copy, quote and delete etc.
  - [x] Question Input auto focus.
  - [x] auto jump to settings page when need setting.

- v0.0.1
  - [x] Support desktop
  - [x] Support mobile
  - [x] Support OpenAI models