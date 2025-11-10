---
ia-translate: true
title: FAQ
description: Perguntas frequentes e respostas sobre Flutter.
showBreadcrumbs: false
---

## Introdução

Esta página reúne algumas perguntas comuns sobre
Flutter. Você também pode conferir as seguintes
FAQs especializadas:

* [Web FAQ][Web FAQ]
* [Performance FAQ][Performance FAQ]

[Web FAQ]: /platform-integration/web/faq
[Performance FAQ]: /perf/faq

### O que é Flutter?

Flutter é o toolkit de UI portátil do Google para criar aplicações
lindas e compiladas nativamente para mobile, web
e desktop a partir de uma única base de código.
Flutter funciona com código existente,
é usado por desenvolvedores e organizações ao redor
do mundo, e é gratuito e open source.

### Para quem é o Flutter?

Para usuários, Flutter dá vida a apps lindos.

Para desenvolvedores, Flutter reduz a barreira de entrada para construir apps.
Ele acelera o desenvolvimento de apps e reduz o custo e a complexidade
da produção de apps em várias plataformas.

Para designers, Flutter fornece uma tela para
experiências de usuário de alta qualidade. A Fast Company descreveu
Flutter como [uma das principais ideias de design da década][one of the top design ideas of the decade] por
sua capacidade de transformar conceitos em código de produção
sem os compromissos impostos por frameworks típicos.
Ele também funciona como uma ferramenta produtiva de prototipagem
com ferramentas drag-and-drop como [FlutterFlow][FlutterFlow]
e IDEs baseadas na web como [Zapp!][Zapp!].

Para gerentes de engenharia e empresas,
Flutter permite a unificação de desenvolvedores
de apps em uma única _equipe de apps mobile, web
e desktop_, construindo apps com marca
para múltiplas plataformas a partir de uma única base de código.
Flutter acelera o desenvolvimento de recursos e sincroniza
cronogramas de lançamento em toda a base de clientes.

[FlutterFlow]: https://flutterflow.io/
[Zapp!]: https://zapp.run/
[one of the top design ideas of the decade]: https://www.fastcompany.com/90442092/the-14-most-important-design-ideas-of-the-decade-according-to-the-experts

### Quanta experiência de desenvolvimento eu preciso para usar Flutter?

Flutter é acessível para programadores familiarizados com
conceitos de orientação a objetos (classes, métodos, variáveis,
etc) e conceitos de programação imperativa (loops,
condicionais, etc).

Nós vimos pessoas com muito pouca experiência de programação
aprender e usar Flutter para prototipagem
e desenvolvimento de apps.

### Que tipos de apps eu posso construir com Flutter?

Flutter foi projetado para suportar apps mobile que rodam
tanto em Android quanto em iOS, assim como apps interativos
que você deseja executar em suas páginas web ou no desktop.

Apps que precisam entregar designs altamente personalizados
são particularmente adequados para Flutter.
No entanto, você também pode criar experiências pixel-perfect
que combinam com as linguagens de design do Android e iOS com Flutter.

O [ecossistema de packages][package ecosystem] do Flutter suporta uma ampla
variedade de hardware (como câmera, GPS, rede
e armazenamento) e serviços (como pagamentos, armazenamento
em nuvem, autenticação e [anúncios][ads]).

[ads]: {{site.main-url}}/monetization
[package ecosystem]: {{site.pub}}/flutter

### Quem faz Flutter?

Flutter é um projeto open source,
com contribuições do Google e de outras
empresas e indivíduos.

### Quem usa Flutter?

Desenvolvedores dentro e fora do Google usam
Flutter para construir apps lindos compilados nativamente
para iOS e Android. Para aprender sobre alguns
desses apps, visite a [vitrine][showcase].

[showcase]: {{site.main-url}}/showcase

### O que torna Flutter único?

Flutter é diferente da maioria das outras opções
para construir apps mobile porque não depende
de tecnologia de navegador web nem do conjunto de widgets
que vem com cada dispositivo. Em vez disso, Flutter usa
seu próprio motor de renderização de alta performance para desenhar widgets.

Além disso, Flutter é diferente porque tem apenas
uma fina camada de código C/C++. Flutter implementa
a maior parte de seu sistema (composição, gestos, animação,
framework, widgets, etc) em [Dart][Dart] (uma linguagem moderna,
concisa e orientada a objetos) que os desenvolvedores
podem facilmente ler, alterar, substituir ou remover.
Isso dá aos desenvolvedores tremendo controle sobre o sistema,
assim como reduz significativamente a barreira de acessibilidade
para a maior parte do sistema.

[Dart]: {{site.dart-site}}/

### Devo construir meu próximo app de produção com Flutter?

[Flutter 1][Flutter 1] foi lançado em 4 de dezembro de 2018,
[Flutter 2][Flutter 2] em 3 de março de 2021, e
[Flutter 3][Flutter 3] em 10 de maio de 2023.
Em maio de 2023, mais de _um milhão_ de apps foram distribuídos usando
Flutter para muitas centenas de milhões de dispositivos.
Confira alguns apps de exemplo na [vitrine][showcase].

Flutter distribui atualizações em uma cadência aproximadamente trimestral
que melhora estabilidade e performance
e atende recursos comumente solicitados pelos usuários.

[Flutter 1]: {{site.google-blog}}/2018/12/flutter-10-googles-portable-ui-toolkit.html
[Flutter 2]: {{site.google-blog}}/2021/03/announcing-flutter-2.html
[Flutter 3]: {{site.google-blog}}/flutter/introducing-flutter-3-5eb69151622f

## O que Flutter fornece?

### O que está dentro do Flutter SDK?

Flutter inclui:

* Motor de renderização 2D altamente otimizado e mobile-first
  com excelente suporte para texto
* Framework moderno estilo react
* Rico conjunto de widgets implementando Material Design e estilo iOS
* APIs para testes unitários e de integração
* APIs de interop e plugin para conectar ao sistema e SDKs de terceiros
* Test runner headless para executar testes no Windows, Linux e Mac
* [Flutter DevTools][Flutter DevTools] (também chamado Dart DevTools)
  para testar, depurar e fazer profiling do seu app
* Ferramentas de linha de comando para criar, compilar, testar e
  compilar seus apps

### Flutter funciona com quaisquer editores ou IDEs?

Fornecemos plugins para [VS Code][VS Code],
[Android Studio][Android Studio], e [IntelliJ IDEA][IntelliJ IDEA].
Veja [configuração de editor][editor configuration] para detalhes de configuração,
e [VS Code][VS Code] e [Android Studio/IntelliJ][Android Studio/IntelliJ]
para dicas sobre como usar os plugins.

