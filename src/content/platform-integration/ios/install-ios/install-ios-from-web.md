---
ia-translate: true
title: Adicionar iOS como plataforma de destino partindo da web
description: Configure seu sistema para desenvolver apps Flutter mobile no iOS.
short-title: Partindo da web
---

Para adicionar iOS como destino de app Flutter no macOS, siga este procedimento.

## Instalar Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
1. Instale o [Xcode][] {{site.appnow.xcode}} para debugar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='iOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='iOS' devos='macOS' config='macOSiOSWeb' %}

[Xcode]: {{site.apple-dev}}/xcode/
