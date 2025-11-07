---
ia-translate: true
title: Adicionar Android como plataforma de destino para Flutter a partir do início Web no ChromeOS
description: Configure seu sistema ChromeOS para desenvolver apps mobile Flutter para Android.
short-title: Partindo do Web no ChromeOS
---

Para adicionar Android como destino de app Flutter para ChromeOS, siga este procedimento.

## Instalar Android Studio

1. Aloque um mínimo de 7.5 GB de armazenamento para o Android Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.

1. Instale os seguintes pacotes pré-requisito para o Android Studio:

    ```console
    $ sudo apt-get install libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64
    ```

1. Instale o [Android Studio][] {{site.appmin.android_studio}} ou posterior
   para depurar e compilar código Java ou Kotlin para Android.
   O Flutter requer a versão completa do Android Studio.

{% include docs/install/compiler/android.md target='linux' devos='ChromeOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='ChromeOS' config='ChromeOSAndroidWeb' %}

[Android Studio]: https://developer.android.com/studio/install#linux
