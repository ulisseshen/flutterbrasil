---
ia-translate: true
title: Novos Botões e Temas de Botões
description: As classes básicas de botões do Material foram substituídas.
---

## Sumário

Um novo conjunto de widgets de botões básicos do Material e temas foram adicionados ao Flutter. As classes originais foram depreciadas e serão eventualmente removidas. O objetivo geral é tornar os botões mais flexíveis e fáceis de configurar por meio de parâmetros de construtor ou temas.

Os widgets `FlatButton`, `RaisedButton` e `OutlineButton` foram substituídos por `TextButton`, `ElevatedButton` e `OutlinedButton`, respectivamente. Cada nova classe de botão tem seu próprio tema: `TextButtonTheme`, `ElevatedButtonTheme` e `OutlinedButtonTheme`. A classe `ButtonTheme` original não é mais usada. A aparência dos botões é especificada por um objeto `ButtonStyle`, em vez de um grande conjunto de parâmetros e propriedades de widget. Isso é aproximadamente comparável à forma como a aparência do texto é definida com um objeto `TextStyle`. Os novos temas de botões também são configurados com um objeto `ButtonStyle`. Um `ButtonStyle` é, em si, apenas uma coleção de propriedades visuais. Muitas dessas propriedades são definidas com `MaterialStateProperty`, o que significa que seu valor pode depender do estado do botão.

## Contexto

Em vez de tentar evoluir as classes de botões existentes e seu tema no mesmo lugar, introduzimos novos widgets e temas de botões de substituição. Além de nos livrar do labirinto de compatibilidade com versões anteriores que a evolução das classes existentes no mesmo lugar acarretaria, os novos nomes sincronizam o Flutter de volta com a especificação do Material Design, que usa os novos nomes para os componentes do botão.

| Widget Antigo  | Tema Antigo | Novo Widget    | Novo Tema            |
|----------------|-------------|----------------|----------------------|
| `FlatButton`   | `ButtonTheme`| `TextButton`   | `TextButtonTheme`    |
| `RaisedButton` | `ButtonTheme`| `ElevatedButton`| `ElevatedButtonTheme`|
| `OutlineButton`| `ButtonTheme`| `OutlinedButton`| `OutlinedButtonTheme`|

{:.table .table-striped .nowrap}

Os novos temas seguem o padrão "normalizado" que o Flutter adotou para novos widgets Material há cerca de um ano. As propriedades do tema e os parâmetros do construtor do widget são nulos por padrão. Propriedades de tema não nulas e parâmetros de widget especificam uma substituição do valor padrão do componente. A implementação e a documentação dos valores padrão são de responsabilidade exclusiva dos widgets do componente de botão. Os padrões em si são baseados principalmente no `colorScheme` e `textTheme` do tema geral.

Visualmente, os novos botões parecem um pouco diferentes, porque correspondem à especificação atual do Material Design e porque suas cores são configuradas em termos do `ColorScheme` do tema geral. Existem outras pequenas diferenças no preenchimento, raios de canto arredondados e o feedback de passar o mouse/foco/pressionado.

Muitos aplicativos poderão apenas substituir os novos nomes de classe pelos antigos. Aplicativos com testes de imagem dourada ou com botões cuja aparência foi configurada com parâmetros de construtor ou com o `ButtonTheme` original podem precisar consultar o guia de migração e o material introdutório que segue.

## Mudança de API: ButtonStyle em vez de propriedades de estilo individuais

Exceto para casos de uso simples, as APIs das novas classes de botão não são compatíveis com as classes antigas. Os atributos visuais dos novos botões e temas são configurados com um único objeto `ButtonStyle`, semelhante à forma como um widget `TextField` ou `Text` pode ser configurado com um objeto `TextStyle`. A maioria das propriedades `ButtonStyle` é definida com `MaterialStateProperty`, de modo que uma única propriedade pode representar valores diferentes dependendo do estado pressionado/focado/pairando/etc do botão.

