---
ia-translate: true
title: Sequência de carregamento, desempenho e memória
description: Quais são os passos envolvidos ao mostrar uma UI Flutter.
---

Esta página descreve a divisão dos passos envolvidos
para mostrar uma UI Flutter. Sabendo disso, você pode tomar decisões melhores e
mais informadas sobre quando pré-aquecer o engine Flutter,
quais operações são possíveis em qual estágio,
e os custos de latência e memória dessas operações.

## Carregando Flutter

Apps Android e iOS (as duas plataformas suportadas para
integrar em apps existentes), apps Flutter completos,
e padrões add-to-app têm uma sequência similar de
passos conceituais de carregamento ao exibir a UI Flutter.

### Encontrando os recursos Flutter

O runtime do engine Flutter e o código Dart compilado de sua aplicação
são ambos empacotados como bibliotecas compartilhadas no Android
e iOS. O primeiro passo de carregar o Flutter é encontrar esses
recursos em seu .apk/.ipa/.app (junto com outros ativos Flutter
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

Depois de encontradas, as bibliotecas compartilhadas do engine são carregadas na memória
uma vez por processo.

No **Android**, isso também acontece quando o
[`FlutterEngine`][android-engine] é construído porque os
conectores JNI precisam referenciar a biblioteca C++ do Flutter.
No **iOS**, isso acontece quando o
[`FlutterEngine`][ios-engine] é executado pela primeira vez,
como ao executar [`runWithEntrypoint:`][].

### Iniciando a Dart VM

O runtime Dart é responsável por gerenciar memória Dart e
concorrência para seu código Dart. No modo JIT,
ele também é responsável por compilar
o código-fonte Dart em código de máquina durante o runtime.

Um único runtime Dart existe por sessão de aplicação no
Android e iOS.

Um início único da Dart VM é feito ao construir o
[`FlutterEngine`][android-engine] pela primeira vez no
**Android** e ao [executar um entrypoint Dart][ios-engine]
pela primeira vez no **iOS**.

Neste ponto, o [snapshot][] do seu código Dart
também é carregado na memória dos arquivos de sua aplicação.

Este é um processo genérico que também ocorre se você usou o
[Dart SDK][] diretamente, sem o engine Flutter.

A Dart VM nunca desliga depois de ser iniciada.

### Criando e executando um Dart Isolate

Depois que o runtime Dart é inicializado,
o uso do runtime Dart pelo engine Flutter é o próximo passo.

Isso é feito iniciando um [Dart `Isolate`][] no runtime Dart.
O isolate é o container do Dart para memória e threads.
Um número de [threads auxiliares][auxiliary threads] na plataforma hospedeira também são
criadas neste ponto para suportar o isolate, como
uma thread para descarregar tratamento de GPU e outra para decodificação de imagens.

Um isolate existe por instância de `FlutterEngine`, e múltiplos isolates
podem ser hospedados pela mesma Dart VM.

No **Android**, isso acontece quando você chama
[`DartExecutor.executeDartEntrypoint()`][]
em uma instância de `FlutterEngine`.

No **iOS**, isso acontece quando você chama [`runWithEntrypoint:`][]
em um `FlutterEngine`.

Neste ponto, o entrypoint selecionado do seu código Dart
(a função `main()` do arquivo `main.dart` da sua biblioteca Dart,
por padrão) é executado. Se você chamou a
função Flutter [`runApp()`][] na sua função `main()`,
então seu app Flutter ou a árvore de widget da sua biblioteca também é criada
e construída. Se você precisa prevenir certas funcionalidades de executar
no seu código Flutter, então o valor enum `AppLifecycleState.detached`
indica que o `FlutterEngine` não está anexado
a nenhum componente de UI como um `FlutterViewController`
no iOS ou uma `FlutterActivity` no Android.

### Anexando uma UI ao engine Flutter

Um app Flutter padrão e completo se move para alcançar este estado assim que
o app é iniciado.

Em um cenário add-to-app,
isso acontece quando você anexa um `FlutterEngine`
a um componente de UI como ao chamar [`startActivity()`][]
com um [`Intent`][] construído usando [`FlutterActivity.withCachedEngine()`][]
no **Android**. Ou, ao apresentar um [`FlutterViewController`][]
inicializado usando [`initWithEngine: nibName: bundle:`][]
no **iOS**.

Este também é o caso se um componente de UI Flutter foi lançado sem
pré-aquecer um `FlutterEngine` como com
[`FlutterActivity.createDefaultIntent()`][] no **Android**,
ou com [`FlutterViewController initWithProject: nibName: bundle:`][]
no **iOS**. Um `FlutterEngine` implícito é criado nesses casos.

Por trás dos panos, os componentes de UI de ambas as plataformas fornecem ao
`FlutterEngine` uma superfície de renderização como uma
[`Surface`][] no **Android** ou um [CAEAGLLayer][] ou [CAMetalLayer][]
no **iOS**.

Neste ponto, a árvore [`Layer`][] gerada pelo seu
programa Flutter, por frame, é convertida em
instruções GPU OpenGL (ou Vulkan ou Metal).

## Memória e latência

Mostrar uma UI Flutter tem um custo de latência não trivial.
Este custo pode ser reduzido iniciando o engine Flutter
com antecedência.

A escolha mais relevante para cenários add-to-app é para você
decidir quando pré-carregar um `FlutterEngine`
(ou seja, carregar a biblioteca Flutter, iniciar a Dart VM,
e executar o entrypoint em um isolate), e qual é o custo de memória e latência
desse pré-aquecimento. Você também precisa saber como o pré-aquecimento
afeta o custo de memória e latência de renderizar um primeiro frame Flutter
quando o componente de UI é subsequentemente anexado
a esse `FlutterEngine`.

A partir do Flutter v1.10.3, e testando em um dispositivo de baixo desempenho classe 2015
em modo release-AOT, pré-aquecer o `FlutterEngine` custa:

* 42 MB e 1530 ms para pré-aquecer no **Android**.
  330 ms disso é uma chamada bloqueante na thread principal.
* 22 MB e 860 ms para pré-aquecer no **iOS**.
  260 ms disso é uma chamada bloqueante na thread principal.

Uma UI Flutter pode ser anexada durante o pré-aquecimento.
O tempo restante é unido ao tempo de latência até o primeiro frame.

Em termos de memória, um exemplo de custo (variável,
dependendo do caso de uso) poderia ser:

* ~4 MB de uso de memória do OS para criar pthreads.
* ~10 MB de memória do driver GPU.
* ~1 MB para memória gerenciada pelo runtime Dart.
* ~5 MB para mapas de fonte carregados pelo Dart.

Em termos de latência,
um exemplo de custo (variável, dependendo do caso de uso) poderia ser:

* ~20 ms para coletar os ativos Flutter do pacote de aplicação.
* ~15 ms para dlopen da biblioteca do engine Flutter.
* ~200 ms para criar a Dart VM e carregar o snapshot AOT.
* ~200 ms para carregar fontes e ativos dependentes do Flutter.
* ~400 ms para executar o entrypoint, criar a primeira árvore de widget,
  e compilar os programas de shader GPU necessários.

O `FlutterEngine` deve ser pré-aquecido tarde o suficiente para atrasar o
consumo de memória necessário, mas cedo o suficiente para evitar combinar o
tempo de inicialização do engine Flutter com a latência do primeiro frame de
mostrar o Flutter.

O timing exato depende da estrutura e heurísticas do app.
Um exemplo seria carregar o engine Flutter na tela
antes da tela ser desenhada pelo Flutter.

Dado um pré-aquecimento do engine, o custo do primeiro frame no anexo de UI é:

* 320 ms no **Android** e 12 MB adicionais
  (altamente dependente do tamanho físico do pixel da tela).
* 200 ms no **iOS** e 16 MB adicionais
  (altamente dependente do tamanho físico do pixel da tela).

Em termos de memória, o custo é principalmente o buffer de memória gráfica usado para
renderização e é dependente do tamanho da tela.

Em termos de latência, o custo é principalmente esperar pelo callback do OS para fornecer
ao Flutter uma superfície de renderização e compilar os programas de shader restantes
que não são preventivamente previsíveis. Este é um custo único.

Quando o componente de UI Flutter é liberado, a memória relacionada à UI é liberada.
Isso não afeta o estado do Flutter, que vive no `FlutterEngine`
(a menos que o `FlutterEngine` também seja liberado).

Para detalhes de desempenho sobre criar mais de um `FlutterEngine`,
consulte [múltiplos Flutters][multiple Flutters].

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
