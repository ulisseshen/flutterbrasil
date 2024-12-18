---
ia-translate: true
title: Mecanismo de renderização Impeller
description: O que é Impeller e como habilitá-lo?
---

## O que é Impeller?

Impeller fornece um novo tempo de execução de renderização para Flutter.
A equipe do Flutter acredita que isso resolve o problema de
[jank de início precoce][] do Flutter.
Impeller pré-compila um [conjunto menor e mais simples de shaders][]
no momento da construção do Engine, para que eles não sejam compilados em tempo de execução.

[jank de início precoce]: {{site.repo.flutter}}/projects/188
[conjunto menor e mais simples de shaders]: {{site.repo.flutter}}/issues/77412

Para uma introdução em vídeo ao Impeller, confira a seguinte palestra do Google I/O 2023.

{% ytEmbed 'vd5NqS01rlA', 'Apresentando o Impeller, o novo mecanismo de renderização do Flutter' %}

O Impeller tem os seguintes objetivos:

* **Desempenho previsível**:
  Impeller compila todos os shaders e reflexão offline no momento da compilação.
  Ele constrói todos os objetos de estado do pipeline antecipadamente.
  O mecanismo controla o armazenamento em cache e armazena em cache explicitamente.
* **Instrumentável**:
  Impeller marca e rotula todos os recursos gráficos,
  como texturas e buffers.
  Ele pode capturar e persistir animações em disco sem afetar
  o desempenho da renderização por quadro.
* **Portátil**:
  O Flutter não vincula o Impeller a uma API de renderização de cliente específica.
  Você pode criar shaders uma vez e convertê-los em formatos específicos de backend,
  conforme necessário.
* **Aproveita APIs gráficas modernas**:
  O Impeller usa, mas não depende de, recursos disponíveis em
  APIs modernas como Metal e Vulkan.
* **Aproveita a concorrência**:
  O Impeller pode distribuir cargas de trabalho de um único quadro em várias
  threads, se necessário.

## Disponibilidade

Onde você pode usar o Impeller?

### iOS

O Flutter **habilita o Impeller por padrão** no iOS.

* Para _desabilitar_ o Impeller no iOS durante a depuração,
  passe `--no-enable-impeller` para o comando `flutter run`.

  ```console
  flutter run --no-enable-impeller
  ```

* Para _desabilitar_ o Impeller no iOS ao implantar seu aplicativo,
  adicione as seguintes tags sob a tag de nível superior `<dict>` no
  arquivo `Info.plist` do seu aplicativo.

  ```xml
    <key>FLTEnableImpeller</key>
    <false />
  ```

A equipe continua a melhorar o suporte ao iOS.
Se você encontrar problemas de desempenho ou fidelidade
com o Impeller no iOS,
registre um problema no [rastreador do GitHub][file-issue].
Prefixe o título do problema com `[Impeller]` e
inclua um pequeno caso de teste reproduzível.

[file-issue]: {{site.repo.flutter}}/issues/new/choose

### macOS

A partir da versão 3.19,
você pode experimentar o Impeller para macOS por trás de um sinalizador.
Em uma versão futura, a capacidade de desativar o
uso do Impeller será removida.

Para habilitar o Impeller no macOS durante a depuração,
passe `--enable-impeller` para o comando `flutter run`.

```console
flutter run --enable-impeller
```

Para habilitar o Impeller no macOS ao implantar seu aplicativo,
adicione as seguintes tags sob o nível superior
tag `<dict>` no arquivo `Info.plist` do seu aplicativo.

```xml
  <key>FLTEnableImpeller</key>
  <true />
```

### Android

A partir da versão 3.22, o Impeller no Android com Vulkan
é um release candidate. Em dispositivos que não suportam Vulkan,
o Impeller voltará para o renderizador OpenGL legado. Nenhuma
ação de sua parte é necessária para este comportamento de fallback.
Considere experimentar o Impeller no Android antes que ele se torne o padrão
no stable, você pode optar explicitamente por ele.

:::secondary Seu dispositivo suporta Vulkan?
Você pode determinar se o seu dispositivo Android
suporta Vulkan em [verificando o suporte ao Vulkan][vulkan].
:::

Para experimentar o Impeller em dispositivos Android com capacidade Vulkan,
passe `--enable-impeller` para `flutter run`:

```console
flutter run --enable-impeller
```

Ou, você pode adicionar a seguinte configuração ao
arquivo `AndroidManifest.xml` do seu projeto sob a tag `<application>`:

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="true" />
```

[vulkan]: https://docs.vulkan.org/guide/latest/checking_for_support.html#_android

### Bugs e problemas

Para a lista completa de bugs conhecidos e recursos ausentes do Impeller,
as informações mais atualizadas estão no
[quadro do projeto Impeller][] no GitHub.

A equipe continua a melhorar o suporte do Impeller.
Se você encontrar problemas de desempenho ou fidelidade
com o Impeller em qualquer plataforma,
registre um problema no [rastreador do GitHub][file-issue].
Prefixe o título do problema com `[Impeller]` e
inclua um pequeno caso de teste reproduzível.

Inclua as seguintes informações ao
enviar um problema para o Impeller:

* O dispositivo em que você está executando,
  incluindo as informações do chip.
* Capturas de tela ou gravações de quaisquer problemas visíveis.
* Uma [exportação do rastreamento de desempenho][].
  Compacte o arquivo e anexe-o ao problema do GitHub.

[exportação do rastreamento de desempenho]:/tools/devtools/performance#import-and-export
[quadro do projeto Impeller]: {{site.github}}/orgs/flutter/projects/21

## Arquitetura

Para saber mais detalhes sobre o design e a arquitetura do Impeller,
confira o arquivo [README.md][] na árvore de origem.

[README.md]: {{site.repo.engine}}/blob/main/impeller/README.md

## Informações adicionais

* [Perguntas frequentes]({{site.repo.engine}}/blob/main/impeller/docs/faq.md)
* [Sistema de coordenadas do Impeller]({{site.repo.engine}}/blob/main/impeller/docs/coordinate_system.md)
* [Como configurar o Xcode para capturas de quadro de GPU com metal]({{site.repo.engine}}/blob/main/impeller/docs/xcode_frame_capture.md)
* [Aprendendo a ler capturas de quadro de GPU]({{site.repo.engine}}/blob/main/impeller/docs/read_frame_captures.md)
* [Como habilitar a validação de metal para aplicativos de linha de comando]({{site.repo.engine}}/blob/main/impeller/docs/metal_validation.md)
* [Como o Impeller contorna a falta de buffers uniformes no Open GL ES 2.0]({{site.repo.engine}}/blob/main/impeller/docs/ubo_gles2.md)
* [Orientação para escrever shaders eficientes]({{site.repo.engine}}/blob/main/impeller/docs/shader_optimization.md)
* [Como a mistura de cores funciona no Impeller]({{site.repo.engine}}/blob/main/impeller/docs/blending.md)
