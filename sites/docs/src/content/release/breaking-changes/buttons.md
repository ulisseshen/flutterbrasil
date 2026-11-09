---
title: Novos Botões e temas de Botões
description: As classes básicas de botões material foram substituídas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Um novo conjunto de widgets de botões material básicos e temas foi adicionado
ao Flutter. As classes originais foram descontinuadas e serão
eventualmente removidas. O objetivo geral é tornar os botões mais
flexíveis e mais fáceis de configurar por meio de parâmetros de construtor ou
temas.

Os widgets `FlatButton`, `RaisedButton` e `OutlineButton` foram
substituídos por `TextButton`, `ElevatedButton` e `OutlinedButton`
respectivamente. Cada nova classe de botão tem seu próprio tema:
`TextButtonTheme`, `ElevatedButtonTheme` e
`OutlinedButtonTheme`. A classe original `ButtonTheme` não é mais
usada. A aparência dos botões é especificada por um objeto `ButtonStyle`,
em vez de um grande conjunto de parâmetros e propriedades de widget.
Isso é aproximadamente comparável à forma como a aparência do texto é
definida com um objeto `TextStyle`. Os novos temas de botões também são
configurados com um objeto `ButtonStyle`. Um `ButtonStyle` é, em si, apenas
uma coleção de propriedades visuais. Muitas dessas propriedades são
definidas com `MaterialStateProperty`, o que significa que seu valor pode
depender do estado do botão.


## Contexto {:#context}

Em vez de tentar evoluir as classes de botões existentes e seus temas
in-place, introduzimos novos widgets de botões e temas de substituição.
Além de nos libertar do labirinto de compatibilidade retroativa que
evoluir as classes existentes in-place implicaria, os novos nomes
sincronizam o Flutter de volta com a especificação do Material Design,
que usa os novos nomes para os componentes de botão.

| Widget antigo   | Tema antigo   | Novo widget      | Novo tema             |
|-----------------|---------------|------------------|-----------------------|
| `FlatButton`    | `ButtonTheme` | `TextButton`     | `TextButtonTheme`     |
| `RaisedButton`  | `ButtonTheme` | `ElevatedButton` | `ElevatedButtonTheme` |
| `OutlineButton` | `ButtonTheme` | `OutlinedButton` | `OutlinedButtonTheme` |

{:.table .table-striped .nowrap}

Os novos temas seguem o padrão "normalized" que o Flutter adotou para os
novos widgets Material há cerca de um ano. As propriedades de tema e os
parâmetros de construtor dos widgets são null por padrão. Propriedades de
tema e parâmetros de widget não nulos especificam uma substituição do valor
padrão do componente. Implementar e documentar os valores padrão é
responsabilidade exclusiva dos widgets de componente de botão. Os próprios
padrões são baseados principalmente no `colorScheme` e no `textTheme` do
Theme geral.

Visualmente, os novos botões têm uma aparência um pouco diferente, porque
seguem a especificação atual do Material Design e porque suas cores são
configuradas em termos do `ColorScheme` do Theme geral. Há outras pequenas
diferenças no preenchimento (padding), nos raios dos cantos arredondados e
no feedback de hover, foco e pressionado.

Muitas aplicações poderão apenas substituir os nomes das classes antigas
pelos novos. Apps com testes de imagem golden, ou com botões cuja aparência
foi configurada com parâmetros de construtor ou com o `ButtonTheme` original,
podem precisar consultar o guia de migração e o material introdutório a seguir.

## Mudança da API: ButtonStyle em vez de propriedades de estilo individuais {:#api-change-buttonstyle-instead-of-individual-style-properties}

Exceto em casos de uso simples, as APIs das novas classes de botões não são
compatíveis com as classes antigas. Os atributos visuais dos novos botões e
temas são configurados com um único objeto `ButtonStyle`, de forma semelhante
a como um `TextField` ou um widget `Text` pode ser configurado com um objeto
`TextStyle`. A maioria das propriedades de `ButtonStyle` é definida com
`MaterialStateProperty`, de modo que uma única propriedade pode representar
valores diferentes conforme o estado do botão (pressionado, focado, com hover etc.).

O `ButtonStyle` de um botão não define as propriedades visuais dele, mas sim
substituições das propriedades visuais padrão do botão, que são calculadas
pelo próprio widget do botão. Por exemplo, para substituir a cor de primeiro
plano padrão (texto/ícone) de um `TextButton` em todos os estados, você pode
escrever:

