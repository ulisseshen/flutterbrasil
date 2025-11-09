---
ia-translate: true
title: Tratando entrada do usuário
description: Aprenda como tratar entrada do usuário no Flutter.
prev:
  title: State management
  path: /get-started/fundamentals/state-management
next:
  title: Networking and data
  path: /get-started/fundamentals/networking
---

Agora que você sabe como gerenciar estado no seu
app Flutter, como você pode permitir que usuários interajam
com seu app e mudem seu estado?

## Introduction to handling user input

Como um framework de UI multiplataforma,
existem muitas maneiras diferentes para os usuários
interagirem com um app Flutter.
Os recursos nesta seção introduzem
você a alguns dos widgets comuns usados
para habilitar interação do usuário dentro do seu app.

Alguns mecanismos de entrada do usuário, como [rolagem][scrolling],
já foram cobertos em [Layouts][].

:::secondary About design system support
Flutter vem com componentes pré-construídos para dois sistemas de design como parte do SDK,
[Material][] e [Cupertino][].
Para propósitos educacionais, esta página foca em widgets Material, componentes que
são estilizados de acordo com as especificações da [linguagem de design Material 3][Material 3 design language].

A comunidade Flutter no [pub.dev][], o repositório de pacotes para Dart e Flutter,
cria e suporta linguagens de design adicionais como [Fluent UI][], [macOS UI][],
e mais. Se os componentes de sistema de design existentes não se adequam exatamente ao que você precisa,
Flutter permite que você construa seus próprios widgets customizados,
o que é coberto no final desta seção.
Não importa qual sistema de design você escolha, os princípios nesta página se aplicam.
:::

> <span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **Reference**:
> O [catálogo de widgets][widget catalog] tem um inventário de widgets comumente usados nas bibliotecas [Material][] e [Cupertino][].

A seguir, cobriremos alguns dos widgets Material que suportam casos de uso
comuns para tratar entrada do usuário no seu app Flutter.

[scrolling]: /get-started/fundamentals/layout#scrolling-widgets
[pub.dev]: {{site.pub}}
[Layouts]: /get-started/fundamentals/layout
[Material]: /ui/widgets/material
[Material 3 design language]: https://m3.material.io/
[Cupertino]: /ui/widgets/cupertino
[widget catalog]: /ui/widgets#design-systems
[Fluent UI]: {{site.pub}}/packages/fluent_ui
[macOS UI]: {{site.pub}}/packages/macos_ui

## Buttons

![A collection of Material 3 Buttons.](/assets/images/docs/fwe/user-input/material-buttons.png)

Botões permitem que um usuário inicie uma ação na UI clicando ou tocando.
A biblioteca Material fornece uma variedade de tipos de botão que são funcionalmente similares,
mas estilizados de forma diferente para vários casos de uso, incluindo:

- `ElevatedButton`: Um botão com alguma profundidade. Use botões elevados para adicionar
  dimensão a layouts que são principalmente planos.
- `FilledButton`: Um botão preenchido que deve ser usado para
  ações importantes e finais que completam um fluxo,
  como **Save**, **Join now**, ou **Confirm**.
- `Tonal Button`: Um botão intermediário entre
  `FilledButton` e `OutlinedButton`.
  Eles são úteis em contextos onde um botão de prioridade mais baixa requer mais
  ênfase do que um outline, como **Next**.
- `OutlinedButton`: Um botão com texto e uma borda visível.
  Estes botões contêm ações que são importantes,
  mas não são a ação primária em um app.
- `TextButton`: Texto clicável, sem borda.
  Como botões de texto não têm bordas visíveis,
  eles devem confiar em sua posição
  relativa a outro conteúdo para contexto.
- `IconButton`: Um botão com um ícone.
- `FloatingActionButton`: Um botão com ícone que paira sobre
  conteúdo para promover uma ação primária.

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [FloatingActionButton (Widget of the Week)][]

Geralmente existem 3 aspectos principais para construir um botão:
estilo, callback, e seu filho,
como visto no seguinte código de exemplo de `ElevatedButton`:


{% comment %}
TODO(khanhnwin):
 WidgetStateProperty and styling in the design section of
FWE. Of course, a button's appearance can be dependent on its state.
You can style a button based on its state using `WidgetStateProperty`.
{% endcomment %}

- A função callback de um botão, `onPressed`,
  determina o que acontece quando o botão é clicado,
  portanto, esta função é onde você atualiza o estado do seu app.
  Se o callback é `null`, o botão está desabilitado e
  nada acontece quando um usuário pressiona o botão.

