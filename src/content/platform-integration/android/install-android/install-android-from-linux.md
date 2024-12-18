---
ia-translate: true
title: Adicione o Android como plataforma alvo para Flutter partindo do Linux
description: Configure seu Mac para desenvolver aplicativos móveis Flutter para Android.
short-title: Começando a partir do desktop Linux
---

Para adicionar o Android como um alvo de aplicativo Flutter para Linux, siga este procedimento.

## Instale o Android Studio

1. Aloque um mínimo de 7,5 GB de armazenamento para o Android Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.

1. Instale os seguintes pacotes de pré-requisito para o Android Studio:

    ```console
    $ sudo apt-get install libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64
    ```

1. Instale o [Android Studio][] {{site.appmin.android_studio}} ou mais recente
   para depurar e compilar código Java ou Kotlin para Android.
   O Flutter requer a versão completa do Android Studio.

{% include docs/install/compiler/android.md target='linux' devos='Linux' attempt='first' %}

{% include docs/install/flutter-doctor.md target='Android' devos='Linux' config='LinuxDesktopAndroid' %}

[Android Studio]: https://developer.android.com/studio/install#linux
