---
ia-translate: true
title: Adicionar iOS como plataforma de destino partindo do Android
description: Configure seu sistema para desenvolver apps Flutter mobile também no iOS.
short-title: Partindo do Android
---

Para adicionar iOS como destino de app Flutter no macOS, siga este procedimento.

## Instalar Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
1. Instale o [Xcode][] {{site.appnow.xcode}} para debugar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='iOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='iOS' devos='macOS' config='macOSAndroidiOS' %}

[Xcode]: {{site.apple-dev}}/xcode/
