# Geek Chat

[English](../README.md) | [简体中文](./README_CN.md) | [Русский](./README_RU.md) | [日本語]

あなたのデバイスの便利なAIコパイロット。

Geek ChatはクロスプラットフォームのAIクライアントで、MacOS、Windows、iPhone、iPad、Android携帯電話、およびAndroidタブレットをサポートしています。

> 作者への励ましを示すために、"Starred"をクリックしてください。

![iOS](https://img.shields.io/badge/-iOS-black?style=flat-square&logo=apple&logoColor=white) ![Android](https://img.shields.io/badge/-Android-black?style=flat-square&logo=android&logoColor=white) ![macOS](https://img.shields.io/badge/-macOS-black?style=flat-square&logo=apple&logoColor=white) ![Windows](https://img.shields.io/badge/-Windows-black?style=flat-square&logo=windows&logoColor=white) ![GitHub all releases](https://img.shields.io/github/downloads/geeker-ai/geek_chat/total)

> iOSは現在アプリストアでダウンロードできません。Appleの開発者アカウントの費用を積み立てるために、GeekChat Serverを購入していただけると助かります。ありがとうございます。

## インストールの提案
- Windows [トラブルシューティングAppInstallerの問題](https://learn.microsoft.com/zh-cn/windows/msix/app-installer/troubleshoot-appinstaller-issues)
- macOS [未確認の開発元のMacアプリを開く](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

## デスクトップスクリーンショット

<table>
  <tr>
    <td>
      <img src='../assets/screenshots/screenshot1.png' />
    </td>
    <td>
      <img src='../assets/screenshots/screenshot2.png' />
    </td>
  </tr>
</table>

## モバイルスクリーンショット

<table>
  <tr style="height: 40px">
    <td>
      <img src='../assets/screenshots/screenshot3.jpeg' />
    </td>
    <td>
      <img src='../assets/screenshots/screenshot4.jpeg' />
    </td>
    <td>
      <img src='../assets/screenshots/screenshot5.jpeg' />
    </td>
    <td>
      <img src='../assets/screenshots/screenshot6.jpeg' />
    </td>
  </tr>
</table>

## ダウンロード

<table>
  <tr>
    <td style="text-align:center"><b>Android</b></td>
    <td style="text-align:center"><b>MacOS</b></td>
    <td style="text-align:center"><b>Windows</b></td>
  </tr>
  <tr style="text-align: center">
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='../assets/android-color.svg' style="height:14px; width: 14px" />
        <b>APK</b>
      </a>
    </td>
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='../assets/apple-color.svg' style="height:15px; width: 15px" />
        <b>DMG</b>
      </a>
    </td>
    <td>
      <a href='https://github.com/geeker-ai/geek_chat/releases'>
        <img src='../assets/windows10-color.svg' style="height:14px; width: 14px" />
        <b>Windows</b>
      </a>
    </td>
  </tr>
</table>

## 特長

- iPhone、Android携帯電話、iPad、Androidタブレット、Windows、およびMacOSをサポート。
- 強化されたヒント機能。
- データはローカルに保存され、失われることはありません。
- OpenAIやAzure OpenAIのような多数の先進的なLLMモデルやサービスプロバイダーをサポート。
- Markdownやコードハイライト、およびLaTeXサポート。
- ヒントライブラリ、メッセージ引用。
- ストリーミング応答。
- エルゴノミクスに配慮したUIデザインとナイトモード。
- インストールパッケージを提供し、デプロイ不要。
- 無料かつオープンソース。

## 進捗

- [x] OpenAI公式APIと互換性あり。
- [x] メッセージを引用して会話できる。
- [x] 多言語サポート (English, 简体中文, 繁體中文, Русский) 。
- [x] ヒントワードライブラリ
- [x] Azure OpenAI APIと互換性あり
- [x] Google Gemini AI をサポート
  - [x] Gemini-pro モデル  **With Stream**
  - [x] Gemini-pro-vision *近日公開*
- [ ] DALL-E3
  - [x] 画像を作成する
  - [ ] 画像編集を作成する
  - [ ] 画像の変化を作成する
- [x] GPT-4-Vision モデルをサポート
- [x] コードブロックのコピー機能
- [ ] ファイルとの会話が可能
- [ ] URLとの会話が可能

## コントリビューションの方法

以下に示す形式を含む、あらゆる形式の貢献を歓迎します。

- 問題を提出する。
- プルリクエストを提出する。
- 機能リクエストを提出する。
- エラーレポートを提出する。
- ドキュメントの修正を提出する。
- 翻訳を提出する。
- その他の形式の貢献を提出する。

## 開発

Geek ChatはFlutter言語を使用して開発されています。flutterコマンドを使用して直接ビルドおよびパッケージ化することができます。flutter_distributorを使用することもできます。

Android Studioのインストールをスキップして、VSCodeを使用してFlutter開発を行う方法については、この記事を参照してください。[MacOSでFlutter開発環境を手動でインストールする](https://macgeeker.com/devnotes/macos-flutter/)

iOSのパッケージングには構成ファイルが必要です。iOSをパッケージングする場合は、Appleの開発者許可を取得するまで、自分でパッケージングする必要があります。

```
git clone https://github.com/geeker-ai/geek_chat.git
flutter pub get
flutter build ipa
```

## スターヒストリー

[![スターヒストリー](https://api.star-history.com/svg?repos=geeker-ai/geek_chat&type=Date)](https://star-history.com/#geeker-ai/geek_chat&Date)

## ライセンス
[BSD 2-Clause License](./LICENSE)