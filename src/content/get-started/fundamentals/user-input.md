---
ia-translate: true
title: Manipulando a entrada do usuário
description: Aprenda como manipular a entrada do usuário no Flutter.
prev:
  title: Gerenciamento de estado
  path: /get-started/fundamentals/state-management
next:
  title: Rede e dados
  path: /get-started/fundamentals/networking
---

Agora que você sabe como gerenciar o estado em seu
aplicativo Flutter, como você pode permitir que os usuários interajam
com seu aplicativo e alterem seu estado?

## Introdução ao tratamento da entrada do usuário

Como um framework de UI multi-plataforma,
existem muitas maneiras diferentes para os usuários
interagirem com um aplicativo Flutter.
Os recursos nesta seção apresentam
alguns dos widgets comuns usados
para habilitar a interação do usuário em seu aplicativo.

Alguns mecanismos de entrada do usuário, como [rolagem][],
já foram abordados em [Layouts][].

:::secondary Sobre o suporte ao sistema de design
O Flutter vem com componentes pré-construídos para dois sistemas de design como parte do SDK,
[Material][] e [Cupertino][].
Para fins educacionais, esta página se concentra nos widgets Material, componentes que
são estilizados de acordo com as especificações da [linguagem de design Material 3][].

A comunidade Flutter em [pub.dev][], o repositório de pacotes para Dart e Flutter,
cria e suporta idiomas de design adicionais, como [Fluent UI][], [macOS UI][]
e muito mais. Se os componentes do sistema de design existentes não se encaixam no que você precisa,
o Flutter permite que você construa seus próprios widgets personalizados,
o que é abordado no final desta seção.
Não importa qual sistema de design você escolha, os princípios desta página se aplicam.
:::

> <span class="material-symbols" aria-hidden="true">menu_book</span> **Referência**:
> O [catálogo de widgets][] possui um inventário de widgets comumente usados ​​nas bibliotecas [Material][] e [Cupertino][].

Em seguida, abordaremos alguns dos widgets Material que suportam casos de uso comuns
para lidar com a entrada do usuário em seu aplicativo Flutter.

[scrolling]: /get-started/fundamentals/layout#scrolling-widgets
[pub.dev]: {{site.pub}}
[Layouts]: /get-started/fundamentals/layout
[Material]: /ui/widgets/material
[Material 3 design language]: https://m3.material.io/
[Cupertino]: /ui/widgets/cupertino
[widget catalog]: /ui/widgets#design-systems
[Fluent UI]: {{site.pub}}/packages/fluent_ui
[macOS UI]: {{site.pub}}/packages/macos_ui

## Botões

![Uma coleção de botões Material 3.](/assets/images/docs/fwe/user-input/material-buttons.png)

Botões permitem que um usuário inicie uma ação na UI clicando ou tocando.
A biblioteca Material oferece uma variedade de tipos de botões que são funcionalmente semelhantes,
mas estilizados de forma diferente para vários casos de uso, incluindo:

- `ElevatedButton`: Um botão com alguma profundidade. Use botões elevados para adicionar
  dimensão a layouts que, de outra forma, são principalmente planos.
- `FilledButton`: Um botão preenchido que deve ser usado para
  ações importantes e finais que completam um fluxo,
  como **Salvar**, **Inscreva-se agora** ou **Confirmar**.
- `Tonal Button`: Um botão intermediário entre
  `FilledButton` e `OutlinedButton`.
  Eles são úteis em contextos onde um botão de prioridade mais baixa requer mais
  ênfase do que um contorno, como **Próximo**.
- `OutlinedButton`: Um botão com texto e uma borda visível.
  Esses botões contêm ações que são importantes,
  mas não são a ação principal em um aplicativo.
- `TextButton`: Texto clicável, sem borda.
  Como os botões de texto não possuem bordas visíveis,
  eles devem depender de sua posição
  em relação a outros conteúdos para contexto.
- `IconButton`: Um botão com um ícone.
- `FloatingActionButton`: Um botão de ícone que paira sobre
  o conteúdo para promover uma ação principal.

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [FloatingActionButton (Widget da Semana)][]

Geralmente, existem 3 aspectos principais para construir um botão:
estilo, callback e seu filho,
como visto no seguinte código de exemplo `ElevatedButton`:

{% comment %}
TODO(khanhnwin):
WidgetStateProperty e estilo na seção de design de
FWE. Claro, a aparência de um botão pode depender de seu estado.
Você pode estilizar um botão com base em seu estado usando `WidgetStateProperty`.
{% endcomment %}