Um `ButtonStyle` de um botão não define as propriedades visuais do botão, ele define substituições das propriedades visuais padrão dos botões, onde as propriedades padrão são computadas pelo próprio widget do botão. Por exemplo, para substituir a cor de primeiro plano (texto/ícone) padrão de um `TextButton` para todos os estados, pode-se escrever:

```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

Esse tipo de substituição é comum; no entanto, em muitos casos, o que também é necessário são as substituições para as cores de sobreposição que o botão de texto usa para indicar seu estado pairando/foco/pressionado. Isso pode ser feito adicionando a propriedade `overlayColor` ao `ButtonStyle`.

```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered))
          return Colors.blue.withValues(alpha: 0.04);
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed))
          return Colors.blue.withValues(alpha: 0.12);
        return null; // Deferir para o padrão do widget.
      },
    ),
  ),
  onPressed: () { },
  child: Text('TextButton')
)
```

Um `MaterialStateProperty` de cor só precisa retornar um valor para as cores cujo padrão deve ser substituído. Se retornar nulo, o padrão do widget será usado em vez disso. Por exemplo, para substituir apenas a cor de sobreposição de foco do botão de texto:

```dart
TextButton(
  style: ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused))
          return Colors.red;
        return null; // Deferir para o padrão do widget.
      }
    ),
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

### Os métodos utilitários `styleFrom()` do ButtonStyle

A especificação do Material Design define as cores de primeiro plano e sobreposição dos botões em termos da cor primária do esquema de cores. A cor primária é renderizada em diferentes opacidades, dependendo do estado do botão. Para simplificar a criação de um estilo de botão que inclua todas as propriedades que dependem das cores do esquema de cores, cada classe de botão inclui um método `styleFrom()` estático que constrói um `ButtonStyle` a partir de um conjunto simples de valores, incluindo as cores do `ColorScheme` das quais depende.

Este exemplo cria um botão que substitui sua cor de primeiro plano, bem como sua cor de sobreposição, usando a cor primária especificada e as opacidades da especificação do Material Design.

```dart
TextButton(
  style: TextButton.styleFrom(
    primary: Colors.blue,
  ),
  onPressed: () { },
  child: Text('TextButton'),
)
```

A documentação do `TextButton` indica que a cor de primeiro plano quando o botão está desabilitado é baseada na cor `onSurface` do esquema de cores. Para substituir isso também, usando `styleFrom()`:

```dart
TextButton(
  style: TextButton.styleFrom(
    primary: Colors.blue,
    onSurface: Colors.red,
  ),
  onPressed: null,
  child: Text('TextButton'),
)
```

Usar o método `styleFrom()` é a maneira preferida de criar um `ButtonStyle` se você estiver tentando criar uma variação do Material Design. A abordagem mais flexível é definir um `ButtonStyle` diretamente, com valores `MaterialStateProperty` para os estados cuja aparência você deseja substituir.

## Padrões do ButtonStyle

Widgets como as novas classes de botão _computam_ seus valores padrão com base no `colorScheme` e `textTheme` do tema geral, bem como no estado atual do botão. Em alguns casos, eles também consideram se o esquema de cores do tema geral é claro ou escuro. Cada botão tem um método protegido que computa seu estilo padrão conforme necessário. Embora os aplicativos não chamem esse método diretamente, sua documentação de API explica quais são todos os padrões. Quando um botão ou tema de botão especifica `ButtonStyle`, apenas as propriedades não nulas do estilo do botão substituem os padrões computados. O parâmetro `style` do botão substitui propriedades não nulas especificadas pelo tema do botão correspondente. Por exemplo, se a propriedade `foregroundColor` do estilo de um `TextButton` não for nula, ela substituirá a mesma propriedade do estilo do `TextButonTheme`.

Como explicado anteriormente, cada classe de botão inclui um método estático chamado `styleFrom` que constrói um `ButtonStyle` a partir de um conjunto simples de valores, incluindo as cores `ColorScheme` das quais depende. Em muitos casos comuns, usar `styleFrom` para criar um `ButtonStyle` único que substitui os padrões é mais simples. Isso é particularmente verdadeiro quando o objetivo do estilo personalizado é substituir uma das cores do esquema de cores, como `primary` ou `onPrimary`, das quais o estilo padrão depende. Para outros casos, você pode criar um objeto `ButtonStyle` diretamente. Isso permite que você controle o valor de propriedades visuais, como cores, para todos os estados possíveis do botão - como pressionado, pairado, desabilitado e focado.

