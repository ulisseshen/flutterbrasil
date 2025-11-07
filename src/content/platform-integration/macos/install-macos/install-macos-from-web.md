---
ia-translate: true
title: Adicionar macOS como plataforma de destino para Flutter partindo da web
description: Configure seu sistema para desenvolver apps Flutter mobile no macOS.
short-title: Partindo da web
---

Para adicionar macOS como destino de app Flutter no macOS, siga este procedimento.

## Instalar Xcode

1. Aloque um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
1. Instale o [Xcode][] {{site.appnow.xcode}} para debugar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='macOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='macOS' devos='macOS' config='macOSDesktopWeb' %}

[Xcode]: {{site.apple-dev}}/xcode/
