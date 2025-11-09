---
ia-translate: true
title: Flutter Widget Previewer
description: >-
  Aprenda como usar o Flutter Widget Previewer para ver seus
  widgets renderizarem em tempo real, separados do seu app completo.
---

Neste guia, você aprenderá como usar o
Flutter Widget Previewer.

## Visão geral

Com o Flutter Widget Previewer, você pode ver seus widgets
renderizarem em tempo real, separados de um app completo, no
navegador Chrome. Para iniciar o previewer, mostrar um widget
nele e personalizar uma preview, veja as seções a seguir.

:::version-note
O Flutter Widget Preview requer Flutter versão 3.35 ou
superior. Suporte de IDE requer Flutter versão 3.38 ou superior.

Por favor, esteja ciente de que este é um **recurso experimental**
disponível no canal stable do Flutter. As APIs não são
estáveis e _vão mudar_. Este guia é para a versão
de acesso antecipado atual, e você deve esperar que atualizações futuras
introduzam mudanças incompatíveis.
:::

## Abrindo o previewer

### IDEs

A partir do Flutter 3.38, Android Studio, Intellij e Visual
Studio Code iniciam automaticamente o Flutter Widget Previewer
ao serem lançados.

#### Android Studio e Intellij

Para abrir o Widget Previewer no Android Studio ou Intellij, abra
a aba "Flutter Widget Preview" na barra lateral:

![Flutter Widget Previewer in Android Studio](/assets/images/docs/tools/widget-previewer/android-studio.png "Android Studio")

#### Visual Studio Code

Para abrir o Widget Previewer no Visual Studio Code, abra a
aba "Flutter Widget Preview" na barra lateral:

![Flutter Widget Previewer in Visual Studio Code](/assets/images/docs/tools/widget-previewer/vscode.png "Visual Studio Code")

### Linha de comando

Para iniciar o Flutter Widget Previewer, navegue até o
diretório raiz do seu projeto Flutter e execute o seguinte
comando em seu terminal. Isso lançará um servidor local
e abrirá um ambiente Widget Preview no Chrome que
atualiza automaticamente com base em mudanças em seu projeto.

```shell
flutter widget-preview start
```

## Preview de um widget

Depois de ter iniciado o previewer, para visualizar um widget,
você deve usar a anotação [`@Preview`][`@Preview`] definida em
`package:flutter/widget_previews.dart`. Esta anotação
pode ser aplicada a:

- **Funções top-level** que retornam um `Widget` ou
  `WidgetBuilder`.
- **Métodos estáticos** dentro de uma classe que retornam um `Widget` ou
  `WidgetBuilder`.
- **Construtores e factories de Widget públicos** sem
  argumentos obrigatórios.

Aqui está um exemplo básico de como usar a
anotação `@Preview` para fazer preview de um widget `Text`:

```dart
import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart'; // For Material widgets

@Preview(name: 'My Sample Text')
Widget mySampleText() {
  return const Text('Hello, World!');
}
```

![Sample widget in Flutter Widget Previewer](/assets/images/docs/tools/widget-previewer/widget-previewer.png "Example widget")
Cada instância de preview fornece vários controles para
interagir com o widget em preview. Da esquerda para a direita:

- **Zoom in:** Amplia o widget na preview.

- **Zoom out:** Reduz a ampliação do widget na
  preview.

- **Reset zoom:** Retorna a preview do widget ao seu
  nível de zoom padrão.

- **Alternar entre modo claro e escuro:** Alterna o
  tema da preview entre um esquema de cores claro e escuro.

- **Executar um hot restart para a preview individual:**
  Reinicia apenas a preview de widget específica,
  permitindo que mudanças sejam aplicadas rapidamente sem
  reiniciar a aplicação inteira.

Para o caso em que o estado global foi modificado
(por exemplo, um inicializador estático foi alterado), o
previewer de widget inteiro pode ser instruído a fazer hot restart usando o
botão no canto inferior direito do ambiente.

### Filtrar previews por arquivo selecionado

Ao visualizar previews dentro de uma IDE, o previewer de widget é
configurado para filtrar o conjunto de previews com base no arquivo
atualmente selecionado:

![Filter by previews selected file in Flutter Widget Previewer](/assets/images/docs/tools/widget-previewer/filter-by-file.gif "Filter previews by selected file")

