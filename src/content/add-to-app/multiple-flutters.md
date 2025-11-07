---
ia-translate: true
title: Múltiplas telas ou views Flutter
short-title: Adicione múltiplos Flutters
description: >
  Como integrar múltiplas instâncias do
  engine, telas ou views Flutter à sua aplicação.
---

## Cenários

Se você está integrando Flutter a um app existente,
ou migrando gradualmente um app existente para usar Flutter,
você pode se encontrar querendo adicionar múltiplas
instâncias Flutter ao mesmo projeto.
Em particular, isso pode ser útil nos
seguintes cenários:

* Uma aplicação onde a tela Flutter integrada não é um nó folha do
  grafo de navegação, e a pilha de navegação pode ser uma mistura híbrida de
  nativo -> Flutter -> nativo -> Flutter.
* Uma tela onde múltiplas views Flutter parciais de tela podem ser integradas
  e visíveis ao mesmo tempo.

A vantagem de usar múltiplas instâncias Flutter é que cada
instância é independente e mantém sua própria pilha de navegação
interna, UI e estados de aplicação. Isso simplifica a
responsabilidade geral do código da aplicação para manter estado e melhora a modularidade. Mais detalhes sobre os
cenários que motivam o uso de múltiplos Flutters podem ser encontrados em
[flutter.dev/go/multiple-flutters][].

O Flutter é otimizado para este cenário, com um baixo custo incremental
de memória (~180kB) para adicionar instâncias Flutter adicionais. Este custo fixo de
redução permite que o padrão de múltiplas instâncias Flutter seja usado mais liberalmente
em sua integração add-to-app.

## Componentes

A API principal para adicionar múltiplas instâncias Flutter tanto no Android quanto no iOS
é baseada em uma nova classe `FlutterEngineGroup` ([API Android][Android API], [API iOS][iOS API])
para construir `FlutterEngine`s, em vez dos construtores de `FlutterEngine`
usados anteriormente.

Enquanto a API `FlutterEngine` era direta e mais fácil de consumir, os
`FlutterEngine`s gerados do mesmo `FlutterEngineGroup` têm a vantagem de desempenho
de compartilhar muitos dos recursos comuns e reutilizáveis, como o contexto
GPU, métricas de fonte e snapshot do grupo de isolate, levando a uma latência de
renderização inicial mais rápida e menor footprint de memória.

* `FlutterEngine`s gerados de `FlutterEngineGroup` podem ser usados para
   conectar a classes de UI como [`FlutterActivity`][] ou [`FlutterViewController`][]
   da mesma forma que `FlutterEngine`s em cache normalmente construídos.

* O primeiro `FlutterEngine` gerado do `FlutterEngineGroup` não precisa
  continuar sobrevivendo para que `FlutterEngine`s subsequentes compartilhem
  recursos, desde que haja pelo menos 1 `FlutterEngine` vivo em todos os
  momentos.

* Criar o primeiro `FlutterEngine` de um `FlutterEngineGroup` tem
  as mesmas [características de desempenho][performance characteristics] que construir um
  `FlutterEngine` usando os construtores anteriormente.

* Quando todos os `FlutterEngine`s de um `FlutterEngineGroup` são destruídos, o próximo
  `FlutterEngine` criado tem as mesmas características de desempenho que o
  primeiro engine.

* O `FlutterEngineGroup` em si não precisa viver além de todos os engines
  gerados. Destruir o `FlutterEngineGroup` não afeta os engines gerados
  existentes, mas remove a capacidade de gerar `FlutterEngine`s adicionais
  que compartilham recursos com engines gerados existentes.

## Comunicação

A comunicação entre instâncias Flutter é tratada usando [platform channels][]
(ou [Pigeon][]) através da plataforma hospedeira. Para ver nosso roadmap sobre comunicação,
ou outro trabalho planejado para aprimorar múltiplas instâncias Flutter, confira a
[Issue 72009][].

## Exemplos

Você pode encontrar um exemplo demonstrando como usar `FlutterEngineGroup`
tanto no Android quanto no iOS no [GitHub][].

{% render docs/app-figure.md, image:"development/add-to-app/multiple-flutters-sample.gif", alt:"A sample demonstrating multiple-Flutters" %}

[GitHub]: {{site.repo.samples}}/tree/main/add_to_app/multiple_flutters
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[performance characteristics]: /add-to-app/performance
[flutter.dev/go/multiple-flutters]: /go/multiple-flutters
[Issue 72009]: {{site.repo.flutter}}/issues/72009
[Pigeon]: {{site.pub}}/packages/pigeon
[platform channels]: /platform-integration/platform-channels
[Android API]: https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/engine/FlutterEngineGroup.java
[iOS API]: https://cs.opensource.google/flutter/engine/+/main:shell/platform/darwin/ios/framework/Headers/FlutterEngineGroup.h
