---
ia-translate: true
title: Adicionar iOS como plataforma de destino a partir do início no Android
description: Configure seu sistema para desenvolver aplicativos móveis Flutter também no iOS.
short-title: Começando pelo Android
---

Para adicionar o iOS como um alvo de aplicativo Flutter para macOS, siga este procedimento.

## Instalar o Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
2. Instale o [Xcode][] {{site.appnow.xcode}} para depurar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='iOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='iOS' devos='macOS' config='macOSAndroidiOS' %}

[Xcode]: {{site.apple-dev}}/xcode/
