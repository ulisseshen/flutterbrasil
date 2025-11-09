---
ia-translate: true
title: Sequência de carregamento, desempenho e memória
description: Quais são as etapas envolvidas ao mostrar uma UI Flutter.
---

Esta página descreve a divisão das etapas envolvidas
para mostrar uma UI Flutter. Sabendo disso, você pode tomar decisões
melhores e mais informadas sobre quando pré-aquecer o engine Flutter,
quais operações são possíveis em qual estágio,
e os custos de latência e memória dessas operações.

## Carregando Flutter

Apps Android e iOS (as duas plataformas suportadas para
integração em apps existentes), apps Flutter completos,
e padrões add-to-app têm uma sequência semelhante de
etapas conceituais de carregamento ao exibir a UI Flutter.

### Encontrando os recursos Flutter

O runtime do engine Flutter e o código Dart compilado do seu aplicativo
são ambos empacotados como bibliotecas compartilhadas no Android
e iOS. A primeira etapa de carregamento do Flutter é encontrar esses
recursos no seu .apk/.ipa/.app (junto com outros assets Flutter
como imagens, fontes e código JIT, se aplicável).

Isso acontece quando você constrói um `FlutterEngine` pela
primeira vez tanto nas APIs **[Android][android-engine]**
quanto **[iOS][ios-engine]**.

:::note
Alguns pacotes permitem que você compartilhe imagens e fontes
do aplicativo nativo para sua tela Flutter.
Por exemplo:
* [native_font]({{site.pub-pkg}}/native_font)
* [ios_platform_images]({{site.pub-pkg}}/ios_platform_images)
:::

### Carregando a biblioteca Flutter

Depois de encontrada, as bibliotecas compartilhadas do engine são carregadas na memória
uma vez por processo.

No **Android**, isso também acontece quando o
[`FlutterEngine`][android-engine] é construído porque os
conectores JNI precisam referenciar a biblioteca C++ do Flutter.
No **iOS**, isso acontece quando o
[`FlutterEngine`][ios-engine] é executado pela primeira vez,
como ao executar [`runWithEntrypoint:`][`runWithEntrypoint:`].

### Iniciando a Dart VM

O runtime Dart é responsável por gerenciar a memória Dart e
concorrência para seu código Dart. No modo JIT,
ele é adicionalmente responsável por compilar
o código-fonte Dart em código de máquina durante o runtime.

Um único runtime Dart existe por sessão de aplicação no
Android e iOS.

Um início único da Dart VM é feito ao construir o
[`FlutterEngine`][android-engine] pela primeira vez no
**Android** e ao [executar um ponto de entrada Dart][ios-engine]
pela primeira vez no **iOS**.

Neste ponto, o [snapshot][snapshot] do seu código Dart
também é carregado na memória dos arquivos do seu aplicativo.

Este é um processo genérico que também ocorre se você usou o
[Dart SDK][Dart SDK] diretamente, sem o engine Flutter.

A Dart VM nunca desliga depois de iniciada.

### Criando e executando um Dart Isolate

Depois que o runtime Dart é inicializado,
o uso do runtime Dart pelo engine Flutter é o próximo passo.

Isso é feito iniciando um [Dart `Isolate`][Dart `Isolate`] no runtime Dart.
O isolate é o contêiner do Dart para memória e threads.
Um número de [threads auxiliares][auxiliary threads] na plataforma host também são
criadas neste ponto para suportar o isolate, como
uma thread para descarregar o processamento de GPU e outra para decodificação de imagem.

Um isolate existe por instância de `FlutterEngine`, e múltiplos isolates
podem ser hospedados pela mesma Dart VM.

No **Android**, isso acontece quando você chama
[`DartExecutor.executeDartEntrypoint()`][`DartExecutor.executeDartEntrypoint()`]
em uma instância `FlutterEngine`.

No **iOS**, isso acontece quando você chama [`runWithEntrypoint:`][`runWithEntrypoint:`]
em um `FlutterEngine`.