Para desabilitar este comportamento, alterne a opção "Filter previews by selected file"
no canto inferior esquerdo do ambiente.

## Personalizar uma preview

A anotação [`@Preview`][`@Preview`] tem vários parâmetros que você pode
usar para personalizar a preview:

- **`name`**: Um nome descritivo para a preview.

- **`group`**: Um nome usado para agrupar previews relacionadas juntas
  no previewer de widget.

- **`size`**: Restrições de tamanho artificiais usando um
  objeto `Size`.

- **`textScaleFactor`**: Uma escala de fonte customizada.

- **`wrapper`**: Uma função que envolve seu widget em preview
  em uma árvore de widgets específica (por exemplo, para injetar
  estado de aplicação na árvore de widgets com um
  `InheritedWidget`).

- **`theme`**: Uma função para fornecer dados de tema Material e
  Cupertino.

- **`brightness`**: O brilho inicial do tema.

- **`localizations`**: Uma função para aplicar uma configuração
  de localização.

## Criar anotações de preview customizadas

Para reduzir a quantidade de boilerplate necessária para definir previews com
um conjunto comum de propriedades, a classe de anotação [`Preview`][`Preview`] pode ser
estendida para criar anotações de preview customizadas adaptadas para seu projeto.

Aqui está um exemplo de uma anotação de preview customizada que fornece
dados de tema:

```dart
final class MyCustomPreview extends Preview {
  const MyCustomPreview({
    super.name,
    super.group,
    super.size,
    super.textScaleFactor,
    super.wrapper,
    super.brightness,
    super.localizations,
  }) : super(theme: MyCustomPreview.themeBuilder);

  static PreviewThemeData themeBuilder() {
    return PreviewThemeData(
      materialLight: ThemeData.light(),
      materialDark: ThemeData.dark(),
    );
  }
}
```

Estender a classe de anotação [`Preview`][`Preview`] também permite sobrescrever
o método [`Preview.transform()`][`Preview.transform()`]. Este método é invocado pelo previewer de widget
e pode ser usado para modificar a preview em tempo de execução, permitindo
configurações de preview que não seriam possíveis em um contexto `const`:

```dart
final class TransformativePreview extends Preview {
  const TransformativePreview({
    super.name,
    super.group,
    super.size,
    super.textScaleFactor,
    super.wrapper,
    super.brightness,
    super.localizations,
  });

  // Nota: isso não é mais público ou estático pois é injetado
  // em tempo de execução quando transform() é invocado.
  PreviewThemeData _themeBuilder() {
    return PreviewThemeData(
      materialLight: ThemeData.light(),
      materialDark: ThemeData.dark(),
    );
  }

  @override
  Preview transform() {
    final originalPreview = super.transform();
    // Cria um PreviewBuilder que pode ser usado para modificar
    // os conteúdos da preview.
    final builder = originalPreview.toBuilder();
    builder
      ..name = 'Transformed - ${originalPreview.name}'
      ..theme = _themeBuilder;

    // Retorna a instância Preview atualizada.
    return builder.toPreview();
  }
}
```

## Criando múltiplas configurações de preview

Criar múltiplas previews com configurações diferentes pode ser tão
simples quanto aplicar múltiplas anotações [`@Preview`][`@Preview`] a uma única
função ou construtor:

```dart
@Preview(
  group: 'Brightness',
  name: 'Example - light',
  brightness: Brightness.light,
)
@Preview(
  group: 'Brightness',
  name: 'Example - dark',
  brightness: Brightness.dark,
)
Widget buttonPreview() => const ButtonShowcase();
```

![Multiple previews in Flutter Widget Previewer](/assets/images/docs/tools/widget-previewer/multi-preview.png "Multiple preview example")

Para simplificar a criação de múltiplas previews com configurações comuns, você
pode estender o [`MultiPreview`][`MultiPreview`] para criar uma anotação customizada que cria
múltiplas previews. O seguinte [`MultiPreview`][`MultiPreview`] cria
as mesmas duas previews do exemplo anterior:

```dart
/// Cria previews em modo claro e escuro.
final class MultiBrightnessPreview extends MultiPreview {
  const MultiBrightnessPreview();

  @override
  List<Preview> get previews => const [
        Preview(
          group: 'Brightness',
          name: 'Example - light',
          brightness: Brightness.light,
        ),
        Preview(
          group: 'Brightness',
          name: 'Example - dark',
          brightness: Brightness.dark,
        ),
      ];
}

@MultiBrightnessPreview()
Widget buttonPreview() => const ButtonShowcase();
```

