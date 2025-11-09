---
ia-translate: true
title: Configurar universal links para iOS
description: >-
   Aprenda como configurar universal links para uma
   aplicação iOS construída com Flutter.
---

Deep linking permite que um usuário de app abra um app com uma URI.
Esta URI contém esquema, host e caminho,
e abre o app em uma tela específica.

Um _universal link_, um tipo de deep link exclusivo para dispositivos iOS,
usa apenas os protocolos `http` ou `https`.

Para configurar universal links, você precisa possuir um domínio web.
Como uma solução temporária,
considere usar [Firebase Hosting][] ou [GitHub Pages][].

Uma vez que você configurou seus deep links, você pode validá-los.
Para aprender mais, veja [Validate deep links][].

## Criar ou modificar um app Flutter

Escreva um app Flutter que possa lidar com uma URL de entrada.

Este exemplo usa o pacote [go_router][] para lidar com o roteamento.
A equipe Flutter mantém o pacote `go_router`.
Ele fornece uma API simples para lidar com cenários de roteamento complexos.

1. Para criar uma nova aplicação, digite `flutter create <app-name>`.

    ```console
    $ flutter create deeplink_cookbook
    ```

2. Para incluir o pacote `go_router` como dependência,
   execute `flutter pub add`:

    ```console
    $ flutter pub add go_router
    ```

3. Para lidar com o roteamento, crie um objeto `GoRouter` no arquivo `main.dart`:

    ```dart title="main.dart"
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';

    void main() => runApp(MaterialApp.router(routerConfig: router));

    /// This handles '/' and '/details'.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            appBar: AppBar(title: const Text('Home Screen')),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (_, _) => Scaffold(
                appBar: AppBar(title: const Text('Details Screen')),
              ),
            ),
          ],
        ),
      ],
    );
    ```

## Ajustar configurações de build do iOS

1. Abra o Xcode.

1. Abra o arquivo `ios/Runner.xcworkspace` dentro da
   pasta `ios` do projeto Flutter.

   :::version-note
   Se você usa uma versão do Flutter anterior a 3.27,
   você precisa optar manualmente pelo deep linking adicionando o
   par chave e valor `FlutterDeepLinkingEnabled` e `YES` ao `info.Plist`.
   :::

   :::note
   Se você está usando plugins de terceiros para lidar com deep links,
   como [app_links][],
   o handler de deeplink padrão do Flutter irá
   quebrar esses plugins.

   Se você usa um plugin de terceiros, adicione o
   par chave e valor `FlutterDeepLinkingEnabled` e `NO` ao `info.Plist`.
   :::

### Adicionar domínios associados

:::warning
Equipes de desenvolvimento pessoal não suportam a capacidade de
Associated Domains. Para adicionar domínios associados, escolha a aba IDE.
:::

<Tabs key="darwin-editors">
<Tab name="Xcode">

1. Abra o Xcode se necessário.

1. Clique no **Runner** de nível superior.

1. No Editor, clique no target **Runner**.

1. Clique em **Signing & Capabilities**.

1. Para adicionar um novo domínio, clique em **+ Capability** em
   **Signing & Capabilities**.

1. Clique em **Associated Domains**.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-associated-domains.png"
      alt="Xcode associated domains screenshot"
      width="100%" />

1. Na seção **Associated Domains**, clique em **+**.

1. Digite `applinks:<web domain>`. Substitua `<web domain>` pelo seu próprio nome de domínio.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Xcode add associated domains screenshot"
      width="100%" />

</Tab>
<Tab name="Other editors">

1. Abra o arquivo XML `ios/Runner/Runner.entitlements` no seu editor preferido.

