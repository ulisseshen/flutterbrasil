---
ia-translate: true
title: Depuração iOS
description: Técnicas de depuração específicas para iOS em apps Flutter
---

Devido à segurança em torno das
[permissões de rede local no iOS 14 ou posterior][local network permissions in iOS 14 or later],
você deve aceitar uma caixa de diálogo de permissão para habilitar
funcionalidades de depuração do Flutter, como hot-reload
e DevTools.

![Screenshot of "allow network connections" dialog](/assets/images/docs/development/device-connect.png)

Isso afeta apenas compilações debug e profile e não
aparecerá em compilações release. Você também pode permitir esta
permissão habilitando
**Settings > Privacy > Local Network > Your App**.

[local network permissions in iOS 14 or later]: {{site.apple-dev}}/news/?id=0oi77447