[Firebase Studio][Firebase Studio], atualmente em preview,
é um workspace assistido por IA para desenvolvimento
de apps full-stack e multiplataforma na nuvem.
Firebase Studio suporta Dart e Flutter. Para mais informações,
confira [Começando com Firebase Studio][Get started with Firebase Studio].

[Firebase Studio]: https://firebase.studio/
[Get started with Firebase Studio]: https://firebase.google.com/docs/studio/get-started

Alternativamente, você pode usar o comando `flutter`
a partir de um terminal, junto com um
dos muitos editores que suportam [edição de Dart][editing Dart].


[Android Studio]: {{site.android-dev}}/studio
[Android Studio/IntelliJ]: /tools/android-studio
[editing Dart]: {{site.dart-site}}/tools
[editor configuration]: /tools/editors
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[VS Code]: https://code.visualstudio.com/

### Flutter vem com um framework?

Sim! Flutter vem com um framework moderno estilo react.
O framework do Flutter foi projetado para ser em camadas e
customizável (e opcional). Desenvolvedores podem escolher
usar apenas partes do framework, ou até substituir
completamente as camadas superiores do framework.

### Flutter vem com widgets?

Sim! Flutter vem com um conjunto de
[widgets de alta qualidade Material Design e Cupertino
(estilo iOS)][widgets], layouts e temas.
É claro que esses widgets são apenas um ponto de partida.
Flutter foi projetado para facilitar a criação de seus próprios
widgets, ou customizar os widgets existentes.

[widgets]: /ui/widgets

### Flutter suporta Material Design?

Sim! As equipes Flutter e Material colaboram estreitamente,
e Material é totalmente suportado. Para mais informações,
confira os widgets Material 2 e Material 3
no [catálogo de widgets][widget catalog].

[widget catalog]: /ui/widgets/material

### Flutter vem com um framework de testes?

Sim, Flutter fornece APIs para escrever testes unitários e
de integração. Saiba mais sobre [testes com Flutter][testing with Flutter].

Usamos nossas próprias capacidades de teste para testar nosso SDK,
e medimos nossa [cobertura de testes][test coverage] em cada commit.

[test coverage]: https://coveralls.io/github/flutter/flutter?branch=master
[testing with Flutter]: /testing/overview

### Flutter vem com ferramentas de depuração?

Sim, Flutter vem com [Flutter DevTools][Flutter DevTools] (também
chamado Dart DevTools). Para mais informações, veja
[Depurando com Flutter][Debugging with Flutter] e a documentação do [Flutter DevTools][Flutter DevTools].

[Debugging with Flutter]: /testing/debugging
[Flutter DevTools]: /tools/devtools

### Flutter vem com um framework de injeção de dependência?

Não distribuímos uma solução opinativa,
mas há uma variedade de packages que oferecem
injeção de dependência e localização de serviços,
como [injectable][injectable], [get_it][get_it], [kiwi][kiwi], e [riverpod][riverpod].


[get_it]: {{site.pub}}/packages/get_it
[injectable]: {{site.pub}}/packages/injectable
[kiwi]: {{site.pub}}/packages/kiwi
[riverpod]: {{site.pub}}/packages/riverpod

## Tecnologia

### Com qual tecnologia Flutter é construído?

Flutter é construído com C, C++, Dart,
Skia (um motor de renderização 2D),
e [Impeller][Impeller] (o motor de renderização padrão no iOS).
Veja este [diagrama de arquitetura][architecture diagram]
para uma melhor visão dos principais componentes.
Para uma descrição mais detalhada da arquitetura em camadas
do Flutter, leia a [visão geral arquitetural][architectural overview].

[architectural overview]: /resources/architectural-overview
[architecture diagram]: https://docs.google.com/presentation/d/1cw7A4HbvM_Abv320rVgPVGiUP2msVs7tfGbkgdrTy0I/edit#slide=id.gbb3c3233b_0_162
[Impeller]: /perf/impeller

### Como Flutter executa meu código no Android? {:#run-android}

O código C e C++ do motor são compilados com o NDK do Android.
O código Dart (tanto do SDK quanto o seu)
é compilado ahead-of-time (AOT) em bibliotecas nativas,
ARM e x86-64. Essas bibliotecas são incluídas em um projeto
Android "runner", e tudo é compilado em um `.apk`.
Quando lançado, o app carrega a biblioteca Flutter.
Qualquer renderização, entrada ou manipulação de eventos, e assim por diante,
é delegada ao código compilado do Flutter e do app.
Isso é similar à forma como muitos game engines funcionam.

Durante o modo debug, Flutter usa uma máquina virtual (VM)
para executar seu código a fim de habilitar stateful hot reload,
um recurso que permite fazer alterações no seu código em execução
sem recompilação. Você verá um banner "debug" no
canto superior direito do seu app quando executando neste modo,
para lembrá-lo de que o desempenho não é característico do
app de release finalizado.

### Como Flutter executa meu código no iOS? {:#run-ios}

O código C e C++ do motor são compilados com LLVM.
O código Dart (tanto do SDK quanto o seu)
é compilado ahead-of-time (AOT) em uma biblioteca nativa ARM.
Essa biblioteca é incluída em um projeto iOS "runner",
e tudo é compilado em um `.ipa`.
Quando lançado, o app carrega a biblioteca Flutter.
Qualquer renderização, entrada ou manipulação de eventos, e assim por diante,
são delegados ao código compilado do Flutter e do app.
Isso é similar à forma como muitos game engines funcionam.

Durante o modo debug, Flutter usa uma máquina virtual (VM)
para executar seu código a fim de habilitar stateful hot reload,
um recurso que permite fazer alterações no seu
código em execução sem recompilação. Você verá
um banner "debug" no canto superior direito do
seu app quando executando neste modo, para lembrá-lo de que
o desempenho não é característico do app de release finalizado.

### Flutter usa os widgets de plataforma integrados do meu sistema operacional?

