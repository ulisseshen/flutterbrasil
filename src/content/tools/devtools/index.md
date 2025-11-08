---
ia-translate: true
title: Flutter e Dart DevTools
description: Como usar Flutter DevTools com Flutter.
---

## O que é DevTools?

DevTools é um conjunto de ferramentas de performance e depuração
para Dart e Flutter.
_Flutter DevTools_ e _Dart DevTools_ referem-se ao
mesmo conjunto de ferramentas.

![Dart DevTools Screens](/assets/images/docs/tools/devtools/dart-devtools.gif){:width="100%"}

Para uma introdução em vídeo ao DevTools, confira
o seguinte deep dive e demonstração de casos de uso:

{% ytEmbed '_EYk-E29edo', 'Dive in to Flutter and Dart DevTools' %}

## O que posso fazer com DevTools?

Aqui estão algumas coisas que você pode fazer com DevTools:

* Inspecionar o layout e estado da UI de um app Flutter.
* Diagnosticar problemas de performance de jank de UI em um app Flutter.
* Profiling de CPU para um app Flutter ou Dart.
* Profiling de rede para um app Flutter.
* Depuração em nível de código-fonte de um app Flutter ou Dart.
* Depurar problemas de memória em um app Flutter ou Dart
  de linha de comando.
* Visualizar informações gerais de log e diagnóstico
  sobre um app Flutter ou Dart
  de linha de comando em execução.
* Analisar código e tamanho do app.
* Validar deep links no seu app Android.

Esperamos que você use DevTools em conjunto com
seu fluxo de trabalho de desenvolvimento existente baseado em IDE ou linha de comando.

<a id="how-do-i-install-devtools"></a>
<a id="install-devtools"></a>

## Como executar DevTools {#start}

Veja as páginas [VS Code][], [Android Studio/IntelliJ][] ou
[linha de comando][command line] para instruções sobre como executar DevTools.

## Solucionando alguns problemas padrão

**Pergunta**: Meu app parece janky ou trava.
  Como eu conserto isso?

**Resposta**: Problemas de performance podem causar [frames de UI][UI frames]
  janky e/ou desacelerar algumas operações.

  1. Para detectar qual código impacta frames atrasados concretos,
     comece em [Performance > Timeline][].
  2. Para saber qual código consome mais tempo de CPU em
     segundo plano, use o [CPU profiler][].

Para mais informações, confira a
página [Performance][].

**Pergunta**: Vejo muitos eventos de coleta de lixo (GC) ocorrendo.
  Isso é um problema?

**Resposta**: Eventos frequentes de GC podem aparecer no
  gráfico DevTools > Memory > Memory. Na maioria dos casos,
  não é um problema.

Se seu app tem atividade frequente em segundo plano com algum tempo ocioso,
Flutter pode usar essa oportunidade para coletar os objetos criados
sem impacto de performance.

[CPU profiler]: /tools/devtools/cpu-profiler
[Performance]: /perf
[Performance > Timeline]: /tools/devtools/performance#timeline-events-tab
[UI frames]: /perf/ui-performance

## Fornecendo feedback

Por favor, experimente DevTools, forneça feedback e registre issues
no [rastreador de issues do DevTools][DevTools issue tracker]. Obrigado!

## Outros recursos

Para mais informações sobre depuração e profiling
de apps Flutter, veja a página [Debugging][] e,
em particular, sua lista de [outros recursos][other resources].

Para mais informações sobre usar DevTools com
apps Dart de linha de comando, veja a
[documentação DevTools em dart.dev]({{site.dart-site}}/tools/dart-devtools).

[Android Studio/IntelliJ]: /tools/devtools/android-studio
[VS Code]: /tools/devtools/vscode
[command line]: /tools/devtools/cli
[DevTools issue tracker]: {{site.github}}/flutter/devtools/issues
[Debugging]: /testing/debugging
[Other resources]: /testing/debugging#other-resources
