---
ia-translate: true
title: Adicionar macOS como plataforma de destino para Flutter a partir da web
description: Configure seu sistema para desenvolver aplicativos móveis Flutter no macOS.
short-title: Começando da web
---

Para adicionar o macOS como um destino de aplicativo Flutter para macOS, siga este procedimento.

## Instalar Xcode

1. Alocar um mínimo de 26 GB de armazenamento para o Xcode.
   Considere alocar 42 GB de armazenamento para uma configuração ideal.
2. Instale o [Xcode][] {{site.appnow.xcode}} para depurar e compilar código nativo
   Swift ou ObjectiveC.

{% include docs/install/compiler/xcode.md target='macOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='macOS' devos='macOS' config='macOSDesktopWeb' %}

[Xcode]: {{site.apple-dev}}/xcode/
