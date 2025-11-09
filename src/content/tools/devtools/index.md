---
ia-translate: true
title: Flutter e Dart DevTools
breadcrumb: DevTools
description: Como usar Flutter DevTools com Flutter.
---

## O que é DevTools?

DevTools é um conjunto de ferramentas de desempenho e debugging
para Dart e Flutter.
_Flutter DevTools_ e _Dart DevTools_ referem-se ao
mesmo conjunto de ferramentas.

![Dart DevTools Screens](/assets/images/docs/tools/devtools/dart-devtools.webp){:width="100%"}

Para uma introdução em vídeo ao DevTools, confira
o seguinte mergulho profundo e passo a passo de casos de uso:

<YouTubeEmbed id="_EYk-E29edo" title="Dive in to Flutter and Dart DevTools"></YouTubeEmbed>

## O que posso fazer com DevTools?

Aqui estão algumas das coisas que você pode fazer com DevTools:

* Inspecionar o layout e estado da UI de um app Flutter.
* Diagnosticar problemas de desempenho de jank da UI em um app Flutter.
* Profiling de CPU para um app Flutter ou Dart.
* Profiling de rede para um app Flutter.
* Debugging em nível de código-fonte de um app Flutter ou Dart.
* Depurar problemas de memória em um app de
  linha de comando Flutter ou Dart.
* Visualizar informações gerais de log e diagnóstico
  sobre um app de linha de comando Flutter ou Dart
  em execução.
* Analisar código e tamanho de app.
* Validar deep links no seu app Android ou iOS.

Esperamos que você use DevTools em conjunto com
seu fluxo de trabalho de desenvolvimento existente baseado em IDE ou linha de comando.

<a id="how-do-i-install-devtools"></a>
<a id="install-devtools"></a>

## Como iniciar DevTools {:#start}

Você pode iniciar DevTools com as seguintes ferramentas:

* [VS Code][VS Code]
* [Android Studio/IntelliJ][Android Studio/IntelliJ]
* [linha de comando][command line]

## Solucionando alguns problemas comuns

**Pergunta**: Meu app parece janky ou trava.
  Como eu corrijo isso?

**Resposta**: Problemas de desempenho podem causar [frames de UI][UI frames]
  janky e/ou tornar algumas operações mais lentas.

  1. Para detectar qual código impacta frames atrasados concretos,
     comece em [Performance > Timeline][Performance > Timeline].
  2. Para saber qual código consome mais tempo de CPU em
     segundo plano, use o [profiler de CPU][CPU profiler].

Para mais informações, confira a
página [Performance][Performance].

**Pergunta**: Vejo muitos eventos de garbage collection (GC) ocorrendo.
  Isso é um problema?

**Resposta**: Eventos GC frequentes podem aparecer no
  gráfico DevTools > Memory > Memory. Na maioria dos casos,
  não é um problema.

Se seu app tem atividade frequente em segundo plano com algum tempo ocioso,
Flutter pode usar essa oportunidade para coletar os objetos criados
sem impacto no desempenho.

[CPU profiler]: /tools/devtools/cpu-profiler
[Performance]: /perf
[Performance > Timeline]: /tools/devtools/performance#timeline-events-tab
[UI frames]: /perf/ui-performance

## Fornecendo feedback

Por favor, experimente DevTools, forneça feedback e registre problemas
no [rastreador de problemas do DevTools][DevTools issue tracker]. Obrigado!

## Versionamento do DevTools

DevTools é distribuído como parte do Flutter SDK. Para obter acesso à
funcionalidade mais recente do DevTools, execute `flutter upgrade` para obter a versão
mais atualizada do Flutter. Para acessar recursos do DevTools antes de chegarem ao
canal `stable` do Flutter, considere mudar para os canais `beta` ou `main`.

## Outros recursos

Para mais informações sobre debugging e profiling
de apps Flutter, veja a página [Debugging][Debugging] e,
em particular, sua lista de [outros recursos][Other resources].

Para mais informações sobre o uso de DevTools com
apps de linha de comando Dart, veja a
[documentação do DevTools em dartbrasil.dev]({{site.dart-site}}/tools/dart-devtools).

[Android Studio/IntelliJ]: /tools/devtools/android-studio
[VS Code]: /tools/devtools/vscode
[command line]: /tools/devtools/cli
[DevTools issue tracker]: {{site.github}}/flutter/devtools/issues
[Debugging]: /testing/debugging
[Other resources]: /testing/debugging#other-resources