```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

Esse tipo de substituição é comum; no entanto, em muitos casos também é preciso
substituir as cores de sobreposição que o text button usa para indicar seu
estado de hover, foco ou pressionado. Isso pode ser feito adicionando a
propriedade `overlayColor` ao `ButtonStyle`.

```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered))
          return Colors.blue.withOpacity(0.04);
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed))
          return Colors.blue.withOpacity(0.12);
        return null; // Defer to the widget's default.
      },
    ),
  ),
  onPressed: () { },
  child: Text('TextButton')
)
```

Um `MaterialStateProperty` de cor só precisa retornar um valor para as cores
cujo padrão deve ser substituído. Se ele retornar null, o padrão do widget será
usado no lugar. Por exemplo, para substituir apenas a cor de sobreposição de
foco do text button:

```dart
TextButton(
  style: ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused))
          return Colors.red;
        return null; // Defer to the widget's default.
      }
    ),
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

### Os métodos utilitários `styleFrom()` do ButtonStyle {:#the-stylefrom-buttonstyle-utility-methods}

A especificação do Material Design define as cores de primeiro plano e de
sobreposição dos botões em termos da cor primária do esquema de cores. A cor
primária é renderizada com opacidades diferentes, conforme o estado do botão.
Para simplificar a criação de um estilo de botão que inclua todas as
propriedades que dependem das cores do esquema de cores, cada classe de botão
inclui um método estático `styleFrom()`, que constrói um `ButtonStyle` a partir
de um conjunto simples de valores, incluindo as cores de `ColorScheme` das
quais ele depende.

Este exemplo cria um botão que substitui sua cor de primeiro plano, bem como
sua cor de sobreposição, usando a cor primária especificada e as opacidades da
especificação do Material Design.

```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

A documentação do `TextButton` indica que a cor de primeiro plano quando o
botão está desabilitado é baseada na cor `disabledForegroundColor` do esquema
de cores. Para substituir essa cor também, usando `styleFrom()`:

```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    disabledForegroundColor: Colors.red,
  ),
  onPressed: null,
  child: Text('TextButton'),
)
```

Usar o método `styleFrom()` é a forma preferida de criar um `ButtonStyle`
quando você quer criar uma variação do Material Design. A abordagem mais
flexível é definir um `ButtonStyle` diretamente, com valores de
`MaterialStateProperty` para os estados cuja aparência você quer substituir.

## Padrões do ButtonStyle {:#buttonstyle-defaults}

Widgets como as novas classes de botões _calculam_ seus valores padrão com base
no `colorScheme` e no `textTheme` do tema geral, além do estado atual do botão.
Em alguns casos, também consideram se o esquema de cores do tema geral é claro
ou escuro. Cada botão tem um método protegido que calcula seu estilo padrão
quando necessário. Embora os apps não chamem esse método diretamente, a
documentação da API dele explica quais são todos os padrões. Quando um botão
ou tema de botão especifica um `ButtonStyle`, somente as propriedades não nulas
desse estilo substituem os padrões calculados. O parâmetro `style` do botão
substitui as propriedades não nulas especificadas pelo tema de botão
correspondente. Por exemplo, se a propriedade `foregroundColor` do estilo de um
`TextButton` for não nula, ela substitui a mesma propriedade do estilo do
`TextButtonTheme`.

Como explicado antes, cada classe de botão inclui um método estático chamado
`styleFrom`, que constrói um `ButtonStyle` a partir de um conjunto simples de
valores, incluindo as cores de `ColorScheme` das quais ele depende. Em muitos
casos comuns, usar `styleFrom` para criar um `ButtonStyle` pontual que substitui
os padrões é o mais simples. Isso vale especialmente quando o objetivo do estilo
personalizado é substituir uma das cores do esquema de cores, como `primary` ou
`onPrimary`, das quais o estilo padrão depende. Para outros casos, você pode
criar um objeto `ButtonStyle` diretamente. Assim, é possível controlar o valor
de propriedades visuais, como cores, para todos os estados possíveis do botão,
como pressionado, com hover, desabilitado e focado.


## Guia de migração {:#migration-guide}

Use as informações a seguir para migrar seus botões para a nova API.

### Restaurando os visuais originais dos botões {:#restoring-the-original-button-visuals}

Em muitos casos, é possível simplesmente trocar a classe de botão antiga pela
nova. Isso pressupõe que as pequenas mudanças de tamanho/formato e a provável
mudança maior nas cores não sejam uma preocupação.

Para preservar a aparência dos botões nesses casos, é possível definir estilos
de botão que correspondam ao original com a fidelidade que você quiser. Por
exemplo, o estilo a seguir faz um `TextButton` parecer um `FlatButton` padrão:

```dart
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

