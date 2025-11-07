---
title: Usando Actions e Shortcuts
description: Como usar Actions e Shortcuts no seu app Flutter.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

Esta página descreve como vincular eventos físicos do teclado a ações na interface
do usuário. Por exemplo, para definir atalhos de teclado em sua aplicação, esta
página é para você.

## Visão geral

Para uma aplicação GUI fazer qualquer coisa, ela precisa ter ações: os usuários querem dizer
à aplicação para _fazer_ algo. Ações geralmente são funções simples que
executam diretamente a ação (como definir um valor ou salvar um arquivo). Em uma aplicação maior,
no entanto, as coisas são mais complexas: o código para invocar a ação,
e o código para a ação em si podem precisar estar em lugares diferentes.
Atalhos (vinculações de teclas) podem precisar de definição em um nível que não sabe nada
sobre as ações que invocam.

É aí que entra o sistema de actions e shortcuts do Flutter. Ele permite
que desenvolvedores definam ações que cumprem intents vinculados a elas. Neste
contexto, um intent é uma ação genérica que o usuário deseja realizar, e uma
instância da classe [`Intent`][] representa essas intenções do usuário no Flutter. Um
`Intent` pode ser de propósito geral, cumprido por diferentes ações em diferentes
contextos. Uma [`Action`][] pode ser um callback simples (como no caso do
[`CallbackAction`][]) ou algo mais complexo que se integra com arquiteturas inteiras
de desfazer/refazer (por exemplo) ou outra lógica.

![Diagrama de uso de Shortcuts][Using Shortcuts Diagram]{:width="100%"}

[`Shortcuts`][] são vinculações de teclas que são ativadas ao pressionar uma tecla ou combinação
de teclas. As combinações de teclas residem em uma tabela com seus intents vinculados. Quando
o widget `Shortcuts` os invoca, ele envia seu intent correspondente ao
subsistema de actions para cumprimento.

Para ilustrar os conceitos em actions e shortcuts, este artigo cria um
app simples que permite ao usuário selecionar e copiar texto em um campo de texto usando tanto
botões quanto atalhos.

### Por que separar Actions de Intents?

Você pode se perguntar: por que não mapear uma combinação de teclas diretamente para uma ação? Por que
ter intents? Isso é porque é útil ter uma separação de
preocupações entre onde as definições de mapeamento de teclas estão (geralmente em um nível alto),
e onde as definições de ação estão (geralmente em um nível baixo), e porque é
importante ser capaz de ter uma única combinação de teclas mapeada para uma operação pretendida
em um app, e fazer com que ela se adapte automaticamente a qualquer ação
que cumpra essa operação pretendida para o contexto focado.

Por exemplo, o Flutter tem um widget `ActivateIntent` que mapeia cada tipo de
controle para sua versão correspondente de um `ActivateAction` (e que executa
o código que ativa o controle). Este código geralmente precisa de acesso bastante privado
para fazer seu trabalho. Se a camada extra de indireção que os `Intent`s fornecem
não existisse, seria necessário elevar a definição das ações para
onde a instância definidora do widget `Shortcuts` pudesse vê-las, causando
os shortcuts a ter mais conhecimento do que o necessário sobre qual ação
invocar, e a ter acesso ou fornecer estado que não teria necessariamente
ou precisaria de outra forma. Isso permite que seu código separe as duas preocupações para serem mais
independentes.

Intents configuram uma ação para que a mesma ação possa servir múltiplos usos. Um
exemplo disso é `DirectionalFocusIntent`, que recebe uma direção para mover
o foco, permitindo que o `DirectionalFocusAction` saiba em qual direção
mover o foco. Apenas tenha cuidado: não passe estado no `Intent` que se aplica
a todas as invocações de uma `Action`: esse tipo de estado deve ser passado ao
construtor da própria `Action`, para evitar que o `Intent` precise saber
demais.

### Por que não usar callbacks?

Você também pode se perguntar: por que não usar apenas um callback em vez de um objeto `Action`?
A principal razão é que é útil para as ações decidirem se estão
habilitadas implementando `isEnabled`. Além disso, muitas vezes é útil se as
vinculações de teclas e a implementação dessas vinculações estiverem em lugares diferentes.

