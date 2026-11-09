---
ia-translate: true
title: FAQ
description: Perguntas frequentes e respostas sobre Flutter.
showBreadcrumbs: false
---

## Introdução {:#introduction}

Esta página reúne perguntas comuns sobre o Flutter.
Você também pode conferir as seguintes FAQs especializadas:

* [Web FAQ][Web FAQ]
* [Performance FAQ][Performance FAQ]

[Performance FAQ]: /perf/faq
[Web FAQ]: /platform-integration/web/faq

### O que é Flutter? {:#what-is-flutter}

Flutter é o framework open source do Google
para criar aplicações lindas e compiladas nativamente
para mobile (iOS, Android), web, desktop (macOS, Windows, Linux)
e dispositivos embarcados a partir de uma única base de código.
Flutter funciona com código existente,
é usado por desenvolvedores e organizações ao redor do mundo,
e é gratuito e open source.

### Para quem é o Flutter? {:#who-is-flutter-for}

Para desenvolvedores, Flutter acelera o desenvolvimento de apps
e reduz o custo e a complexidade de construir para várias plataformas.

Para designers, Flutter fornece uma tela flexível
para experiências de usuário de alta qualidade.
Ele transforma conceitos em código de produção
sem os compromissos impostos por frameworks multiplataforma tradicionais.

Para gerentes de engenharia e empresas,
Flutter permite a unificação de desenvolvedores de apps em uma única equipe,
construindo apps com marca para múltiplas plataformas a partir de uma única base de código.
Flutter acelera o desenvolvimento de recursos e sincroniza cronogramas de lançamento
em toda a sua base de clientes.

### Quanta experiência de desenvolvimento eu preciso para usar Flutter? {:#how-much-development-experience-do-i-need-to-use-flutter}

Flutter é acessível para programadores familiarizados com conceitos de
orientação a objetos e de programação imperativa ou declarativa.
Experiência com linguagens como Java, Kotlin, Swift, TypeScript
ou C# ajuda você a aprender Dart e Flutter rapidamente.

### Que tipos de apps eu posso construir com Flutter? {:#what-kinds-of-apps-can-i-build-with-flutter}

Flutter suporta a criação de apps mobile no Android e iOS,
aplicações web, apps desktop no macOS, Windows e Linux,
e interfaces para dispositivos embarcados.

Apps que exigem designs personalizados e com marca são adequados para Flutter.
Você também pode criar experiências pixel-perfect que combinam com
as linguagens de design Material Design do Android e Cupertino do iOS.

O [ecossistema de packages][package ecosystem] do Flutter no pub.dev suporta uma ampla variedade de hardware
(como câmera, GPS, Bluetooth, rede e armazenamento local)
e serviços em nuvem (como autenticação, notificações, pagamentos e armazenamento).

[package ecosystem]: {{site.pub}}/flutter

### Quem faz Flutter? {:#who-makes-flutter}

Flutter é um projeto open source gerenciado pelo Google,
com contribuições de uma comunidade global de desenvolvedores,
empresas e indivíduos.

### Quem usa Flutter? {:#who-uses-flutter}

Desenvolvedores e organizações ao redor do mundo usam Flutter para construir
aplicações compiladas nativamente.
Para explorar apps construídos com Flutter, visite a [vitrine][showcase].

[showcase]: {{site.main-url}}/showcase

### O que torna Flutter único? {:#what-makes-flutter-unique}

Flutter é diferente da maioria das alternativas multiplataforma
porque não depende de views de navegador web
nem de widgets de plataforma fornecidos pelo sistema.
Em vez disso, Flutter renderiza sua UI usando seu próprio
motor de renderização de alta performance ([Impeller][]).

Além disso, Flutter implementa a maior parte de seu framework
(incluindo composição, gestos, animação e widgets) em [Dart][Dart].
Essa arquitetura dá a você controle profundo sobre a UI,
alta previsibilidade e a capacidade de inspecionar ou modificar
o framework em qualquer nível.

[Dart]: {{site.dart-site}}/
[Impeller]: /perf/impeller

### Devo construir meu próximo app de produção com Flutter? {:#should-i-build-my-next-production-app-with-flutter}

Sim. Milhares de organizações, desde startups em estágio inicial
até grandes empresas, implantam apps Flutter em produção
para centenas de milhões de usuários.
Explore exemplos do mundo real na [vitrine][showcase].

Flutter lança atualizações em uma cadência regular,
trazendo melhorias de desempenho, novos recursos
e atualizações de plataforma para o canal stable.

