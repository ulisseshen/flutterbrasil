---
ia-translate: true
title: Suporte a editores para Flutter
shortTitle: Editores
description: >-
  Suporte a editores para Dart e Flutter.
showToc: false
---

Você pode construir apps com Flutter usando qualquer editor de texto ou
ambiente de desenvolvimento integrado (IDE)
combinado com as ferramentas de linha de comando do Flutter.

A equipe Flutter recomenda usar um editor que suporte
uma extensão ou plugin Flutter, como VS Code e Android Studio.
Esses plugins fornecem completação de código, destacamento de sintaxe,
assistências de edição de widgets, suporte a depuração e muito mais.

## Editores locais

A equipe Flutter suporta plugins para VS Code, Android Studio e IntelliJ.
Os plugins fornecem amplo suporte para desenvolvimento e depuração, bem como
integrações profundas com o [Dart analyzer][Dart analyzer] e [Dart and Flutter DevTools][Dart and Flutter DevTools].

<div class="card-grid">
  <a class="card outlined-card" href="/tools/vs-code">
    <div class="card-header">
      <span class="card-title">Visual Studio Code</span>
    </div>
    <div class="card-content">
      <p>Desenvolva e depure apps Flutter em um editor de código simplificado e personalizável.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/tools/android-studio">
    <div class="card-header">
      <span class="card-title">Android Studio and IntelliJ</span>
    </div>
    <div class="card-content">
      <p>Desenvolva e depure apps Flutter em uma IDE com rico suporte a linguagem e ferramentas integradas.</p>
    </div>
  </a>
</div>

[Dart analyzer]: {{site.dart-site}}/tools/analysis
[Dart and Flutter DevTools]: /tools/devtools

## Editores online

Você pode experimentar rapidamente o Flutter online sem nenhuma configuração local
com um dos seguintes editores.

<div class="card-grid">
  <a class="card outlined-card" href="{{site.dartpad}}" target="_blank">
    <div class="card-header">
      <span class="card-title">
        <span>DartPad</span>
        <span class="material-symbols" aria-hidden="true" style="font-size: 1rem;" translate="no">open_in_new</span>
      </span>
    </div>
    <div class="card-content">
      <p>Construa e execute rapidamente apps Flutter simples de arquivo único na web.</p>
    </div>
  </a>
  <a class="card outlined-card" href="https://firebase.studio" target="_blank">
    <div class="card-header">
      <span class="card-title">
        <span>Firebase Studio</span>
        <span class="material-symbols" aria-hidden="true" style="font-size: 1rem;" translate="no">open_in_new</span>
      </span>
    </div>
    <div class="card-content">
      <p>Desenvolva apps Flutter complexos em um espaço de trabalho assistido por IA na nuvem.</p>
    </div>
  </a>
</div>

## Outros editores

Você pode desenvolver apps Dart e Flutter usando qualquer outro editor de texto e terminal.

Dependendo do editor, você pode integrar o suporte do Dart SDK para o
[Language Server Protocol][lsp] e o [Debug Adapter Protocol][dap] para
habilitar recursos avançados de edição de código e depuração para Dart e Flutter.

[lsp]: https://github.com/dart-lang/sdk/tree/main/pkg/analysis_server/tool/lsp_spec/README.md
[dap]: https://github.com/dart-lang/sdk/blob/main/third_party/pkg/dap/tool/README.md