- A função de callback de um botão, `onPressed`,
  determina o que acontece quando o botão é clicado,
  portanto, é nessa função que você atualiza o estado do seu aplicativo.
  Se o callback for `null`, o botão é desabilitado e
  nada acontece quando um usuário pressiona o botão.

- O `child` do botão, que é exibido na área de conteúdo do botão,
  geralmente é um texto ou um ícone que indica o propósito do botão.

- Finalmente, o `style` de um botão controla sua aparência: cor, borda e assim por diante.


{% render docs/code-and-image.md,
image:"fwe/user-input/ElevatedButton.gif",
caption: "Esta figura mostra um ElevatedButton com o texto \"Habilitado\" sendo clicado."
alt: "Um GIF de um botão elevado com o texto \"Habilitado\""
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
    child: const Text('Habilitado'),
  );
}
```
" %}

<br>

> <span class="material-symbols" aria-hidden="true">star</span> **Ponto de Verificação**:
> Conclua este tutorial que ensina como construir um
> botão "favorito": [Adicione interatividade ao seu aplicativo Flutter][]

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API**: [`ElevatedButton`][] • [`FilledButton`][] • [`OutlinedButton`][] • [`TextButton`][] • [`IconButton`][] • [`FloatingActionButton`][]

[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`FilledButton`]: {{site.api}}/flutter/material/FilledButton-class.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[FloatingActionButton (Widget da Semana)]: {{site.youtube-site}}/watch/2uaoEDOgk_I?si=MQZcSp24oRaS_kiY
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[Adicione interatividade ao seu aplicativo Flutter]: /ui/interactivity

## Texto

Vários widgets oferecem suporte à entrada de texto.

### `SelectableText`

O widget `Text` do Flutter exibe texto na tela,
mas não permite que os usuários selecionem ou copiem o texto.
`SelectableText` exibe uma string de texto _selecionável pelo usuário_.

{% render docs/code-and-image.md,
image:"fwe/user-input/SelectableText.gif",
caption: "Esta figura mostra um cursor destacando uma parte de uma string de texto."
alt: 'Um GIF de um cursor destacando duas linhas de texto de um parágrafo.'
code:"
```dart
@override
Widget build(BuildContext context) {
  return const SelectableText('''
Duas famílias, ambas iguais em dignidade,
Na bela Verona, onde situamos nossa cena,
De antiga queixa, surge uma nova revolta,
Onde sangue civil torna mãos civis impuras.
Dos lombos fatais desses dois inimigos''');
}
```
" %}

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [SelectableText (Widget da Semana)][]

[SelectableText (Widget da Semana)]: {{site.youtube-site}}/watch?v=ZSU3ZXOs6hc

### `RichText`

`RichText` permite que você exiba strings de rich text em seu aplicativo.
`TextSpan`, semelhante a `RichText`, permite exibir partes de texto com
estilos de texto diferentes. Não é para lidar com a entrada do usuário,
mas é útil se você estiver permitindo que os usuários editem e formatem o texto.

{% render docs/code-and-image.md,
image:"fwe/user-input/RichText.png",
caption: "Esta figura mostra uma string de texto formatada com diferentes estilos de texto."
alt: 'Uma captura de tela do texto "Olá mundo em negrito!" com a palavra "negrito" em negrito.'
code:"
```dart
@override
Widget build(BuildContext context) {
  return RichText(
    text: TextSpan(
      text: 'Olá ',
      style: DefaultTextStyle.of(context).style,
      children: const <TextSpan>[
        TextSpan(text: 'negrito', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' mundo!'),
      ],
    ),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [Rich Text (Widget da Semana)][]

> <span class="material-symbols" aria-hidden="true">flutter</span> **Demonstração**:
> [Editor de Rich Text][]

> <span class="material-symbols" aria-hidden="true">code</span> **Código**:
> [Código do Editor de Rich Text][]

[Rich Text (Widget da Semana)]: {{site.youtube-site}}/watch?v=rykDVh-QFfw
[Editor de Rich Text]: https://flutter.github.io/samples/rich_text_editor.html
[Código do Editor de Rich Text]: {{site.github}}/flutter/samples/tree/main/simplistic_editor

### `TextField`

Um `TextField` permite que os usuários insiram texto em uma caixa de texto usando um hardware ou
teclado na tela.

`TextField`s têm muitas propriedades e configurações diferentes.
Alguns dos destaques:

- `InputDecoration` determina a aparência do campo de texto,
  como cor e borda.
- `controller`: Um `TextEditingController` controla o texto que está sendo editado.
  Por que você pode precisar de um controller?
  Por padrão, os usuários do seu aplicativo podem digitar
  no campo de texto, mas se você quiser controlar programaticamente o `TextField`
  e limpar seu valor, por exemplo, você precisará de um `TextEditingController`.
- `onChanged`: Esta função de callback é acionada quando o usuário altera
  o valor do campo de texto, como ao inserir ou remover texto.
- `onSubmitted`: Este callback é acionado quando o usuário indica que
  terminou de editar o texto no campo;
  por exemplo, pressionando a tecla "enter" quando o campo de texto está em foco.

A classe suporta outras propriedades configuráveis, como
`obscureText` que transforma cada letra em um círculo `readOnly` conforme é digitada e
`readOnly` que impede o usuário de alterar o texto.

{% render docs/code-and-image.md,
image:"fwe/user-input/TextField.gif",
caption: "Esta figura mostra o texto sendo digitado em um TextField com uma borda e rótulo selecionados."
alt: "Um GIF de um campo de texto com o rótulo \"Nome do Mascote\", borda de foco roxa e a frase \"Dash, o beija-flor\" sendo digitada."
code:"
```dart
final TextEditingController _controller = TextEditingController();

@override
Widget build(BuildContext context) {
  return TextField(
    controller: _controller,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Nome do Mascote',
    ),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true">star</span> **Ponto de Verificação**:
> Conclua esta série de receitas de 4 partes que orienta
> você através de como criar um campo de texto,
> recuperar seu valor e atualizar o estado do seu aplicativo:
> 1. [Crie e estilize um campo de texto][]
> 1. [Recupere o valor de um campo de texto][]
> 1. [Manipule alterações em um campo de texto][]
> 1. [Foco e campos de texto][].

[Crie e estilize um campo de texto]: /cookbook/forms/text-input
[Recupere o valor de um campo de texto]: /cookbook/forms/retrieve-input
[Manipule alterações em um campo de texto]: /cookbook/forms/text-field-changes
[Foco e campos de texto]: /cookbook/forms/focus

### Formulário

`Form` é um contêiner opcional para agrupar vários
widgets de campo de formulário, como `TextField`.

Cada campo de formulário individual deve ser encapsulado em um widget `FormField`
com o widget `Form` como um ancestral comum.
Existem widgets convenientes que pré-encapsulam widgets de campo de formulário em um
`FormField` para você.
Por exemplo, a versão do widget `Form` de `TextField` é `TextFormField`.

Usar um `Form` fornece acesso a um `FormState`,
que permite salvar, redefinir e validar cada `FormField`
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
            hintText: 'Digite seu e-mail',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira algum texto';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate retorna true se o formulário for válido ou false caso contrário.
              if (_formKey.currentState!.validate()) {
                // Processar dados.
              }
            },
            child: const Text('Enviar'),
          ),
        ),
      ],
    ),
  );
}
```

> <span class="material-symbols" aria-hidden="true">star</span> **Ponto de Verificação**:
> Conclua este tutorial para aprender como [construir um formulário com validação][].

> <span class="material-symbols" aria-hidden="true">flutter</span> **Demonstração**:
> [Aplicativo de Formulário][]

> <span class="material-symbols" aria-hidden="true">code</span> **Código**:
> [Código do aplicativo de Formulário][]

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API**: [`TextField`][] • [`RichText`][] • [`SelectableText`][] • [`Form`][]

[Construir um formulário com validação]: /cookbook/forms/validation
[Aplicativo de Formulário]: https://flutter.github.io/samples/web/form_app/
[Código do aplicativo de Formulário]: {{site.github}}/flutter/samples/tree/main/form_app
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`RichText`]: {{site.api}}/flutter/widgets/RichText-class.html
[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html

## Selecione um valor de um grupo de opções

Forneça uma maneira para os usuários selecionarem entre várias opções.

### `SegmentedButton`

`SegmentedButton` permite que os usuários selecionem de um
grupo mínimo de 2 a 5 itens.

O tipo de dados, `<T>`, pode ser um tipo integrado, como
`int`, `String`, `bool` ou um enum.
Um `SegmentedButton` tem algumas propriedades relevantes:

- `segments`, uma lista de `ButtonSegment`s, onde cada um representa um "segmento"
   ou opção que o usuário pode selecionar.
   Visualmente, cada `ButtonSegment` pode ter um ícone, um rótulo de texto ou ambos.

- `multiSelectionEnabled` indica se o usuário tem permissão para
   selecionar várias opções. Esta propriedade tem como padrão false.

- `selected` identifica o(s) valor(es) selecionado(s) atualmente.
  **Nota:** `selected` é do tipo `Set<T>`, portanto, se você estiver apenas
   permitindo que os usuários selecionem um valor, esse valor deve ser
  fornecido como um `Set` com um único elemento.

- O callback `onSelectionChanged` é acionado quando um usuário seleciona qualquer segmento.
  Ele fornece uma lista dos segmentos selecionados para que você possa atualizar o estado do seu aplicativo.

- Parâmetros de estilo adicionais permitem que você modifique a aparência do botão.
  Por exemplo, `style` usa um `ButtonStyle`,
  fornecendo uma maneira de configurar um `selectedIcon`.

{% render docs/code-and-image.md,
image:"fwe/user-input/segmented-button.gif",
caption: "Esta figura mostra um SegmentedButton, cada segmento com um ícone e
texto representando seu valor."
alt: "Um GIF de um SegmentedButton com 4 segmentos: Dia, Semana, Mês e Ano.
Cada um tem um ícone de calendário para representar seu valor e um rótulo de texto.
Dia é selecionado primeiro, depois semana e mês, depois ano."
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
          label: Text('Dia'),
          icon: Icon(Icons.calendar_view_day)),
      ButtonSegment<Calendar>(
          value: Calendar.week,
          label: Text('Semana'),
          icon: Icon(Icons.calendar_view_week)),
      ButtonSegment<Calendar>(
          value: Calendar.month,
          label: Text('Mês'),
          icon: Icon(Icons.calendar_view_month)),
      ButtonSegment<Calendar>(
          value: Calendar.year,
          label: Text('Ano'),
          icon: Icon(Icons.calendar_today)),
    ],
    selected: <Calendar>{calendarView},
    onSelectionChanged: (Set<Calendar> newSelection) {
      setState(() {
        // Mudança sugerida
        // Por padrão, há apenas um único segmento que pode ser
        // selecionado por vez, então seu valor é sempre o primeiro
        // Por padrão, apenas um único segmento pode ser
        // selecionado por vez, então seu valor é sempre o primeiro
        calendarView = newSelection.first;
      });
    },
  );
}
```
" %}

### Chip

`Chip` é uma forma compacta de representar um
atributo, texto, entidade ou ação para um contexto específico.
Existem widgets `Chip` especializados para casos de uso específicos:

- [InputChip][] representa uma informação complexa,
  como uma entidade (pessoa, lugar ou coisa) ou
  texto conversacional, de forma compacta.
- [ChoiceChip][] permite uma única seleção de um conjunto de opções.
  Os chips de escolha contêm texto descritivo ou categorias relacionadas.
- [FilterChip][] usa tags ou palavras descritivas para filtrar o conteúdo.
- [ActionChip][] representa uma ação relacionada ao conteúdo principal.

Cada widget `Chip` requer um `label`.
Ele pode opcionalmente ter um `avatar` (como um ícone ou a foto do perfil de um usuário)
e um callback `onDeleted`, que mostra um ícone de exclusão que
quando acionado, exclui o chip.
A aparência de um widget `Chip` também pode ser personalizada definindo um
número de parâmetros opcionais, como `shape`, `color` e `iconTheme`.

Normalmente, você usará `Wrap`, um widget que exibe seus filhos em
várias execuções horizontais ou verticais, para garantir que seus chips se envolvam e
não sejam cortados na borda do seu aplicativo.

{% render docs/code-and-image.md,
image:"fwe/user-input/chip.png",
caption: "Esta figura mostra duas linhas de widgets Chip, cada um contendo um círculo
imagem de perfil principal e texto de conteúdo."
alt: "Uma captura de tela de 4 Chips divididos em duas linhas com um círculo principal
imagem de perfil com texto de conteúdo."
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
          label: Text('Dash Bombeiro'),
        ),
        Chip(
          avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dash_musician.png')),
          label: Text('Dash Músico'),
        ),
        Chip(
          avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dash_artist.png')),
          label: Text('Dash Artista'),
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

Um `DropdownMenu` permite que os usuários selecionem uma opção de um menu
de opções e coloca o texto selecionado em um `TextField`.
Ele também permite que os usuários filtrem os itens do menu com base na entrada de texto.

Os parâmetros de configuração incluem o seguinte:

- `dropdownMenuEntries` fornece uma lista de `DropdownMenuEntry`s que
   descreve cada item do menu.
  O menu pode conter informações como um rótulo de texto e
   um ícone inicial ou final.
  (Este também é o único parâmetro obrigatório.)
- `TextEditingController` permite o controle programático do `TextField`.
- O callback `onSelected` é acionado quando o usuário seleciona uma opção.
- `initialSelection` permite que você configure o valor padrão.
- Parâmetros adicionais também estão disponíveis para
  personalizar a aparência e o comportamento do widget.

{% render docs/code-and-image.md,
image:"fwe/user-input/dropdownmenu.gif",
caption: "Esta figura mostra um widget DropdownMenu com 5 opções de valor. Cada
a cor do texto da opção é estilizada para representar o valor da cor."
alt: "Um GIF do widget DropdownMenu que é selecionado, ele exibe 5 opções:
Azul, Rosa, Verde, Laranja e Cinza. O texto da opção é exibido na cor
de seu valor."
code:"
```dart
enum ColorLabel {
  blue('Azul', Colors.blue),
  pink('Rosa', Colors.pink),
  green('Verde', Colors.green),
  yellow('Laranja', Colors.orange),
  grey('Cinza', Colors.grey);

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
    // requestFocusOnTap é habilitado/desabilitado por plataformas quando é nulo.
    // Em plataformas móveis, isso é false por padrão. Definir isso como true irá
    // acionar a solicitação de foco no campo de texto e o teclado virtual aparecerá
    // depois. Em plataformas de desktop, no entanto, o padrão é true.
    requestFocusOnTap: true,
    label: const Text('Cor'),
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
              enabled: color.label != 'Cinza',
              style: MenuItemButton.styleFrom(
                foregroundColor: color.color,
              ),
            );
      }).toList(),
  );
}
```
" %}

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [DropdownMenu (Widget da Semana)][]

[DropdownMenu (Widget da Semana)]: {{site.youtube-site}}/watch?v=giV9AbM2gd8?si=E23hjg72cjMTe_mz

### Slider

O widget `Slider` permite que um usuário ajuste um valor movendo um indicador,
como uma barra de volume.

Parâmetros de configuração para o widget `Slider`:

- `value` representa o valor atual do slider
- `onChanged` é o callback que é acionado quando a alça é movida
- `min` e `max` estabelecem os valores mínimo e máximo permitidos pelo slider
- `divisions` estabelece um intervalo discreto com o qual o usuário pode mover o
  manipule ao longo da faixa.

{% render docs/code-and-image.md,
image:"fwe/user-input/slider.gif",
caption: "Esta figura mostra um widget slider com um valor que varia de 0,0 a 5,0
dividido em 5 divisões. Ele mostra o valor atual como um rótulo conforme o dial
é arrastado."
alt: "Um GIF de um slider que tem o dial arrastado da esquerda para a direita em incrementos
de 1, de 0,0 a 5,0"
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

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [Slider, RangeSlider, CupertinoSlider (Widget da Semana)][]

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API:** [`SegmentedButton`][] • [`DropdownMenu`][] • [`Slider`][] • [`Chip`][]

[Slider, RangeSlider, CupertinoSlider (Widget da Semana)]: {{site.youtube-site}}/watch?v=ufb4gIPDmEss
[`SegmentedButton`]: {{site.api}}/flutter/material/SegmentedButton-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html

## Alternar entre valores

Existem várias maneiras pelas quais sua UI pode permitir a alternância entre valores.

### Checkbox, Switch e Radio

Forneça uma opção para alternar um único valor ligado e desligado.
A lógica funcional por trás desses widgets é a mesma,
pois todos os 3 são construídos em cima de `ToggleableStateMixin`, embora
cada um fornece ligeiras diferenças de apresentação.:

- `Checkbox` é um contêiner que está vazio quando false ou
  preenchido com uma marca de seleção quando verdadeiro.
- `Switch` tem um manipulo que fica à esquerda quando false e
  desliza para a direita quando verdadeiro.
- `Radio` é semelhante a um `Checkbox` em que é um contêiner que é
  vazio quando false, mas preenchido quando verdadeiro.

A configuração para `Checkbox` e `Switch` contém:

- um `value` que é `true` ou `false`
- e um callback `onChanged` que é acionado quando
  o usuário alterna o widget

### Checkbox

{% render docs/code-and-image.md,
image:"fwe/user-input/checkbox.gif",
caption: "Esta figura mostra um checkbox sendo marcado e desmarcado."
alt: "Um GIF que mostra um ponteiro clicando em um checkbox
e depois clicando novamente para desmarcá-lo."
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

{% render docs/code-and-image.md,
image:"fwe/user-input/Switch.gif",
caption: "Esta figura mostra um widget Switch que é ligado e desligado."
alt: "Um GIF de um widget Switch que é ligado e desligado. Em seu estado desligado,
é cinza com bordas cinza-escuras. Em seu estado ligado,
é vermelho com uma borda vermelha clara."
code:"
```dart
bool light = true;