1. Adicione um domínio associado dentro da tag `<dict>`.

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     [!<key>com.apple.developer.associated-domains</key>!]
     [!<array>!]
       [!<string>applinks:example.com</string>!]
     [!</array>!]
   </dict>
   </plist>
   ```

1. Salve o arquivo `ios/Runner/Runner.entitlements`.

Para verificar que os domínios associados que você criou estão disponíveis,
execute os seguintes passos:

1. Abra o Xcode se necessário.

1. Clique no **Runner** de nível superior.

1. No Editor, clique no target **Runner**.

1. Clique em **Signing & Capabilities**.
   Os domínios devem aparecer na
   seção **Associated Domains**.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Xcode add associated domains screenshot"
      width="100%" />

</Tab>
</Tabs>

Você terminou de configurar a aplicação para deep linking.

## Associar seu app com seu domínio web

Você precisa hospedar um arquivo `apple-app-site-association` no domínio web.
Este arquivo informa ao navegador móvel qual
aplicação iOS abrir em vez do navegador.
Para criar o arquivo, encontre o `appID` do app Flutter que você
criou na seção anterior.

### Localizar componentes do `appID`

Apple formata o `appID` como `<team id>.<bundle id>`.

* Localize o bundle ID no projeto Xcode.
* Localize o team ID na [developer account][].

**Por exemplo:** Dado um team ID de `S8QB4VV633`
e um bundle ID de `com.example.deeplinkCookbook`,
você digitaria uma entrada `appID` de
`S8QB4VV633.com.example.deeplinkCookbook`.

### Criar e hospedar arquivo JSON `apple-app-site-association`

Este arquivo usa o formato JSON.
Não inclua a extensão de arquivo `.json` quando você salvar este arquivo.
De acordo com a [documentação da Apple][apple-app-site-assoc],
este arquivo deve se parecer com o seguinte conteúdo:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": [
          "S8QB4VV633.com.example.deeplinkCookbook"
        ],
        "paths": [
          "*"
        ],
        "components": [
          {
            "/": "/*"
          }
        ]
      }
    ]
  },
  "webcredentials": {
    "apps": [
      "S8QB4VV633.com.example.deeplinkCookbook"
    ]
  }
}
```

1. Defina um valor no array `appIDs` para
   `<team id>.<bundle id>`.

1. Defina o array `paths` para `["*"]`.
   O array `paths` especifica os universal links permitidos.
   Usando o asterisco, `*` redireciona cada caminho para o app Flutter.
   Se necessário, mude o valor do array `paths` para uma configuração mais
   apropriada ao seu app.

1. Hospede o arquivo em uma URL que se assemelhe à seguinte estrutura.

   `<webdomain>/.well-known/apple-app-site-association`

1. Verifique se seu navegador pode acessar este arquivo.

:::note
Se você tem mais de um scheme/flavor, você pode
adicionar mais de um `appID` no campo `appIDs`.
:::

## Testar o universal link

Teste um universal link usando um dispositivo iOS físico ou o Simulator.

:::note
Pode levar até 24 horas antes que a [Content Delivery Network][] (CDN) da Apple
solicite o arquivo `apple-app-site-association` (AASA) do seu domínio web.
Até que a CDN solicite o arquivo, o universal link não funcionará.
Para contornar a CDN da Apple, confira a [alternate mode section][].
:::

1. Antes de testar,
   instale o app Flutter no dispositivo iOS ou Simulator,
   Use `flutter run` no dispositivo desejado.

   <img
       src="/assets/images/docs/cookbook/set-up-universal-links-simulator.png"
       alt="Simulator screenshot"
       width="50%" />

   Quando completo,
   o app Flutter é exibido na tela inicial do
   dispositivo iOS ou Simulator.

1. Se você testa usando o Simulator, use a CLI do Xcode:

   ```console
   $ xcrun simctl openurl booted https://<web domain>/details
   ```

1. Se você testa com um dispositivo iOS físico:

   1. Abra o app **Note**.
   1. Digite a URL no app **Note**.
   1. Clique no link resultante.

   Se bem-sucedido, o app Flutter abre e exibe sua tela de detalhes.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-simulator-deeplinked.png"
      alt="Deeplinked Simulator screenshot"
      width="50%" />

[Content Delivery Network]: https://en.wikipedia.org/wiki/Content_delivery_network

## Encontrar o código-fonte

Você pode encontrar o código-fonte para a receita [deeplink_cookbook][]
no repositório GitHub.

[apple-app-site-assoc]: {{site.apple-dev}}/documentation/xcode/supporting-associated-domains
[alternate mode section]: {{site.apple-dev}}/documentation/bundleresources/entitlements/com_apple_developer_associated-domains?language=objc
[deeplink_cookbook]: {{site.repo.organization}}/codelabs/tree/main/deeplink_cookbook
[developer account]: {{site.apple-dev}}/account
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub-pkg}}/go_router
[GitHub Pages]: https://pages.github.com
[app_links]: {{site.pub-pkg}}/app_links
[Validate deep links]: /tools/devtools/deep-links
