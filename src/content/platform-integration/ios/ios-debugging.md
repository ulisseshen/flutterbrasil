---
ia-translate: true
title: Debug no iOS
description: Técnicas de debug específicas do iOS para apps Flutter
---

Devido à segurança em torno das
[permissões de rede local no iOS 14 ou posterior][local network permissions in iOS 14 or later],
você deve aceitar uma caixa de diálogo de permissão para habilitar
funcionalidades de debug do Flutter, como hot-reload
e DevTools.

![Screenshot of "allow network connections" dialog](/assets/images/docs/development/device-connect.png)

Isso afeta apenas builds de debug e profile e não
aparecerá em builds de release. Você também pode permitir esta
permissão habilitando
**Settings > Privacy > Local Network > Your App**.

[local network permissions in iOS 14 or later]: {{site.apple-dev}}/news/?id=0oi77447