Não. Em vez disso, Flutter fornece um conjunto de widgets
(incluindo widgets Material Design e Cupertino (estilo iOS)),
gerenciados e renderizados pelo framework e motor do Flutter.
Você pode navegar por um [catálogo de widgets do Flutter][catalog of Flutter's widgets].

Acreditamos que o resultado final são apps de maior qualidade.
Se reutilizássemos os widgets de plataforma integrados,
a qualidade e desempenho dos apps Flutter seriam limitados
pela flexibilidade e qualidade desses widgets.

No Android, por exemplo, há um conjunto hard-coded
de gestos e regras fixas para desambiguá-los.
No Flutter, você pode escrever seu próprio reconhecedor de gestos
que é um participante de primeira classe no [sistema de gestos][gesture system].
Além disso, dois widgets criados por pessoas diferentes podem
coordenar para desambiguar gestos.

Tendências modernas de design de apps apontam para designers e
usuários querendo UIs mais ricas em movimento e designs brand-first.
Para alcançar esse nível de design customizado e bonito,
Flutter é arquitetado para controlar pixels em vez
dos widgets integrados.

Usando o mesmo renderizador, framework e conjunto de widgets,
é mais fácil publicar para múltiplas plataformas a partir da mesma
base de código, sem ter que fazer planejamento cuidadoso e custoso
para alinhar diferentes conjuntos de recursos e características de API.

Usando uma única linguagem, um único framework,
e um único conjunto de bibliotecas para todo o seu código
(independentemente de sua UI ser diferente para cada plataforma ou não),
também visamos ajudar a reduzir custos de desenvolvimento e manutenção de apps.

[catalog of Flutter's widgets]: /ui/widgets
[gesture system]: /ui/interactivity/gestures

### O que acontece quando meu SO mobile atualiza e introduz novos widgets?

A equipe Flutter monitora a adoção e demanda por novos
widgets mobile do iOS e Android, e visa trabalhar com a comunidade
para construir suporte para novos widgets. Este trabalho pode vir na forma
de recursos de framework de nível mais baixo, novos widgets composáveis,
ou novas implementações de widgets.

A arquitetura em camadas do Flutter foi projetada para suportar inúmeras
bibliotecas de widgets, e encorajamos e apoiamos a comunidade em
construir e manter bibliotecas de widgets.

### O que acontece quando meu SO mobile atualiza e introduz novas capacidades de plataforma?

O sistema de interop e plugin do Flutter foi projetado para permitir
que desenvolvedores acessem novos recursos e capacidades do SO mobile
imediatamente. Desenvolvedores não precisam esperar a equipe Flutter
expor a nova capacidade do SO mobile.

### Flutter suporta code push?

Code push, ou a capacidade de enviar atualizações de app diretamente para o
dispositivo de um usuário, não é diretamente suportado pelo Flutter.
No entanto, estamos cientes de uma solução de terceiros,
chamada [Shorebird][Shorebird].
Note que isso não é um endosso ou recomendação oficial.

[Shorebird]: https://shorebird.dev/

### Quais sistemas operacionais posso usar para construir um app Flutter?

Flutter suporta desenvolvimento usando Linux, macOS, ChromeOS
e Windows.

### Em qual linguagem Flutter é escrito?

[Dart][Dart], uma linguagem moderna de rápido crescimento otimizada
para apps cliente. O framework gráfico subjacente
e a máquina virtual Dart são implementados em C/C++.

### Por que Flutter escolheu usar Dart?

Durante a fase de desenvolvimento inicial,
a equipe Flutter analisou muitas
linguagens e runtimes, e finalmente
adotou Dart para o framework e widgets.
Flutter usou quatro dimensões primárias para avaliação,
e considerou as necessidades dos autores de framework,
desenvolvedores e usuários finais. Encontramos muitas linguagens
que atendiam alguns requisitos, mas Dart pontuou altamente em
todas as nossas dimensões de avaliação e atendeu todos os nossos
requisitos e critérios.

Os runtimes e compiladores Dart suportam a combinação de
dois recursos críticos para Flutter: um ciclo de
desenvolvimento rápido baseado em JIT que permite mudança de forma e
hot reloads stateful em uma linguagem com tipos,
mais um compilador Ahead-of-Time que emite código
ARM eficiente para inicialização rápida e desempenho previsível de
deployments de produção.

Além disso, temos a oportunidade de trabalhar de perto
com a comunidade Dart, que está ativamente investindo
recursos em melhorar Dart para uso no Flutter. Por
exemplo, quando adotamos Dart,
a linguagem não tinha uma toolchain ahead-of-time
para produzir binários nativos,
o que é instrumental para alcançar desempenho previsível e
alto, mas agora a linguagem tem porque a equipe Dart
construiu isso para Flutter. Similarmente, a VM Dart foi
anteriormente otimizada para throughput mas a
equipe está agora otimizando a VM para latência, que é mais
importante para a carga de trabalho do Flutter.

Dart pontua altamente para nós nos seguintes critérios primários:

_Produtividade do desenvolvedor_
: Uma das principais propostas de valor do Flutter é que ele
  economiza recursos de engenharia permitindo que desenvolvedores
  criem apps tanto para iOS quanto para Android com a mesma base de código.
  Usar uma linguagem altamente produtiva acelera
  ainda mais os desenvolvedores e torna Flutter mais atraente.
  Isso foi muito importante tanto para nossa equipe de framework quanto
  para nossos desenvolvedores. A maioria do Flutter
  é construída na mesma linguagem que damos aos nossos usuários,
  então precisamos permanecer produtivos com centenas de milhares de linhas de código,
  sem sacrificar a acessibilidade ou
  legibilidade do framework e widgets para nossos desenvolvedores.

_Orientação a objetos_
: Para Flutter, queremos uma linguagem adequada ao
  domínio do problema do Flutter: criar experiências visuais de usuário.
  A indústria tem múltiplas décadas de experiência construindo
  frameworks de interface de usuário em linguagens orientadas a objetos.
  Embora pudéssemos usar uma linguagem não orientada a objetos,
  isso significaria reinventar a roda para resolver vários
  problemas difíceis. Além disso, a grande maioria dos desenvolvedores
  tem experiência com desenvolvimento orientado a objetos,
  tornando mais fácil aprender como desenvolver com Flutter.

_Desempenho previsível e alto_
: Com Flutter, queremos empoderar desenvolvedores a criar experiências de usuário
  rápidas e fluidas. Para alcançar isso, precisamos
  ser capazes de executar uma quantidade significativa de código do desenvolvedor final
  durante cada frame de animação. Isso significa que precisamos de uma linguagem
  que entregue tanto alto desempenho quanto desempenho
  previsível, sem pausas periódicas que causariam
  frames perdidos.

_Alocação rápida_
: O framework Flutter usa um fluxo estilo funcional que
  depende fortemente do alocador de memória subjacente
  manipular eficientemente alocações pequenas e de curta duração.
  Este estilo foi desenvolvido em linguagens com esta
  propriedade e não funciona eficientemente em linguagens
  que não têm esta facilidade.

### Flutter pode executar qualquer código Dart?

Flutter pode executar código Dart que não importe diretamente ou
transitivamente `dart:mirrors` ou `dart:html`.

### Flutter pode compilar Dart para JavaScript?

Flutter compila Dart para JavaScript com o
package [`js.dart`][`js.dart`].

[`js.dart`]: {{site.dart-site}}/tools/dart-compile#js

### Qual o tamanho do motor Flutter?

Em março de 2021, medimos o tamanho de download de um
[app Flutter mínimo][minimal Flutter app] (sem Material Components,
apenas um único widget `Center`, construído com `flutter build
apk --split-per-abi`), empacotado e comprimido como um APK de release,
em aproximadamente 4.3 MB para ARM32, e 4.8 MB para ARM64.

No ARM32, o motor principal é aproximadamente 3.4 MB
(comprimido), o framework + código do app é aproximadamente
765 KB (comprimido), o arquivo LICENSE é 58 KB
(comprimido), e o código Java necessário (`classes.dex`)
é 120 KB (comprimido).

No ARM64, o motor principal é aproximadamente 4.0 MB
(comprimido), o framework + código do app é aproximadamente
659 KB (comprimido), o arquivo LICENSE é 58 KB
(comprimido), e o código Java necessário (`classes.dex`)
é 120 KB (comprimido).

Estes números foram medidos usando [apkanalyzer][apkanalyzer],
que também está [integrado no Android Studio][built into Android Studio].

No iOS, um IPA de release do mesmo app tem um tamanho de download
de 10.9 MB em um iPhone X, conforme reportado pelo
App Store Connect da Apple. O IPA é maior que o APK principalmente
porque a Apple criptografa binários dentro do IPA, tornando a
compressão menos eficiente (veja a
seção [iOS App Store Specific Considerations][iOS App Store Specific Considerations]
do [QA1795][QA1795] da Apple).

:::note
O binário do motor de release costumava incluir LLVM IR (bitcode).
No entanto, a Apple [descontinuou bitcode no Xcode 14][deprecated bitcode in Xcode 14] e removeu o suporte,
então ele foi removido do release Flutter 3.7.
:::

É claro, recomendamos que você meça seu próprio app.
Para fazer isso, veja [Medindo o tamanho do seu app][Measuring your app's size].


[apkanalyzer]: {{site.android-dev}}/studio/command-line/apkanalyzer
[built into Android Studio]: {{site.android-dev}}/studio/build/apk-analyzer
[deprecated bitcode in Xcode 14]: {{site.apple-dev}}/documentation/xcode-release-notes/xcode-14-release-notes
[iOS App Store Specific Considerations]: {{site.apple-dev}}/library/archive/qa/qa1795/_index.html#//apple_ref/doc/uid/DTS40014195-CH1-APP_STORE_CONSIDERATIONS
[Measuring your app's size]: /perf/app-size
[minimal Flutter app]: {{site.repo.flutter}}/tree/75228a59dacc24f617272f7759677e242bbf74ec/examples/hello_world
[QA1795]: {{site.apple-dev}}/library/archive/qa/qa1795/_index.html

### Como Flutter define um pixel?

Flutter usa pixels lógicos,
e frequentemente se refere a eles meramente como "pixels".
O [`devicePixelRatio`][`devicePixelRatio`] do Flutter expressa a razão
entre pixels físicos e pixels CSS lógicos.

[`devicePixelRatio`]: {{site.api}}/flutter/dart-html/Window/devicePixelRatio.html

## Capacidades

### Que tipo de desempenho de app posso esperar?

Em geral, você pode esperar excelente desempenho. Flutter foi projetado para ajudar
desenvolvedores a alcançar facilmente um constante 60fps. Apps Flutter rodam usando código
compilado nativamente, então nenhum interpretador está envolvido. Isso significa que apps Flutter
iniciam rapidamente.

O desempenho do Flutter ao usar código nativo depende da
[arquitetura do seu app][app's architecture]. Para desempenho ideal, familiarize-se com os
[platform channels][platform channels] do Flutter. Esses channels fornecem um sistema de passagem de mensagens
assíncrona para comunicação com código nativo.

Para aprender mais sobre desempenho e Flutter, veja a [Performance FAQ][Performance FAQ].

[platform channels]: /platform-integration/platform-channels
[app's architecture]: /app-architecture
[Performance FAQ]: /perf/faq

### Que tipo de ciclos de desenvolvedor posso esperar? Quanto tempo entre editar e atualizar? {:#hot-reload}

Flutter implementa um ciclo de desenvolvedor _hot reload_. Você pode esperar
tempos de reload sub-segundo, em um dispositivo ou um emulador/simulador.

O hot reload do Flutter é _stateful_ então o estado do app
é mantido após um reload. Isso significa que você pode iterar rapidamente
em uma tela profundamente aninhada em seu app, sem começar
da tela inicial após cada reload.

### Como _hot reload_ é diferente de _hot restart_?

Hot reload funciona injetando arquivos de código-fonte atualizados
na VM Dart (Virtual Machine) em execução. Isso não
apenas adiciona novas classes, mas também adiciona métodos e campos
a classes existentes, e altera funções existentes.
Hot restart reseta o estado para o estado inicial do app.

Para mais informações, veja [Hot reload][Hot reload].


[Hot reload]: /tools/hot-reload

### Onde posso fazer deploy do meu app Flutter?

Você pode compilar e fazer deploy do seu app Flutter para iOS, Android,
[web][web], e [desktop][desktop].


[desktop]: /platform-integration/desktop
[web]: /platform-integration/web

### Em quais dispositivos e versões de SO Flutter roda?

* Suportamos e testamos a execução do Flutter em uma variedade
  de plataformas de baixo a alto desempenho. Para uma lista detalhada
  das plataformas nas quais testamos, veja
  a lista de [plataformas suportadas][supported platforms].

* Flutter suporta construção de bibliotecas compiladas ahead-of-time (AOT)
  para `x86-64`, `armeabi-v7a`, e `arm64-v8a`.

* Apps construídos para ARMv7 ou ARM64 rodam bem (usando emulação ARM)
  em muitos dispositivos Android x86-64.

* Suportamos desenvolvimento de apps Flutter em uma variedade de plataformas.
  Veja os requisitos de sistema listados em cada
  [sistema operacional de desenvolvimento][install].


[install]: /get-started
[supported platforms]: /reference/supported-platforms

### Flutter roda na web?

Sim, o suporte web está disponível no canal stable.
Para mais detalhes, confira as [instruções web][web instructions].

[web instructions]: /platform-integration/web/building

### Posso usar Flutter para construir apps desktop?

Sim, o suporte desktop está stable para Windows,
macOS e Linux.

### Posso usar Flutter dentro do meu app nativo existente?

Sim, saiba mais na seção [add-to-app][add-to-app] do nosso site.

[add-to-app]: /add-to-app

### Posso acessar serviços e APIs de plataforma como sensores e armazenamento local?

Sim. Flutter dá aos desenvolvedores acesso pronto a _alguns_
serviços e APIs específicos de plataforma do sistema operacional.
No entanto, queremos evitar o problema do "mínimo denominador comum"
com a maioria das APIs multiplataforma, então não pretendemos construir
APIs multiplataforma para todos os serviços e APIs nativos.

Vários serviços e APIs de plataforma têm
[packages prontos][ready-made packages] disponíveis no pub.dev.
Usar um package existente [é fácil][is easy].

Finalmente, encorajamos desenvolvedores a usar o
sistema de passagem de mensagens assíncrona do Flutter para criar suas
próprias integrações com [APIs de plataforma e de terceiros][platform and third-party APIs].
Desenvolvedores podem expor tanto ou tão pouco das
APIs de plataforma quanto precisarem, e construir camadas de
abstrações que se ajustem melhor ao seu projeto.


[is easy]: /packages-and-plugins/using-packages
[platform and third-party APIs]: /platform-integration/platform-channels
[ready-made packages]: {{site.pub}}/flutter/

### Posso estender e customizar os widgets empacotados?

Absolutamente. O sistema de widgets do Flutter foi projetado
para ser facilmente customizável.

Em vez de ter cada widget fornecendo um grande número de parâmetros,
Flutter abraça a composição. Widgets são construídos a partir de widgets menores
que você pode reutilizar e combinar de formas novas para fazer
widgets personalizados. Por exemplo, em vez de fazer subclasse de um widget
de botão genérico, `ElevatedButton` combina um widget Material com um
widget `GestureDetector`. O widget Material fornece o design
visual e o widget `GestureDetector` fornece o
design de interação.

Para criar um botão com um design visual personalizado, você pode combinar
widgets que implementam seu design visual com um `GestureDetector`,
que fornece o design de interação. Por exemplo,
`CupertinoButton` segue esta abordagem e combina um
`GestureDetector` com vários outros widgets que implementam seu
design visual.

Composição dá a você controle máximo sobre o design visual e
de interação de seus widgets enquanto também permite uma
grande quantidade de reutilização de código. No framework, decompomos
widgets complexos em peças que implementam separadamente
o design visual, de interação e de movimento. Você pode remixar
esses widgets como quiser para fazer seus próprios widgets personalizados
que têm toda a gama de expressão.

### Por que eu gostaria de compartilhar código de layout entre iOS e Android?

Você pode escolher implementar layouts de app diferentes para
iOS e Android. Desenvolvedores são livres para verificar o SO mobile
em tempo de execução e renderizar layouts diferentes,
embora achemos esta prática rara.

Cada vez mais, vemos layouts e designs de apps mobile evoluindo
para serem mais orientados à marca e unificados entre plataformas.
Isso implica uma forte motivação para compartilhar layout e código
de UI entre iOS e Android.

A identidade de marca e customização do design
estético do app está se tornando mais importante do que
aderir estritamente à estética tradicional da plataforma.
Por exemplo, designs de apps frequentemente requerem fontes, cores,
formas, movimento personalizados e mais para transmitir claramente sua
identidade de marca.

Também vemos padrões de layout comuns implementados em
iOS e Android. Por exemplo, o padrão "bottom nav bar"
agora pode ser naturalmente encontrado em iOS e Android.
Parece haver uma convergência de ideias de design
entre plataformas mobile.

### Posso fazer interop com a linguagem de programação padrão da minha plataforma mobile?

Sim, Flutter suporta chamadas para a plataforma,
incluindo integração com código Java ou Kotlin no Android,
e código Swift ou Objective-C no iOS.
Isso é habilitado por um estilo flexível de passagem de mensagens
onde um app Flutter pode enviar e receber mensagens
para a plataforma mobile usando um [`BasicMessageChannel`][`BasicMessageChannel`].

Saiba mais sobre acessar serviços de plataforma e de terceiros
no Flutter com [platform channels][platform channels].

Aqui está um [projeto de exemplo][example project] que mostra como usar um
platform channel para acessar informações de estado da bateria no
iOS e Android.


[`BasicMessageChannel`]: {{site.api}}/flutter/services/BasicMessageChannel-class.html
[example project]: {{site.repo.flutter}}/tree/main/examples/platform_channel
[platform channels]: /platform-integration/platform-channels

### Flutter vem com um sistema de reflection / mirrors?

Não. Dart inclui `dart:mirrors`,
que fornece reflexão de tipos. Mas como
apps Flutter são pré-compilados para produção,
e o tamanho do binário é sempre uma preocupação com apps mobile,
esta biblioteca não está disponível para apps Flutter.

Usando análise estática podemos remover qualquer coisa que não é
usada ("tree shaking"). Se você importar uma enorme biblioteca Dart
mas usar apenas um método autocontido de duas linhas,
então você paga apenas o custo do método de duas linhas,
mesmo que essa biblioteca Dart em si importe dezenas e
dezenas de outras bibliotecas. Esta garantia só é segura
se Dart puder identificar o caminho do código em tempo de compilação.
Até agora, encontramos outras abordagens para necessidades específicas
que oferecem um melhor trade-off, como geração de código.

### Internacionalização e localização são suportadas?

Sim, Flutter suporta internacionalização (i18n) e localização (l10n) para que
seus apps sejam adaptáveis a diferentes idiomas e culturas. Você pode
aprender mais na [documentação de internacionalização][internationalization documentation].

[internationalization documentation]: /ui/internationalization

### Qual acessibilidade é suportada?

Flutter suporta requisitos rigorosos de acessibilidade (a11y). Por exemplo,
leitores de tela, texto grande, contraste de cores e controle por switch de hardware são
todos suportados. Para saber mais, veja a [documentação de acessibilidade][accessibility documentation].

[accessibility documentation]: /ui/accessibility

### Como escrevo apps paralelos e/ou concorrentes para Flutter?

Flutter suporta isolates. Isolates são heaps separados na
VM do Flutter, e são capazes de rodar em paralelo
(geralmente implementados como threads separadas). Isolates
se comunicam enviando e recebendo mensagens assíncronas.

Confira um [exemplo de uso de isolates com Flutter][example of using isolates with Flutter].

[example of using isolates with Flutter]: {{site.repo.flutter}}/blob/main/examples/layers/services/isolate.dart

### Posso executar código Dart em background de um app Flutter?

Sim, você pode executar código Dart em um processo background tanto no
iOS quanto no Android. Para mais informações, veja o artigo gratuito do Medium
[Executing Dart in the Background with Flutter Plugins and Geofencing][backgnd].

[backgnd]: {{site.flutter-blog}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

### Posso usar JSON/XML/<wbr>Protobufs (e assim por diante) com Flutter?

Absolutamente. Há bibliotecas no
[pub.dev][pub.dev] para JSON, XML, protobufs,
e muitos outros utilitários e formatos.

Para um artigo detalhado sobre usar JSON com Flutter,
confira o [tutorial de JSON][JSON tutorial].

[JSON tutorial]: /data-and-backend/serialization/json
[pub.dev]: {{site.pub}}

### Posso construir apps 3D (OpenGL) com Flutter?

Hoje não suportamos 3D usando OpenGL ES ou similar.
Temos planos de longo prazo para expor uma API 3D otimizada,
mas agora estamos focados em 2D.

### Por que meu APK ou IPA é tão grande?

Normalmente, assets incluindo imagens, arquivos de som, fontes e assim por diante,
são a maior parte de um APK ou IPA. Várias ferramentas nos
ecossistemas Android e iOS podem ajudar você a entender
o que está dentro do seu APK ou IPA.

Além disso, certifique-se de criar um _build de release_
do seu APK ou IPA com as ferramentas Flutter.
Um build de release é geralmente _muito_ menor
do que um _build de debug_.

Saiba mais sobre criar um
[build de release do seu app Android][release build of your Android app],
e criar um [build de release do seu app iOS][release build of your iOS app].
Além disso, confira [Medindo o tamanho do seu app][Measuring your app's size].


[release build of your Android app]: /deployment/android
[release build of your iOS app]: /deployment/ios

### Apps Flutter rodam em Chromebooks?

Vimos apps Flutter rodarem em alguns Chromebooks.
Estamos rastreando [issues relacionadas a rodar Flutter em
Chromebooks][issues related to running Flutter on Chromebooks].

[issues related to running Flutter on Chromebooks]: {{site.repo.flutter}}/labels/platform-arc

### Flutter é compatível com ABI?

Flutter e Dart não oferecem compatibilidade de interface binária de aplicação (ABI).
Oferecer compatibilidade ABI não é um objetivo atual
para Flutter ou Dart.

### Como Flutter lida com rolagem?

Uma implementação de rolagem personalizada é usada para cada plataforma de app para que
a rolagem corresponda à aparência e sensação de rolagem nativa dessa plataforma. Para aprender
mais sobre rolagem com Flutter, veja a documentação de [rolagem][scrolling].

[scrolling]: /ui/layout/scrolling

## Framework

### Por que o método build() está em State, em vez de StatefulWidget?

Colocar um método `Widget build(BuildContext context)` em `State`
em vez de colocar um método `Widget build(BuildContext context, State state)`
em `StatefulWidget` dá aos desenvolvedores mais flexibilidade ao
fazer subclasse de `StatefulWidget`. Você pode ler uma
[discussão mais detalhada na documentação da API para `State.build`][detailed discussion on the API docs for `State.build`].

[detailed discussion on the API docs for `State.build`]: {{site.api}}/flutter/widgets/State/build.html

### Onde está a linguagem de marcação do Flutter? Por que Flutter não tem uma sintaxe de marcação?

UIs Flutter são construídas com uma linguagem imperativa orientada a objetos
(Dart, a mesma linguagem usada para construir o
framework do Flutter). Flutter não vem com uma marcação declarativa.

Descobrimos que UIs construídas dinamicamente com código permitem
mais flexibilidade. Por exemplo, achamos difícil
para um sistema de marcação rígido expressar e produzir
widgets customizados com comportamentos sob medida.

Também descobrimos que nossa abordagem "código-primeiro" permite melhor
recursos como hot reload e adaptações dinâmicas de ambiente.

É possível criar uma linguagem personalizada que é então
convertida para widgets em tempo real. Como métodos build
são "apenas código", eles podem fazer qualquer coisa,
incluindo interpretar marcação e transformá-la em widgets.

### Meu app tem um banner/faixa Debug no canto superior direito. Por que estou vendo isso?

Por padrão, o comando `flutter run` usa a
configuração de build debug.

A configuração debug executa seu código Dart em uma VM (Virtual Machine)
habilitando um ciclo de desenvolvimento rápido com [hot reload][hot reload]
(builds de release são compilados usando as toolchains padrão [Android][Android]
e [iOS][iOS]).

A configuração debug também verifica todos os asserts, o que ajuda
você a pegar erros cedo durante o desenvolvimento, mas impõe um
custo em tempo de execução. O banner "Debug" indica que essas verificações
estão habilitadas. Você pode executar seu app sem essas verificações
usando a flag `--profile` ou `--release` no `flutter run`.

Se sua IDE usa o plugin Flutter,
você pode lançar o app em modo profile ou release.
Para VS Code, use as entradas de menu **Run > Start debugging**
ou **Run > Run without debugging**.
Para IntelliJ, use as entradas de menu
**Run > Flutter Run in Profile Mode** ou **Release Mode**.


[Android]: #run-android
[hot reload]: #hot-reload
[iOS]: #run-ios

### Qual paradigma de programação o framework do Flutter usa?

Flutter é um ambiente de programação multi-paradigma.
Muitas técnicas de programação desenvolvidas ao longo das últimas décadas
são usadas no Flutter. Usamos cada uma onde acreditamos que
os pontos fortes da técnica a tornam particularmente adequada.
Sem ordem particular:

**Composição**
: O paradigma primário usado pelo Flutter é o de usar
  objetos pequenos com escopos estreitos de comportamento, compostos juntos para
  obter efeitos mais complicados, às vezes chamado
  _composição agressiva_. A maioria dos widgets na biblioteca de widgets
  Flutter é construída dessa forma. Por exemplo, a classe
  [`TextButton`][`TextButton`] do Material é construída usando
  um [`IconTheme`][`IconTheme`], um [`InkWell`][`InkWell`], um [`Padding`][`Padding`],
  um [`Center`][`Center`], um [`Material`][`Material`],
  um [`AnimatedDefaultTextStyle`][`AnimatedDefaultTextStyle`], e um [`ConstrainedBox`][`ConstrainedBox`].
  O [`InkWell`][`InkWell`] é construído usando um [`GestureDetector`][`GestureDetector`].
  O [`Material`][`Material`] é construído usando um
  [`AnimatedDefaultTextStyle`][`AnimatedDefaultTextStyle`],
  um [`NotificationListener`][`NotificationListener`], e um [`AnimatedPhysicalModel`][`AnimatedPhysicalModel`].
  E assim por diante. São widgets até o fim.

**Programação funcional**
: Aplicações inteiras podem ser construídas com apenas
  [`StatelessWidget`][`StatelessWidget`]s, que são essencialmente funções que
  descrevem como argumentos mapeiam para outras funções, chegando
  em primitivos que computam layouts ou pintam gráficos.
  (Tais aplicações não podem facilmente ter estado,
  então são tipicamente não-interativas.) Por exemplo, o widget
  [`Icon`][`Icon`] é essencialmente uma função que mapeia seus argumentos
  ([`color`][`color`], [`icon`][`icon`], [`size`][`size`]) em primitivos de layout.
  Além disso, uso pesado é feito de estruturas de dados imutáveis,
  incluindo toda a hierarquia de classes [`Widget`][`Widget`]
  assim como numerosas classes de suporte como
  [`Rect`][`Rect`] e [`TextStyle`][`TextStyle`]. Em menor escala, a
  API [`Iterable`][`Iterable`] do Dart, que faz uso pesado do estilo
  funcional (map, reduce, where, etc), é frequentemente usada para processar
  listas de valores no framework.

**Programação orientada a eventos**
: Interações do usuário são representadas por objetos de evento
  que são despachados para callbacks registrados com manipuladores de eventos.
  Atualizações de tela são acionadas por um mecanismo de callback similar. A
  classe [`Listenable`][`Listenable`], que é usada como base do
  sistema de animação, formaliza um modelo de assinatura para eventos
  com múltiplos listeners.

**Programação orientada a objetos baseada em classes**
: A maioria das APIs do framework são construídas usando classes
  com herança. Usamos uma abordagem onde definimos
  APIs de muito alto nível em nossas classes base, depois especializamos
  elas iterativamente em subclasses. Por exemplo,
  nossos objetos de renderização têm uma classe base ([`RenderObject`][`RenderObject`])
  que é agnóstica em relação ao sistema de coordenadas,
  e então temos uma subclasse ([`RenderBox`][`RenderBox`])
  que introduz a opinião de que a geometria deve ser baseada
  no sistema de coordenadas cartesiano (x/largura e y/altura).

**Programação orientada a objetos baseada em protótipos**
: A classe [`ScrollPhysics`][`ScrollPhysics`] encadeia instâncias para compor
  a física que se aplica à rolagem dinamicamente em tempo de execução.
  Isso permite que o sistema componha, por exemplo, física de paginação
  com física específica de plataforma, sem que a plataforma precise ser
  selecionada em tempo de compilação.

**Programação imperativa**
: Programação imperativa direta, geralmente
  pareada com estado encapsulado dentro de um objeto,
  é usada onde fornece a solução mais intuitiva.
  Por exemplo, testes são escritos em estilo imperativo,
  primeiro descrevendo a situação sob teste, depois listando
  as invariantes que o teste deve corresponder, depois avançando
  o relógio ou inserindo eventos conforme necessário para o teste.

**Programação reativa**
: As árvores de widget e elemento são às vezes descritas como
  reativas, porque novas entradas fornecidas no
  construtor de um widget são imediatamente propagadas como mudanças para
  widgets de nível inferior pelo método build do widget, e
  mudanças feitas nos widgets inferiores (por exemplo,
  em resposta à entrada do usuário) propagam de volta pela árvore
  usando manipuladores de eventos. Aspectos tanto de funcional-reativo quanto
  imperativo-reativo estão presentes no framework,
  dependendo das necessidades dos widgets. Widgets com métodos build
  que consistem apenas de uma expressão descrevendo como
  o widget reage a mudanças em sua configuração são widgets
  reativos funcionais (por exemplo, a classe [`Divider`][`Divider`] do Material).
  Widgets cujos métodos build constroem uma lista de filhos
  ao longo de várias instruções, descrevendo como o widget reage
  a mudanças em sua configuração, são widgets reativos
  imperativos (por exemplo, a classe [`Chip`][`Chip`]).

**Programação declarativa**
: Os métodos build de widgets são frequentemente uma única
  expressão com múltiplos níveis de construtores aninhados,
  escritos usando um subconjunto estritamente declarativo de Dart.
  Tais expressões aninhadas poderiam ser mecanicamente transformadas
  de ou para qualquer linguagem de marcação suficientemente expressiva.
  Por exemplo, o widget
  [`UserAccountsDrawerHeader`][`UserAccountsDrawerHeader`] tem um método build longo (20+ linhas),
  consistindo de uma única expressão aninhada.
  Isso também pode ser combinado com o estilo imperativo para construir UIs
  que seriam mais difíceis de descrever em uma abordagem puramente declarativa.

**Programação genérica**
: Tipos podem ser usados para ajudar desenvolvedores a pegar erros de programação
  cedo. O framework Flutter usa programação genérica para
  ajudar neste aspecto. Por exemplo, a classe [`State`][`State`]
  é parametrizada em termos do tipo de seu
  widget associado, de forma que o analisador Dart possa pegar
  incompatibilidades de estados e widgets. Similarmente, a
  classe [`GlobalKey`][`GlobalKey`] recebe um parâmetro de tipo para que possa
  acessar o estado de um widget remoto de maneira type-safe
  (usando verificação em tempo de execução), a interface [`Route`][`Route`] é
  parametrizada com o tipo que é esperado usar quando
  [popped][popped], e coleções como [`List`][`List`]s, [`Map`][`Map`]s,
  e [`Set`][`Set`]s são todas parametrizadas para que elementos
  incompatíveis possam ser pegos cedo durante análise ou em
  tempo de execução durante depuração.

**Programação concorrente**
: Flutter faz uso pesado de [`Future`][`Future`]s e outras
  APIs assíncronas. Por exemplo, o sistema de animação reporta
  quando uma animação termina completando um future.
  O sistema de carregamento de imagens similarmente usa futures para reportar
  quando um carregamento está completo.

**Programação de restrições**
: O sistema de layout no Flutter usa uma forma fraca de
  programação de restrições para determinar a geometria de uma cena.
  Restrições (por exemplo, para caixas cartesianas, uma largura
  mínima e máxima e uma altura mínima e máxima)
  são passadas de pai para filho, e o filho seleciona uma
  geometria resultante (por exemplo, para caixas cartesianas, um tamanho,
  especificamente uma largura e uma altura) que cumpre essas restrições.
  Usando esta técnica, Flutter geralmente pode
  fazer layout de uma cena inteira com uma única passagem.


[`AnimatedDefaultTextStyle`]: {{site.api}}/flutter/widgets/AnimatedDefaultTextStyle-class.html
[`AnimatedPhysicalModel`]: {{site.api}}/flutter/widgets/AnimatedPhysicalModel-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`color`]: {{site.api}}/flutter/widgets/Icon/color.html
[`ConstrainedBox`]: {{site.api}}/flutter/widgets/ConstrainedBox-class.html
[`Divider`]: {{site.api}}/flutter/material/Divider-class.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`icon`]: {{site.api}}/flutter/widgets/Icon/icon.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`IconTheme`]: {{site.api}}/flutter/widgets/IconTheme-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`Iterable`]: {{site.api}}/flutter/dart-core/Iterable-class.html
[`List`]: {{site.api}}/flutter/dart-core/List-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`Map`]: {{site.api}}/flutter/dart-core/Map-class.html
[`Material`]: {{site.api}}/flutter/material/Material-class.html
[`NotificationListener`]: {{site.api}}/flutter/widgets/NotificationListener-class.html
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[popped]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Rect`]: {{site.api}}/flutter/dart-ui/Rect-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`ScrollPhysics`]: {{site.api}}/flutter/widgets/ScrollPhysics-class.html
[`Set`]: {{site.api}}/flutter/dart-core/Set-class.html
[`size`]: {{site.api}}/flutter/widgets/Icon/size.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[`UserAccountsDrawerHeader`]: {{site.api}}/flutter/material/UserAccountsDrawerHeader-class.html
[`Widget`]: {{site.api}}/flutter/widgets/Widget-class.html

## Projeto

### Onde posso obter suporte?

Se você acha que encontrou um bug, registre-o em nosso
[issue tracker][issue tracker]. Você também pode usar
[Stack Overflow][Stack Overflow] para perguntas tipo "HOWTO".
Para discussões, junte-se à nossa lista de e-mails em
[{{site.email}}][{{site.email}}] ou nos procure no [Discord][Discord].

Para mais informações, veja nossa página [Community][Community].


[Community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/rflutterdev
[issue tracker]: {{site.repo.flutter}}/issues
[{{site.email}}]: mailto:{{site.email}}
[Stack Overflow]: {{site.so}}/tags/flutter

### Como me envolvo?

Flutter é open source, e encorajamos você a contribuir.
Você pode começar simplesmente registrando issues para solicitações de recursos
e bugs em nosso [issue tracker][issue tracker].

Recomendamos que você se junte à nossa lista de e-mails em
[{{site.email}}][{{site.email}}] e nos conte como está
usando Flutter e o que gostaria de fazer com ele.

Se você está interessado em contribuir código, pode começar
lendo nosso [guia de Contribuição][Contributing guide], e confira nossa
lista de [issues iniciais fáceis][easy starter issues].

Finalmente, você pode se conectar com comunidades úteis do Flutter.
Para mais informações, veja a página [Community][Community].

Você também pode interagir com outros desenvolvedores no
[Discord][Discord] do Flutter.

[Contributing guide]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[easy starter issues]: {{site.repo.flutter}}/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+fix%22

### Flutter é open source?

Sim, Flutter é tecnologia open source.
Você pode encontrar o projeto no [GitHub][GitHub].

[GitHub]: {{site.repo.flutter}}

### Quais licenças de software se aplicam ao Flutter e suas dependências?

Flutter inclui dois componentes: um motor que é distribuído como um
binário dinamicamente linkado, e o framework Dart como um
binário separado que o motor carrega. O motor usa múltiplos componentes
de software com muitas dependências; veja a lista completa
em seu [arquivo de licença][license file].

O framework é totalmente autocontido e requer
[apenas uma licença][only one license].

Além disso, quaisquer packages Dart que você use podem ter seus
próprios requisitos de licença.

[license file]: {{site.repo.flutter}}/blob/main/engine/src/flutter/sky/packages/sky_engine/LICENSE
[only one license]: {{site.repo.flutter}}/blob/main/LICENSE

### Como posso determinar as licenças que meu aplicativo Flutter precisa mostrar?

Há uma API para encontrar a lista de licenças que você precisa mostrar:

* Se seu aplicativo tem um [`Drawer`][`Drawer`], adicione um
  [`AboutListTile`][`AboutListTile`].

* Se seu aplicativo não tem um Drawer mas usa a
  biblioteca Material Components, chame [`showAboutDialog`][`showAboutDialog`]
  ou [`showLicensePage`][`showLicensePage`].

* Para uma abordagem mais customizada, você pode obter as licenças brutas do
  [`LicenseRegistry`][`LicenseRegistry`].


[`AboutListTile`]: {{site.api}}/flutter/material/AboutListTile-class.html
[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`LicenseRegistry`]: {{site.api}}/flutter/foundation/LicenseRegistry-class.html
[`showAboutDialog`]: {{site.api}}/flutter/material/showAboutDialog.html
[`showLicensePage`]: {{site.api}}/flutter/material/showLicensePage.html

### Quem trabalha no Flutter?

Todos nós! Flutter é um projeto open source.
Atualmente, a maior parte do desenvolvimento é feita
por engenheiros do Google. Se você está empolgado com Flutter,
encorajamos você a se juntar à comunidade e
[contribuir para o Flutter][contribute to Flutter]!

[contribute to Flutter]: {{site.repo.flutter}}/blob/master/CONTRIBUTING.md

### Quais são os princípios orientadores do Flutter?

Acreditamos no seguinte:

* Para alcançar cada usuário potencial,
  desenvolvedores precisam visar múltiplas plataformas mobile.
* HTML e WebViews como existem hoje tornam desafiador
  consistentemente atingir altas taxas de frames e entregar
  experiências de alta fidelidade, devido a comportamento automático (rolagem,
  layout) e suporte legado.
* Hoje, é muito custoso construir o mesmo app múltiplas vezes: isso
  requer diferentes equipes, diferentes bases de código,
  diferentes workflows, diferentes ferramentas, etc.
* Desenvolvedores querem uma maneira mais fácil e melhor de usar uma única base de código para
  construir apps mobile para múltiplas plataformas alvo,
  e não querem sacrificar qualidade, controle ou desempenho.

Estamos focados em três coisas:

_Controle_
: Desenvolvedores merecem acesso a, e controle sobre,
  todas as camadas do sistema. O que leva a:

_Desempenho_
: Usuários merecem apps perfeitamente fluidos, responsivos
  e sem travamentos. O que leva a:

_Fidelidade_:
: Todos merecem experiências de app precisas, lindas e
  deliciosas.

### A Apple vai rejeitar meu app Flutter?

Não podemos falar pela Apple, mas sua App Store contém
muitos apps construídos com tecnologias de framework como Flutter.
De fato, Flutter usa o mesmo modelo arquitetural
fundamental que Unity, o motor que impulsiona muitos dos
jogos mais populares na Apple store.

A Apple tem frequentemente destacado apps bem projetados
que são construídos com Flutter,
incluindo [Hamilton][Hamilton for iOS] e [Reflectly][Reflectly].

Como com qualquer app submetido à Apple store,
apps construídos com Flutter devem seguir as
[diretrizes][guidelines] da Apple para submissão à App Store.


[guidelines]: {{site.apple-dev}}/app-store/review/guidelines/
[Hamilton for iOS]: https://itunes.apple.com/us/app/hamilton-the-official-app/id1255231054?mt=8
[Reflectly]: https://apps.apple.com/us/app/reflectly-journal-ai-diary/id1241229134