## O que Flutter fornece? {:#what-does-flutter-provide}

### O que está dentro do Flutter SDK? {:#what-is-inside-the-flutter-sdk}

O Flutter SDK inclui:

* Motor de renderização 2D de alta performance ([Impeller][])
* Framework moderno e reativo escrito em Dart
* Rico conjunto de widgets implementando Material Design 3 e Cupertino (estilo iOS)
* APIs para testes unitários, de widget e de integração
* APIs de interop e plugin para conectar a recursos do sistema e SDKs nativos
* Test runner headless para executar testes no Windows, Linux e macOS
* [Flutter DevTools][Flutter DevTools] para fazer profiling, depurar e inspecionar seu app
* Ferramentas de linha de comando para criar, compilar, testar e compilar apps

[Flutter DevTools]: /tools/devtools

### Flutter funciona com quaisquer editores ou IDEs? {:#does-flutter-work-with-any-editors-or-ides}

O Flutter fornece plugins e extensões para [VS Code][VS Code],
[Antigravity][] (uma IDE assistida por IA), [Android Studio][Android Studio],
e [IntelliJ IDEA][IntelliJ IDEA].
Veja [configuração de editor][editor configuration] para detalhes de configuração,
e [VS Code][VS Code] e [Android Studio/IntelliJ][Android Studio/IntelliJ] para orientações de uso.

Você também pode executar o comando `flutter` a partir de um terminal
junto com qualquer editor que suporte [edição de Dart][editing Dart].

[Android Studio]: {{site.android-dev}}/studio
[Android Studio/IntelliJ]: /tools/android-studio
[Antigravity]: /ai/get-started
[editing Dart]: {{site.dart-site}}/tools
[editor configuration]: /tools/editors
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[VS Code]: https://code.visualstudio.com/

### Flutter vem com um framework? {:#does-flutter-come-with-a-framework}

Sim. Flutter inclui um framework moderno e reativo.
O framework é em camadas e customizável,
permitindo que você use widgets de alto nível ou interaja diretamente
com camadas inferiores do pipeline de renderização.

### Flutter vem com widgets? {:#does-flutter-come-with-widgets}

Sim. Flutter vem com uma coleção de
[widgets Material Design e Cupertino (estilo iOS)][widgets] de alta qualidade,
layouts e temas.
Você pode usar esses widgets como são fornecidos,
customizá-los ou criar widgets personalizados.

[widgets]: /ui/widgets

### Flutter suporta Material Design? {:#does-flutter-support-material-design}

Sim. Flutter fornece suporte completo ao [Material Design 3][widget catalog],
o sistema de design do Google.

[widget catalog]: /ui/widgets/material

### Flutter vem com um framework de testes? {:#does-flutter-come-with-a-testing-framework}

Sim. Flutter fornece suporte integrado para testes unitários, de widget
e de integração.
Para saber mais, veja [Visão geral de testes][Testing overview].

[Testing overview]: /testing/overview

### Flutter vem com ferramentas de depuração? {:#does-flutter-come-with-debugging-tools}

Sim. Flutter inclui o [Flutter DevTools][Flutter DevTools].
Para mais informações, veja [Depurando apps Flutter][Debugging Flutter apps]
e a documentação do [Flutter DevTools][Flutter DevTools].

[Debugging Flutter apps]: /testing/debugging

### Flutter vem com um framework de injeção de dependência? {:#does-flutter-come-with-a-dependency-injection-framework}

Flutter não exige um framework opinativo de injeção de dependência.
O ecossistema Flutter oferece vários packages para injeção de dependência
e localização de serviços, como [Riverpod][], [get_it][get_it],
[Provider][] e [injectable][injectable].

[get_it]: {{site.pub}}/packages/get_it
[injectable]: {{site.pub}}/packages/injectable
[Provider]: {{site.pub}}/packages/provider
[Riverpod]: {{site.pub}}/packages/riverpod

## Tecnologia {:#technology}

### Com qual tecnologia Flutter é construído? {:#what-technology-is-flutter-built-with}

Flutter é construído com C, C++ e Dart.
Ele usa o [Impeller][Impeller] como seu motor de renderização padrão,
aproveitando APIs gráficas modernas como Metal no iOS e macOS,
e Vulkan no Android.
Para uma descrição detalhada da arquitetura em camadas do Flutter,
leia a [visão geral arquitetural][architectural overview].

[architectural overview]: /resources/architectural-overview

### Como Flutter executa meu código no Android? {:#run-android}

