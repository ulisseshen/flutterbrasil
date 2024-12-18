---
ia-translate: true
title: Conexões HTTP inseguras são desabilitadas por padrão no iOS e Android
description: >
  Acessar uma URL com protocolo HTTP lança uma exceção a menos que o
  domínio seja explicitamente permitido pela política.
---

## Resumo

Se seu código tentar abrir uma conexão HTTP para um host no iOS ou Android,
uma `StateException` agora será lançada com a seguinte mensagem:

```plaintext
HTTP inseguro não é permitido pela plataforma: <host>
```

Use HTTPS em vez disso.

:::important
Essa mudança restringiu excessivamente o acesso HTTP em redes locais,
além das restrições impostas pelas plataformas móveis
([flutter/flutter#72723]({{site.repo.flutter}}/issues/72723)).

Essa mudança foi revertida desde então.
:::

## Contexto

Começando com o Android [API 28][] e [iOS 9][],
essas plataformas desabilitam conexões HTTP inseguras por padrão.

Com essa mudança, o Flutter também desabilita conexões inseguras em
plataformas móveis. Outras plataformas (desktop, web, etc) não são
afetadas.

Você pode substituir esse comportamento seguindo as diretrizes
específicas da plataforma para definir uma política de rede
específica do domínio. Veja o guia de migração abaixo para
detalhes.

[API 28]: {{site.android-dev}}/training/articles/security-config#CleartextTrafficPermitted
[iOS 9]: {{site.apple-dev}}/documentation/bundleresources/information_property_list/nsapptransportsecurity

Assim como as plataformas, o aplicativo ainda pode abrir conexões de socket
inseguras. O Flutter não impõe nenhuma política em nível de socket;
você seria responsável por proteger a conexão.

## Guia de migração

No iOS, você pode adicionar [NSExceptionDomains][] ao Info.plist do seu
aplicativo.

No Android, você pode adicionar um XML de [configuração de segurança de
rede][]. Para que o Flutter encontre seu arquivo XML, você também
precisa adicionar uma entrada `metadata` à tag `<application>` no
seu manifesto. Essa entrada de metadados deve ter o nome:
`io.flutter.network-policy` e deve conter o identificador de
recurso do XML.

Por exemplo, se você colocar sua configuração XML em
`res/xml/network_security_config.xml`, seu manifesto
conteria o seguinte:

```xml
<application ...>
  ...
  <meta-data android:name="io.flutter.network-policy"
             android:resource="@xml/network_security_config"/>
</application>
```

### Permitindo conexão cleartext para builds de debug

Se você quiser permitir conexões HTTP para builds de debug do
Android, você pode adicionar o seguinte snippet ao seu
$project_path\android\app\src\debug\AndroidManifest.xml:

```xml
<application android:usesCleartextTraffic="true"/>
```

Para iOS, você pode seguir [estas instruções](/add-to-app/ios/project-setup/?tab=embed-using-cocoapods#set-local-network-privacy-permissions) para criar um `Info-debug.plist` e colocar isto nele:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Nós **não** recomendamos que você faça isso para seus builds de release.

## Informação Adicional

* A configuração em tempo de build é a única maneira de alterar a
  política de rede. Ela não pode ser modificada em tempo de execução.
* Conexões localhost são sempre permitidas.
* Você pode permitir conexões inseguras apenas para domínios.
  Endereços IP específicos não são aceitos como entrada.
  Isso está alinhado com o que as plataformas suportam. Se você quiser
  permitir endereços IP, a única opção é permitir conexões cleartext
  em seu aplicativo.

[network security config]: {{site.android-dev}}/training/articles/security-config#CleartextTrafficPermitted
[NSExceptionDomains]: {{site.apple-dev}}/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsexceptiondomains

## Linha do tempo

Implementado na versão: 1.23<br>
Na versão estável: 2.0.0<br>
Revertido na versão: 2.2.0 (proposta)

## Referências

Documentação da API: Não há API para esta mudança, uma vez que a
modificação na política de rede é feita através da configuração
específica da plataforma, conforme detalhado acima.

PRs relevantes:

* [PR 20218: Plumbing para configuração da política de rede por domínio][]
* [Introduzir política por domínio para conexões seguras estritas][]

[PR 20218: Plumbing para configuração da política de rede por domínio]: {{site.repo.engine}}/pull/20218
[Introduzir política por domínio para conexões seguras estritas]: {{site.github}}/dart-lang/sdk/commit/d878cfbf20375befa09f9bf85f0ba2b87b319427

