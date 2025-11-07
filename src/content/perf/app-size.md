---
ia-translate: true
title: Medindo o tamanho do seu app
description: Como medir o tamanho do app para iOS e Android.
---

Muitos desenvolvedores estão preocupados com o tamanho de seu app compilado.
Como a versão APK, app bundle ou IPA de um app Flutter é
autocontida e contém todo o código e assets necessários para executar o app,
seu tamanho pode ser uma preocupação. Quanto maior um app,
mais espaço ele requer em um dispositivo,
mais tempo leva para baixar,
e pode exceder o limite de recursos úteis
como os instant apps do Android.

## Builds de debug não são representativos

Por padrão, executar seu app com `flutter run`,
ou clicando no botão **Play** na sua IDE
(como usado em [Test drive][] e
[Write your first Flutter app][]),
gera um build de _debug_ do app Flutter.
O tamanho do app de um build de debug é grande devido ao
overhead de depuração que permite hot reload
e depuração em nível de código-fonte. Como tal, não é representativo de um app de produção
que os usuários finais baixam.

<a id="checking-the-total-size"></a>
## Verificando o tamanho total

Um build de release padrão, como um criado por `flutter build apk` ou
`flutter build ios`, é construído para convenientemente montar seu pacote de upload
para a Play Store e App Store. Como tal, eles também não são representativos do
tamanho de download dos seus usuários finais. As lojas geralmente reprocessam e dividem
seu pacote de upload para direcionar o dispositivo específico do usuário e o hardware do dispositivo,
como filtrar assets direcionados ao DPI do telefone, filtrar
bibliotecas nativas direcionadas à arquitetura de CPU do telefone.

<a id="estimating-total-size"></a>
### Estimando o tamanho total

Para obter o tamanho aproximado mais próximo em cada plataforma, use as seguintes
instruções.

#### Android