@override
Widget build(BuildContext context) {
  return Switch(
    // Este valor booleano alterna o switch.
    value: light,
    activeColor: Colors.red,
    onChanged: (bool value) {
      // Isso é chamado quando o usuário alterna o switch.
      setState(() {
        light = value;
      });
    },
  );
}
```
" %}
### Radio

Um grupo de botões `Radio` que permite ao usuário selecionar entre valores mutuamente exclusivos. Quando o usuário seleciona um botão de rádio em um grupo, os outros botões de rádio são desmarcados.

- O `value` de um botão `Radio` específico representa o valor desse botão,
- O valor selecionado para um grupo de botões de rádio é identificado pelo parâmetro `groupValue`.
- `Radio` também tem um callback `onChanged` que é acionado quando os usuários clicam nele, como `Switch` e `Checkbox`

{% render docs/code-and-image.md,
image:"fwe/user-input/Radio.gif",
caption: "Esta figura mostra uma coluna de ListTiles contendo um botão de rádio e um rótulo, onde apenas um botão de rádio pode ser selecionado por vez.",
alt: "Um GIF de 4 ListTiles em uma coluna, cada um contendo um botão Radio à esquerda e um texto de título. Os botões Radio são selecionados em ordem de cima para baixo.",
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

#### Bônus: CheckboxListTile & SwitchListTile

Esses widgets de conveniência são os mesmos widgets de checkbox e switch, mas suportam um rótulo (como um `ListTile`).

{% render docs/code-and-image.md,
image:"fwe/user-input/SpecialListTiles.gif",
caption: "Esta figura mostra uma coluna contendo um CheckboxListTile e um SwitchListTile sendo alternados.",
alt: "Um ListTile com um ícone à esquerda, um texto de título e um checkbox à direita sendo marcado e desmarcado. Ele também mostra um ListTile com um ícone à esquerda, um texto de título e um switch sendo alternado ligado e desligado.",
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

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [CheckboxListTile (Widget da Semana)][]

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [SwitchListTile (Widget da Semana)][]

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API**:
[`Checkbox`][] • [`CheckboxListTile`][] • [`Switch`][] • [`SwitchListTile`][] •
[`Radio`][]

[CheckboxListTile (Widget da Semana)]: {{site.youtube-site}}/watch?v=RkSqPAn9szs
[SwitchListTile (Widget da Semana)]: {{site.youtube-site}}/watch?v=0igIjvtEWNU

[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`CheckboxListTile`]: {{site.api}}/flutter/material/CheckboxListTile-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`SwitchListTile`]: {{site.api}}/flutter/material/SwitchListTile-class.html
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html

## Selecionar uma data ou hora

Widgets são fornecidos para que o usuário possa selecionar uma data e hora.

Há um conjunto de diálogos que permitem aos usuários selecionar uma data ou hora, como você verá nas seções a seguir. Com exceção dos diferentes tipos de data - `DateTime` para datas vs `TimeOfDay` para hora - esses diálogos funcionam de forma semelhante, você pode configurá-los fornecendo:

- um `initialDate` ou `initialTime` padrão
- ou um `initialEntryMode` que determina a interface do usuário do seletor que é exibida.

### DatePickerDialog

Este diálogo permite que o usuário selecione uma data ou um intervalo de datas. Ative chamando a função `showDatePicker`, que retorna um `Future<DateTime>`, então não se esqueça de aguardar a chamada de função assíncrona!

{% render docs/code-and-image.md,
image:"fwe/user-input/DatePicker.gif",
caption: "Esta figura mostra um DatePicker que é exibido quando o botão \"Escolher uma data\" é clicado.",
alt: "Um GIF de um ponteiro clicando em um botão que diz \"Escolher uma data\", então mostra um seletor de data. A data sexta-feira, 30 de agosto é selecionada e o botão \"OK\" é clicado.",
code:"
```dart
DateTime? selectedDate;