TextButton(
  style: flatButtonStyle,
  onPressed: () { },
  child: Text('Looks like a FlatButton'),
)
```

Da mesma forma, para fazer um `ElevatedButton` parecer um `RaisedButton` padrão:

```dart
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
ElevatedButton(
  style: raisedButtonStyle,
  onPressed: () { },
  child: Text('Looks like a RaisedButton'),
)
```

O estilo do `OutlineButton` para o `OutlinedButton` é um pouco mais complicado,
porque a cor da borda muda para a cor primária quando o botão é pressionado. A
aparência da borda é definida por um `BorderSide`, e você usará um
`MaterialStateProperty` para definir a cor da borda pressionada:

```dart
final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
).copyWith(
  side: MaterialStateProperty.resolveWith<BorderSide?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        );
      }
      return null;
    },
  ),
);

OutlinedButton(
  style: outlineButtonStyle,
  onPressed: () { },
  child: Text('Looks like an OutlineButton'),
)
```

Para restaurar a aparência padrão dos botões em todo o aplicativo, você pode
configurar os novos temas de botões no tema do aplicativo:

```dart
MaterialApp(
  theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
  ),
)
```

Para restaurar a aparência padrão dos botões em parte de um aplicativo, você
pode envolver uma subárvore de widgets com `TextButtonTheme`,
`ElevatedButtonTheme` ou `OutlinedButtonTheme`. Por exemplo:

```dart
TextButtonTheme(
  data: TextButtonThemeData(style: flatButtonStyle),
  child: myWidgetSubtree,
)
```

### Migrando botões com cores personalizadas {:#migrating-buttons-with-custom-colors}

As seções a seguir cobrem o uso dos seguintes parâmetros de cor de
`FlatButton`, `RaisedButton` e `OutlineButton`:

```dart
textColor
disabledTextColor
color
disabledColor
focusColor
hoverColor
highlightColor*
splashColor
```

As novas classes de botões não oferecem suporte a uma cor de destaque separada,
porque ela não faz mais parte do Material Design.

#### Migrando botões com cores de primeiro plano e de fundo personalizadas {:#migrating-buttons-with-custom-foreground-and-background-colors}

Duas personalizações comuns das classes de botão originais são uma cor de
primeiro plano personalizada para o `FlatButton`, ou cores de primeiro plano e
de fundo personalizadas para o `RaisedButton`. Obter o mesmo resultado com as
novas classes de botões é simples:

```dart
FlatButton(
  textColor: Colors.red, // foreground
  onPressed: () { },
  child: Text('FlatButton with custom foreground/background'),
)

TextButton(
  style: TextButton.styleFrom(
    foregroundColor Colors.red,
  ),
  onPressed: () { },
  child: Text('TextButton with custom foreground'),
)
```

Neste caso, a cor de primeiro plano (texto/ícone) do `TextButton`, bem como
suas cores de sobreposição de hover, foco e pressionado, serão baseadas em
`Colors.red`. Por padrão, a cor de preenchimento de fundo do `TextButton` é
transparente.

Migrando um `RaisedButton` com cores de primeiro plano e de fundo personalizadas:

```dart
RaisedButton(
  color: Colors.red, // background
  textColor: Colors.white, // foreground
  onPressed: () { },
  child: Text('RaisedButton with custom foreground/background'),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
  onPressed: () { },
  child: Text('ElevatedButton with custom foreground/background'),
)
```

Neste caso, o uso da cor primária do esquema de cores pelo botão é invertido em
relação ao `TextButton`: a cor primária é a cor de preenchimento de fundo do
botão, e `onPrimary` é a cor de primeiro plano (texto/ícone).

#### Migrando botões com cores de sobreposição personalizadas {:#migrating-buttons-with-custom-overlay-colors}

Substituir as cores padrão de foco, hover, destaque ou splash é menos comum. As
classes `FlatButton`, `RaisedButton` e `OutlineButton` têm parâmetros
individuais para essas cores dependentes de estado. As novas classes
`TextButton`, `ElevatedButton` e `OutlinedButton` usam, em vez disso, um único
parâmetro `MaterialStateProperty<Color>`. Os novos botões permitem especificar
valores dependentes de estado para todas as cores; os botões originais só
permitiam especificar o que hoje se chama "overlayColor".

```dart
FlatButton(
  focusColor: Colors.red,
  hoverColor: Colors.green,
  splashColor: Colors.blue,
  onPressed: () { },
  child: Text('FlatButton with custom overlay colors'),
)

