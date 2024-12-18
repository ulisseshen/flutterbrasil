---
ia-translate: true
title: Dispositivos de rolagem por arrasto padrão
description: >
  ScrollBehaviors agora configuram quais
  PointerDeviceKinds podem arrastar Scrollables.
---

## Resumo

`ScrollBehavior`s agora permitem ou impedem a rolagem por arrasto de
`PointerDeviceKind`s especificados. `ScrollBehavior.dragDevices`, por padrão,
permite que widgets de rolagem sejam arrastados por todos os
`PointerDeviceKind`s, exceto por `PointerDeviceKind.mouse`.

## Contexto

Antes desta alteração, todos os `PointerDeviceKind`s podiam arrastar um widget
`Scrollable`. Isso não correspondia às expectativas dos desenvolvedores ao
interagir com aplicativos Flutter usando dispositivos de entrada de mouse. Isso
também dificultava a execução de outros gestos do mouse, como selecionar texto
que estava contido em um widget `Scrollable`.

Agora, o `ScrollBehavior` herdado gerencia quais dispositivos podem arrastar
widgets de rolagem, conforme especificado por `ScrollBehavior.dragDevices`. Este
conjunto de `PointerDeviceKind`s tem permissão para arrastar.

## Descrição da alteração

Essa alteração corrigiu a capacidade inesperada de rolar arrastando com o mouse.

Se você confiou no comportamento anterior em seu aplicativo, existem várias
maneiras de controlar e configurar esse recurso.

- Estenda `ScrollBehavior`, `MaterialScrollBehavior` ou `CupertinoScrollBehavior`
para modificar o comportamento padrão, substituindo `ScrollBehavior.dragDevices`.

  - Com seu próprio `ScrollBehavior`, você pode aplicá-lo em todo o aplicativo
    definindo `MaterialApp.scrollBehavior` ou `CupertinoApp.scrollBehavior`.
  - Ou, se você deseja aplicá-lo apenas a widgets específicos, adicione um
    `ScrollConfiguration` acima do widget em questão com seu `ScrollBehavior`
    personalizado.

Seus widgets roláveis ​​herdam e refletem esse comportamento.

- Em vez de criar seu próprio `ScrollBehavior`, outra opção para alterar
o comportamento padrão é copiar o `ScrollBehavior` existente e definir
`dragDevices` diferentes.
  - Crie um `ScrollConfiguration` em sua árvore de widgets e forneça uma cópia
    modificada do `ScrollBehavior` existente no contexto atual usando
    `copyWith`.

Para acomodar a nova configuração de dispositivos de arrasto em
`ScrollBehavior`, `GestureDetector.kind` foi descontinuado junto com todas as
instâncias de subclasses do parâmetro. Uma correção do flutter está disponível
para migrar o código existente para todos os detectores de gestos de `kind` para
`supportedDevices`. O parâmetro anterior `kind` permitia que apenas um
`PointerDeviceKind` fosse usado para filtrar gestos. A introdução de
`supportedDevices` torna possível o uso de mais de um `PointerDeviceKind`
válido.

## Guia de migração

### Definindo um `ScrollBehavior` personalizado para seu aplicativo

Código antes da migração:

```dart
MaterialApp(
  // ...
);
```

Código após a migração:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua métodos de comportamento e getters como dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// Define ScrollBehavior para um aplicativo inteiro.
MaterialApp(
  scrollBehavior: MyCustomScrollBehavior(),
  // ...
);
```

### Definindo um `ScrollBehavior` personalizado para um widget específico

Código antes da migração:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Código após a migração:

```dart
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Substitua métodos de comportamento e getters como dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// ScrollBehavior pode ser definido para um widget específico.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: MyCustomScrollBehavior(),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
     return Text('Item $index');
    }
  ),
);
```

### Copiar e modificar o `ScrollBehavior` existente

Código antes da migração:

```dart
final ScrollController controller = ScrollController();
ListView.builder(
  controller: controller,
  itemBuilder: (BuildContext context, int index) {
   return Text('Item $index');
 }
);
```

Código após a migração:

```dart
// ScrollBehavior pode ser copiado e ajustado.
final ScrollController controller = ScrollController();
ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  }),
  child: ListView.builder(
    controller: controller,
    itemBuilder: (BuildContext context, int index) {
     return Text('Item $index');
    }
  ),
);
```

### Migrar `GestureDetector`s de `kind` para `supportedDevices`

Código antes da migração:

```dart
VerticalDragGestureRecognizer(
  kind: PointerDeviceKind.touch,
);
```

Código após a migração:

```dart
VerticalDragGestureRecognizer(
  supportedDevices: <PointerDeviceKind>{ PointerDeviceKind.touch },
);
```

## Linha do tempo

Implementado na versão: 2.3.0-12.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`ScrollConfiguration`][]
* [`ScrollBehavior`][]
* [`MaterialScrollBehavior`][]
* [`CupertinoScrollBehavior`][]
* [`PointerDeviceKind`][]
* [`GestureDetector`][]

Problema relevante:

* [Issue #71322][]

PRs relevantes:

* [Rejeitar arrastos do mouse por padrão em roláveis][]
* [Descontinuar GestureDetector.kind em favor de novos supportedDevices][]


[`ScrollConfiguration`]: {{site.api}}/flutter/widgets/ScrollConfiguration-class.html
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[`MaterialScrollBehavior`]: {{site.api}}/flutter/material/MaterialScrollBehavior-class.html
[`CupertinoScrollBehavior`]: {{site.api}}/flutter/cupertino/CupertinoScrollBehavior-class.html
[`PointerDeviceKind`]: {{site.api}}/flutter/dart-ui/PointerDeviceKind-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Issue #71322]: {{site.repo.flutter}}/issues/71322
[Rejeitar arrastos do mouse por padrão em roláveis]: {{site.repo.flutter}}/pull/81569
[Descontinuar GestureDetector.kind em favor de novos supportedDevices]: {{site.repo.flutter}}/pull/81858
