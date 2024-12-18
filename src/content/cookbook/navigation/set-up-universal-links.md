---
ia-translate: true
title: Configurar links universais para iOS
description: >-
   Aprenda como configurar links universais para um
   aplicativo iOS construído com Flutter.
---

O deep linking permite que um usuário de aplicativo inicie um aplicativo com um URI.
Este URI contém esquema, host e caminho,
e abre o aplicativo para uma tela específica.

:::note
Você sabia que o Flutter DevTools fornece uma
ferramenta de validação de deep link para Android?
Uma versão iOS da ferramenta está em desenvolvimento.
Saiba mais e veja uma demonstração em [Validar deep links][].
:::

[Validar deep links]: /tools/devtools/deep-links

Um _link universal_, um tipo de deep link exclusivo para dispositivos iOS,
usa apenas os protocolos `http` ou `https`.

Para configurar links universais, você precisa possuir um domínio da web.
Como uma solução temporária,
considere usar o [Firebase Hosting][] ou o [GitHub Pages][].

## Criar ou modificar um aplicativo Flutter

Escreva um aplicativo Flutter que possa lidar com um URL de entrada.

Este exemplo usa o pacote [go_router][] para lidar com o roteamento.
A equipe Flutter mantém o pacote `go_router`.
Ele fornece uma API simples para lidar com cenários de roteamento complexos.

1. Para criar um novo aplicativo, digite `flutter create <nome-do-app>`.

    ```console
    $ flutter create deeplink_cookbook
    ```

2. Para incluir o pacote `go_router` como uma dependência,
   execute `flutter pub add`:

    ```console
    $ flutter pub add go_router
    ```

3. Para lidar com o roteamento, crie um objeto `GoRouter` no arquivo `main.dart`:

    ```dart title="main.dart"
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';
    
    void main() => runApp(MaterialApp.router(routerConfig: router));
    
    /// Isso lida com '/' e '/details'.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Tela Inicial')),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (_, __) => Scaffold(
                appBar: AppBar(title: const Text('Tela de Detalhes')),
              ),
            ),
          ],
        ),
      ],
    );
    ```

## Ajustar as configurações de build do iOS

1. Inicie o Xcode.

1. Abra o arquivo `ios/Runner.xcworkspace` dentro da
   pasta `ios` do projeto Flutter.

  :::note
  Se você estiver usando plugins de terceiros para lidar com deep links,
  como [app_links][],
  o manipulador de deeplink padrão do Flutter
  quebrará esses plugins.

  Se você usa um plugin de terceiros,
  adicione o par chave-valor `FlutterDeepLinkingEnabled` e `NO` ao info.Plist.
  :::

### Adicionar domínios associados

:::warning
Equipes de desenvolvimento pessoal não suportam a funcionalidade de Domínios Associados. Para adicionar domínios associados, escolha a aba IDE.
:::

{% tabs %}
{% tab "Xcode" %}

1. Inicie o Xcode, se necessário.

1. Clique no **Runner** de nível superior.

1. No Editor, clique no alvo **Runner**.

1. Clique em **Signing & Capabilities**.

1. Para adicionar um novo domínio, clique em **+ Capability** em
   **Signing & Capabilities**.

1. Clique em **Associated Domains**.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-associated-domains.png"
      alt="Captura de tela de domínios associados do Xcode"
      width="100%" />

1. Na seção **Associated Domains**, clique em **+**.

1. Insira `applinks:<domínio da web>`. Substitua `<domínio da web>` pelo seu próprio nome de domínio.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Captura de tela de adicionar domínios associados do Xcode"
      width="100%" />

{% endtab %}
{% tab "Outros editores" %}

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

Para verificar se os domínios associados que você criou estão disponíveis,
execute as seguintes etapas:

1. Inicie o Xcode, se necessário.

1. Clique no **Runner** de nível superior.

1. No Editor, clique no alvo **Runner**.

1. Clique em **Signing & Capabilities**.
   Os domínios devem aparecer na
   seção **Associated Domains**.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Captura de tela de adicionar domínios associados do Xcode"
      width="100%" />

{% endtab %}
{% endtabs %}

