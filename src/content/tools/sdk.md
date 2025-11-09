---
ia-translate: true
title: Visão geral do Flutter SDK
shortTitle: Flutter SDK
description: Bibliotecas e ferramentas de linha de comando do Flutter.
---

O Flutter SDK tem os packages e ferramentas de linha de comando necessários para desenvolver
apps Flutter em diferentes plataformas. Para obter o Flutter SDK, veja [Install][Install].

## O que há no Flutter SDK

O seguinte está disponível através do Flutter SDK:

* [Dart SDK][Dart SDK]
* Motor de renderização 2D altamente otimizado, mobile-first com
  excelente suporte para texto
* Framework moderno ao estilo react
* Rico conjunto de widgets implementando Material Design e estilos iOS
* APIs para testes de unidade e integração
* APIs de interoperabilidade e plugin para conectar ao sistema e SDKs de terceiros
* Test runner headless para executar testes no Windows, Linux e Mac
* [Flutter DevTools][Flutter DevTools] para testar, depurar e fazer profiling do seu app
* Ferramentas de linha de comando `flutter` e `dart` para criar, compilar, testar
  e compilar seus apps

Nota: Para mais informações sobre o Flutter SDK, veja seu
[arquivo README][README file].

## Ferramenta de linha de comando `flutter`

A [ferramenta CLI `flutter`][flutter CLI tool] (`flutter/bin/flutter`) é como desenvolvedores
(ou IDEs em nome de desenvolvedores) interagem com o Flutter.

## Ferramenta de linha de comando `dart`

A [ferramenta CLI `dart`][dart CLI tool] está disponível com o Flutter SDK em `flutter/bin/dart`.

[Flutter DevTools]: /tools/devtools
[Dart SDK]: {{site.dart-site}}/tools/sdk
[dart CLI tool]: {{site.dart-site}}/tools/dart-tool
[flutter CLI tool]: /reference/flutter-cli
[Install]: /get-started
[README file]: {{site.repo.flutter}}/blob/main/README.md

## Suporte do SDK para ferramentas de desenvolvedor Flutter

As ferramentas de IDE para Flutter (plugins do Android Studio e Intellij, extensões do
VS Code) suportam versões do Flutter SDK que remontam a dois anos. Isso significa que
embora as ferramentas ainda possam funcionar com SDKs com mais de dois anos, elas
não fornecerão mais correções para problemas específicos dessas versões mais antigas.
