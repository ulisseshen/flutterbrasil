---
ia-translate: true
title: Engine de renderização Impeller
description: O que é Impeller e como habilitá-lo?
---

:::note
A partir da versão 3.27, Impeller é o engine de
renderização padrão para iOS e Android API 29+.
Para ver informações _detalhadas_ sobre onde Impeller é atualmente suportado,
confira a página [Posso usar Impeller?][Can I use Impeller?].
:::

[Can I use Impeller?]: {{site.main-url}}/go/can-i-use-impeller

## O que é Impeller?

Impeller fornece um novo runtime de renderização para Flutter.
Impeller pré-compila um [conjunto menor e mais simples de shaders][smaller, simpler set of shaders]
em tempo de build do engine para que não compilem em tempo de execução.

[smaller, simpler set of shaders]: {{site.repo.flutter}}/issues/77412

Para uma introdução em vídeo ao Impeller, confira a seguinte
apresentação do Google I/O 2023.

<YouTubeEmbed id="vd5NqS01rlA" title="Introducing Impeller, Flutter's new rendering engine"></YouTubeEmbed>

Impeller tem os seguintes objetivos:

* **Performance previsível**:
  Impeller compila todos os shaders e reflection offline em tempo de build.
  Ele constrói todos os objetos de estado de pipeline antecipadamente.
  O engine controla o caching e faz cache explicitamente.
* **Instrumentável**:
  Impeller marca e rotula todos os recursos gráficos,
  como texturas e buffers.
  Ele pode capturar e persistir animações em disco sem afetar
  a performance de renderização por frame.
* **Portável**:
  Flutter não vincula Impeller a uma API de renderização de cliente específica.
  Você pode criar shaders uma vez e convertê-los para formatos
  específicos de backend, conforme necessário.
* **Aproveita APIs gráficas modernas**:
  Impeller usa, mas não depende de, recursos disponíveis em
  APIs modernas como Metal e Vulkan.
* **Aproveita concorrência**:
  Impeller pode distribuir cargas de trabalho de um único frame entre múltiplas
  threads, se necessário.

## Disponibilidade

Onde você pode usar Impeller? Para informações _detalhadas_, confira
a página [Posso usar Impeller?][Can I use Impeller?].

### iOS

Desde o [Flutter 3.29](https://blog.flutterbrasil.dev/whats-new-in-flutter-3-29-f90c380c2317), Impeller é o **padrão no iOS** sem capacidade de
alternar para Skia.

### Android

Impeller está **disponível e habilitado por padrão no Android API 29+**.
Em dispositivos executando versões mais baixas do Android ou que não suportam Vulkan,
Impeller volta para o renderizador OpenGL legado.
Nenhuma ação de sua parte é necessária para este comportamento de fallback.

* Para _desabilitar_ Impeller ao depurar,
  passe `--no-enable-impeller` para o comando `flutter run`.

  ```console
  flutter run --no-enable-impeller
  ```

* Para _desabilitar_ Impeller ao fazer deploy do seu app,
  adicione a seguinte configuração ao arquivo
  `AndroidManifest.xml` do seu projeto sob a tag `<application>`:

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

### Web

Flutter na web oferece [dois renderizadores][two renderers] --
`canvaskit` e `skwasm` -- que atualmente usam Skia.
Eles podem usar Impeller no futuro.

[two renderers]: /platform-integration/web/renderers#renderers

### macOS

Você pode experimentar Impeller para macOS atrás de uma flag.
Em uma versão futura, a capacidade de optar por não
usar Impeller será removida.

Para habilitar Impeller no macOS ao depurar,
passe `--enable-impeller` para o comando `flutter run`.

```console
flutter run --enable-impeller
```

Para habilitar Impeller no macOS ao fazer deploy do seu app,
adicione as seguintes tags sob a tag `<dict>`
de nível superior no arquivo `Info.plist` do seu app.

```xml
  <key>FLTEnableImpeller</key>
  <true />
```

### Bugs e problemas

A equipe continua a melhorar o suporte ao Impeller.
Se você encontrar problemas de performance ou fidelidade
com Impeller em qualquer plataforma,
registre um issue no [rastreador do GitHub][file-issue].
Prefixe o título do issue com `[Impeller]` e
inclua um pequeno caso de teste reproduzível.

Por favor, inclua as seguintes informações ao
enviar um issue para Impeller:

* O dispositivo em que você está executando,
  incluindo as informações do chip.
* Screenshots ou gravações de quaisquer problemas visíveis.
* Uma [exportação do trace de performance][export of the performance trace].
  Compacte o arquivo e anexe-o ao issue do GitHub.

[export of the performance trace]:/tools/devtools/performance#import-and-export
[file-issue]: {{site.github}}/flutter/flutter/issues/new/choose
[Impeller project board]: {{site.github}}/orgs/flutter/projects/21

## Arquitetura

Para aprender mais detalhes sobre o design e arquitetura do Impeller,
confira o arquivo [README.md][README.md] na árvore de código-fonte.

[README.md]: {{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/README.md

## Informações adicionais

* [Perguntas frequentes][impeller-faq]
* [Sistema de coordenadas do Impeller][impeller-coords]
* [Como configurar o Xcode para capturas de frame GPU com metal][impeller-xcode-capture]
* [Aprendendo a ler capturas de frame GPU][impeller-read-capture]
* [Como habilitar validação metal para apps de linha de comando][impeller-metal-validation]
* [Como Impeller contorna a falta de buffers uniformes no Open GL ES 2.0][impeller-ubo-gles2]
* [Orientação para escrever shaders eficientes][impeller-shader-optimization]
* [Como a mistura de cores funciona no Impeller][impeller-blending]

[impeller-faq]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/faq.md
[impeller-coords]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/coordinate_system.md
[impeller-xcode-capture]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/xcode_frame_capture.md
[impeller-read-capture]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/read_frame_captures.md
[impeller-metal-validation]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/metal_validation.md
[impeller-ubo-gles2]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/ubo_gles2.md
[impeller-shader-optimization]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/shader_optimization.md
[impeller-blending]: {{site.repo.flutter}}/blob/main/docs/engine/impeller/docs/blending.md
