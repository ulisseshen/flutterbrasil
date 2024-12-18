---
ia-translate: true
title: Adicionar Android como plataforma alvo para Flutter a partir do Windows
description: Configure seu sistema Windows para desenvolver aplicativos móveis Flutter para Android.
short-title: Começando do desktop Windows
---

Para adicionar o Android como um alvo de aplicativo Flutter para Windows, siga este procedimento.

## Instalar o Android Studio

1. Alocar um mínimo de 7,5 GB de armazenamento para o Android Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.
2. Instale o [Android Studio][] {{site.appmin.android_studio}} ou posterior
   para depurar e compilar código Java ou Kotlin para Android.
   O Flutter requer a versão completa do Android Studio.

{% include docs/install/compiler/android.md target='desktop' devos='windows' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='Windows' config='WindowsDesktopAndroid' %}

[Android Studio]: https://developer.android.com/studio/install#win