@override
Widget build(BuildContext context) {
  var date = selectedDate;

  return Column(children: [
    Text(
      date == null
          ? \"Você ainda não escolheu uma data.\"
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
      label: const Text('Escolher uma data'),
    )
  ]);
}
```
" %}

### TimePickerDialog

`TimePickerDialog` é um diálogo que apresenta um seletor de tempo. Ele pode ser ativado chamando a função `showTimePicker()`. Em vez de retornar um `Future<DateTime>`, `showTimePicker` retorna um `Future<TimeOfDay>`. Mais uma vez, não se esqueça de aguardar a chamada da função!

{% render docs/code-and-image.md,
image:"fwe/user-input/TimePicker.gif",
caption: "Esta figura mostra um TimePicker que é exibido quando o botão \"Escolher uma hora\" é clicado.",
alt: "Um GIF de um ponteiro clicando em um botão que diz \"Escolher uma hora\", então mostra um seletor de hora. O seletor de hora mostra um relógio circular enquanto o cursor move o ponteiro das horas, depois o ponteiro dos minutos, seleciona PM e, em seguida, o botão \"OK\" é clicado.",
code:"
```dart
TimeOfDay? selectedTime;

@override
Widget build(BuildContext context) {
  var time = selectedTime;

  return Column(children: [
    Text(
      time == null ? "Você ainda não escolheu uma hora." : time.format(context),
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
      label: const Text('Escolher uma data'),
    )
  ]);
}
```
" %}

:::tip
Chamar `showDatePicker()` e `showTimePicker()` é equivalente a chamar `showDialog()` com `DatePickerDialog()` e `TimePickerDialog()`, respectivamente. Internamente, ambas as funções usam a função `showDialog()` com seus respectivos widgets `Dialog`. Para habilitar a restauração do estado, você também pode colocar `DatePickerDialog()` e `TimePickerDialog()` diretamente na pilha do `Navigator`.
:::

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API:**
[`showDatePicker`][] • [`showTimePicker`][]

[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html
[`showTimePicker`]: {{site.api}}/flutter/material/showTimePicker.html

## Deslizar e arrastar

### [`Dismissible`][]

Um `Dismissible` é um widget que permite aos usuários dispensá-lo deslizando. Ele tem vários parâmetros de configuração, incluindo:

- Um widget `child`
- Um callback `onDismissed` que é acionado quando o usuário desliza
- Parâmetros de estilo como `background`
- É importante incluir um objeto `key` também para que eles possam ser identificados exclusivamente de widgets `Dismissible` irmãos na árvore de widgets.

{% render docs/code-and-image.md,
image:"fwe/user-input/Dismissible.gif",
caption: "Esta figura mostra uma lista de widgets Dismissible que contêm cada um um ListTile. Deslizar pelo ListTile revela um fundo verde faz o tile desaparecer.",
alt: "Uma captura de tela de três widgets, espaçados uniformemente um do outro.",
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

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [Dismissible (Widget da Semana)][]

> <span class="material-symbols" aria-hidden="true">star</span> **Checkpoint**:
> Complete este tutorial sobre como [implementar deslizar para dispensar][] usando o
> widget dismissible.

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API:**
[`Dismissible`][]

[Dismissible (Widget da Semana)]: {{site.youtube-site}}/watch?v=iEMgjrfuc58?si=f0S7IdaA9PIWIYvl
[implementar deslizar para dispensar]: /cookbook/gestures/dismissible
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html

## Procurando por mais widgets?

Esta página apresenta apenas alguns dos widgets Material comuns que você pode usar para lidar com a entrada do usuário em seu aplicativo Flutter. Confira a [biblioteca de widgets Material][] e a [documentação da API da biblioteca Material][] para uma lista completa de widgets.

> <span class="material-symbols" aria-hidden="true">flutter</span> **Demonstração**:
> Veja a [Demonstração do Material 3][] do Flutter para uma amostra selecionada de widgets de entrada do usuário disponíveis na biblioteca Material.

Se as bibliotecas Material e Cupertino não tiverem um widget que faça o que você precisa, confira o [pub.dev][] para encontrar pacotes mantidos e de propriedade da comunidade Flutter & Dart. Por exemplo, o pacote [`flutter_slidable`][] fornece um widget `Slidable` que é mais personalizável do que o widget `Dismissible` descrito na seção anterior.

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [flutter_slidable (Pacote da Semana)][]

[Biblioteca de Widgets Material]: /ui/widgets/material
[Documentação da API da Biblioteca Material]: {{site.api}}/flutter/material/material-library.html
[Demonstração do Material 3]: https://flutter.github.io/samples/web/material_3_demo/

[`flutter_slidable`]: {{site.pub}}/packages/flutter_slidable
[flutter_slidable (Pacote da Semana)]: {{site.youtube-site}}/watch?v=QFcFEpFmNJ8

## Construir widgets interativos com GestureDetector

Você examinou as bibliotecas de widgets, o pub.dev, perguntou aos seus amigos programadores e ainda não consegue encontrar um widget que se encaixe na interação do usuário que você está procurando? Você pode construir seu próprio widget personalizado e torná-lo interativo usando `GestureDetector`.

> <span class="material-symbols" aria-hidden="true">star</span> **Checkpoint**:
> Use esta receita como ponto de partida para criar seu próprio widget de botão _personalizado_ que possa [manipular toques][].

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [GestureDetector (Widget da Semana)][]

> <span class="material-symbols" aria-hidden="true">menu_book</span> **Referência**:
> Confira [Toques, arrastos e outros gestos][] que explicam como ouvir e responder a gestos no Flutter.

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo Bônus**:
> Curioso sobre como o `GestureArena` do Flutter transforma dados brutos de interação do usuário em conceitos reconhecíveis pelo ser humano, como toques, arrastos e pinças? Confira este vídeo: [GestureArena (Decodificando o Flutter)][]

[manipular toques]: /cookbook/gestures/handling-taps
[GestureDetector (Widget da Semana)]: {{site.youtube-site}}/watch?v=WhVXkCFPmK4
[Toques, arrastos e outros gestos]: /ui/interactivity/gestures#gestures
[GestureArena (Decodificando o Flutter)]: {{site.youtube-site}}/watch?v=Q85LBtBdi0U

### Não se esqueça da acessibilidade!

Se você estiver construindo um widget personalizado, anote seu significado com o widget `Semantics`. Ele fornece descrições e metadados para leitores de tela e outras ferramentas baseadas em análise semântica.

> <span class="material-symbols" aria-hidden="true">slideshow</span> **Vídeo**:
> [Semantics (Widget da Semana do Flutter)][]

<br>

<span class="material-symbols" aria-hidden="true">menu_book</span> **Documentação da API**:
[`GestureDetector`][] • [`Semantics`][]

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html

## Testando

Depois de terminar de construir as interações do usuário em seu aplicativo, não se esqueça de escrever testes para garantir que tudo funcione como esperado!

Estes tutoriais o guiam na escrita de testes que simulam interações do usuário em seu aplicativo:

> <span class="material-symbols" aria-hidden="true">star</span> **Checkpoint**:
> Siga este artigo de cookbook [toque, arraste e insira texto][] e aprenda como usar `WidgetTester` para simular e testar as interações do usuário em seu aplicativo.

> <span class="material-symbols" aria-hidden="true">bookmark</span> **Tutorial Bônus**:
> A receita do cookbook [manipular rolagem][] mostra como verificar se as listas de widgets contêm o conteúdo esperado rolando as listas usando testes de widget.

[Semantics (Widget da Semana do Flutter)]: {{site.youtube-site}}/watch?v=NvtMt_DtFrQ?si=o79BqAg9NAl8EE8_
[Toque, arraste e insira texto]: /cookbook/testing/widget/tap-drag
[Manipular rolagem]: /cookbook/testing/widget/scrolling

## Próximo: Rede

Esta página foi uma introdução ao tratamento da entrada do usuário. Agora que você sabe como lidar com a entrada de usuários do aplicativo, você pode tornar seu aplicativo ainda mais interessante adicionando dados externos. Na próxima seção, você aprenderá agora a buscar dados para seu aplicativo por meio de uma rede, como converter dados de e para JSON, autenticação e outros recursos de rede.

## Feedback

Como esta seção do site está evoluindo, nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="user-input"
