---
ia-translate: true
title: Adicione macOS como plataforma alvo para Flutter a partir do Android
description: Configure seu sistema para desenvolver aplicativos móveis Flutter também no macOS.
short-title: Começando do Android
---

Para adicionar o desktop macOS como um alvo de aplicativo Flutter, siga este procedimento.

## Instale o Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração
   ótima.
2. Instale o [Xcode][] {{site.appnow.xcode}} para depurar e compilar
   código nativo Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='macOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='macOS' devos='macOS' config='macOSDesktopAndroid' %}

[Xcode]: {{site.apple-dev}}/xcode/
