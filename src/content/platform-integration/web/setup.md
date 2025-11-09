---
ia-translate: true
title: Configurar desenvolvimento web
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, compilar e fazer deploy de apps Flutter para a plataforma web.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, compilar e fazer deploy de apps Flutter para a plataforma web.

:::note
Se você ainda não configurou o Flutter,
visite e siga o guia [Começando com Flutter][Get started with Flutter] primeiro.

Se você já instalou o Flutter,
certifique-se de que ele está [atualizado][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Instalar um navegador web {: #install}

Para executar e depurar seu app Flutter na web,
[baixe e instale o Google Chrome][chrome-install]
ou [instale e use o Microsoft Edge][edge-install].

<details>
<summary>Expandir para instruções de outros navegadores</summary>

Se você quiser depurar seu app em outros navegadores web,
você pode usar o comando `flutter run -d web-server`,
e navegar manualmente para a URL especificada em seu navegador preferido.

Observe que o suporte de depuração no modo `web-server` é limitado.

</details>


[chrome-install]: https://www.google.com/chrome/
[edge-install]: https://www.microsoft.com/edge

## Validar sua configuração {: #validate-setup}

Para garantir que você instalou o navegador com sucesso,
e que o Flutter pode encontrá-lo,
execute `flutter devices` em seu terminal preferido.

Você deve ver pelo menos um dispositivo conectado rotulado
**Chrome (web)** ou **Edge (web)**, semelhante ao seguinte:

```console highlightLines=4
$ flutter devices

Found 1 connected devices:
  Chrome (web)    • chrome • web-javascript • Google Chrome
```

Se o comando não for encontrado, ou você não ver o Chrome listado,
confira [Solução de problemas de configuração][troubleshoot].

[troubleshoot]: /install/troubleshoot

## Começar a desenvolver para a web {: #start-developing}

Agora que você configurou o desenvolvimento web para Flutter,
você pode continuar sua jornada de aprendizado Flutter testando na web
ou começar a expandir a integração com a web.

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash helping you explore Flutter learning resources.">
    </div>
    <div class="card-header">
      <span class="card-title">Continue learning Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/get-started/codelab">Write your first app</a>
        </li>
        <li>
          <a class="text-button" href="/get-started/fundamentals">Learn the fundamentals</a>
        </li>
        <li>
          <a class="text-button" href="https://www.youtube.com/watch?v=b_sQ9bMltGU&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Explore Flutter widgets</a>
        </li>
        <li>
          <a class="text-button" href="/reference/learning-resources">Check out samples</a>
        </li>
        <li>
          <a class="text-button" href="/resources/bootstrap-into-dart">Learn about Dart</a>
        </li>
      </ul>
    </div>
  </div>
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/flutter-on-phone.svg" height="160" aria-hidden="true" alt="A representation of Flutter on multiple devices.">
    </div>
    <div class="card-header">
      <span class="card-title">Build for the web</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/platform-integration/web/building">Build a web app with Flutter</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/web/initialization">Customize app initialization</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/web/wasm">Compile to Wasm</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/web/web-content-in-flutter">Integrate web content</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/web/embedding-flutter-web">Embed in another web app</a>
        </li>
      </ul>
    </div>
  </div>
</div>
