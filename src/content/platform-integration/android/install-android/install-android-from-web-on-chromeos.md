---
ia-translate: true
title: Adicione Android como plataforma alvo para Flutter a partir da Web no ChromeOS
description: Configure seu sistema ChromeOS para desenvolver aplicativos móveis Flutter para Android.
short-title: Começando da Web no ChromeOS
---

Para adicionar Android como um alvo de aplicativo Flutter para ChromeOS, siga este procedimento.

## Instalar o Android Studio

1. Aloque um mínimo de 7,5 GB de armazenamento para o Android Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.

1. Instale os seguintes pacotes pré-requisitos para o Android Studio:

    ```console
    $ sudo apt-get install libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64
    ```

1. Instale o [Android Studio][] {{site.appmin.android_studio}} ou posterior
   para depurar e compilar código Java ou Kotlin para Android.
   O Flutter requer a versão completa do Android Studio.

{% include docs/install/compiler/android.md target='linux' devos='ChromeOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='ChromeOS' config='ChromeOSAndroidWeb' %}

[Android Studio]: https://developer.android.com/studio/install#linux