Você concluiu a configuração do aplicativo para deep linking.

## Associar seu aplicativo ao seu domínio da web

Você precisa hospedar um arquivo `apple-app-site-association` no domínio da web.
Este arquivo informa ao navegador móvel qual
aplicativo iOS abrir em vez do navegador.
Para criar o arquivo, encontre o `appID` do aplicativo Flutter que você
criou na seção anterior.

### Localizar os componentes do `appID`

A Apple formata o `appID` como `<id da equipe>.<id do pacote>`.

* Localize o ID do pacote no projeto Xcode.
* Localize o ID da equipe na [conta de desenvolvedor][].

**Por exemplo:** Dado um ID de equipe de `S8QB4VV633`
e um ID de pacote de `com.example.deeplinkCookbook`,
você inseriria uma entrada `appID` de
`S8QB4VV633.com.example.deeplinkCookbook`.

### Criar e hospedar o arquivo JSON `apple-app-site-association`

Este arquivo usa o formato JSON.
Não inclua a extensão de arquivo `.json` ao salvar este arquivo.
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

1. Defina um valor na matriz `appIDs` como
   `<id da equipe>.<id do pacote>`.

1. Defina a matriz `paths` como `["*"]`.
   A matriz `paths` especifica os links universais permitidos.
   Usando o asterisco, `*` redireciona todos os caminhos para o aplicativo Flutter.
   Se necessário, altere o valor da matriz `paths` para uma configuração mais
   apropriada para seu aplicativo.

1. Hospede o arquivo em um URL que se assemelhe à seguinte estrutura.

   `<domínio da web>/.well-known/apple-app-site-association`

1. Verifique se seu navegador pode acessar este arquivo.

:::note
Se você tiver mais de um esquema/flavor, você pode
adicionar mais de um `appID` no campo `appIDs`.
:::

## Testar o link universal

Teste um link universal usando um dispositivo iOS físico ou o Simulador.

:::note
Pode levar até 24 horas antes que a [Rede de Entrega de Conteúdo][] (CDN) da Apple
solicite o arquivo `apple-app-site-association` (AASA) do seu domínio da web.
Até que a CDN solicite o arquivo, o link universal não funcionará.
Para ignorar a CDN da Apple, consulte a [seção de modo alternativo][].
:::

1. Antes de testar,
   instale o aplicativo Flutter no dispositivo iOS ou Simulador,
   Use `flutter run` no dispositivo desejado.

   <img
       src="/assets/images/docs/cookbook/set-up-universal-links-simulator.png"
       alt="Captura de tela do Simulador"
       width="50%" />

   Quando concluído,
   o aplicativo Flutter é exibido na tela inicial do
   dispositivo iOS ou Simulador.

1. Se você testar usando o Simulador, use o Xcode CLI:

   ```console
   $ xcrun simctl openurl booted https://<domínio da web>/details
   ```

1. Se você testar com um dispositivo iOS físico:

   1. Inicie o aplicativo **Notas**.
   1. Digite o URL no aplicativo **Notas**.
   1. Clique no link resultante.

   Se bem-sucedido, o aplicativo Flutter é iniciado e exibe sua tela de detalhes.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-simulator-deeplinked.png"
      alt="Captura de tela do Simulador com deep link"
      width="50%" />

[Rede de Entrega de Conteúdo]: https://pt.wikipedia.org/wiki/Rede_de_distribui%C3%A7%C3%A3o_de_conte%C3%BAdo

## Encontrar o código-fonte

Você pode encontrar o código-fonte da receita [deeplink_cookbook][]
no repositório do GitHub.

[apple-app-site-assoc]: {{site.apple-dev}}/documentation/xcode/supporting-associated-domains
[seção de modo alternativo]: {{site.apple-dev}}/documentation/bundleresources/entitlements/com_apple_developer_associated-domains?language=objc
[deeplink_cookbook]: {{site.repo.organization}}/codelabs/tree/main/deeplink_cookbook
[conta de desenvolvedor]: {{site.apple-dev}}/account
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub-pkg}}/go_router
[GitHub Pages]: https://pages.github.com
[app_links]: {{site.pub-pkg}}/app_links
