---
ia-translate: true
title: Rede
description: Chamadas de rede de internet no Flutter.
---

## Rede http multiplataforma

O [pacote `http`][`http`] fornece a maneira mais simples de emitir requisições http. Este
pacote é suportado em Android, iOS, macOS, Windows, Linux e web.

## Notas de plataforma

Algumas plataformas exigem etapas adicionais, conforme detalhado abaixo.

### Android

Apps Android devem [declarar seu uso da internet][declare] no
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

Saiba mais sobre [configuração de entitlements][setting up entitlements].

[setting up entitlements]: /platform-integration/macos/building#setting-up-entitlements

## Exemplos

Para um exemplo prático de várias tarefas de rede (incluindo busca de dados,
WebSockets e análise de dados em background) veja o
[cookbook de rede](/cookbook#networking).

[declare]: {{site.android-dev}}/training/basics/network-ops/connecting
[`http`]: {{site.pub-pkg}}/http