Siga as [instruções do Google Play Console][Play Console's instructions] para verificar o tamanho de download e
instalação do app.

Produza um pacote de upload para sua aplicação:

```console
flutter build appbundle
```

Faça login no seu [Google Play Console][]. Faça upload do binário da sua aplicação arrastando
e soltando o arquivo .aab.

Visualize o tamanho de download e instalação da aplicação na aba **Android vitals** ->
**App size**.

{% render docs/app-figure.md, image:"perf/vital-size.png", alt:"App size tab in Google Play Console" %}

O tamanho de download é calculado com base em um dispositivo XXXHDPI (~640dpi) em uma
arquitetura arm64-v8a. Os tamanhos de download dos seus usuários finais podem variar dependendo
do hardware deles.

A aba superior tem um botão para alternar entre tamanho de download e tamanho de instalação. A página também
contém dicas de otimização mais abaixo.

#### iOS

Crie um [Xcode App Size Report][].

Primeiro, configurando a versão e build do app conforme descrito nas
[instruções de criação de arquivo de build do iOS][iOS create build archive instructions].

Então:

1. Execute `flutter build ipa --export-method development`.
1. Execute `open build/ios/archive/*.xcarchive` para abrir o arquivo no Xcode.
1. Clique em **Distribute App**.
1. Selecione um método de distribuição. **Development** é o mais simples se você não
   pretende distribuir a aplicação.
1. Em **App Thinning**, selecione 'all compatible device variants'.
1. Selecione **Strip Swift symbols**.

Assine e exporte o IPA. O diretório exportado contém
`App Thinning Size Report.txt` com detalhes sobre o tamanho projetado da sua
aplicação em diferentes dispositivos e versões do iOS.

O App Size Report para o app de demonstração padrão no Flutter 1.17 mostra:

```plaintext
Variant: Runner-7433FC8E-1DF4-4299-A7E8-E00768671BEB.ipa
Supported variant descriptors: [device: iPhone12,1, os-version: 13.0] and [device: iPhone11,8, os-version: 13.0]
App + On Demand Resources size: 5.4 MB compressed, 13.7 MB uncompressed
App size: 5.4 MB compressed, 13.7 MB uncompressed
On Demand Resources size: Zero KB compressed, Zero KB uncompressed
```

Neste exemplo, o app tem um tamanho aproximado
de download de 5.4 MB e um tamanho aproximado
de instalação de 13.7 MB em um iPhone12,1 ([Model ID / Hardware
number][] para iPhone 11)
e iPhone11,8 (iPhone XR) executando iOS 13.0.

Para medir um app iOS com exatidão,
você precisa fazer upload de um IPA de release para o
App Store Connect da Apple ([instructions][])
e obter o relatório de tamanho de lá.
IPAs são geralmente maiores que APKs conforme explicado
em [How big is the Flutter engine?][], uma
seção no [FAQ][] do Flutter.

<a id="breaking-down-the-size"></a>
## Detalhando o tamanho

A partir da versão 1.22 do Flutter e versão 0.9.1 do DevTools,
uma ferramenta de análise de tamanho está incluída para ajudar desenvolvedores a entender o detalhamento
do build de release de sua aplicação.

:::warning
Como mencionado na seção [verificando o tamanho total](#checking-the-total-size)
acima, um pacote de upload não é representativo do tamanho de download
dos seus usuários finais. Esteja ciente de que arquiteturas de biblioteca nativa redundantes e densidades de assets
vistas na ferramenta de detalhamento podem ser filtradas pela Play Store e App Store.
:::

A ferramenta de análise de tamanho é invocada passando a flag `--analyze-size` ao
compilar:

- `flutter build apk --analyze-size`
- `flutter build appbundle --analyze-size`
- `flutter build ios --analyze-size`
- `flutter build linux --analyze-size`
- `flutter build macos --analyze-size`
- `flutter build windows --analyze-size`

Este build é diferente de um build de release padrão de duas maneiras.

1. A ferramenta compila Dart de uma forma que registra o uso de tamanho de código dos
   pacotes Dart.
2. A ferramenta exibe um resumo de alto nível do detalhamento de tamanho
   no terminal, e deixa um arquivo `*-code-size-analysis_*.json` para análise mais
   detalhada no DevTools.

Além de analisar um único build, dois builds também podem ser comparados
carregando dois arquivos `*-code-size-analysis_*.json` no DevTools.
Confira a [documentação do DevTools][DevTools documentation] para detalhes.

{% render docs/app-figure.md, image:"perf/size-summary.png", alt:"Size summary of an Android application in terminal" %}

Através do resumo, você pode ter uma ideia rápida do uso de tamanho por categoria
(como asset, código nativo, bibliotecas Flutter, etc). A biblioteca nativa compilada de Dart
é ainda mais detalhada por pacote para análise rápida.

:::warning
Esta ferramenta no iOS cria um .app em vez de um IPA. Use esta ferramenta para
avaliar o tamanho relativo do conteúdo do .app. Para obter
uma estimativa mais próxima do tamanho de download, consulte a
seção [Estimando o tamanho total](#estimating-total-size) acima.
:::

### Análise mais profunda no DevTools

O arquivo `*-code-size-analysis_*.json` produzido acima pode ser
analisado em maior detalhe no DevTools onde uma visualização em árvore ou treemap pode
detalhar o conteúdo da aplicação até o nível de arquivo individual e
até o nível de função para o artefato Dart AOT.

Isso pode ser feito executando `dart devtools`, selecionando
`Open app size tool` e fazendo upload do arquivo JSON.

{% render docs/app-figure.md, image:"perf/devtools-size.png", alt:"Example breakdown of app in DevTools" %}

Para mais informações sobre como usar a ferramenta de tamanho de app do DevTools,
confira a [documentação do DevTools][DevTools documentation].

## Reduzindo o tamanho do app

Ao construir uma versão de release do seu app,
considere usar a tag `--split-debug-info`.
Esta tag pode reduzir drasticamente o tamanho do código.
Para um exemplo de uso desta tag, veja
[Obfuscating Dart code][].

Algumas outras coisas que você pode fazer para tornar seu app menor são:

* Remover recursos não utilizados
* Minimizar recursos importados de bibliotecas
* Comprimir arquivos PNG e JPEG

[FAQ]: /resources/faq
[How big is the Flutter engine?]: /resources/faq#how-big-is-the-flutter-engine
[instructions]: /deployment/ios
[Xcode App Size Report]: {{site.apple-dev}}/documentation/xcode/reducing_your_app_s_size#3458589
[iOS create build archive instructions]: /deployment/ios#update-the-apps-build-and-version-numbers
[Model ID / Hardware number]: https://en.wikipedia.org/wiki/List_of_iOS_devices#Models
[Obfuscating Dart code]: /deployment/obfuscate
[Test drive]: /get-started/test-drive
[Write your first Flutter app]: /get-started/codelab
[Play Console's instructions]: https://support.google.com/googleplay/android-developer/answer/9302563?hl=en
[Google Play Console]: https://play.google.com/apps/publish/
[DevTools documentation]: /tools/devtools/app-size