- O `child` do botão, que é exibido dentro da área de conteúdo do botão,
  geralmente é texto ou um ícone que indica o propósito do botão.

- Finalmente, o `style` de um botão controla sua aparência: cor, borda, e assim por diante.


{% render "docs/code-and-image.md",
image:"fwe/user-input/ElevatedButton.webp",
caption: "This figure shows an ElevatedButton with the text \"Enabled\" being clicked."
alt: "A GIF of an elevated button with the text 'Enabled'"
code:"
```dart
int count = 0;

@override
Widget build(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
    ),
    onPressed: () {
      setState(() {
        count += 1;
      });
    },
    child: const Text('Enabled'),
  );
}
```
" %}


<br>

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Complete este tutorial que ensina você a construir um
> botão de "favoritar": [Add interactivity to your Flutter app][]

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs**: [`ElevatedButton`][] • [`FilledButton`][] • [`OutlinedButton`][] • [`TextButton`][] • [`IconButton`][] • [`FloatingActionButton`][]

[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`FilledButton`]: {{site.api}}/flutter/material/FilledButton-class.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[FloatingActionButton (Widget of the Week)]: {{site.youtube-site}}/watch/2uaoEDOgk_I?si=MQZcSp24oRaS_kiY
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[Add interactivity to your Flutter app]: /ui/interactivity

## Text

Vários widgets suportam entrada de texto.

### `SelectableText`

O widget `Text` do Flutter exibe texto na tela,
mas não permite que usuários destaquem ou copiem o texto.
`SelectableText` exibe uma string de texto _selecionável pelo usuário_.

{% render "docs/code-and-image.md",
image:"fwe/user-input/SelectableText.webp",
caption: "This figure shows a cursor highlighting a portion of a string of text."
alt: 'A GIF of a cursor highlighting two lines of text from a paragraph.'
code:"
```dart
@override
Widget build(BuildContext context) {
  return const SelectableText('''
Two households, both alike in dignity,
In fair Verona, where we lay our scene,
From ancient grudge break to new mutiny,
Where civil blood makes civil hands unclean.
From forth the fatal loins of these two foes''');
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [SelectableText (Widget of the Week)][]

[SelectableText (Widget of the Week)]: {{site.youtube-site}}/watch?v=ZSU3ZXOs6hc

### `RichText`

`RichText` permite que você exiba strings de rich text no seu app.
`TextSpan`, similar a `RichText`, permite que você exiba partes de texto com
diferentes estilos de texto. Não é para tratar entrada do usuário,
mas é útil se você está permitindo que usuários editem e formatem texto.

{% render "docs/code-and-image.md",
image:"fwe/user-input/RichText.png",
caption: "This figure shows a string of text formatted with different text styles."
alt: 'A screenshot of the text "Hello bold world!" with the word "bold" in bold font.'
code:"
```dart
@override
Widget build(BuildContext context) {
  return RichText(
    text: TextSpan(
      text: 'Hello ',
      style: DefaultTextStyle.of(context).style,
      children: const <TextSpan>[
        TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' world!'),
      ],
    ),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [Rich Text (Widget of the Week)][]

> <span class="material-symbols" aria-hidden="true" translate="no">code</span> **Code**:
> [Rich Text Editor code][]

[Rich Text (Widget of the Week)]: {{site.youtube-site}}/watch?v=rykDVh-QFfw
[Rich Text Editor code]: {{site.github}}/flutter/samples/tree/main/simplistic_editor

### `TextField`

Um `TextField` permite que usuários insiram texto em uma caixa de texto usando um teclado
físico ou na tela.

`TextField`s têm muitas propriedades e configurações diferentes.
Alguns dos destaques:

- `InputDecoration` determina a aparência do campo de texto,
  como cor e borda.
- `controller`: Um `TextEditingController` controla o texto sendo editado.
  Por que você pode precisar de um controller?
  Por padrão, os usuários do seu app podem digitar
  no campo de texto, mas se você quiser controlar programaticamente o `TextField`
  e limpar seu valor, por exemplo, você precisará de um `TextEditingController`.
- `onChanged`: Esta função callback é acionada quando o usuário muda
  o valor do campo de texto, como ao inserir ou remover texto.
- `onSubmitted`: Este callback é acionado quando o usuário indica que
  terminou de editar o texto no campo;
  por exemplo, ao tocar na tecla "enter" quando o campo de texto está em foco.

A classe suporta outras propriedades configuráveis, como
`obscureText` que transforma cada letra em um círculo `readOnly` conforme é inserida e
`readOnly` que impede o usuário de mudar o texto.

{% render "docs/code-and-image.md",
image:"fwe/user-input/TextField.webp",
caption: "This figure shows text being typed into a TextField with a selected border and label."
alt: "A GIF of a text field with the label 'Mascot Name', purple focus border and the phrase 'Dash the hummingbird' being typed in."
code:"
```dart
final TextEditingController _controller = TextEditingController();

@override
Widget build(BuildContext context) {
  return TextField(
    controller: _controller,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Mascot Name',
    ),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Complete esta série de cookbook de 4 partes que guia
> você através de como criar um campo de texto,
> recuperar seu valor, e atualizar o estado do seu app:
> 1. [Create and style a text field][]
> 1. [Retrieve the value of a text field][]
> 1. [Handle changes to a text field][]
> 1. [Focus and text fields][].

[Create and style a text field]: /cookbook/forms/text-input
[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[Handle changes to a text field]: /cookbook/forms/text-field-changes
[Focus and text fields]: /cookbook/forms/focus

### Form

`Form` é um container opcional para agrupar múltiplos
widgets de campo de formulário, como `TextField`.

Cada campo de formulário individual deve ser envolvido em um widget `FormField`
com o widget `Form` como um ancestral comum.
Existem widgets de conveniência que pré-envolvem widgets de campo de formulário em um
`FormField` para você.
Por exemplo, a versão widget `Form` de `TextField` é `TextFormField`.

Usar um `Form` fornece acesso a um `FormState`,
que permite salvar, resetar, e validar cada `FormField`
que descende deste `Form`.
Você também pode fornecer uma `GlobalKey` para identificar um formulário específico,
como mostrado no seguinte código:

```dart
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@override
Widget build(BuildContext context) {
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your email',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // Process data.
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    ),
  );
}
```

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Complete este tutorial para aprender como [construir um formulário com validação][build a form with validation].

> <span class="material-symbols" aria-hidden="true" translate="no">flutter</span> **Demo**:
> [Form app][]

> <span class="material-symbols" aria-hidden="true" translate="no">code</span> **Code**:
> [Form app code][]

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs**: [`TextField`][] • [`RichText`][] • [`SelectableText`][] • [`Form`][]

[Build a form with validation]: /cookbook/forms/validation
[Form app]: https://github.com/flutter/samples/tree/main/form_app/
[Form app code]: {{site.github}}/flutter/samples/tree/main/form_app
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`RichText`]: {{site.api}}/flutter/widgets/RichText-class.html
[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html

## Select a value from a group of options

Forneça uma maneira para os usuários selecionarem entre várias opções.

### SegmentedButton

`SegmentedButton` permite que usuários selecionem de um
grupo mínimo de 2-5 itens.

O tipo de dados, `<T>`, pode ser um tipo integrado como
`int`, `String`, `bool` ou um enum.
Um `SegmentedButton` tem algumas propriedades relevantes:

- `segments`, uma lista de `ButtonSegment`s, onde cada um representa um "segmento"
   ou opção que o usuário pode selecionar.
   Visualmente, cada `ButtonSegment` pode ter um ícone, label de texto, ou ambos.

- `multiSelectionEnabled` indica se o usuário tem permissão
   para selecionar múltiplas opções. Esta propriedade tem padrão false.

- `selected` identifica o(s) valor(es) atualmente selecionado(s).
   **Nota:** `selected` é do tipo `Set<T>`, então se você está apenas
   permitindo que usuários selecionem um valor, esse valor deve ser
  fornecido como um `Set` com um único elemento.

- O callback `onSelectionChanged` é acionado quando um usuário seleciona quaisquer segmentos.
  Ele fornece uma lista dos segmentos selecionados para que você possa atualizar o estado do seu app.

- Parâmetros de estilo adicionais permitem que você modifique a aparência do botão.
  Por exemplo, `style` recebe um `ButtonStyle`,
  fornecendo uma maneira de configurar um `selectedIcon`.

{% render "docs/code-and-image.md",
image:"fwe/user-input/segmented-button.webp",
caption: "This figure shows a SegmentedButton, each segment with an icon and
text representing its value."
alt: "A GIF of a SegmentedButton with 4 segments: Day, Week, Month, and Year.
Each has a calendar icon to represent its value and a text label.
Day is first selected, then week and month, then year."
code:"

```dart
enum Calendar { day, week, month, year }

// StatefulWidget...
Calendar calendarView = Calendar.day;

@override
Widget build(BuildContext context) {
  return SegmentedButton<Calendar>(
    segments: const <ButtonSegment<Calendar>>[
      ButtonSegment<Calendar>(
          value: Calendar.day,
          label: Text('Day'),
          icon: Icon(Icons.calendar_view_day)),
      ButtonSegment<Calendar>(
          value: Calendar.week,
          label: Text('Week'),
          icon: Icon(Icons.calendar_view_week)),
      ButtonSegment<Calendar>(
          value: Calendar.month,
          label: Text('Month'),
          icon: Icon(Icons.calendar_view_month)),
      ButtonSegment<Calendar>(
          value: Calendar.year,
          label: Text('Year'),
          icon: Icon(Icons.calendar_today)),
    ],
    selected: <Calendar>{calendarView},
    onSelectionChanged: (Set<Calendar> newSelection) {
      setState(() {
        Suggested change
        // By default there is only a single segment that can be
        // selected at one time, so its value is always the first
        // By default, only a single segment can be
        // selected at one time, so its value is always the first
        calendarView = newSelection.first;
      });
    },
  );
}
```
" %}


### Chip

`Chip` é uma maneira compacta de representar um
atributo, texto, entidade, ou ação para um contexto específico.
Existem widgets `Chip` especializados para casos de uso específicos:

- [InputChip][] representa uma informação complexa,
  como uma entidade (pessoa, lugar, ou coisa), ou
  texto de conversa, de forma compacta.
- [ChoiceChip][] permite uma única seleção de um conjunto de opções.
  Chips de escolha contêm texto descritivo ou categorias relacionadas.
- [FilterChip][] usa tags ou palavras descritivas para filtrar conteúdo.
- [ActionChip][] representa uma ação relacionada ao conteúdo primário.

Todo widget `Chip` requer um `label`.
Ele pode opcionalmente ter um `avatar` (como um ícone ou foto de perfil de um usuário)
e um callback `onDeleted`, que mostra um ícone de deletar que
quando acionado, deleta o chip.
A aparência de um widget `Chip` também pode ser customizada definindo um
número de parâmetros opcionais como `shape`, `color`, e `iconTheme`.

Você tipicamente usará `Wrap`, um widget que exibe seus filhos em
múltiplas linhas horizontais ou verticais, para garantir que seus chips envolvam e
não sejam cortados na borda do seu app.

{% render "docs/code-and-image.md",
image:"fwe/user-input/chip.png",
caption: "This figure shows two rows of Chip widgets, each containing a circular
leading profile image and content text."
alt: "A screenshot of 4 Chips split over two rows with a leading circular
profile image with content text."
code:"
```dart
@override
Widget build(BuildContext context) {
  return const SizedBox(
    width: 500,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Chip(
          avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dash_chef.png')),
          label: Text('Chef Dash'),
        ),
        Chip(
          avatar: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/dash_firefighter.png')),
          label: Text('Firefighter Dash'),
        ),
        Chip(
          avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dash_musician.png')),
          label: Text('Musician Dash'),
        ),
        Chip(
          avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dash_artist.png')),
          label: Text('Artist Dash'),
        ),
      ],
    ),
  );
}
```
" %}

[InputChip]: {{site.api}}/flutter/material/InputChip-class.html
[ChoiceChip]: {{site.api}}/flutter/material/ChoiceChip-class.html
[FilterChip]: {{site.api}}/flutter/material/FilterChip-class.html
[ActionChip]: {{site.api}}/flutter/material/ActionChip-class.html


### `DropdownMenu`

Um `DropdownMenu` permite que usuários selecionem uma opção de um menu
de opções e coloca o texto selecionado em um `TextField`.
Também permite que usuários filtrem os itens do menu baseado na entrada de texto.

Parâmetros de configuração incluem o seguinte:

- `dropdownMenuEntries` fornece uma lista de `DropdownMenuEntry`s que
  descreve cada item do menu.
  O menu pode conter informações como um label de texto, e
  um ícone leading ou trailing.
  (Este também é o único parâmetro obrigatório.)
- `TextEditingController` permite controlar programaticamente o `TextField`.
- O callback `onSelected` é acionado quando o usuário seleciona uma opção.
- `initialSelection` permite que você configure o valor padrão.
- Parâmetros adicionais também estão disponíveis para
  customizar a aparência e comportamento do widget.

{% render "docs/code-and-image.md",
image:"fwe/user-input/dropdownmenu.webp",
caption: "This figure shows a DropdownMenu widget with 5 value options. Each
option's text color is styled to represent the color value."
alt: "A GIF the DropdownMenu widget that is selected, it displays 5 options:
Blue, Pink, Green, Orange, and Grey. The option text is displayed in the color
of its value."
code:"
```dart
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  orange('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

// StatefulWidget...
@override
Widget build(BuildContext context) {
  return DropdownMenu<ColorLabel>(
    initialSelection: ColorLabel.green,
    controller: colorController,
    // requestFocusOnTap is enabled/disabled by platforms when it is null.
    // On mobile platforms, this is false by default. Setting this to true will
    // trigger focus request on the text field and virtual keyboard will appear
    // afterward. On desktop platforms however, this defaults to true.
    requestFocusOnTap: true,
    label: const Text('Color'),
    onSelected: (ColorLabel? color) {
      setState(() {
        selectedColor = color;
      });
    },
    dropdownMenuEntries: ColorLabel.values
      .map<DropdownMenuEntry<ColorLabel>>(
          (ColorLabel color) {
            return DropdownMenuEntry<ColorLabel>(
              value: color,
              label: color.label,
              enabled: color.label != 'Grey',
              style: MenuItemButton.styleFrom(
                foregroundColor: color.color,
              ),
            );
      }).toList(),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [DropdownMenu (Widget of the Week)][]

[DropdownMenu (Widget of the Week)]: {{site.youtube-site}}/watch?v=giV9AbM2gd8?si=E23hjg72cjMTe_mz

### Slider

O widget `Slider` permite que um usuário ajuste um valor movendo um indicador,
como uma barra de volume.

Parâmetros de configuração para o widget `Slider`:

- `value` representa o valor atual do slider
- `onChanged` é o callback que é acionado quando a alça é movida
- `min` e `max` estabelecem valores mínimo e máximo permitidos pelo slider
- `divisions` estabelece um intervalo discreto com o qual o usuário pode mover a
  alça ao longo da trilha.


{% render "docs/code-and-image.md",
image:"fwe/user-input/slider.webp",
caption: "This figure shows a slider widget with a value ranging from 0.0 to 5.0
broken up into 5 divisions. It shows the current value as a label as the dial
is dragged."
alt: "A GIF of a slider that has the dial dragged left to right in increments
of 1, from 0.0 to 5.0"
code:"
```dart
double _currentVolume = 1;

@override
Widget build(BuildContext context) {
  return Slider(
    value: _currentVolume,
    max: 5,
    divisions: 5,
    label: _currentVolume.toString(),
    onChanged: (double value) {
      setState(() {
        _currentVolume = value;
      });
    },
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [Slider, RangeSlider, CupertinoSlider (Widget of the Week)][]

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs:** [`SegmentedButton`][] • [`DropdownMenu`][] • [`Slider`][] • [`Chip`][]

[Slider, RangeSlider, CupertinoSlider (Widget of the Week)]: {{site.youtube-site}}/watch?v=ufb4gIPDmEss
[`SegmentedButton`]: {{site.api}}/flutter/material/SegmentedButton-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html

## Toggle between values

Existem várias maneiras que sua UI pode permitir alternar entre valores.

### Checkbox, Switch, and Radio

Forneça uma opção para alternar um único valor ligado e desligado.
A lógica funcional por trás desses widgets é a mesma,
já que todos os 3 são construídos em cima de `ToggleableStateMixin`, embora
cada um forneça leves diferenças de apresentação.:

- `Checkbox` é um container que está vazio quando false ou
  preenchido com um check quando true.
- `Switch` tem uma alça que está à esquerda quando false e
  desliza para a direita quando true.
- `Radio` é similar a um `Checkbox` pois é um container que está
  vazio quando false, mas preenchido quando true.

A configuração para `Checkbox` e `Switch` contém:

- um `value` que é `true` ou `false`
- e um callback `onChanged` que é acionado quando
  o usuário alterna o widget

### Checkbox

{% render "docs/code-and-image.md",
image:"fwe/user-input/checkbox.webp",
caption: "This figure shows a checkbox being checked and unchecked."
alt: "A GIF that shows a pointer clicking a checkbox
and then clicking again to uncheck it."
code:"
```dart
bool isChecked = false;

@override
Widget build(BuildContext context) {
  return Checkbox(
    checkColor: Colors.white,
    value: isChecked,
    onChanged: (bool? value) {
      setState(() {
        isChecked = value!;
      });
    },
  );
}
```
" %}

### Switch

{% render "docs/code-and-image.md",
image:"fwe/user-input/Switch.webp",
caption: "This figure shows a Switch widget that is toggled on and off."
alt: "A GIF of a Switch widget that is toggled on and off. In its off state,
it is gray with dark gray borders. In its on state,
it is red with a light red border."
code:"
```dart
bool light = true;

@override
Widget build(BuildContext context) {
  return Switch(
    // This bool value toggles the switch.
    value: light,
    activeColor: Colors.red,
    onChanged: (bool value) {
      // This is called when the user toggles the switch.
      setState(() {
        light = value;
      });
    },
  );
}
```
" %}

### Radio

Um grupo de botões `Radio` que permite ao usuário
selecionar entre valores mutuamente exclusivos.
Quando o usuário seleciona um botão radio em um grupo,
os outros botões radio são desmarcados.

- O `value` de um botão `Radio` particular representa o valor daquele botão,
- O valor selecionado para um grupo de botões radio é identificado pelo
  parâmetro `groupValue`.
- `Radio` também tem um callback `onChanged` que
  é acionado quando usuários clicam nele, como `Switch` e `Checkbox`

{% render "docs/code-and-image.md",
image:"fwe/user-input/Radio.webp",
caption: "This figure shows a column of ListTiles containing a radio button and
label, where only one radio button can be selected at a time."
alt: "A GIF of 4 ListTiles in a column, each containing a leading Radio button
and title text. The Radio buttons are selected in order from top to bottom."
code:"
```dart
enum Character { musician, chef, firefighter, artist }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  Character? _character = Character.musician;

  void setCharacter(Character? value) {
    setState(() {
      _character = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Musician'),
          leading: Radio<Character>(
            value: Character.musician,
            groupValue: _character,
            onChanged: setCharacter,
          ),
        ),
        ListTile(
          title: const Text('Chef'),
          leading: Radio<Character>(
            value: Character.chef,
            groupValue: _character,
            onChanged: setCharacter,
          ),
        ),
        ListTile(
          title: const Text('Firefighter'),
          leading: Radio<Character>(
            value: Character.firefighter,
            groupValue: _character,
            onChanged: setCharacter,
          ),
        ),
        ListTile(
          title: const Text('Artist'),
          leading: Radio<Character>(
            value: Character.artist,
            groupValue: _character,
            onChanged: setCharacter,
          ),
        ),
      ],
    );
  }
}
```
" %}

#### Bonus: CheckboxListTile & SwitchListTile

Estes widgets de conveniência são os mesmos widgets checkbox e switch,
mas suportam um label (como um `ListTile`).

{% render "docs/code-and-image.md",
image:"fwe/user-input/SpecialListTiles.webp",
caption: "This figure shows a column containing a CheckboxListTile and
a SwitchListTile being toggled."
alt: "A ListTile with a leading icon, title text, and a trailing checkbox being
checked and unchecked. It also shows a ListTile with a leading icon, title text
and a switch being toggled on and off."
code:"
```dart
double timeDilation = 1.0;
bool _lights = false;

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      CheckboxListTile(
        title: const Text('Animate Slowly'),
        value: timeDilation != 1.0,
        onChanged: (bool? value) {
          setState(() {
            timeDilation = value! ? 10.0 : 1.0;
          });
        },
        secondary: const Icon(Icons.hourglass_empty),
      ),
      SwitchListTile(
        title: const Text('Lights'),
        value: _lights,
        onChanged: (bool value) {
          setState(() {
            _lights = value;
          });
        },
        secondary: const Icon(Icons.lightbulb_outline),
      ),
    ],
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [CheckboxListTile (Widget of the Week)][]

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [SwitchListTile (Widget of the Week)][]

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs**:
[`Checkbox`][] • [`CheckboxListTile`][] • [`Switch`][] • [`SwitchListTile`][] •
[`Radio`][]

[CheckboxListTile (Widget of the Week)]: {{site.youtube-site}}/watch?v=RkSqPAn9szs
[SwitchListTile (Widget of the Week)]: {{site.youtube-site}}/watch?v=0igIjvtEWNU

[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`CheckboxListTile`]: {{site.api}}/flutter/material/CheckboxListTile-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`SwitchListTile`]: {{site.api}}/flutter/material/SwitchListTile-class.html
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html

