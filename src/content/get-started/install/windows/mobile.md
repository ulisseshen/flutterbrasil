---
ia-translate: true
title: Comece a construir aplicativos Flutter para Android no Windows
description: Configure seu sistema para desenvolver aplicativos móveis Flutter no Windows.
short-title: Crie aplicativos Android
target: Android
config: WindowsAndroid
devos: Windows
next:
  title: Crie seu primeiro aplicativo
  path: /get-started/codelab
---

{% include docs/install/reqs/windows/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='PowerShell' -%}

{% include docs/install/compiler/android.md devos=devos target=target attempt='first' %}

{% include docs/install/flutter-doctor.md devos=devos target=target config=config %}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