Se tudo o que você precisa são callbacks sem a flexibilidade de `Actions` e
`Shortcuts`, você pode usar o widget [`CallbackShortcuts`][]:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (callback-shortcuts)"?>
```dart
@override
Widget build(BuildContext context) {
  return CallbackShortcuts(
    bindings: <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.arrowUp): () {
        setState(() => count = count + 1);
      },
      const SingleActivator(LogicalKeyboardKey.arrowDown): () {
        setState(() => count = count - 1);
      },
    },
    child: Focus(
      autofocus: true,
      child: Column(
        children: <Widget>[
          const Text('Press the up arrow key to add to the counter'),
          const Text('Press the down arrow key to subtract from the counter'),
          Text('count: $count'),
        ],
      ),
    ),
  );
}
```

## Shortcuts

Como você verá abaixo, actions são úteis por si só, mas o caso de uso mais comum
envolve vinculá-las a um atalho de teclado. É para isso que serve o widget `Shortcuts`.

Ele é inserido na hierarquia de widgets para definir combinações de teclas que
representam a intenção do usuário quando essa combinação de teclas é pressionada. Para converter
essa finalidade pretendida para a combinação de teclas em uma ação concreta, o
widget `Actions` é usado para mapear o `Intent` a uma `Action`. Por exemplo, você pode
definir um `SelectAllIntent` e vinculá-lo ao seu próprio `SelectAllAction` ou ao seu
`CanvasSelectAllAction`, e a partir dessa única vinculação de tecla, o sistema invoca
qualquer um deles, dependendo de qual parte da sua aplicação tem foco. Vamos ver como
funciona a parte de vinculação de teclas:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (shortcuts)"?>
```dart
@override
Widget build(BuildContext context) {
  return Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
          const SelectAllIntent(),
    },
    child: Actions(
      dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        SelectAllIntent: SelectAllAction(model),
      },
      child: Builder(
        builder: (context) => TextButton(
          onPressed: Actions.handler<SelectAllIntent>(
            context,
            const SelectAllIntent(),
          ),
          child: const Text('SELECT ALL'),
        ),
      ),
    ),
  );
}
```

O mapa dado a um widget `Shortcuts` mapeia um `LogicalKeySet` (ou um
`ShortcutActivator`, veja nota abaixo) para uma instância de `Intent`. O conjunto de teclas lógicas
define um conjunto de uma ou mais teclas, e o intent indica o propósito pretendido
do pressionamento de tecla. O widget `Shortcuts` procura pressionamentos de teclas no mapa,
para encontrar uma instância de `Intent`, que ele passa para o método `invoke()` da action.

:::note
`ShortcutActivator` é uma substituição para `LogicalKeySet`.
Ele permite ativação mais flexível e correta de atalhos.
`LogicalKeySet` é um `ShortcutActivator`, é claro, mas
também existe `SingleActivator`, que recebe uma única tecla e os
modificadores opcionais a serem pressionados antes da tecla.
Depois há `CharacterActivator`, que ativa um atalho baseado no
caractere produzido por uma sequência de teclas, em vez das teclas lógicas em si.
`ShortcutActivator` também é destinado a ser subclasseado para permitir
formas personalizadas de ativar atalhos a partir de eventos de teclas.
:::

### O ShortcutManager

O gerenciador de atalhos, um objeto de vida mais longa que o widget `Shortcuts`, passa
eventos de teclas quando os recebe. Ele contém a lógica para decidir como
lidar com as teclas, a lógica para percorrer a árvore para encontrar outros mapeamentos
de atalhos, e mantém um mapa de combinações de teclas para intents.

Embora o comportamento padrão do `ShortcutManager` seja geralmente desejável, o
widget `Shortcuts` aceita um `ShortcutManager` que você pode subclassear para personalizar
sua funcionalidade.

Por exemplo, se você quiser registrar cada tecla que um widget `Shortcuts` processou,
você poderia fazer um `LoggingShortcutManager`:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (logging-shortcut-manager)"?>
```dart
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}
```

Agora, toda vez que o widget `Shortcuts` processar um atalho, ele imprime o evento de tecla
e o contexto relevante.

## Actions

`Actions` permitem a definição de operações que a aplicação pode
realizar invocando-as com um `Intent`. Actions podem ser habilitadas ou desabilitadas,
e recebem a instância de intent que as invocou como argumento para permitir
configuração pelo intent.

### Definindo actions

Actions, em sua forma mais simples, são apenas subclasses de `Action<Intent>` com um
método `invoke()`. Aqui está uma action simples que simplesmente invoca uma função no
modelo fornecido:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (select-all-action)"?>
```dart
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.model);

  final Model model;

  @override
  void invoke(covariant SelectAllIntent intent) => model.selectAll();
}
```

Ou, se for muito trabalhoso criar uma nova classe, use um `CallbackAction`:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (callback-action)"?>
```dart
CallbackAction(onInvoke: (intent) => model.selectAll());
```

