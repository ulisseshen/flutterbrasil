---
ia-translate: true
title: Múltiplas telas ou views Flutter
shortTitle: Adicione múltiplos Flutters
description: >
  Como integrar múltiplas instâncias de
  engine Flutter, telas ou views ao seu aplicativo.
---

## Cenários

Se você está integrando Flutter em um app existente,
ou gradualmente migrando um app existente para usar Flutter,
você pode se encontrar querendo adicionar múltiplas
instâncias Flutter ao mesmo projeto.
Em particular, isso pode ser útil nos
seguintes cenários:

* Um aplicativo onde a tela Flutter integrada não é um nó folha do
  grafo de navegação, e a pilha de navegação pode ser uma mistura híbrida de
  nativo -> Flutter -> nativo -> Flutter.
* Uma tela onde múltiplas views Flutter de tela parcial podem ser integradas
  e visíveis ao mesmo tempo.

A vantagem de usar múltiplas instâncias Flutter é que cada
instância é independente e mantém sua própria pilha de navegação
interna, UI e estados de aplicação. Isso simplifica a responsabilidade geral
do código do aplicativo pela manutenção de estado e melhora a modularidade. Mais detalhes sobre os
cenários motivando o uso de múltiplos Flutters podem ser encontrados em
[flutterbrasil.dev/go/multiple-flutters][flutterbrasil.dev/go/multiple-flutters].

Flutter é otimizado para este cenário, com um baixo custo incremental
de memória (~180kB) para adicionar instâncias Flutter adicionais. Este custo fixo
reduzido permite que o padrão de múltiplas instâncias Flutter seja usado mais livremente
na sua integração add-to-app.

## Componentes

A API primária para adicionar múltiplas instâncias Flutter tanto no Android quanto no iOS
é baseada em uma nova classe `FlutterEngineGroup` ([API Android][Android API], [API iOS][iOS API])
para construir `FlutterEngine`s, em vez dos construtores `FlutterEngine`
usados anteriormente.

Enquanto a API `FlutterEngine` era direta e mais fácil de consumir, os
`FlutterEngine` criados do mesmo `FlutterEngineGroup` têm a vantagem de desempenho
de compartilhar muitos dos recursos comuns e reutilizáveis, como o contexto
GPU, métricas de fonte e snapshot de grupo de isolate, levando a uma latência de
renderização inicial mais rápida e menor uso de memória.

* `FlutterEngine`s criados de `FlutterEngineGroup` podem ser usados para
   conectar a classes de UI como [`FlutterActivity`][`FlutterActivity`] ou [`FlutterViewController`][`FlutterViewController`]
   da mesma forma que `FlutterEngine`s em cache normalmente construídos.

* O primeiro `FlutterEngine` criado do `FlutterEngineGroup` não precisa
  continuar existindo para que `FlutterEngine`s subsequentes compartilhem
  recursos, desde que haja pelo menos 1 `FlutterEngine` vivo em todos
  os momentos.

* Criar o primeiro `FlutterEngine` de um `FlutterEngineGroup` tem
  as mesmas [características de desempenho][performance characteristics] que construir um
  `FlutterEngine` usando os construtores anteriormente.

* Quando todos os `FlutterEngine`s de um `FlutterEngineGroup` são destruídos, o próximo
  `FlutterEngine` criado tem as mesmas características de desempenho que o primeiro
  engine.

* O `FlutterEngineGroup` em si não precisa existir além de todos os engines
  criados. Destruir o `FlutterEngineGroup` não afeta engines criados existentes,
  mas remove a capacidade de criar `FlutterEngine`s adicionais
  que compartilham recursos com engines criados existentes.

## Comunicação

A comunicação entre instâncias Flutter é tratada usando [canais de plataforma][platform channels]
(ou [Pigeon][Pigeon]) através da plataforma host. Para ver nosso roadmap sobre comunicação,
ou outro trabalho planejado sobre aprimoramento de múltiplas instâncias Flutter, confira
[Issue 72009][Issue 72009].

## Amostras

Você pode encontrar um exemplo demonstrando como usar `FlutterEngineGroup`
tanto no Android quanto no iOS no [GitHub][GitHub].

<DashImage figure image="development/add-to-app/multiple-flutters-sample.webp" alt="A sample demonstrating multiple-Flutters" />

[GitHub]: {{site.repo.samples}}/tree/main/add_to_app/multiple_flutters
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[performance characteristics]: /add-to-app/performance
[flutterbrasil.dev/go/multiple-flutters]: /go/multiple-flutters
[Issue 72009]: {{site.repo.flutter}}/issues/72009
[Pigeon]: {{site.pub}}/packages/pigeon
[platform channels]: /platform-integration/platform-channels
[Android API]: https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/engine/FlutterEngineGroup.java
[iOS API]: https://cs.opensource.google/flutter/engine/+/main:shell/platform/darwin/ios/framework/Headers/FlutterEngineGroup.h