O código C e C++ do motor é compilado usando o NDK do Android.
O código Dart (tanto do framework quanto o código da sua aplicação)
é compilado ahead-of-time (AOT) em código de máquina nativo.
Essas bibliotecas são empacotadas em um projeto Android "runner"
e compiladas em um APK ou Android App Bundle (AAB).
Quando lançado, o app carrega o motor Flutter,
que executa o código compilado e renderiza a UI.

Durante o modo debug, Flutter roda dentro da VM Dart
para habilitar o [hot reload][Hot reload] stateful,
permitindo que você faça alterações no seu código em execução sem recompilar.
Um banner "debug" no canto superior direito indica
que o app está rodando em modo debug.

### Como Flutter executa meu código no iOS? {:#run-ios}

O código C e C++ do motor é compilado com LLVM.
O código Dart (tanto do framework quanto o código da sua aplicação)
é compilado ahead-of-time (AOT) em código de máquina ARM nativo.
O código compilado é empacotado em um projeto iOS "runner"
e compilado em um bundle `.ipa`.
Quando lançado, o app carrega o motor Flutter,
que executa o código compilado e renderiza a UI usando o Impeller.

Durante o modo debug, Flutter roda dentro da VM Dart
para habilitar o [hot reload][Hot reload] stateful.
Um banner "debug" no canto superior direito indica
que o app está rodando em modo debug.

### Flutter usa os widgets de plataforma integrados do meu sistema operacional? {:#does-flutter-use-my-operating-systems-built-in-platform-widgets}