## Guia de Migração

Use as seguintes informações para migrar seus botões para a nova API.

### Restaurando os visuais originais do botão

Em muitos casos, é possível apenas alternar da classe de botão antiga para a nova. Isso pressupõe que as pequenas mudanças no tamanho/forma e a mudança provavelmente maior nas cores não sejam uma preocupação.

Para preservar a aparência original dos botões nesses casos, pode-se definir estilos de botão que correspondam o mais próximo possível ao original. Por exemplo, o estilo a seguir faz com que um `TextButton` se pareça com um `FlatButton` padrão:

```dart
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

TextButton(
  style: flatButtonStyle,
  onPressed: () { },
  child: Text('Parece um FlatButton'),
)
```

Da mesma forma, para fazer um `ElevatedButton` se parecer com um `RaisedButton` padrão:

```dart
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
ElevatedButton(
  style: raisedButtonStyle,
  onPressed: () { },
  child: Text('Parece um RaisedButton'),
)
```

O estilo `OutlineButton` para `OutlinedButton` é um pouco mais complicado porque a cor do contorno muda para a cor primária quando o botão é pressionado. A aparência do contorno é definida por um `BorderSide` e você usará um `MaterialStateProperty` para definir a cor do contorno pressionado:

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
  child: Text('Parece um OutlineButton'),
)
```

Para restaurar a aparência padrão para botões em um aplicativo, você pode configurar os novos temas de botão no tema do aplicativo:

```dart
MaterialApp(
  theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
  ),
)
```

Para restaurar a aparência padrão para botões em parte de um aplicativo, você pode envolver uma subárvore de widget com `TextButtonTheme`, `ElevatedButtonTheme` ou `OutlinedButtonTheme`. Por exemplo:

```dart
TextButtonTheme(
  data: TextButtonThemeData(style: flatButtonStyle),
  child: myWidgetSubtree,
)
```

### Migrando botões com cores personalizadas

As seções a seguir cobrem o uso dos seguintes parâmetros de cor `FlatButton`, `RaisedButton` e `OutlineButton`:

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

As novas classes de botão não oferecem suporte a uma cor de destaque separada porque ela não faz mais parte do Material Design.

#### Migrando botões com cores de primeiro plano e fundo personalizadas

Duas personalizações comuns para as classes de botão originais são uma cor de primeiro plano personalizada para `FlatButton` ou cores de primeiro plano e fundo personalizadas para `RaisedButton`. Produzir o mesmo resultado com as novas classes de botão é simples:

```dart
FlatButton(
  textColor: Colors.red, // primeiro plano
  onPressed: () { },
  child: Text('FlatButton com primeiro plano/fundo personalizado'),
)

