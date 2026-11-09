---
title: Conexões HTTP inseguras são desabilitadas por padrão no iOS e no Android
description: >
  Acessar uma URL com o protocolo HTTP lança uma exceção, a menos que
  o domínio seja explicitamente permitido pela política.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Se o seu código tentar abrir uma conexão HTTP com um host
no iOS ou no Android, agora é lançado um `StateException` com
a seguinte mensagem:

```plaintext
Insecure HTTP is not allowed by platform: <host>
```

Use HTTPS no lugar.

## Contexto {:#context}

A partir do Android [API 28][] e do [iOS 9][],
essas plataformas desabilitam conexões HTTP inseguras por padrão.

Com essa mudança, o Flutter também desabilita conexões inseguras em
plataformas móveis. Outras plataformas (desktop, web etc.)
não são afetadas.

Você pode sobrescrever esse comportamento seguindo as
diretrizes específicas de cada plataforma para definir uma
política de rede por domínio. Consulte o guia de migração
abaixo para mais detalhes.

[API 28]: {{site.android-dev}}/training/articles/security-config#CleartextTrafficPermitted
[iOS 9]: {{site.apple-dev}}/documentation/bundleresources/information_property_list/nsapptransportsecurity

:::important
O que segue se aplica somente a sockets nativos da plataforma (sockets
pertencentes ao Android e ao iOS).

O Flutter não impõe nenhuma política no nível de socket; você é
responsável por proteger a conexão. Se o socket pertencer ao
Dart/Flutter, nenhuma política será aplicada.
:::

## Guia de migração {:#migration-guide}

No iOS, você pode adicionar [NSExceptionDomains][] ao
Info.plist do seu app.

No Android, você pode adicionar um XML de [configuração de segurança de rede][network security config].

### Permitindo conexão sem criptografia em builds de debug {:#allowing-cleartext-connection-for-debug-builds}

Se você quiser permitir conexões HTTP em builds de debug do Android,
pode adicionar o seguinte trecho em $project_path\android\app\src\debug\AndroidManifest.xml:

```xml
<application android:networkSecurityConfig="@xml/network_security_config">
  ...
</application>
```

Em seguida, adicione a configuração de rede em $project_path/android/app/src/debug/res/xml/network_security_config.xml:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

Também é possível definir a política por domínio. Consulte a
documentação do Android para mais informações.

No iOS, você pode seguir [estas instruções][these instructions] para criar um `Info-debug.plist`
e incluí-lo:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**Não** recomendamos que você faça isso nas builds de release.

## Informações adicionais {:#additional-information}

* A configuração em tempo de build é a única forma de
  alterar a política de rede. Ela não pode ser modificada em tempo de execução.

[network security config]: {{site.android-dev}}/training/articles/security-config#CleartextTrafficPermitted
[NSExceptionDomains]: {{site.apple-dev}}/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsexceptiondomains

## Linha do tempo {:#timeline}

Incluído na versão: 1.23<br>
Na versão estável: 2.0.0<br>
Revertido na versão: 2.2.0 (proposto)

## Referências {:#references}

Documentação da API: não há API para esta mudança, pois a alteração
da política de rede é feita pela configuração específica de cada
plataforma, conforme detalhado acima.

PRs relevantes:

* [PR 20218: Infraestrutura para definir a política de rede por domínio][PR 20218: Plumbing for setting domain network policy]
* [Introduzir política por domínio para conexões seguras estritas][Introduce per-domain policy for strict secure connections]

[PR 20218: Plumbing for setting domain network policy]: {{site.repo.engine}}/pull/20218
[Introduce per-domain policy for strict secure connections]: {{site.repo.dart-sdk}}/commit/d878cfbf20375befa09f9bf85f0ba2b87b319427
[these instructions]: /add-to-app/ios/project-setup#local-network-permissions