## Select a date or time

Widgets são fornecidos para que o usuário possa selecionar uma data e hora.

Existe um conjunto de diálogos que permitem aos usuários selecionar uma data ou hora,
como você verá nas seções a seguir.
Com exceção de tipos de data diferentes -
`DateTime` para datas vs `TimeOfDay` para hora -
esses diálogos funcionam de forma similar, você pode configurá-los fornecendo:

- uma `initialDate` ou `initialTime` padrão
- ou um `initialEntryMode` que determina a UI do seletor que é exibida.

### DatePickerDialog

Este diálogo permite que o usuário selecione uma data ou um intervalo de datas.
Ative chamando a função `showDatePicker`,
que retorna uma `Future<DateTime>`,
então não esqueça de aguardar a chamada de função assíncrona!

{% render "docs/code-and-image.md",
image:"fwe/user-input/DatePicker.webp",
caption: "This figure shows a DatePicker that is displayed when the
'Pick a date' button is clicked."
alt: "A GIF of a pointer clicking a button that says 'Pick a date',
then shows a date picker. The date Friday, August 30 is selected and the 'OK'
button is clicked."
code:"
```dart
DateTime? selectedDate;

@override
Widget build(BuildContext context) {
  var date = selectedDate;

  return Column(children: [
    Text(
      date == null
          ? 'You haven\'t picked a date yet.'
          : DateFormat('MM-dd-yyyy').format(date),
    ),
    ElevatedButton.icon(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(2019),
          lastDate: DateTime(2050),
        );

        setState(() {
          selectedDate = pickedDate;
        });
      },
      label: const Text('Pick a date'),
    )
  ]);
}
```
" %}

### TimePickerDialog

`TimePickerDialog` é um diálogo que apresenta um seletor de hora.
Pode ser ativado chamando a função `showTimePicker()`.
Em vez de retornar uma `Future<DateTime>`,
`showTimePicker` retorna uma `Future<TimeOfDay>`.
Mais uma vez, não esqueça de aguardar a chamada de função!

{% render "docs/code-and-image.md",
image:"fwe/user-input/TimePicker.webp",
caption: "This figure shows a TimePicker that is displayed when the
'Pick a time' button is clicked."
alt: "A GIF of a pointer clicking a button that says 'Pick a time', then shows
 a time picker. The time picker shows a circular clock as the cursor moves the
 hour hand, then minute hand, selects PM, then the 'OK' button is clicked."
code:"
```dart
TimeOfDay? selectedTime;

@override
Widget build(BuildContext context) {
  var time = selectedTime;

  return Column(children: [
    Text(
      time == null ? 'You haven\'t picked a time yet.' : time.format(context),
    ),
    ElevatedButton.icon(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        var pickedTime = await showTimePicker(
          context: context,
          initialEntryMode: TimePickerEntryMode.dial,
          initialTime: TimeOfDay.now(),
        );

        setState(() {
          selectedTime = pickedTime;
        });
      },
      label: const Text('Pick a time'),
    )
  ]);
}
```
" %}

:::tip
Chamar `showDatePicker()` e `showTimePicker()`
é equivalente a chamar `showDialog()` com `DatePickerDialog()` e
`TimePickerDialog()`, respectivamente.
Internamente, ambas as funções usam a função `showDialog()` com
seus respectivos widgets `Dialog`.
Para habilitar state restoration, você também pode empurrar
`DatePickerDialog()` e `TimePickerDialog()` diretamente
para a pilha `Navigator`.
:::

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs:**
[`showDatePicker`][] • [`showTimePicker`][]

[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html
[`showTimePicker`]: {{site.api}}/flutter/material/showTimePicker.html

## Swipe & slide

### [`Dismissible`][]

Um `Dismissible` é um widget que permite aos usuários descartá-lo deslizando.
Ele tem vários parâmetros de configuração, incluindo:

- Um widget `child`
- Um callback `onDismissed` que é acionado quando o usuário desliza
- Parâmetros de estilo como `background`
- É importante incluir um objeto `key` também para que eles possam ser identificados unicamente
  de widgets `Dismissible` irmãos na árvore de widgets.

{% render "docs/code-and-image.md",
image:"fwe/user-input/Dismissible.webp",
caption: "This figure shows a list of Dismissible widgets that each contain a
ListTile. Swiping across the ListTile reveals a green background and makes the tile
disappear."
alt: "A screenshot of three widgets, spaced evenly from each other."
code:"
```dart
List<int> items = List<int>.generate(100, (int index) => index);

@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    padding: const EdgeInsets.symmetric(vertical: 16),
    itemBuilder: (BuildContext context, int index) {
      return Dismissible(
        background: Container(
          color: Colors.green,
        ),
        key: ValueKey<int>(items[index]),
        onDismissed: (DismissDirection direction) {
          setState(() {
            items.removeAt(index);
          });
        },
        child: ListTile(
          title: Text(
            'Item ${items[index]}',
          ),
        ),
      );
    },
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [Dismissible (Widget of the Week)][]

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Complete este tutorial sobre como [implementar swipe to dismiss][implement swipe to dismiss] usando o
> widget dismissible.

<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs:**
[`Dismissible`][]

[Dismissible (Widget of the Week)]: {{site.youtube-site}}/watch?v=iEMgjrfuc58?si=f0S7IdaA9PIWIYvl
[Implement swipe to dismiss]: /cookbook/gestures/dismissible
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html

## Looking for more widgets?

Esta página apresenta apenas alguns dos widgets Material comuns que
você pode usar para tratar entrada do usuário no seu app Flutter.
Confira a [biblioteca de Widgets Material][Material Widget library] e
os [docs da API da biblioteca Material][Material Library API docs] para uma lista completa de widgets.

> <span class="material-symbols" aria-hidden="true" translate="no">flutter</span> **Demo**:
> Veja a [Demo Material 3][Material 3 Demo] do Flutter para uma amostra curada de widgets de entrada do usuário
> disponíveis na biblioteca Material.

Se as bibliotecas Material e Cupertino não têm um widget que
faz o que você precisa, confira [pub.dev][] para encontrar
pacotes mantidos e de propriedade da comunidade Flutter & Dart.
Por exemplo, o pacote [`flutter_slidable`][] fornece
um widget `Slidable` que é mais customizável que
o widget `Dismissible` descrito na seção anterior.

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [flutter_slidable (Package of the Week)][]

[Material Widget Library]: /ui/widgets/material
[Material Library API docs]: {{site.api}}/flutter/material/material-library.html
[Material 3 Demo]: https://github.com/flutter/samples/tree/main/material_3_demo

[`flutter_slidable`]: {{site.pub}}/packages/flutter_slidable
[flutter_slidable (Package of the Week)]: {{site.youtube-site}}/watch?v=QFcFEpFmNJ8

## Build interactive widgets with GestureDetector

Você procurou nas bibliotecas de widgets, pub.dev, perguntou aos seus amigos programadores,
e ainda não consegue encontrar um widget que
se adeque à interação do usuário que você está procurando?
Você pode construir seu próprio widget customizado e
torná-lo interativo usando `GestureDetector`.

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Use esta receita como ponto de partida para criar seu próprio widget de botão _customizado_
> que pode [tratar toques][handle taps].

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [GestureDetector (Widget of the Week)][]

> <span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **Reference**:
> Confira [Taps, drags, and other gestures][] que explica como ouvir
> e responder a gestos no Flutter.

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Bonus Video**:
> Curioso sobre como a `GestureArena` do Flutter transforma dados brutos de interação do usuário em
> conceitos reconhecíveis por humanos como toques, arrastos e pinças?
> Confira este vídeo: [GestureArena (Decoding Flutter)][]

[handle taps]: /cookbook/gestures/handling-taps
[GestureDetector (Widget of the Week)]: {{site.youtube-site}}/watch?v=WhVXkCFPmK4
[Taps, drags, and other gestures]: /ui/interactivity/gestures#gestures
[GestureArena (Decoding Flutter)]: {{site.youtube-site}}/watch?v=Q85LBtBdi0U

### Don't forget about accessibility!

Se você está construindo um widget customizado,
anote seu significado com o widget `Semantics`.
Ele fornece descrições e metadados para leitores de tela e
outras ferramentas baseadas em análise semântica.

> <span class="material-symbols" aria-hidden="true" translate="no">slideshow</span> **Video**:
> [Semantics (Flutter Widget of the Week)][]


<br>

<span class="material-symbols" aria-hidden="true" translate="no">menu_book</span> **API Docs**:
[`GestureDetector`][] • [`Semantics`][]

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html

## Testing

Depois de ter terminado de construir interações do usuário
no seu app, não esqueça de escrever testes para
garantir que tudo funciona como esperado!

Estes tutoriais guiam você através de escrever testes que
simulam interações do usuário no seu app:

> <span class="material-symbols" aria-hidden="true" translate="no">star</span> **Checkpoint**:
> Siga este artigo do cookbook [tap, drag, and enter text][] e aprenda como
> usar `WidgetTester` para simular e testar interações do usuário no seu app.

> <span class="material-symbols" aria-hidden="true" translate="no">bookmark</span> **Bonus Tutorial**:
> A receita do cookbook [handle scrolling][] mostra como verificar que
> listas de widgets contêm o conteúdo esperado
> rolando através das listas usando testes de widget.

[Semantics (Flutter Widget of the Week)]: {{site.youtube-site}}/watch?v=NvtMt_DtFrQ?si=o79BqAg9NAl8EE8_
[Tap, drag, and enter text]: /cookbook/testing/widget/tap-drag
[Handle scrolling]: /cookbook/testing/widget/scrolling

## Next: Networking

Esta página foi uma introdução ao tratamento de entrada do usuário.
Agora que você sabe como tratar entrada de usuários do app,
você pode tornar seu app ainda mais interessante adicionando
dados externos. Na próxima seção,
você aprenderá como buscar dados para seu app pela rede,
como converter dados de e para JSON, autenticação,
e outros recursos de networking.

## Feedback

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="user-input"
