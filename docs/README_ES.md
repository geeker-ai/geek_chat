# Geek Chat

[English](../README.md) | [简体中文](./README_CN.md)  | [Русский](./README_RU.md) | [日本語](./README_JP.md) | [हिन्दी](./README_HI.md) | [Español](./README_ES.md)

Un útil asistente de inteligencia artificial en su dispositivo.

Geek Chat es un cliente de inteligencia artificial multiplataforma que es compatible con MacOS, Windows, iPhone, iPad, teléfonos Android y tabletas Android.

> Por favor, haga clic en "Destacado" para mostrar su aprecio al autor.

![iOS](https://img.shields.io/badge/-iOS-black?style=flat-square&logo=apple&logoColor=white) ![Android](https://img.shields.io/badge/-Android-black?style=flat-square&logo=android&logoColor=white) ![macOS](https://img.shields.io/badge/-macOS-black?style=flat-square&logo=apple&logoColor=white) ![Windows](https://img.shields.io/badge/-Windows-black?style=flat-square&logo=windows&logoColor=white) ![GitHub all releases](https://img.shields.io/github/downloads/geeker-ai/geek_chat/total)

> iOS, actualmente no está disponible para descargar en la tienda de aplicaciones, por favor, apóyenos comprando GeekChat Server para ayudar a acumular el costo de la cuenta de desarrollador de Apple. ¡Gracias!

<!-- <a title="Hecho con Fluent Design" href="https://github.com/bdlukaa/fluent_ui">
  <img
    src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"
  >
</a> -->
<a title="Logotipo diseñado por Beth Bo" href="https://github.com/bbmm007">Logotipo diseñado por Beth Bo</a>

## Problemas de Instalación
- Windows [solucionar-problemas-de-instalación-de-aplicaciones](https://learn.microsoft.com/zh-cn/windows/msix/app-installer/troubleshoot-appinstaller-issues)
- macOS [Abrir una aplicación de Mac de un desarrollador no identificado](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

## Capturas de Pantalla de Escritorio

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

## Capturas de Pantalla Móviles

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

## Descargar

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

## Características

- Compatible con iPhone, dispositivos Android, iPad, tabletas Android, Windows y MacOS.
- Capacidad mejorada de sugerencias
- Los datos se almacenan de forma segura localmente para proteger la privacidad y mejorar la seguridad.
- Soporta múltiples modelos y proveedores de vanguardia LLM, como OpenAI y Azure OpenAI
- Resaltado de Markdown & Código y Latex
- Biblioteca de sugestiones, Citas de mensajes
- Respuesta en tiempo real
- Diseño ergonómico de la interfaz de usuario y Modo Nocturno
- Proporcionar paquetes de instalación, no se requiere implementación
- Gratuito y de código abierto

## Hoja de Ruta

- [x] Compatibilidad con la API oficial de OpenAI.
- [x] Modo Tema Oscuro/Claro.
- [x] Hablar con mensajes citados.
- [x] Soporte de múltiples idiomas (English, 简体中文, 繁體中文, Русский, 日本語, हिन्दी, Español).
- [x] Biblioteca de Sugerencias
- [x] Compatibilidad con la API de Azure OpenAI
- [x] Soporte de Google Gemini AI
  - [x] Modelo Gemini-pro **con transmisión**
  - [ ] Gemini-pro-vision *próximamente*
- [ ] DALL-E3
  - [x] Crear imagen
  - [ ] Editar imagen creada
  - [ ] Variación de imagen creada
- [x] Soporte del modelo GPT-4-Vision
- [x] Botón de copia para bloques de código
- [ ] Chat con archivos.
- [ ] Chat con URL.
- [ ] Conversación de Voz en Tiempo Real

## Cómo Contribuir

Cualquier forma de contribución es bienvenida, incluyendo pero no limitada a:

- Envío de problemas
- Envío de solicitudes de extracción
- Envío de solicitudes de funciones
- Envío de informes de errores
- Envío de revisiones de documentación
- Envío de traducciones
- Envío de cualquier otra forma de contribución

## Desarrollo

Geek chat se desarrolla utilizando el lenguaje Flutter. Puede ser compilado y empaquetado directamente utilizando el comando flutter. También es compatible con el empaquetado de flutter_distributor.

En cuanto al desarrollo de flutter utilizando vscode y omitir la instalación de android studio, por favor refiérase a este artículo [Instalación manual del entorno de desarrollo de Flutter en MacOS.](https://macgeeker.com/devnotes/macos-flutter/)

El empaquetado de iOS requiere un perfil. Antes de obtener autorización de los desarrolladores de Apple, si necesita empaquetar iOS, por favor empaquételo usted mismo.

```shell
git clone https://github.com/geeker-ai/geek_chat.git
flutter pub get
flutter build ipa
```

## Historial de Estrellas

[![Gráfico de Historial de Estrellas](https://api.star-history.com/svg?repos=geeker-ai/geek_chat&type=Date)](https://star-history.com/#geeker-ai/geek_chat&Date)

## Licencia
[Licencia BSD de 2 cláusulas](./LICENSE)