Assim como [`Preview`][`Preview`], [`MultiPreview`][`MultiPreview`] também fornece um
método [`MultiPreview.transform()`][`MultiPreview.transform()`] para executar transformações
em cada preview em tempo de execução:

```dart
/// Cria previews em modo claro e escuro.
final class MultiBrightnessPreview extends MultiPreview {
  const MultiBrightnessPreview({required this.name});

  final String name;

  @override
  List<Preview> get previews => const [
        Preview(brightness: Brightness.light),
        Preview(brightness: Brightness.dark),
      ];

  @override
  List<Preview> transform() {
    final previews = super.transform();
    return previews.map((preview) {
      final builder = preview.toBuilder()
        ..group = 'Brightness'
        // Construir nomes baseados em valores fornecidos à anotação
        // não é possível dentro de um construtor constante. No entanto,
        // não há tal restrição ao construir uma Preview em
        // tempo de execução.
        ..name = '$name - ${preview.brightness!.name}';
      return builder.toPreview();
    }).toList();
  }
}

@MultiBrightnessPreview(name: 'Example')
Widget buttonPreview() => const ButtonShowcase();
```

## Restrições e limitações

O Flutter Widget Previewer tem certas restrições que
você deve estar ciente:

- **Nomes de callback públicos**: Todos os argumentos de callback fornecidos a
  anotações de preview devem ser públicos e constantes.
  Isso é necessário para que a implementação de geração de código
  do previewer funcione corretamente.

- **APIs não suportadas**: Plugins nativos e quaisquer APIs das
  bibliotecas `dart:io` ou `dart:ffi` não são suportadas.
  Isso ocorre porque o previewer de widget é construído com
  Flutter Web, que não tem acesso às APIs de
  plataforma nativa subjacentes. Embora plugins web possam funcionar ao
  usar Chrome, não há garantia de que funcionarão
  dentro de outros ambientes, como quando incorporados em
  IDEs.

  Widgets com dependências transitivas em `dart:io` serão
  carregados corretamente, mas todas as APIs de `dart:io` lançarão uma
  exceção quando invocadas. Widgets com dependências transitivas
  em `dart:ffi` falharão ao carregar completamente ([#166431][#166431]).

  Veja a [documentação Dart sobre importações condicionais][Dart documentation on conditional imports] para detalhes
  sobre como estruturar sua aplicação para suportar de forma limpa
  bibliotecas específicas de plataforma ao direcionar múltiplas plataformas.

- **Caminhos de asset**: Ao usar APIs `fromAsset` de
  `dart:ui` para carregar recursos, você deve usar
  **caminhos baseados em package** ao invés de caminhos locais diretos.
  Isso garante que os assets possam ser corretamente localizados
  e carregados dentro do ambiente web do previewer. Por
  exemplo, use `'packages/my_package_name/assets/my_image.png'`
  ao invés de `'assets/my_image.png'`.

- **Widgets sem restrições**: Widgets sem restrições são
  automaticamente restritos a aproximadamente metade da
  altura e largura do previewer de widget. Este comportamento
  provavelmente mudará no futuro, então restrições devem
  ser aplicadas usando o parâmetro `size` quando possível.

- **Suporte multi-projeto em IDEs**: O previewer de widget
  atualmente apenas suporta exibir previews contidas
  dentro de um único projeto ou workspace Pub. Estamos ativamente
  investigando opções para suportar sessões de IDE com múltiplos
  projetos Flutter ([#173550][#173550]).

[`@Preview`]: {{site.api}}/flutter/widget_previews/Preview-class.html
[`Preview`]: {{site.api}}/flutter/widget_previews/Preview-class.html
[`Preview.transform()`]: {{site.api}}/flutter/widget_previews/Preview/transform.html
[`MultiPreview`]: {{site.api}}/flutter/widget_previews/MultiPreview-class.html
[`MultiPreview.transform()`]: {{site.api}}/flutter/widget_previews/MultiPreview/transform.html
[Dart documentation on conditional imports]: {{site.dart-site}}/tools/pub/create-packages#conditionally-importing-and-exporting-library-files
[#166431]: https://github.com/flutter/flutter/issues/166431
[#173550]: https://github.com/flutter/flutter/issues/173550
