---
ia-translate: true
title: Networking
description: Chamadas de rede pela Internet no Flutter.
---

## Networking http cross-platform

O pacote [`http`][] oferece a maneira mais simples de emitir requisições http. Este
pacote é suportado em Android, iOS, macOS, Windows, Linux e web.

## Notas sobre Plataformas

Algumas plataformas exigem etapas adicionais, conforme detalhado abaixo.

### Android

Aplicativos Android devem [declarar seu uso da internet][declare] no manifesto do
Android (`AndroidManifest.xml`):

```xml
<manifest xmlns:android...>
 ...
 <uses-permission android:name="android.permission.INTERNET" />
 <application ...
</manifest>
```

### macOS

Aplicativos macOS devem permitir acesso à rede nos arquivos `*.entitlements` relevantes.

```xml
<key>com.apple.security.network.client</key>
<true/>
```

Saiba mais sobre [como configurar entitlements][].

[como configurar entitlements]: /platform-integration/macos/building#setting-up-entitlements

## Exemplos

Para um exemplo prático de várias tarefas de networking (incluindo busca de dados,
WebSockets e análise de dados em segundo plano), consulte o
[cookbook de networking](/cookbook#networking).

[declare]: {{site.android-dev}}/training/basics/network-ops/connecting
[`http`]: {{site.pub-pkg}}/http
