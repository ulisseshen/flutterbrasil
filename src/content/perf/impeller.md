---
ia-translate: true
title: Motor de renderização Impeller
description: O que é Impeller e como habilitá-lo?
---

:::note
A partir da versão 3.27, Impeller é o motor de
renderização padrão tanto para iOS quanto para Android.
Para ver informações _detalhadas_ sobre onde Impeller é atualmente suportado,
confira a página [Can I use Impeller?][].
:::

[Can I use Impeller?]: {{site.main-url}}/go/can-i-use-impeller

## O que é Impeller?

Impeller fornece um novo runtime de renderização para Flutter.
Impeller pré-compila um [conjunto menor e mais simples de shaders][smaller, simpler set of shaders]
em tempo de build do Engine para que eles não compilem em runtime.

[smaller, simpler set of shaders]: {{site.repo.flutter}}/issues/77412

Para uma introdução em vídeo ao Impeller, confira a seguinte
palestra do Google I/O 2023.

{% ytEmbed 'vd5NqS01rlA', 'Introducing Impeller, Flutter\'s new rendering engine' %}

Impeller tem os seguintes objetivos:

* **Desempenho previsível**:
  Impeller compila todos os shaders e reflexão offline em tempo de build.
  Ele constrói todos os objetos de estado de pipeline antecipadamente.
  O motor controla o cache e faz cache explicitamente.
* **Instrumentável**:
  Impeller marca e rotula todos os recursos gráficos,
  como texturas e buffers.
  Ele pode capturar e persistir animações em disco sem afetar
  o desempenho de renderização por frame.
* **Portável**:
  Flutter não vincula Impeller a uma API específica de renderização do cliente.
  Você pode criar shaders uma vez e convertê-los para formatos
  específicos do backend, conforme necessário.
* **Aproveita APIs gráficas modernas**:
  Impeller usa, mas não depende de, recursos disponíveis em
  APIs modernas como Metal e Vulkan.
* **Aproveita concorrência**:
  Impeller pode distribuir cargas de trabalho de frame único através de múltiplas
  threads, se necessário.

## Disponibilidade

Onde você pode usar Impeller? Para informações _detalhadas_, confira
a página [Can I use Impeller?][].

### iOS

Flutter **habilita Impeller por padrão** no iOS.

* Para _desabilitar_ Impeller no iOS ao depurar,
  passe `--no-enable-impeller` para o comando `flutter run`.

  ```console
  flutter run --no-enable-impeller
  ```

* Para _desabilitar_ Impeller no iOS ao implantar seu app,
  adicione as seguintes tags sob a tag `<dict>` de nível superior no
  arquivo `Info.plist` do seu app.

  ```xml
    <key>FLTEnableImpeller</key>
    <false />
  ```

### Android

Flutter **habilita Impeller por padrão** no Android.
Em dispositivos que não suportam Vulkan,
Impeller fará fallback para o renderizador OpenGL legado.
Nenhuma ação de sua parte é necessária para este comportamento de fallback.

* Para _desabilitar_ Impeller ao depurar,
  passe `--no-enable-impeller` para o comando `flutter run`.

  ```console
  flutter run --no-enable-impeller
  ```

* Para _desabilitar_ Impeller ao implantar seu app,
  adicione a seguinte configuração ao arquivo
  `AndroidManifest.xml` do seu projeto sob a tag `<application>`:

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

### macOS

Você pode experimentar Impeller para macOS atrás de uma flag.
Em uma versão futura, a capacidade de optar por não
usar Impeller será removida.

Para habilitar Impeller no macOS ao depurar,
passe `--enable-impeller` para o comando `flutter run`.

```console
flutter run --enable-impeller
```

Para habilitar Impeller no macOS ao implantar seu app,
adicione as seguintes tags sob a tag
`<dict>` de nível superior no arquivo `Info.plist` do seu app.

```xml
  <key>FLTEnableImpeller</key>
  <true />
```

### Bugs e problemas

A equipe continua a melhorar o suporte ao Impeller.
Se você encontrar problemas de desempenho ou fidelidade
com Impeller em qualquer plataforma,
registre um issue no [rastreador do GitHub][file-issue].
Prefixe o título do issue com `[Impeller]` e
inclua um pequeno caso de teste reproduzível.

Por favor, inclua as seguintes informações ao
enviar um issue para Impeller:

* O dispositivo em que você está executando,
  incluindo as informações do chip.
* Screenshots ou gravações de quaisquer problemas visíveis.
* Uma [exportação do trace de desempenho][export of the performance trace].
  Compacte o arquivo e anexe-o ao issue do GitHub.

[export of the performance trace]:/tools/devtools/performance#import-and-export
[file-issue]: {{site.github}}/flutter/flutter/issues/new/choose
[Impeller project board]: {{site.github}}/orgs/flutter/projects/21

## Arquitetura

Para aprender mais detalhes sobre o design e arquitetura do Impeller,
confira o arquivo [README.md][] na árvore de código-fonte.

[README.md]: {{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/README.md

## Informações adicionais

* [Frequently asked questions]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/faq.md)
* [Impeller's coordinate system]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/coordinate_system.md)
* [How to set up Xcode for GPU frame captures with metal]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/xcode_frame_capture.md)
* [Learning to read GPU frame captures]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/read_frame_captures.md)
* [How to enable metal validation for command line apps]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/metal_validation.md)
* [How Impeller works around the lack of uniform buffers in Open GL ES 2.0]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/ubo_gles2.md)
* [Guidance for writing efficient shaders]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/shader_optimization.md)
* [How color blending works in Impeller]({{site.repo.flutter}}/blob/main/engine/src/flutter/impeller/docs/blending.md)