TextButton(
  style: ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused))
          return Colors.red;
        if (states.contains(MaterialState.hovered))
            return Colors.green;
        if (states.contains(MaterialState.pressed))
            return Colors.blue;
        return null; // Defer to the widget's default.
    }),
  ),
  onPressed: () { },
  child: Text('TextButton with custom overlay colors'),
)
```

A nova versão é mais flexível, embora menos compacta. Na versão original, a
precedência dos diferentes estados é implícita (e não documentada) e fixa; na
nova versão, ela é explícita. Para um app que especificava essas cores com
frequência, o caminho de migração mais simples seria definir um ou mais
`ButtonStyle` que correspondam ao exemplo acima e usar apenas o parâmetro
`style`, ou definir um widget wrapper stateless que encapsule os três
parâmetros de cor.

#### Migrando botões com cores desabilitadas personalizadas {:#migrating-buttons-with-custom-disabled-colors}

Esta é uma personalização relativamente rara. As classes `FlatButton`,
`RaisedButton` e `OutlineButton` têm os parâmetros `disabledTextColor` e
`disabledColor`, que definem as cores de fundo e de primeiro plano quando o
callback `onPressed` do botão é null.

Por padrão, todos os botões usam a cor `disabledForegroundColor` do esquema de
cores, com opacidade 0,38 para a cor de primeiro plano desabilitada. Somente o
`ElevatedButton` tem uma cor de fundo não transparente, e seu valor padrão é a
cor `disabledForegroundColor` com opacidade 0,12. Assim, em muitos casos, basta
usar o método `styleFrom` para substituir as cores desabilitadas:

```dart
RaisedButton(
  disabledColor: Colors.red.withOpacity(0.12),
  disabledTextColor: Colors.red.withOpacity(0.38),
  onPressed: null,
  child: Text('RaisedButton with custom disabled colors'),
),

ElevatedButton(
  style: ElevatedButton.styleFrom(disabledForegroundColor: Colors.red),
  onPressed: null,
  child: Text('ElevatedButton with custom disabled colors'),
)
```

Para controle total sobre as cores desabilitadas, é preciso definir o estilo do
`ElevatedButton` explicitamente, em termos de `MaterialStateProperty`:

```dart
RaisedButton(
  disabledColor: Colors.red,
  disabledTextColor: Colors.blue,
  onPressed: null,
  child: Text('RaisedButton with custom disabled colors'),
)

ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled))
          return Colors.red;
        return null; // Defer to the widget's default.
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled))
          return Colors.blue;
        return null; // Defer to the widget's default.
    }),
  ),
  onPressed: null,
  child: Text('ElevatedButton with custom disabled colors'),
)
```

Assim como no caso anterior, há formas óbvias de tornar a nova versão mais
compacta em um app onde essa migração aparece com frequência.

#### Migrando botões com elevações personalizadas {:#migrating-buttons-with-custom-elevations}

Esta também é uma personalização relativamente rara. Normalmente, apenas os
`ElevatedButton`s (originalmente chamados de `RaisedButton`s) incluem mudanças
de elevação. Para elevações proporcionais a uma elevação de base (conforme a
especificação do Material Design), é possível substituir todas elas de forma
bem simples.

Por padrão, a elevação de um botão desabilitado é 0, e os demais estados são
definidos em relação a uma base de 2:

```dart
disabled: 0
hovered or focused: baseline + 2
pressed: baseline + 6
```

Assim, para migrar um `RaisedButton` para o qual todas as elevações foram
definidas:

```dart
RaisedButton(
  elevation: 2,
  focusElevation: 4,
  hoverElevation: 4,
  highlightElevation: 8,
  disabledElevation: 0,
  onPressed: () { },
  child: Text('RaisedButton with custom elevations'),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(elevation: 2),
  onPressed: () { },
  child: Text('ElevatedButton with custom elevations'),
)
```

Para substituir apenas uma elevação, como a elevação ao pressionar:

```dart
RaisedButton(
  highlightElevation: 16,
  onPressed: () { },
  child: Text('RaisedButton with a custom elevation'),
)