Uma vez que você tem uma action, você a adiciona à sua aplicação usando o widget [`Actions`][],
que recebe um mapa de tipos de `Intent` para `Action`s:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (select-all-usage)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: child,
  );
}
```

O widget `Shortcuts` usa o contexto do widget `Focus` e `Actions.invoke` para
encontrar qual action invocar. Se o widget `Shortcuts` não encontrar um tipo de intent correspondente
no primeiro widget `Actions` encontrado, ele considera o próximo
widget ancestral `Actions`, e assim por diante, até atingir a raiz da árvore de
widgets, ou encontrar um tipo de intent correspondente e invocar a action correspondente.

### Invocando Actions

O sistema de actions tem várias maneiras de invocar actions. De longe, a maneira mais comum
é através do uso de um widget `Shortcuts` coberto na seção anterior,
mas existem outras maneiras de interrogar o subsistema de actions e invocar uma
action. É possível invocar actions que não estão vinculadas a teclas.

Por exemplo, para encontrar uma action associada a um intent, você pode usar:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (maybe-find)"?>
```dart
Action<SelectAllIntent>? selectAll =
    Actions.maybeFind<SelectAllIntent>(context);
```

Isso retorna uma `Action` associada ao tipo `SelectAllIntent` se uma estiver
disponível no `context` dado. Se não estiver disponível, retorna null. Se uma
`Action` associada sempre deve estar disponível, então use `find` em vez de
`maybeFind`, que lança uma exceção quando não encontra um tipo de `Intent`
correspondente.

Para invocar a action (se ela existir), chame:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (invoke-action)"?>
```dart
Object? result;
if (selectAll != null) {
  result =
      Actions.of(context).invokeAction(selectAll, const SelectAllIntent());
}
```

Combine isso em uma única chamada com o seguinte:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (maybe-invoke)"?>
```dart
Object? result =
    Actions.maybeInvoke<SelectAllIntent>(context, const SelectAllIntent());
```

Às vezes você quer invocar uma action como
resultado de pressionar um botão ou outro controle.
Você pode fazer isso com a função `Actions.handler`.
Se o intent tiver um mapeamento para uma action habilitada,
a função `Actions.handler` cria um closure de handler.
No entanto, se não tiver um mapeamento, ela retorna `null`.
Isso permite que o botão seja desabilitado se
não houver action habilitada que corresponda no contexto.

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (handler)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Actions.handler<SelectAllIntent>(
          context,
          SelectAllIntent(controller: controller),
        ),
        child: const Text('SELECT ALL'),
      ),
    ),
  );
}
```

O widget `Actions` só invoca actions quando `isEnabled(Intent intent)`
retorna true, permitindo que a action decida se o dispatcher deve considerá-la
para invocação. Se a action não estiver habilitada, então o widget `Actions` dá
a outra action habilitada mais acima na hierarquia de widgets (se existir) uma chance de
executar.

O exemplo anterior usa um `Builder` porque `Actions.handler` e
`Actions.invoke` (por exemplo) só encontram actions no `context` fornecido, e
se o exemplo passar o `context` dado à função `build`, o framework
começa a procurar _acima_ do widget atual. Usar um `Builder` permite que o
framework encontre as actions definidas na mesma função `build`.

Você pode invocar uma action sem precisar de um `BuildContext`, mas como o
widget `Actions` requer um contexto para encontrar uma action habilitada para invocar, você
precisa fornecer um, seja criando sua própria instância de `Action`, ou
encontrando uma em um contexto apropriado com `Actions.find`.

Para invocar a action, passe a action para o método `invoke` em um
`ActionDispatcher`, seja um que você criou, ou um recuperado de um
widget `Actions` existente usando o método `Actions.of(context)`. Verifique se
a action está habilitada antes de chamar `invoke`. É claro, você também pode simplesmente chamar
`invoke` na própria action, passando um `Intent`, mas então você opta por não usar quaisquer
serviços que um dispatcher de action possa fornecer (como registro, desfazer/refazer e
assim por diante).

### Dispatchers de action

Na maioria das vezes, você só quer invocar uma action, fazê-la fazer sua coisa e
esquecer dela. Às vezes, no entanto, você pode querer registrar as actions executadas.

É aqui que substituir o `ActionDispatcher` padrão por um dispatcher personalizado
entra. Você passa seu `ActionDispatcher` ao widget `Actions`, e ele
invoca actions de quaisquer widgets `Actions` abaixo daquele que não define um
dispatcher próprio.

