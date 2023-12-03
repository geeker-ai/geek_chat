# Geek Chat

[English](../README.md) | 简体中文 | [Русский](./README_RU.md)

您设备上一个有用的AI副驾驶。

Geek Chat是一个跨平台的AI客户端，支持MacOS、Windows、iPhone、iPad、Android手机和Android平板。


![iOS](https://img.shields.io/badge/-iOS-black?style=flat-square&logo=apple&logoColor=white) ![Android](https://img.shields.io/badge/-Android-black?style=flat-square&logo=android&logoColor=white) ![macOS](https://img.shields.io/badge/-macOS-black?style=flat-square&logo=apple&logoColor=white) ![Windows](https://img.shields.io/badge/-Windows-black?style=flat-square&logo=windows&logoColor=white) ![GitHub all releases](https://img.shields.io/github/downloads/geeker-ai/geek_chat/total)

## 安装建议
- Windows [troubleshoot-appinstaller-issues](https://learn.microsoft.com/zh-cn/windows/msix/app-installer/troubleshoot-appinstaller-issues)
- macOS [Open a Mac app from an unidentified developer](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

## 桌面端截图

<table>
  <tr>
    <td>
      <img src='./assets/screenshots/screenshot1.png' />
    </td>
    <td>
      <img src='./assets/screenshots/screenshot2.png' />
    </td>
  </tr>
</table>

## 手机端截图

<table>
  <tr style="height: 40px">
    <td>
      <img src='./assets/screenshots/screenshot3.jpeg' />
    </td>
    <td>
      <img src='./assets/screenshots/screenshot4.jpeg' />
    </td>
    <td>
      <img src='./assets/screenshots/screenshot5.jpeg' />
    </td>
    <td>
      <img src='./assets/screenshots/screenshot6.jpeg' />
    </td>
  </tr>
</table>

## 下载

<table>
  <tr>
    <td style="text-align:center"><b>Android</b></td>
    <td style="text-align:center"><b>MacOS</b></td>
    <td style="text-align:center"><b>Windows</b></td>
  </tr>
  <tr style="text-align: center">
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='./assets/android-color.svg' style="height:14px; width: 14px" />
        <b>APK</b>
      </a>
    </td>
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='./assets/apple-color.svg' style="height:15px; width: 15px" />
        <b>DMG</b>
      </a>
    </td>
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='./assets/windows10-color.svg' style="height:14px; width: 14px" />
        <b>Windows</b>
      </a>
    </td>
  </tr>
</table>

## 特性

- 支持 iPhone、Android 手机、iPad、Android 平板、Windows 和 MacOS。
- 增强提示能力。
- 数据存储在本地，不会丢失。
- 支持多个先进的 LLM 模型和服务提供商，如 OpenAI 和 Azure OpenAI。
- Markdown 和代码高亮以及 Latex。
- 提示库，消息引用。
- 流式回复。
- 人体工程学 UI 设计和夜间模式。
- 提供安装包，无需部署。
- 免费和开源。

## 进展

- [x] 与OpenAI官方API兼容。
- [x] 可以引用消息进行对话。
- [x] 提示词库
- [x] 与Azure OpenAI API兼容
- [ ] 代码块的复制按钮
- [ ] 可以与文件进行对话。
- [ ] DALL-E3。
- [ ] 可以与URL进行对话。

## 如何贡献

欢迎任何形式的贡献，包括但不限于：

- 提交问题。
- 提交拉取请求。
- 提交功能请求。
- 提交错误报告。
- 提交文档修订。
- 提交翻译。
- 提交任何其他形式的贡献。

## 开发

Geek Chat是使用Flutter语言开发的。可以使用flutter命令直接编译和打包它。它还支持使用flutter_distributor进行打包。

关于使用VSCode进行Flutter开发并跳过安装Android Studio，请参考这篇文章。 [在MacOS上手动安装Flutter开发环境](https://macgeeker.com/devnotes/macos-flutter/)

iOS打包需要一个配置文件。在我获得苹果开发者的授权之前，如果您需要打包iOS，请自行打包。

```
git clone https://github.com/geeker-ai/geek_chat.git
flutter pub get
flutter build ipa
```

## 星标历史

[![星标历史图](https://api.star-history.com/svg?repos=geeker-ai/geek_chat&type=Date)](https://star-history.com/#geeker-ai/geek_chat&Date)

## 许可证
[BSD 2-Clause License](./LICENSE)