ElevatedButton(
  style: ButtonStyle(
    elevation: MaterialStateProperty.resolveWith<double?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed))
          return 16;
        return null;
      }),
  ),
  onPressed: () { },
  child: Text('ElevatedButton with a custom elevation'),
)
```

#### Migrando botões com formas e bordas personalizadas {:#migrating-buttons-with-custom-shapes-and-borders}

As classes originais `FlatButton`, `RaisedButton` e `OutlineButton` oferecem um
parâmetro `shape`, que define tanto o formato do botão quanto a aparência da
borda. As novas classes correspondentes e seus temas permitem especificar o
formato do botão e a borda separadamente, com os parâmetros
`OutlinedBorder shape` e `BorderSide side`.

Neste exemplo, a versão original do `OutlineButton` especifica a mesma cor de
borda no estado destacado (pressionado) que nos demais estados.

```dart
OutlineButton(
  shape: StadiumBorder(),
  highlightedBorderColor: Colors.red,
  borderSide: BorderSide(
    width: 2,
    color: Colors.red
  ),
  onPressed: () { },
  child: Text('OutlineButton with custom shape and border'),
)

OutlinedButton(
  style: OutlinedButton.styleFrom(
    shape: StadiumBorder(),
    side: BorderSide(
      width: 2,
      color: Colors.red
    ),
  ),
  onPressed: () { },
  child: Text('OutlinedButton with custom shape and border'),
)
```

A maioria dos parâmetros de estilo do novo widget `OutlinedButton`, incluindo
seu formato e sua borda, pode ser especificada com valores de
`MaterialStateProperty`, ou seja, eles podem ter valores diferentes conforme o
estado do botão. Para especificar uma cor de borda diferente quando o botão é
pressionado, faça o seguinte:

```dart
OutlineButton(
  shape: StadiumBorder(),
  highlightedBorderColor: Colors.blue,
  borderSide: BorderSide(
    width: 2,
    color: Colors.red
  ),
  onPressed: () { },
  child: Text('OutlineButton with custom shape and border'),
)

OutlinedButton(
  style: ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.pressed)
          ? Colors.blue
          : Colors.red;
        return BorderSide(color: color, width: 2);
      }
    ),
  ),
  onPressed: () { },
  child: Text('OutlinedButton with custom shape and border'),
)
```

## Linha do tempo {:#timeline}

Incluído na versão: 1.20.0-0.0.pre<br>
Na versão estável: 2.0.0

## Referências {:#references}

Documentação da API:

* [`ButtonStyle`][`ButtonStyle`]
* [`ButtonStyleButton`][`ButtonStyleButton`]
* [`ElevatedButton`][`ElevatedButton`]
* [`ElevatedButtonTheme`][`ElevatedButtonTheme`]
* [`ElevatedButtonThemeData`][`ElevatedButtonThemeData`]
* [`OutlinedButton`][`OutlinedButton`]
* [`OutlinedButtonTheme`][`OutlinedButtonTheme`]
* [`OutlinedButtonThemeData`][`OutlinedButtonThemeData`]
* [`TextButton`][`TextButton`]
* [`TextButtonTheme`][`TextButtonTheme`]
* [`TextButtonThemeData`][`TextButtonThemeData`]

PRs relevantes:

* [PR 59702: Novo universo de botões][PR 59702: New Button Universe]
* [PR 73352: Descontinuação das classes Material obsoletas: FlatButton, RaisedButton, OutlineButton][PR 73352: Deprecated obsolete Material classes: FlatButton, RaisedButton, OutlineButton]


[`ButtonStyle`]: {{site.material_ui}}/ButtonStyle-class.html
[`ButtonStyleButton`]: {{site.material_ui}}/ButtonStyleButton-class.html
[`ElevatedButton`]: {{site.material_ui}}/ElevatedButton-class.html
[`ElevatedButtonTheme`]: {{site.material_ui}}/ElevatedButtonTheme-class.html
[`ElevatedButtonThemeData`]: {{site.material_ui}}/ElevatedButtonThemeData-class.html
[`OutlinedButton`]: {{site.material_ui}}/OutlinedButton-class.html
[`OutlinedButtonTheme`]: {{site.material_ui}}/OutlinedButtonTheme-class.html
[`OutlinedButtonThemeData`]: {{site.material_ui}}/OutlinedButtonThemeData-class.html
[`TextButton`]: {{site.material_ui}}/TextButton-class.html
[`TextButtonTheme`]: {{site.material_ui}}/TextButtonTheme-class.html
[`TextButtonThemeData`]: {{site.material_ui}}/TextButtonThemeData-class.html

[PR 59702: New Button Universe]: {{site.repo.flutter}}/pull/59702
[PR 73352: Deprecated obsolete Material classes: FlatButton, RaisedButton, OutlineButton]: {{site.repo.flutter}}/pull/73352
