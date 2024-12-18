---
ia-translate: true
title: Depuração no iOS
description: Técnicas de depuração específicas do iOS para aplicativos Flutter
---

Devido à segurança em torno das
[permissões de rede local no iOS 14 ou posterior][],
você deve aceitar uma caixa de diálogo de permissão para habilitar
funcionalidades de depuração do Flutter, como hot-reload
e DevTools.

![Captura de tela da caixa de diálogo "permitir conexões de rede"](/assets/images/docs/development/device-connect.png)

Isso afeta apenas builds de depuração e perfil e não
aparecerá em builds de lançamento. Você também pode permitir esta
permissão habilitando
**Ajustes > Privacidade > Rede Local > Seu Aplicativo**.

[permissões de rede local no iOS 14 ou posterior]: {{site.apple-dev}}/news/?id=0oi77447
