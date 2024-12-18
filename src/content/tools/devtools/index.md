---
ia-translate: true
title: Flutter e Dart DevTools
description: Como usar o Flutter DevTools com Flutter.
---

## O que é DevTools?

DevTools é um conjunto de ferramentas de desempenho e depuração
para Dart e Flutter.
_Flutter DevTools_ e _Dart DevTools_ referem-se ao
mesmo conjunto de ferramentas.

![Telas do Dart DevTools](/assets/images/docs/tools/devtools/dart-devtools.gif){:width="100%"}

Para uma introdução em vídeo ao DevTools, confira o
seguinte mergulho profundo e passo a passo de casos de uso:

{% ytEmbed '_EYk-E29edo', 'Mergulhe no Flutter e Dart DevTools' %}

## O que posso fazer com o DevTools?

Aqui estão algumas coisas que você pode fazer com o DevTools:

* Inspecionar o layout da UI e o estado de um app Flutter.
* Diagnosticar problemas de desempenho de jank da UI em um app Flutter.
* Profiling de CPU para um app Flutter ou Dart.
* Profiling de rede para um app Flutter.
* Depuração em nível de código-fonte de um app Flutter ou Dart.
* Depurar problemas de memória em um app de linha de comando Flutter ou Dart.
* Visualizar logs gerais e informações de diagnóstico sobre um app de linha de comando Flutter ou Dart em execução.
* Analisar o código e o tamanho do app.
* Validar links diretos no seu app Android.

Esperamos que você use o DevTools em conjunto com
seu IDE existente ou fluxo de trabalho de desenvolvimento baseado em linha de comando.

<a id="how-do-i-install-devtools"></a>
<a id="install-devtools"></a>

## Como iniciar o DevTools {:#start}

Consulte as páginas do [VS Code][], [Android Studio/IntelliJ][] ou
[linha de comando][] para obter instruções sobre como iniciar o DevTools.

## Solução de problemas comuns

**Pergunta**: Meu app parece instável ou gagueja.
Como faço para corrigir isso?

**Resposta**: Problemas de desempenho podem fazer com que [frames da UI][]
fiquem instáveis e/ou lentos em algumas operações.

  1. Para detectar qual código afeta frames atrasados concretos,
     comece em [Performance > Timeline][].
  2. Para saber qual código leva mais tempo de CPU em
     segundo plano, use o [profiler de CPU][].

Para obter mais informações, consulte a página [Performance][].

**Pergunta**: Vejo muitos eventos de coleta de lixo (GC) ocorrendo.
Isso é um problema?

**Resposta**: Eventos de GC frequentes podem ser exibidos no
  DevTools > Memória > Gráfico de Memória. Na maioria dos casos,
  não é um problema.

Se seu app tiver atividade frequente em segundo plano com algum tempo ocioso,
o Flutter pode usar essa oportunidade para coletar os objetos criados
sem impacto no desempenho.

[profiler de CPU]: /tools/devtools/cpu-profiler
[Performance]: /perf
[Performance > Timeline]: /tools/devtools/performance#timeline-events-tab
[UI frames]: /perf/ui-performance

## Fornecendo feedback

Por favor, experimente o DevTools, forneça feedback e registre problemas
no [rastreador de problemas do DevTools][]. Obrigado!

## Outros recursos

Para obter mais informações sobre depuração e profiling de
apps Flutter, consulte a página [Depuração][] e,
em particular, sua lista de [outros recursos][].

Para obter mais informações sobre como usar o DevTools com
apps de linha de comando Dart, consulte a
[documentação do DevTools em dart.dev]({{site.dart-site}}/tools/dart-devtools).

[Android Studio/IntelliJ]: /tools/devtools/android-studio
[VS Code]: /tools/devtools/vscode
[linha de comando]: /tools/devtools/cli
[rastreador de problemas do DevTools]: {{site.github}}/flutter/devtools/issues
[Depuração]: /testing/debugging
[Outros recursos]: /testing/debugging#other-resources
