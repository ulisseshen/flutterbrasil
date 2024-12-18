---
ia-translate: true
title: Medindo o tamanho do seu aplicativo
description: Como medir o tamanho do aplicativo para iOS e Android.
---

Muitos desenvolvedores se preocupam com o tamanho do aplicativo compilado. Como o APK, o app bundle ou a versão IPA de um aplicativo Flutter é autocontido e contém todo o código e ativos necessários para executar o aplicativo, seu tamanho pode ser uma preocupação. Quanto maior um aplicativo, mais espaço ele requer em um dispositivo, mais tempo leva para ser baixado e pode quebrar o limite de recursos úteis, como aplicativos instantâneos do Android.

## Builds de debug não são representativos

Por padrão, iniciar seu aplicativo com `flutter run` ou clicando no botão **Play** no seu IDE (como usado em [Test drive][] e [Escreva seu primeiro aplicativo Flutter][]), gera um build de _debug_ do aplicativo Flutter. O tamanho do aplicativo de um build de debug é grande devido à sobrecarga de depuração que permite hot reload e depuração em nível de código-fonte. Sendo assim, não é representativo de um aplicativo de produção que os usuários finais baixam.

## Verificando o tamanho total

Um build de release padrão, como um criado por `flutter build apk` ou `flutter build ios`, é construído para montar convenientemente seu pacote de upload para a Play Store e a App Store. Sendo assim, eles também não são representativos do tamanho de download de seus usuários finais. As lojas geralmente reprocessam e dividem seu pacote de upload para direcionar o downloader específico e o hardware do downloader, como filtrar ativos direcionados ao DPI do telefone, filtrar bibliotecas nativas direcionadas à arquitetura da CPU do telefone.

### Estimando o tamanho total

Para obter o tamanho aproximado mais próximo em cada plataforma, use as seguintes instruções.

#### Android

Siga as [instruções do Google Play Console][] para verificar o tamanho de download e instalação do aplicativo.

Produza um pacote de upload para sua aplicação:

```console
flutter build appbundle
```

Faça login no seu [Google Play Console][]. Faça o upload do binário do seu aplicativo arrastando e soltando o arquivo .aab.

Visualize o tamanho de download e instalação do aplicativo na aba **Android vitals** -> **Tamanho do aplicativo**.

{% render docs/app-figure.md, image:"perf/vital-size.png", alt:"Aba de tamanho do aplicativo no Google Play Console" %}

O tamanho do download é calculado com base em um dispositivo XXXHDPI (~640dpi) em uma arquitetura arm64-v8a. Os tamanhos de download de seus usuários finais podem variar dependendo do hardware deles.

A aba superior tem um alternador para o tamanho do download e o tamanho da instalação. A página também contém dicas de otimização mais abaixo.

#### iOS

Crie um [Relatório de Tamanho do Aplicativo Xcode][].

Primeiro, configurando a versão e o build do aplicativo conforme descrito nas [instruções de criação do arquivo de build do iOS][].

Então:

1. Execute `flutter build ipa --export-method development`.
2. Execute `open build/ios/archive/*.xcarchive` para abrir o arquivo no Xcode.
3. Clique em **Distribute App**.
4. Selecione um método de distribuição. **Development** é o mais simples se você não pretende distribuir o aplicativo.
5. Em **App Thinning**, selecione 'all compatible device variants'.
6. Selecione **Strip Swift symbols**.

Assine e exporte o IPA. O diretório exportado contém `App Thinning Size Report.txt` com detalhes sobre o tamanho projetado do seu aplicativo em diferentes dispositivos e versões do iOS.

O Relatório de Tamanho do Aplicativo para o aplicativo de demonstração padrão no Flutter 1.17 mostra:

```plaintext
Variant: Runner-7433FC8E-1DF4-4299-A7E8-E00768671BEB.ipa
Supported variant descriptors: [device: iPhone12,1, os-version: 13.0] and [device: iPhone11,8, os-version: 13.0]
App + On Demand Resources size: 5.4 MB compressed, 13.7 MB uncompressed
App size: 5.4 MB compressed, 13.7 MB uncompressed
On Demand Resources size: Zero KB compressed, Zero KB uncompressed
```

Neste exemplo, o aplicativo tem um tamanho de download aproximado de 5,4 MB e um tamanho de instalação aproximado de 13,7 MB em um iPhone12,1 ([ID do modelo / número de hardware][] para iPhone 11) e iPhone11,8 (iPhone XR) executando iOS 13.0.

