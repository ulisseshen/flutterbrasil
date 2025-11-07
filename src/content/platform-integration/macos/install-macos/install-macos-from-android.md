---
ia-translate: true
title: Adicionar macOS como plataforma de destino para Flutter partindo do Android
description: Configure seu sistema para desenvolver apps Flutter mobile também no macOS.
short-title: Partindo do Android
---

Para adicionar macOS desktop como destino de app Flutter, siga este procedimento.

## Instalar Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
1. Instale o [Xcode][] {{site.appnow.xcode}} para debugar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='macOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='macOS' devos='macOS' config='macOSDesktopAndroid' %}

[Xcode]: {{site.apple-dev}}/xcode/
