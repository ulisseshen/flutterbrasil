---
ia-translate: true
title: Comece a construir aplicativos Flutter para Android no macOS
description: Configure seu sistema para desenvolver aplicativos móveis Flutter no macOS e Android.
short-title: Faça aplicativos Android
target: Android
config: macOSAndroid
devos: macOS
next:
  title: Crie seu primeiro aplicativo
  path: /get-started/codelab
---

{% include docs/install/reqs/macos/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='Terminal' %}

{% include docs/install/compiler/android.md devos=devos target=target attempt='first' %}

{% include docs/install/flutter-doctor.md devos=devos target=target config=config %}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
