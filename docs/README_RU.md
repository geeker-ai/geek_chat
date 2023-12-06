# Geek Chat

[English](../README.md) | [简体中文](./README_CN.md) | Русский | [日本語](./README_JP.md)

Полезный AI-помощник на вашем устройстве.

Geek Chat - это кросс-платформенный AI-клиент, поддерживающий MacOS, Windows, iPhone, iPad, Android-телефон и планшет.

> Пожалуйста, нажмите "Звезда" для выражения своей благодарности автору.

![iOS](https://img.shields.io/badge/-iOS-black?style=flat-square&logo=apple&logoColor=white) ![Android](https://img.shields.io/badge/-Android-black?style=flat-square&logo=android&logoColor=white) ![macOS](https://img.shields.io/badge/-macOS-black?style=flat-square&logo=apple&logoColor=white) ![Windows](https://img.shields.io/badge/-Windows-black?style=flat-square&logo=windows&logoColor=white) ![GitHub все загрузки](https://img.shields.io/github/downloads/geeker-ai/geek_chat/total)

<!-- <a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui">
  <img
    src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"
  >
</a> -->
<a title="Логотип разработан Бет Бо" href="https://github.com/bbmm007">Логотип разработан Бет Бо</a>

## Проблемы установки

- Windows [решение проблемы с установщиком приложений](https://learn.microsoft.com/zh-cn/windows/msix/app-installer/troubleshoot-appinstaller-issues)
- MacOS [Открытие приложения Mac от неизвестного разработчика](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

## Снимки экрана рабочего стола

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

## Снимки экрана мобильных устройств

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

## Загрузка

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

## Особенности

- Совместим с iPhone, Android-устройствами, iPad, Android-планшетами, Windows и MacOS.
- Улучшенная способность предложения
- Данные безопасно хранятся локально для защиты конфиденциальности и повышения безопасности.
- Поддерживает несколько передовых моделей LLM и поставщиков, таких как OpenAI и Azure OpenAI
- Markdown & подсветка кода & LaTeX
- Библиотека предложений, цитирование сообщений
- Потоковый ответ
- Эргономичный дизайн интерфейса и ночной режим
- Предоставление установочных пакетов, не требуется развертывание
- Бесплатное и открытое программное обеспечение

## План развития

- [x] Совместимость с официальным API OpenAI.
- [x] Темный/Светлый режим темы.
- [x] Общение с цитированными сообщениями.
- [x] Поддержка нескольких языков (английский, 简体中文, 繁體中文, Русский).
- [x] Библиотека предложений
- [x] Совместимость с API Azure OpenAI
- [ ] Кнопка копирования для блоков кода
- [ ] Чат с файлами.
- [ ] DALL-E3
- [ ] Чат с URL-адресами.

## Как внести свой вклад

Любая форма вклада приветствуется, включая, но не ограничиваясь следующим:

- Подача проблем
- Подача запросов на перенос
- Подача запросов функций
- Подача отчетов об ошибках
- Подача исправлений документации
- Подача переводов
- Подача любых других форм вклада

## Разработка

Geek chat разрабатывается с использованием языка flutter. Он может быть скомпилирован и упакован непосредственно с использованием команды flutter. Также поддерживается упаковка flutter_distributor.

Что касается разработки flutter с использованием vscode и пропуска установки android studio, обратитесь к этой статье [Ручная установка среды разработки Flutter на MacOS.](https://macgeeker.com/devnotes/macos-flutter/)

Для упаковки iOS требуется профиль. Прежде чем я получу авторизацию от разработчиков Apple, если вам нужно упаковать iOS, пожалуйста, упакуйте его самостоятельно.

```
git clone https://github.com/geeker-ai/geek_chat.git
flutter pub get
flutter build ipa
```

## История звезд

[![График истории звезд](https://api.star-history.com/svg?repos=geeker-ai/geek_chat&type=Date)](https://star-history.com/#geeker-ai/geek_chat&Date)

## Лицензия
[BSD 2-Clause License](./LICENSE)