Para medir um aplicativo iOS exatamente, você deve enviar um IPA de release para o App Store Connect da Apple ([instruções][]) e obter o relatório de tamanho de lá. Os IPAs são normalmente maiores do que os APKs, conforme explicado em [Quão grande é o engine Flutter?][], uma seção nas [FAQ][] do Flutter.

## Dividindo o tamanho

A partir da versão 1.22 do Flutter e da versão 0.9.1 do DevTools, uma ferramenta de análise de tamanho está incluída para ajudar os desenvolvedores a entender a divisão do build de release de seu aplicativo.

:::warning
Como afirmado na seção [verificando o tamanho total](#verificando-o-tamanho-total) acima, um pacote de upload não é representativo do tamanho de download de seus usuários finais. Esteja ciente de que as arquiteturas de bibliotecas nativas redundantes e as densidades de ativos vistas na ferramenta de detalhamento podem ser filtradas pela Play Store e pela App Store.
:::

A ferramenta de análise de tamanho é invocada passando a flag `--analyze-size` ao construir:

- `flutter build apk --analyze-size`
- `flutter build appbundle --analyze-size`
- `flutter build ios --analyze-size`
- `flutter build linux --analyze-size`
- `flutter build macos --analyze-size`
- `flutter build windows --analyze-size`

Este build é diferente de um build de release padrão de duas maneiras.

1. A ferramenta compila o Dart de uma forma que registra o uso do tamanho do código de pacotes Dart.
2. A ferramenta exibe um resumo de alto nível da divisão do tamanho no terminal e deixa um arquivo `*-code-size-analysis_*.json` para uma análise mais detalhada no DevTools.

Além de analisar um único build, dois builds também podem ser comparados carregando dois arquivos `*-code-size-analysis_*.json` no DevTools. Confira a [documentação do DevTools][] para mais detalhes.

{% render docs/app-figure.md, image:"perf/size-summary.png", alt:"Resumo do tamanho de um aplicativo Android no terminal" %}

Através do resumo, você pode ter uma ideia rápida do uso do tamanho por categoria (como ativo, código nativo, bibliotecas Flutter, etc.). A biblioteca nativa Dart compilada é ainda dividida por pacote para uma análise rápida.

:::warning
Esta ferramenta no iOS cria um .app em vez de um IPA. Use esta ferramenta para avaliar o tamanho relativo do conteúdo do .app. Para obter uma estimativa mais precisa do tamanho do download, consulte a seção [Estimando o tamanho total](#estimando-o-tamanho-total) acima.
:::

### Análise mais profunda no DevTools

O arquivo `*-code-size-analysis_*.json` produzido acima pode ser analisado mais detalhadamente no DevTools, onde uma visualização em árvore ou mapa de árvore pode detalhar o conteúdo do aplicativo até o nível de arquivo individual e até o nível de função para o artefato Dart AOT.

Isso pode ser feito por `dart devtools`, selecionando `Open app size tool` e enviando o arquivo JSON.

{% render docs/app-figure.md, image:"perf/devtools-size.png", alt:"Exemplo de divisão do aplicativo no DevTools" %}

Para obter mais informações sobre como usar a ferramenta de tamanho de aplicativo do DevTools, consulte a [documentação do DevTools][].

## Reduzindo o tamanho do aplicativo

Ao construir uma versão de release do seu aplicativo, considere usar a tag `--split-debug-info`. Essa tag pode reduzir drasticamente o tamanho do código. Para um exemplo de uso desta tag, veja [Ofuscando código Dart][].

Outras coisas que você pode fazer para tornar seu aplicativo menor são:

* Remover recursos não utilizados
* Minimizar recursos importados de bibliotecas
* Compactar arquivos PNG e JPEG

[FAQ]: /resources/faq
[Quão grande é o engine Flutter?]: /resources/faq#how-big-is-the-flutter-engine
[instruções]: /deployment/ios
[Relatório de Tamanho do Aplicativo Xcode]: {{site.apple-dev}}/documentation/xcode/reducing_your_app_s_size#3458589
[instruções de criação do arquivo de build do iOS]: /deployment/ios#update-the-apps-build-and-version-numbers
[ID do modelo / número de hardware]: https://en.wikipedia.org/wiki/List_of_iOS_devices#Models
[Ofuscando código Dart]: /deployment/obfuscate
[Test drive]: /get-started/test-drive
[Escreva seu primeiro aplicativo Flutter]: /get-started/codelab
[instruções do Google Play Console]: https://support.google.com/googleplay/android-developer/answer/9302563?hl=en
[Google Play Console]: https://play.google.com/apps/publish/
[documentação do DevTools]: /tools/devtools/app-size
