---
ia-translate: true
title: Networking
description: Chamadas de rede pela internet no Flutter.
---

## Networking http multiplataforma

O pacote [`http`][] fornece a maneira mais simples de fazer requisições http. Este
pacote tem suporte em Android, iOS, macOS, Windows, Linux e web.

## Notas sobre plataformas

Algumas plataformas requerem etapas adicionais, conforme detalhado abaixo.

### Android

Apps Android devem [declarar o uso da internet][declare] no
manifesto Android (`AndroidManifest.xml`):

```xml
<manifest xmlns:android...>
 ...
 <uses-permission android:name="android.permission.INTERNET" />
 <application ...
</manifest>
```

### macOS

Apps macOS devem permitir acesso à rede nos arquivos `*.entitlements` relevantes.

```xml
<key>com.apple.security.network.client</key>
<true/>
```

Saiba mais sobre [configurar entitlements][setting up entitlements].

[setting up entitlements]: /platform-integration/macos/building#setting-up-entitlements

## Exemplos

Para um exemplo prático de várias tarefas de networking (incluindo busca de dados,
WebSockets e análise de dados em segundo plano), veja as
[receitas do cookbook de networking](/cookbook/networking).

[declare]: {{site.android-dev}}/training/basics/network-ops/connecting
[`http`]: {{site.pub-pkg}}/http