Não. Em vez disso, Flutter renderiza widgets diretamente usando seu próprio motor,
fornecendo implementações de widgets Material Design e Cupertino (estilo iOS).
Você pode explorar os widgets disponíveis no [catálogo de widgets][catalog of Flutter's widgets].

Ao renderizar pixels diretamente, Flutter evita as limitações de desempenho
e as diferenças de comportamento das abstrações de widgets de plataforma.
Essa abordagem entrega desempenho e aparência consistentes entre plataformas.

Para casos em que você precisa de um componente nativo da plataforma
(como Google Maps ou uma web view),
Flutter suporta incorporar [platform views][] diretamente na árvore de widgets.

[catalog of Flutter's widgets]: /ui/widgets
[platform views]: /platform-integration/platform-views

### O que acontece quando meu SO mobile atualiza e introduz novos widgets? {:#what-happens-when-my-mobile-os-updates-and-introduces-new-widgets}

A equipe Flutter e a comunidade acompanham novas diretrizes de design
e widgets de plataforma da Apple e do Google,
atualizando as bibliotecas de widgets do Flutter de acordo.
Como os widgets Flutter são escritos em Dart,
você também pode construir ou adaptar widgets imediatamente
sem esperar por uma atualização do SO ou do SDK.

### O que acontece quando meu SO mobile atualiza e introduz novas capacidades de plataforma? {:#what-happens-when-my-mobile-os-updates-and-introduces-new-platform-capabilities}

A arquitetura de plugins do Flutter, os [platform channels][platform channels]
e as ferramentas de interop nativo (como Dart FFI, `ffigen` e `jnigen`)
permitem que você acesse novas APIs do SO imediatamente.
Você não precisa esperar por um lançamento do Flutter SDK para integrar novas capacidades da plataforma.

[platform channels]: /platform-integration/platform-channels

### Flutter suporta code push? {:#does-flutter-support-code-push}

Flutter não fornece funcionalidade de code push integrada.
Soluções de terceiros, como o [Shorebird][Shorebird],
fornecem suporte a code push para aplicações Flutter.

[Shorebird]: https://shorebird.dev/

### Quais sistemas operacionais posso usar para construir um app Flutter? {:#what-operating-systems-can-i-use-to-build-a-flutter-app}

Flutter suporta desenvolvimento no macOS, Windows, Linux e ChromeOS.
Para detalhes sobre requisitos de sistema, veja o [guia de instalação][install].

[install]: /install

### Em qual linguagem Flutter é escrito? {:#what-language-is-flutter-written-in}

O framework Flutter é escrito em [Dart][Dart].
O motor subjacente e o pipeline gráfico são implementados em C e C++.

### Por que Flutter escolheu usar Dart? {:#why-did-flutter-choose-to-use-dart}

Durante o desenvolvimento inicial, a equipe Flutter avaliou várias linguagens
e runtimes antes de selecionar Dart para o framework e os widgets.
Dart obteve a maior pontuação em vários critérios-chave de avaliação:

_Produtividade do desenvolvedor_
: Dart suporta tanto compilação JIT (Just-in-Time) para desenvolvimento rápido
  com hot reload stateful, quanto compilação AOT (Ahead-of-Time)
  para código de máquina nativo eficiente em produção.
  Como o framework é escrito em Dart,
  desenvolvedores podem inspecionar, depurar e modificar toda a stack.

_Orientação a objetos e composição de UI_
: A estrutura orientada a objetos do Dart atende aos requisitos
  de construir interfaces de usuário composáveis sem exigir uma linguagem de marcação separada.

_Desempenho previsível e alto_
: Dart compila diretamente para código de máquina nativo sem um interpretador ou bridge,
  entregando taxas de quadros consistentes sem pausas imprevisíveis em tempo de execução.

_Alocação rápida de memória_
: O framework reativo do Flutter cria muitos objetos de curta duração.
  O coletor de lixo geracional do Dart é otimizado
  para alocação e limpeza rápidas de objetos efêmeros.

### Flutter pode executar qualquer código Dart? {:#can-flutter-run-any-dart-code}

Flutter pode executar qualquer código Dart que não dependa de bibliotecas
indisponíveis na plataforma alvo.
Por exemplo, apps mobile e desktop não podem importar bibliotecas específicas da web,
e apps web não podem usar `dart:io`.

### Como Flutter compila para a web? {:#how-does-flutter-compile-for-the-web}

Flutter compila Dart para a web tanto para JavaScript quanto para WebAssembly (Wasm).
A compilação para WebAssembly (WasmGC) entrega renderização de alta performance
comparável a apps nativos desktop e mobile.
Para detalhes, veja a [documentação do Flutter web][web].

[web]: /platform-integration/web

### Qual o tamanho do motor Flutter? {:#how-big-is-the-flutter-engine}

Uma aplicação Flutter mínima de release inclui o motor Flutter,
o framework e o código da sua aplicação.
O motor adiciona uma pequena pegada base (alguns megabytes comprimidos),
que varia de acordo com a plataforma e arquitetura alvo.

O tamanho do app é determinado em grande parte pelos assets incluídos, fontes
e packages de terceiros.
Para analisar e minimizar o tamanho da sua aplicação,
veja [Medindo o tamanho do seu app][Measuring your app's size].

[Measuring your app's size]: /perf/app-size

### Como Flutter define um pixel? {:#how-does-flutter-define-a-pixel}

Flutter usa pixels lógicos,
que correspondem aproximadamente a pixels físicos em uma tela de densidade padrão.
Flutter mapeia automaticamente pixels lógicos para pixels físicos do dispositivo
com base no [`devicePixelRatio`][`devicePixelRatio`] da view.

[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html

## Capacidades {:#capabilities}

### Que tipo de desempenho de app posso esperar? {:#what-kind-of-app-performance-can-i-expect}

Flutter foi projetado para entregar animações suaves a 60fps e 120fps.
Apps Flutter compilam diretamente para código de máquina nativo ou WebAssembly,
eliminando a sobrecarga de interpretadores.
Para saber mais sobre otimização de desempenho, veja a [Performance FAQ][Performance FAQ].

### Que tipo de ciclos de desenvolvedor posso esperar? Quanto tempo entre editar e atualizar? {:#hot-reload}

Flutter implementa um ciclo de desenvolvedor de _hot reload_ stateful.
Você pode esperar tempos de reload abaixo de um segundo em dispositivos físicos,
emuladores e simuladores.

O hot reload preserva o estado da sua aplicação,
permitindo que você itere rapidamente sem precisar navegar de volta
para a tela atual após cada alteração de código.

### Como hot reload é diferente de hot restart? {:#how-is-hot-reload-different-from-hot-restart}

O hot reload injeta arquivos de código-fonte atualizados na VM Dart em execução
sem limpar o estado da aplicação.
O hot restart reseta o estado da aplicação e executa novamente `main()`,
o que leva um pouco mais de tempo que o hot reload, mas continua sendo mais rápido
do que uma recompilação completa.

Para mais informações, veja [Hot reload][Hot reload].

[Hot reload]: /tools/hot-reload

### Onde posso fazer deploy do meu app Flutter? {:#where-can-i-deploy-my-flutter-app}

Você pode compilar e fazer deploy de apps Flutter para iOS, Android,
[web][web], [desktop][desktop] (macOS, Windows, Linux) e dispositivos embarcados.

[desktop]: /platform-integration/desktop

### Em quais dispositivos e versões de SO Flutter roda? {:#what-devices-and-os-versions-does-flutter-run-on}

Flutter suporta uma ampla gama de sistemas operacionais e plataformas de hardware:

* Mobile: Android (ARM32, ARM64, x86_64) e iOS (ARM64).
* Desktop: macOS (x86_64, ARM64), Windows (x86_64, ARM64) e Linux (x86_64, ARM64).
* Web: navegadores modernos que suportam WebAssembly ou JavaScript.

Para a lista completa de versões de SO suportadas,
veja [Plataformas suportadas][Supported platforms].

[Supported platforms]: /reference/supported-platforms

### Flutter roda na web? {:#does-flutter-run-on-the-web}

Sim. O suporte web do Flutter está disponível no canal stable
e suporta compilação tanto para WebAssembly (Wasm) quanto para JavaScript.
Para mais detalhes, veja [Suporte web para Flutter][web].

### Posso usar Flutter para construir apps desktop? {:#can-i-use-flutter-to-build-desktop-apps}

Sim. O suporte desktop está disponível no canal stable
para macOS, Windows e Linux.
Para detalhes, veja [Suporte desktop para Flutter][desktop].

### Posso usar Flutter dentro do meu app nativo existente? {:#can-i-use-flutter-inside-of-my-existing-native-app}

Sim. Você pode integrar o Flutter em aplicações Android e iOS existentes
usando [Add-to-App][add-to-app].

[add-to-app]: /add-to-app

### Posso acessar serviços e APIs de plataforma como sensores e armazenamento local? {:#can-i-access-platform-services-and-apis-like-sensors-and-local-storage}

Sim. Flutter fornece acesso a APIs e hardware específicos de plataforma
por meio de plugins disponíveis no [pub.dev][ready-made packages].
Você também pode criar integrações personalizadas usando [platform channels][platform channels]
ou interop nativo (Dart FFI).

[ready-made packages]: {{site.pub}}/flutter/

### Posso estender e customizar os widgets empacotados? {:#can-i-extend-and-customize-the-bundled-widgets}

Sim. O sistema de widgets do Flutter é construído em torno da composição.
Em vez de criar subclasses de widgets complexos,
você compõe widgets menores e de propósito único para criar designs personalizados.
Essa arquitetura fornece controle sobre layout, pintura
e tratamento de gestos.

### Por que eu gostaria de compartilhar código de layout entre iOS e Android? {:#why-would-i-want-to-share-layout-code-across-ios-and-android}

Compartilhar código de layout e de UI reduz o esforço de engenharia,
mantém os lançamentos de recursos sincronizados
e garante uma experiência de marca consistente entre plataformas.
Quando você quiser comportamento ou estilo específico de plataforma,
pode adaptar a UI usando verificações de plataforma ou layouts responsivos.

### Posso fazer interop com a linguagem de programação padrão da minha plataforma mobile? {:#can-i-interop-with-my-mobile-platforms-default-programming-language}

Sim. Flutter suporta chamar código nativo em todas as plataformas suportadas:

* No Android: Kotlin e Java via [platform channels][platform channels] e [interop com JNI][JNI interop] (`jnigen`).
* No iOS e macOS: Swift e Objective-C via [platform channels][platform channels] e [interop com Objective-C/Swift][Objective-C/Swift interop] (`ffigen`).
* No desktop e mobile: C e C++ via Dart FFI ([`dart:ffi`][]).

[JNI interop]: {{site.dart-site}}/interop/java-interop
[Objective-C/Swift interop]: {{site.dart-site}}/interop/objective-c-interop
[`dart:ffi`]: {{site.dart-site}}/interop/c-interop

### Flutter vem com um sistema de reflection / mirrors? {:#does-flutter-come-with-a-reflection-mirrors-system}

Não. Dart desabilita `dart:mirrors` no Flutter para permitir compilação
ahead-of-time (AOT) agressiva e eliminação de código morto (tree shaking).
Isso mantém os binários pequenos e os tempos de inicialização rápidos.
Para inspeção de metadados e serialização,
aplicações Flutter usam geração de código em tempo de compilação.

### Internacionalização e localização são suportadas? {:#are-internationalization-and-localization-supported}

Sim. Flutter fornece suporte integrado a internacionalização (i18n)
e localização (l10n),
incluindo pluralização, texto bidirecional e formatação de datas.
Para saber mais, veja [Internacionalizando apps Flutter][internationalization documentation].

[internationalization documentation]: /ui/internationalization

### Qual acessibilidade é suportada? {:#what-accessibility-is-supported}

Flutter suporta recursos padrão de acessibilidade (a11y),
incluindo leitores de tela (TalkBack, VoiceOver), escalonamento de texto grande,
temas de alto contraste e acesso por switch de hardware.
Para detalhes, veja [Acessibilidade][accessibility documentation].

[accessibility documentation]: /ui/accessibility

### Como escrevo apps paralelos e/ou concorrentes para Flutter? {:#how-do-i-write-parallel-andor-concurrent-apps-for-flutter}

Dart usa um event loop para operações assíncronas (`Future` e `Stream`).
Para tarefas que exigem muito da CPU, Flutter suporta isolates — threads de execução
isoladas com heaps de memória independentes que se comunicam por meio de troca de mensagens.
Você pode usar [`Isolate.run()`][] ou a função [`compute()`][]
para executar computações pesadas em segundo plano.

[`Isolate.run()`]: {{site.api}}/flutter/dart-isolate/Isolate/run.html
[`compute()`]: {{site.api}}/flutter/foundation/compute.html

### Posso executar código Dart em background de um app Flutter? {:#can-i-run-dart-code-in-the-background-of-a-flutter-app}

Sim. Você pode executar código Dart em processos em segundo plano no Android e iOS
usando packages de execução em segundo plano e integrações com serviços da plataforma.

### Posso usar JSON, XML ou Protocol Buffers com Flutter? {:#can-i-use-json-xml-or-protocol-buffers-with-flutter}

Sim. O ecossistema Dart fornece packages no [pub.dev][pub.dev]
para serialização JSON, parsing de XML, Protocol Buffers
e outros formatos de dados.
Para detalhes sobre como trabalhar com JSON, veja [JSON e serialização][JSON tutorial].

[JSON tutorial]: /data-and-backend/serialization/json
[pub.dev]: {{site.pub}}

### Posso construir apps 3D com Flutter? {:#can-i-build-3d-apps-with-flutter}

Sim. Flutter suporta gráficos 3D por meio do Flutter GPU
e de packages como `flutter_scene`,
que usam o backend de renderização Impeller para desenhar cenas 3D.
Você também pode incorporar views 3D de terceiros (como Unity ou motores 3D nativos)
usando platform views.

### Por que meu APK ou IPA é tão grande? {:#why-is-my-apk-or-ipa-so-big}

O tamanho do bundle do app inclui o motor Flutter, o código do framework,
a lógica da aplicação e os assets incluídos (como imagens, fontes e áudio).
Sempre crie um build de release (`flutter build apk` ou `flutter build appbundle`
para Android, e `flutter build ipa` para iOS),
que remove símbolos de debug e habilita otimizações do compilador.
Para analisar e reduzir o tamanho do app, veja [Medindo o tamanho do seu app][Measuring your app's size].

### Flutter é compatível com ABI? {:#is-flutter-abi-compatible}

Flutter e Dart não fornecem compatibilidade de interface binária de aplicação (ABI)
entre diferentes versões do compilador.
Sempre compile sua aplicação usando versões correspondentes do SDK.

### Como Flutter lida com rolagem? {:#how-does-flutter-handle-scrolling}

Flutter fornece física de rolagem específica de cada plataforma
que corresponde ao comportamento de rolagem nativo de cada plataforma
(como rolagem com momento no iOS e efeito de esticar ao ultrapassar o limite no Android).
Para mais detalhes, veja a documentação de [rolagem][scrolling].

[scrolling]: /ui/layout/scrolling

## Framework

### Por que o método build() está em State, em vez de StatefulWidget? {:#why-is-the-build-method-on-state-rather-than-statefulwidget}

Colocar o método `Widget build(BuildContext context)` em `State`
em vez de `StatefulWidget` fornece maior flexibilidade
ao criar subclasses de `StatefulWidget` e gerenciar o estado do ciclo de vida.
Para uma explicação detalhada, veja a [documentação da API para `State.build`][API documentation for `State.build`].

[API documentation for `State.build`]: {{site.api}}/flutter/widgets/State/build.html

### Onde está a linguagem de marcação do Flutter? Por que Flutter não tem uma sintaxe de marcação? {:#where-is-flutters-markup-language-why-doesnt-flutter-have-a-markup-syntax}

UIs Flutter são definidas em código Dart em vez de uma linguagem de marcação declarativa.
Definir a UI em código permite:

* Desenvolvimento rápido com hot reload stateful.
* Acesso completo aos recursos da linguagem de programação (loops, condicionais, funções).
* Forte segurança de tipos e verificações do compilador.
* Fácil refatoração e reutilização de código entre widgets.

Como os métodos build são código padrão,
você também pode criar widgets dinamicamente a partir de dados ou configurações externas.

### Meu app tem um banner Debug no canto superior direito. Por que estou vendo isso? {:#my-app-has-a-debug-banner-in-the-upper-right-why-am-i-seeing-that}

Por padrão, `flutter run` lança o app em modo debug.
A configuração de build debug executa o código dentro da VM Dart
para habilitar o [hot reload][Hot reload] stateful,
e habilita asserções em tempo de execução para pegar erros cedo.
O banner "Debug" indica que essas verificações estão ativas.

Para executar sem asserções e com desempenho otimizado,
execute o app em modo release usando `flutter run --release`
ou compile um binário de release.

### Qual paradigma de programação o framework do Flutter usa? {:#what-programming-paradigm-does-flutters-framework-use}

Flutter usa uma combinação de paradigmas de programação,
aplicando cada um onde é mais eficaz:

**Composição**
: O paradigma primário no Flutter é compor widgets pequenos
  e de propósito único em interfaces de usuário complexas.
  Por exemplo, o widget [`TextButton`][`TextButton`] do Material é composto por
  um [`IconTheme`][`IconTheme`], um [`InkWell`][`InkWell`], um [`Padding`][`Padding`],
  um [`Center`][`Center`], um [`Material`][`Material`],
  um [`AnimatedDefaultTextStyle`][`AnimatedDefaultTextStyle`] e um [`ConstrainedBox`][`ConstrainedBox`].

**Programação funcional**
: Aplicações podem definir a UI usando instâncias de [`StatelessWidget`][`StatelessWidget`],
  que atuam como funções que mapeiam entradas de configuração para widgets filhos.
  Flutter usa estruturas de dados imutáveis em toda a sua hierarquia de widgets,
  incluindo [`Widget`][`Widget`], [`TextStyle`][`TextStyle`] e [`Rect`][`Rect`].

**Programação orientada a eventos**
: Interações do usuário são representadas por objetos de evento
  despachados para callbacks registrados em widgets.
  Classes como [`Listenable`][`Listenable`] formalizam modelos de assinatura de eventos.

**Programação orientada a objetos baseada em classes**
: As APIs do framework usam herança para especializar comportamentos.
  Por exemplo, [`RenderBox`][`RenderBox`] estende [`RenderObject`][`RenderObject`]
  para estabelecer um sistema de coordenadas cartesiano para layout 2D.

**Programação orientada a objetos baseada em protótipos**
: A classe [`ScrollPhysics`][`ScrollPhysics`] encadeia instâncias para compor
  a física de rolagem dinamicamente em tempo de execução.

**Programação imperativa**
: Código imperativo gerencia estado encapsulado e a execução de testes,
  onde a lógica passo a passo é mais clara.

**Programação reativa**
: Parâmetros de construtor propagam mudanças para baixo na árvore de widgets,
  e interações do usuário disparam atualizações de volta para cima na árvore por meio de callbacks.
  Mudanças de estado agendam reconstruções das subárvores afetadas.

**Programação declarativa**
: Os métodos `build` dos widgets descrevem o estado desejado da UI de forma declarativa,
  deixando as atualizações de layout e renderização para o framework.

**Programação genérica**
: Tipos genéricos garantem a segurança de tipos em todo o framework,
  como parametrizar [`State<T>`][] com seu tipo de widget
  e [`GlobalKey<T>`][] com seu tipo de estado.

**Programação concorrente**
: Flutter usa [`Future`][`Future`] e [`Stream`][] para operações assíncronas,
  e isolates para computação paralela em segundo plano.

**Programação de restrições**
: O sistema de layout usa restrições de caixa (largura e altura mínimas e máximas)
  passadas de pai para filho para calcular a geometria em uma única passagem.

[`AnimatedDefaultTextStyle`]: {{site.api}}/flutter/widgets/AnimatedDefaultTextStyle-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`ConstrainedBox`]: {{site.api}}/flutter/widgets/ConstrainedBox-class.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`GlobalKey<T>`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`IconTheme`]: {{site.api}}/flutter/widgets/IconTheme-class.html
[`InkWell`]: {{site.material_ui}}/InkWell-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`Material`]: {{site.material_ui}}/Material-class.html
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[`Rect`]: {{site.api}}/flutter/dart-ui/Rect-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[`ScrollPhysics`]: {{site.api}}/flutter/widgets/ScrollPhysics-class.html
[`State<T>`]: {{site.api}}/flutter/widgets/State-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`Stream`]: {{site.api}}/flutter/dart-async/Stream-class.html
[`TextButton`]: {{site.material_ui}}/TextButton-class.html
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[`Widget`]: {{site.api}}/flutter/widgets/Widget-class.html

## Projeto {:#project}

### Onde posso obter suporte? {:#where-can-i-get-support}

Para reportar bugs ou solicitar recursos, registre uma issue no
[issue tracker do Flutter][issue tracker].

Para discussões da comunidade, solução de problemas e conselhos:

* Junte-se ao [Discord do Flutter][Discord].
* Faça perguntas no [Stack Overflow][Stack Overflow] usando a tag `flutter`.
* Participe de discussões no [Reddit r/FlutterDev][Reddit].
* Visite a página [Community][Community] para recursos adicionais.

[Community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/rflutterdev
[issue tracker]: {{site.repo.flutter}}/issues
[Reddit]: https://www.reddit.com/r/FlutterDev/
[Stack Overflow]: {{site.so}}/tags/flutter

### Como me envolvo? {:#how-do-i-get-involved}

Flutter é open source, e contribuições são bem-vindas.
Você pode ajudar:

* Reportando bugs e solicitações de recursos no [issue tracker][issue tracker].
* Contribuindo com código e documentação seguindo o [guia de Contribuição][Contributing guide].
* Fazendo triagem de issues ou ajudando outros desenvolvedores no [Discord][Discord] e no [Stack Overflow][Stack Overflow].

[Contributing guide]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md

### Flutter é open source? {:#is-flutter-open-source}

Sim. Flutter é open source e está disponível sob a
licença BSD 3-Clause no [GitHub][GitHub].

[GitHub]: {{site.repo.flutter}}

### Quais licenças de software se aplicam ao Flutter e suas dependências? {:#which-software-licenses-apply-to-flutter-and-its-dependencies}

Flutter inclui dois componentes principais:
o motor (binário compilado com dependências)
e o framework (código-fonte Dart).

* O framework é licenciado sob a [licença BSD 3-Clause][only one license].
* O motor usa dependências open source listadas em seu [arquivo de licença][license file].
* Packages Dart no pub.dev especificam suas próprias licenças individuais.

[license file]: {{site.repo.flutter}}/blob/main/engine/src/flutter/sky/packages/sky_engine/LICENSE
[only one license]: {{site.repo.flutter}}/blob/main/LICENSE

### Como posso determinar as licenças que meu aplicativo Flutter precisa mostrar? {:#how-can-i-determine-the-licenses-my-flutter-application-needs-to-show}

Flutter fornece APIs integradas para exibir licenças open source:

* Se sua aplicação usa um `Drawer`, adicione um [`AboutListTile`][`AboutListTile`].
* Se sua aplicação usa Material Design, chame [`showAboutDialog`][`showAboutDialog`]
  ou [`showLicensePage`][`showLicensePage`].
* Para apresentações personalizadas, acesse as licenças brutas a partir do [`LicenseRegistry`][`LicenseRegistry`].

[`AboutListTile`]: {{site.material_ui}}/AboutListTile-class.html
[`LicenseRegistry`]: {{site.api}}/flutter/foundation/LicenseRegistry-class.html
[`showAboutDialog`]: {{site.material_ui}}/showAboutDialog.html
[`showLicensePage`]: {{site.material_ui}}/showLicensePage.html

### Quem trabalha no Flutter? {:#who-works-on-flutter}

Flutter é desenvolvido por engenheiros do Google junto com
centenas de colaboradores open source ao redor do mundo.
Para se juntar à comunidade, veja [contribuir para o Flutter][contribute to Flutter].

[contribute to Flutter]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md

### Quais são os princípios orientadores do Flutter? {:#what-are-flutters-guiding-principles}

Flutter é construído em torno de três princípios fundamentais:

_Controle_
: Desenvolvedores têm acesso completo e controle sobre todas as camadas do sistema.

_Desempenho_
: Aplicações entregam experiências fluidas, responsivas e sem travamentos.

_Fidelidade_
: Aplicações alcançam experiências de usuário lindas e pixel-perfect em todas as plataformas.

### A Apple ou o Google vão rejeitar meu app Flutter? {:#will-apple-or-google-reject-my-flutter-app}

Não. Milhares de apps Flutter são publicados, aprovados e destacados
na Apple App Store e na Google Play Store.
Como com qualquer aplicação, certifique-se de que seu app está em conformidade com as
[App Store Review Guidelines][guidelines] da Apple
e com as Políticas do Programa para Desenvolvedores do Google Play.

[guidelines]: {{site.apple-dev}}/app-store/review/guidelines/