Neste ponto, o ponto de entrada selecionado do seu código Dart
(a função `main()` do arquivo `main.dart` da sua biblioteca Dart,
por padrão) é executado. Se você chamou a
função Flutter [`runApp()`][`runApp()`] na sua função `main()`,
então seu app Flutter ou a árvore de widgets da sua biblioteca também é criada
e construída. Se você precisa evitar que certas funcionalidades sejam executadas
no seu código Flutter, então o valor enum `AppLifecycleState.detached`
indica que o `FlutterEngine` não está anexado
a nenhum componente de UI, como um `FlutterViewController`
no iOS ou uma `FlutterActivity` no Android.

### Anexando uma UI ao engine Flutter

Um app Flutter padrão e completo avança para alcançar este estado assim
que o app é iniciado.

Em um cenário add-to-app,
isso acontece quando você anexa um `FlutterEngine`
a um componente de UI, como ao chamar [`startActivity()`][`startActivity()`]
com um [`Intent`][`Intent`] construído usando [`FlutterActivity.withCachedEngine()`][`FlutterActivity.withCachedEngine()`]
no **Android**. Ou, ao apresentar um [`FlutterViewController`][`FlutterViewController`]
inicializado usando [`initWithEngine: nibName: bundle:`][`initWithEngine: nibName: bundle:`]
no **iOS**.

Este também é o caso se um componente de UI Flutter foi lançado sem
pré-aquecer um `FlutterEngine`, como com
[`FlutterActivity.createDefaultIntent()`][`FlutterActivity.createDefaultIntent()`] no **Android**,
ou com [`FlutterViewController initWithProject: nibName: bundle:`][`FlutterViewController initWithProject: nibName: bundle:`]
no **iOS**. Um `FlutterEngine` implícito é criado nesses casos.

Por trás dos panos, os componentes de UI de ambas as plataformas fornecem ao
`FlutterEngine` uma superfície de renderização, como um
[`Surface`][`Surface`] no **Android** ou um [CAEAGLLayer][CAEAGLLayer] ou [CAMetalLayer][CAMetalLayer]
no **iOS**.

Neste ponto, a árvore [`Layer`][`Layer`] gerada pelo seu
programa Flutter, por frame, é convertida em
instruções GPU OpenGL (ou Vulkan ou Metal).

[android-engine]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[auxiliary threads]: {{site.repo.flutter}}/blob/main/docs/about/The-Engine-architecture.md#threading
[CAEAGLLayer]: {{site.apple-dev}}/documentation/quartzcore/caeagllayer
[CAMetalLayer]: {{site.apple-dev}}/documentation/quartzcore/cametallayer
[Dart `Isolate`]: {{site.dart.api}}/dart-isolate/Isolate-class.html
[Dart SDK]: {{site.dart-site}}/tools/sdk
[`DartExecutor.executeDartEntrypoint()`]: {{site.api}}/javadoc/io/flutter/embedding/engine/dart/DartExecutor.html#executeDartEntrypoint-io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint-
[`FlutterActivity.createDefaultIntent()`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html#createDefaultIntent-android.content.Context-
[`FlutterActivity.withCachedEngine()`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html#withCachedEngine-java.lang.String-
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[`FlutterViewController initWithProject: nibName: bundle:`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#aa3aabfb89e958602ce6a6690c919f655
[`initWithEngine: nibName: bundle:`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#a0aeea9525c569d5efbd359e2d95a7b31
[`Intent`]: {{site.android-dev}}/reference/android/content/Intent.html
[ios-engine]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[`Layer`]: {{site.api}}/flutter/rendering/Layer-class.html
[multiple Flutters]: /add-to-app/multiple-flutters
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`runWithEntrypoint:`]: {{site.api}}/ios-embedder/interface_flutter_engine.html#a019d6b3037eff6cfd584fb2eb8e9035e
[snapshot]: {{site.github}}/dart-lang/sdk/wiki/Snapshots
[`startActivity()`]: {{site.android-dev}}/reference/android/content/Context#startActivity(android.content.Intent)
[`Surface`]: {{site.android-dev}}/reference/android/view/Surface