TextButton(
  style: TextButton.styleFrom(
    primary: Colors.red, // primeiro plano
  ),
  onPressed: () { },
  child: Text('TextButton com primeiro plano personalizado'),
)
```

Nesse caso, a cor de primeiro plano (texto/ícone) do `TextButton`, bem como as cores de sobreposição pairadas/focadas/pressionadas, serão baseadas em `Colors.red`. Por padrão, a cor de preenchimento do fundo do `TextButton` é transparente.

Migrando um `RaisedButton` com cores de primeiro plano e fundo personalizadas:

```dart
RaisedButton(
  color: Colors.red, // fundo
  textColor: Colors.white, // primeiro plano
  onPressed: () { },
  child: Text('RaisedButton com primeiro plano/fundo personalizado'),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.red, // fundo
    onPrimary: Colors.white, // primeiro plano
  ),
  onPressed: () { },
  child: Text('ElevatedButton com primeiro plano/fundo personalizado'),
)
```

Nesse caso, o uso da cor primária do esquema de cores pelo botão é invertido em relação ao `TextButton`: primary é a cor de preenchimento do fundo do botão e `onPrimary` é a cor de primeiro plano (texto/ícone).

#### Migrando botões com cores de sobreposição personalizadas

Substituir as cores padrão de foco, pairar, destaque ou splash de um botão é menos comum. As classes `FlatButton`, `RaisedButton` e `OutlineButton` têm parâmetros individuais para essas cores dependentes do estado. As novas classes `TextButton`, `ElevatedButton` e `OutlinedButton` usam um único parâmetro `MaterialStateProperty<Color>` em vez disso. Os novos botões permitem especificar valores dependentes de estado para todas as cores, os botões originais suportavam apenas especificar o que agora é chamado de "overlayColor".

```dart
FlatButton(
  focusColor: Colors.red,
  hoverColor: Colors.green,
  splashColor: Colors.blue,
  onPressed: () { },
  child: Text('FlatButton com cores de sobreposição personalizadas'),
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
        return null; // Deferir para o padrão do widget.
    }),
  ),
  onPressed: () { },
  child: Text('TextButton com cores de sobreposição personalizadas'),
)
```

A nova versão é mais flexível, embora menos compacta. Na versão original, a precedência dos diferentes estados é implícita (e não documentada) e fixa, na nova versão, é explícita. Para um aplicativo que especificou essas cores com frequência, o caminho de migração mais fácil seria definir um ou mais `ButtonStyles` que correspondem ao exemplo acima - e apenas usar o parâmetro style - ou definir um widget wrapper sem estado que encapsula os três parâmetros de cor.

#### Migrando botões com cores desabilitadas personalizadas

Esta é uma personalização relativamente rara. As classes `FlatButton`, `RaisedButton` e `OutlineButton` têm os parâmetros `disabledTextColor` e `disabledColor` que definem as cores de fundo e primeiro plano quando o retorno de chamada `onPressed` do botão é nulo.

Por padrão, todos os botões usam a cor `onSurface` do esquema de cores, com opacidade 0,38 para a cor de primeiro plano desabilitada. Apenas `ElevatedButton` tem uma cor de fundo não transparente e seu valor padrão é a cor `onSurface` com opacidade 0,12. Portanto, em muitos casos, pode-se apenas usar o método `styleFrom` para substituir as cores desabilitadas:

```dart
RaisedButton(
  disabledColor: Colors.red.withValues(alpha: 0.12),
  disabledTextColor: Colors.red.withValues(alpha: 0.38),
  onPressed: null,
  child: Text('RaisedButton com cores desabilitadas personalizadas'),
),

