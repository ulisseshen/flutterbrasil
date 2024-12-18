---
ia-translate: true
title: Adicione Android como plataforma de destino para Flutter a partir do início no iOS
description: Configure seu Mac para desenvolver aplicativos móveis Flutter para Android.
short-title: Começando do iOS no macOS
---

Para adicionar o Android como um alvo de aplicativo Flutter para iOS, siga este procedimento.

## Instalar o Android Studio

1. Aloque um mínimo de 7,5 GB de armazenamento para o Android Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.
2. Instale o [Android Studio][] {{site.appmin.android_studio}} ou posterior
   para depurar e compilar código Java ou Kotlin para Android.
   O Flutter requer a versão completa do Android Studio.

{% include docs/install/compiler/android.md target='macos' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='macOS' config='macOSDesktopAndroid' %}

[Android Studio]: https://developer.android.com/studio/install#mac