A primeira coisa que `Actions` faz ao invocar uma action é procurar o
`ActionDispatcher` e passar a action para ele para invocação. Se não houver nenhum,
ele cria um `ActionDispatcher` padrão que simplesmente invoca a action.

Se você quiser um log de todas as actions invocadas, no entanto, você pode criar seu próprio
`LoggingActionDispatcher` para fazer o trabalho:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher)"?>
```dart
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }

  @override
  (bool, Object?) invokeActionIfEnabled(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    return super.invokeActionIfEnabled(action, intent, context);
  }
}
```

Então você passa isso para seu widget `Actions` de nível superior:

<?code-excerpt "ui/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher-usage)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    dispatcher: LoggingActionDispatcher(),
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Actions.handler<SelectAllIntent>(
          context,
          const SelectAllIntent(),
        ),
        child: const Text('SELECT ALL'),
      ),
    ),
  );
}
```

Isso registra cada action conforme ela é executada, assim:

```console
flutter: Action invoked: SelectAllAction#906fc(SelectAllIntent#a98e3) from Builder(dependencies: _[ActionsMarker])
```

## Juntando tudo

A combinação de `Actions` e `Shortcuts` é poderosa: você pode definir intents
genéricos que mapeiam para actions específicas no nível do widget. Aqui está um app simples
que ilustra os conceitos descritos acima. O app cria um campo de texto que
também tem botões "select all" e "copy to clipboard" ao lado dele. Os botões
invocam actions para realizar seu trabalho. Todas as actions e
shortcuts invocados são registrados.

<?code-excerpt "ui/actions_and_shortcuts/lib/copyable_text.dart"?>
```dartpad title="Exemplo prático do DartPad de texto copiável" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field that also has buttons to select all the text and copy the
/// selected text to the clipboard.
class CopyableTextField extends StatefulWidget {
  const CopyableTextField({super.key, required this.title});

  final String title;

  @override
  State<CopyableTextField> createState() => _CopyableTextFieldState();
}

class _CopyableTextFieldState extends State<CopyableTextField> {
  late final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        ClearIntent: ClearAction(controller),
        CopyIntent: CopyAction(controller),
        SelectAllIntent: SelectAllAction(controller),
      },
      child: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: Row(
              children: <Widget>[
                const Spacer(),
                Expanded(
                  child: TextField(controller: controller),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed:
                      Actions.handler<CopyIntent>(context, const CopyIntent()),
                ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: Actions.handler<SelectAllIntent>(
                      context, const SelectAllIntent()),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

/// An intent that is bound to ClearAction in order to clear its
/// TextEditingController.
class ClearIntent extends Intent {
  const ClearIntent();
}

/// An action that is bound to ClearIntent that clears its
/// TextEditingController.
class ClearAction extends Action<ClearIntent> {
  ClearAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant ClearIntent intent) {
    controller.clear();

    return null;
  }
}

/// An intent that is bound to CopyAction to copy from its
/// TextEditingController.
class CopyIntent extends Intent {
  const CopyIntent();
}

/// An action that is bound to CopyIntent that copies the text in its
/// TextEditingController to the clipboard.
class CopyAction extends Action<CopyIntent> {
  CopyAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant CopyIntent intent) {
    final String selectedString = controller.text.substring(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    Clipboard.setData(ClipboardData(text: selectedString));

    return null;
  }
}

/// An intent that is bound to SelectAllAction to select all the text in its
/// controller.
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

/// An action that is bound to SelectAllAction that selects all text in its
/// TextEditingController.
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant SelectAllIntent intent) {
    controller.selection = controller.selection.copyWith(
      baseOffset: 0,
      extentOffset: controller.text.length,
      affinity: controller.selection.affinity,
    );

    return null;
  }
}

/// The top level application class.
///
/// Shortcuts defined here are in effect for the whole app,
/// although different widgets may fulfill them differently.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Shortcuts and Actions Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
              const CopyIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
              const SelectAllIntent(),
        },
        child: const CopyableTextField(title: title),
      ),
    );
  }
}

void main() => runApp(const MyApp());
```


[`Action`]: {{site.api}}/flutter/widgets/Action-class.html
[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`CallbackAction`]: {{site.api}}/flutter/widgets/CallbackAction-class.html
[`CallbackShortcuts`]: {{site.api}}/flutter/widgets/CallbackShortcuts-class.html
[`Intent`]: {{site.api}}/flutter/widgets/Intent-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html
[Using Shortcuts Diagram]: /assets/images/docs/using_shortcuts.png