ElevatedButton(
  style: ElevatedButton.styleFrom(onSurface: Colors.red),
  onPressed: null,
  child: Text('ElevatedButton com cores desabilitadas personalizadas'),
)
```

Para controle completo sobre as cores desabilitadas, deve-se definir o estilo do `ElevatedButton` explicitamente, em termos de `MaterialStateProperties`:

```dart
RaisedButton(
  disabledColor: Colors.red,
  disabledTextColor: Colors.blue,
  onPressed: null,
  child: Text('RaisedButton com cores desabilitadas personalizadas'),
)

ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled))
          return Colors.red;
        return null; // Deferir para o padrão do widget.
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled))
          return Colors.blue;
        return null; // Deferir para o padrão do widget.
    }),
  ),
  onPressed: null,
  child: Text('ElevatedButton com cores desabilitadas personalizadas'),
)
```

Como no caso anterior, existem maneiras óbvias de tornar a nova versão mais compacta em um aplicativo onde essa migração surge com frequência.

#### Migrando botões com elevações personalizadas

Esta também é uma personalização relativamente rara. Normalmente, apenas `ElevatedButton`s (originalmente chamados `RaisedButtons`) incluem mudanças de elevação. Para elevações que são proporcionais a uma elevação de linha de base (de acordo com a especificação do Material Design), pode-se substituir todas elas de forma bastante simples.

Por padrão, a elevação de um botão desabilitado é 0 e os estados restantes são definidos em relação a uma linha de base de 2:

```dart
desabilitado: 0
pairado ou focado: linha de base + 2
pressionado: linha de base + 6
```

Portanto, para migrar um `RaisedButton` para o qual todas as elevações foram definidas:

```dart
RaisedButton(
  elevation: 2,
  focusElevation: 4,
  hoverElevation: 4,
  highlightElevation: 8,
  disabledElevation: 0,
  onPressed: () { },
  child: Text('RaisedButton com elevações personalizadas'),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(elevation: 2),
  onPressed: () { },
  child: Text('ElevatedButton com elevações personalizadas'),
)
```

Para substituir arbitrariamente apenas uma elevação, como a elevação pressionada:

```dart
RaisedButton(
  highlightElevation: 16,
  onPressed: () { },
  child: Text('RaisedButton com uma elevação personalizada'),
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
  child: Text('ElevatedButton com uma elevação personalizada'),
)
```

#### Migrando botões com formas e bordas personalizadas

As classes originais `FlatButton`, `RaisedButton` e `OutlineButton` fornecem um parâmetro shape que define a forma do botão e a aparência de seu contorno. As novas classes correspondentes e seus temas oferecem suporte à especificação da forma do botão e de sua borda separadamente, com os parâmetros `OutlinedBorder shape` e `BorderSide side`.

Neste exemplo, a versão original do `OutlineButton` especifica a mesma cor para a borda em seu estado destacado (pressionado) como para outros estados.

```dart
OutlineButton(
  shape: StadiumBorder(),
  highlightedBorderColor: Colors.red,
  borderSide: BorderSide(
    width: 2,
    color: Colors.red
  ),
  onPressed: () { },
  child: Text('OutlineButton com forma e borda personalizadas'),
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
  child: Text('OutlinedButton com forma e borda personalizadas'),
)
```

A maioria dos novos parâmetros de estilo do widget `OutlinedButton`, incluindo sua forma e borda, pode ser especificada com valores `MaterialStateProperty`, o que significa que eles podem ter valores diferentes dependendo do estado do botão. Para especificar uma cor de borda diferente quando o botão é pressionado, faça o seguinte:

```dart
OutlineButton(
  shape: StadiumBorder(),
  highlightedBorderColor: Colors.blue,
  borderSide: BorderSide(
    width: 2,
    color: Colors.red
  ),
  onPressed: () { },
  child: Text('OutlineButton com forma e borda personalizadas'),
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
  child: Text('OutlinedButton com forma e borda personalizadas'),
)
```

## Linha do Tempo

Incluído na versão: 1.20.0-0.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`ButtonStyle`][]
* [`ButtonStyleButton`][]
* [`ElevatedButton`][]
* [`ElevatedButtonTheme`][]
* [`ElevatedButtonThemeData`][]
* [`OutlinedButton`][]
* [`OutlinedButtonTheme`][]
* [`OutlinedButtonThemeData`][]
* [`TextButton`][]
* [`TextButtonTheme`][]
* [`TextButtonThemeData`][]

PRs relevantes:

* [PR 59702: Novo Universo de Botões][]
* [PR 73352: Classes Material obsoletas depreciadas: FlatButton, RaisedButton, OutlineButton][]


[`ButtonStyle`]: {{site.api}}/flutter/material/ButtonStyle-class.html
[`ButtonStyleButton`]: {{site.api}}/flutter/material/ButtonStyleButton-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`ElevatedButtonTheme`]: {{site.api}}/flutter/material/ElevatedButtonTheme-class.html
[`ElevatedButtonThemeData`]: {{site.api}}/flutter/material/ElevatedButtonThemeData-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`OutlinedButtonTheme`]: {{site.api}}/flutter/material/OutlinedButtonTheme-class.html
[`OutlinedButtonThemeData`]: {{site.api}}/flutter/material/OutlinedButtonThemeData-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`TextButtonTheme`]: {{site.api}}/flutter/material/TextButtonTheme-class.html
[`TextButtonThemeData`]: {{site.api}}/flutter/material/TextButtonThemeData-class.html

[PR 59702: Novo Universo de Botões]: {{site.repo.flutter}}/pull/59702
[PR 73352: Classes Material obsoletas depreciadas: FlatButton, RaisedButton, OutlineButton]: {{site.repo.flutter}}/pull/73352
