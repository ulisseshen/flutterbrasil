---
ia-translate: true
title: Comece a construir apps Flutter Android no ChromeOS
description: Configure seu sistema para desenvolver apps Flutter para mobile no ChromeOS e Android.
short-title: Desenvolvimento Android no ChromeOS
target: Android
config: ChromeOSAndroid
devos: ChromeOS
next:
  title: Crie seu primeiro app
  path: /get-started/codelab
---

{% include docs/install/reqs/linux/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='Terminal' %}

{% include docs/install/compiler/android.md devos=devos target=target attempt='first' %}

{% include docs/install/flutter-doctor.md devos=devos target=target config=config %}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
