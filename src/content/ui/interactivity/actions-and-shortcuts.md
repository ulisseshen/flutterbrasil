---
ia-translate: true
title: Usando Ações e Atalhos
description: Como usar Ações e Atalhos em seu aplicativo Flutter.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

Esta página descreve como vincular eventos de teclado físico a ações na
interface do usuário. Por exemplo, para definir atalhos de teclado em seu
aplicativo, esta página é para você.

## Visão Geral

Para que um aplicativo GUI faça alguma coisa, ele precisa ter ações: os
usuários querem dizer ao aplicativo para _fazer_ algo. As ações são
frequentemente funções simples que realizam diretamente a ação (como definir um
valor ou salvar um arquivo). Em um aplicativo maior, no entanto, as coisas são
mais complexas: o código para invocar a ação e o código para a própria ação
podem precisar estar em locais diferentes. Os atalhos (combinações de teclas)
podem precisar de definição em um nível que não saiba nada sobre as ações que
invocam.

É aí que entra o sistema de ações e atalhos do Flutter. Ele permite que os
desenvolvedores definam ações que cumprem intenções vinculadas a elas. Neste
contexto, uma intenção é uma ação genérica que o usuário deseja realizar, e uma
instância de classe [`Intent`][] representa essas intenções do usuário no
Flutter. Uma `Intent` pode ser de propósito geral, cumprida por diferentes ações
em diferentes contextos. Uma [`Action`][] pode ser um callback simples (como no
caso de [`CallbackAction`][]) ou algo mais complexo que se integra a
arquiteturas inteiras de desfazer/refazer (por exemplo) ou outra lógica.

![Diagrama Usando Atalhos][]{:width="100%"}

[`Shortcuts`][] são associações de teclas que ativam pressionando uma tecla ou
combinação de teclas. As combinações de teclas residem em uma tabela com sua
intenção vinculada. Quando o widget `Shortcuts` os invoca, ele envia sua
intenção correspondente para o subsistema de ações para cumprimento.

Para ilustrar os conceitos em ações e atalhos, este artigo cria um aplicativo
simples que permite que um usuário selecione e copie texto em um campo de texto
usando botões e atalhos.

### Por que separar Ações de Intenções?

Você pode se perguntar: por que não mapear uma combinação de teclas diretamente
para uma ação? Por que ter intenções? Isso ocorre porque é útil ter uma
separação de preocupações entre onde as definições de mapeamento de teclas estão
(geralmente em um nível alto) e onde as definições de ação estão (geralmente em
um nível baixo), e porque é importante ser capaz de ter uma única combinação de
teclas mapear para uma operação pretendida em um aplicativo e fazê-lo se adaptar
automaticamente a qualquer ação que cumpra essa operação pretendida para o
contexto focado.

Por exemplo, o Flutter tem um widget `ActivateIntent` que mapeia cada tipo de
controle para sua versão correspondente de um `ActivateAction` (e que executa o
código que ativa o controle). Esse código geralmente precisa de acesso bastante
privado para fazer seu trabalho. Se a camada extra de indireção que as `Intent`s
fornecem não existisse, seria necessário elevar a definição das ações para onde
a instância de definição do widget `Shortcuts` pudesse vê-las, fazendo com que
os atalhos tivessem mais conhecimento do que o necessário sobre qual ação
invocar e ter acesso ou fornecer estado que ele não necessariamente teria ou
precisaria de outra forma. Isso permite que seu código separe as duas
preocupações para serem mais independentes.

As intenções configuram uma ação para que a mesma ação possa servir a vários
usos. Um exemplo disso é `DirectionalFocusIntent`, que leva uma direção para
mover o foco, permitindo que o `DirectionalFocusAction` saiba qual direção mover
o foco. Apenas tome cuidado: não passe o estado na `Intent` que se aplica a
todas as invocações de uma `Action`: esse tipo de estado deve ser passado para o
construtor da própria `Action`, para evitar que a `Intent` precise saber
muito.

### Por que não usar callbacks?

Você também pode se perguntar: por que não usar apenas um callback em vez de um
objeto `Action`? A principal razão é que é útil para as ações decidirem se estão
habilitadas implementando `isEnabled`. Além disso, é frequentemente útil se as
associações de teclas e a implementação dessas associações estiverem em locais
diferentes.

Se tudo o que você precisa são callbacks sem a flexibilidade de `Actions` e
`Shortcuts`, você pode usar o widget [`CallbackShortcuts`][]:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (callback-shortcuts)"?>
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
          const Text('Pressione a seta para cima para adicionar ao contador'),
          const Text('Pressione a seta para baixo para subtrair do contador'),
          Text('contagem: $count'),
        ],
      ),
    ),
  );
}
```

## Atalhos

Como você verá abaixo, as ações são úteis por si só, mas o caso de uso mais
comum envolve vinculá-las a um atalho de teclado. É para isso que serve o widget
`Shortcuts`.

Ele é inserido na hierarquia de widgets para definir combinações de teclas que
representam a intenção do usuário quando essa combinação de teclas é
pressionada. Para converter esse propósito pretendido para a combinação de
teclas em uma ação concreta, o widget `Actions` usado para mapear a `Intent`
para uma `Action`. Por exemplo, você pode definir uma `SelectAllIntent` e
vinculá-la à sua própria `SelectAllAction` ou à sua `CanvasSelectAllAction` e,
a partir dessa ligação de tecla, o sistema invoca uma ou outra, dependendo de
qual parte do seu aplicativo está em foco. Vamos ver como funciona a parte de
vinculação de teclas:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (shortcuts)"?>
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
          child: const Text('SELECIONAR TUDO'),
        ),
      ),
    ),
  );
}
```

O mapa dado a um widget `Shortcuts` mapeia um `LogicalKeySet` (ou um
`ShortcutActivator`, veja a nota abaixo) para uma instância `Intent`. O conjunto
de chaves lógicas define um conjunto de uma ou mais chaves e a intenção indica
o propósito pretendido da pressão da tecla. O widget `Shortcuts` procura
pressionamentos de teclas no mapa, para encontrar uma instância `Intent`, que
ele fornece ao método `invoke()` da ação.

:::note
`ShortcutActivator` é um substituto para `LogicalKeySet`. Ele permite uma
ativação mais flexível e correta de atalhos. `LogicalKeySet` é um
`ShortcutActivator`, é claro, mas também há `SingleActivator`, que recebe uma
única tecla e os modificadores opcionais a serem pressionados antes da tecla.
Em seguida, há `CharacterActivator`, que ativa um atalho com base no caractere
produzido por uma sequência de teclas, em vez das próprias teclas lógicas.
`ShortcutActivator` também deve ser subclassificado para permitir maneiras
personalizadas de ativar atalhos a partir de eventos de tecla.
:::

### O ShortcutManager

O gerenciador de atalhos, um objeto de vida mais longa do que o widget
`Shortcuts`, passa eventos de tecla quando os recebe. Ele contém a lógica para
decidir como lidar com as teclas, a lógica para subir na árvore para encontrar
outros mapeamentos de atalho e mantém um mapa de combinações de teclas para
intenções.

Embora o comportamento padrão do `ShortcutManager` seja geralmente desejável, o
widget `Shortcuts` recebe um `ShortcutManager` que você pode subclassificar
para personalizar sua funcionalidade.

Por exemplo, se você quisesse registrar cada tecla que um widget `Shortcuts`
manipulasse, você poderia criar um `LoggingShortcutManager`:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-shortcut-manager)"?>
```dart
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Atalho tratado $event em $context');
    }
    return result;
  }
}
```

Agora, toda vez que o widget `Shortcuts` manipula um atalho, ele imprime o
evento de tecla e o contexto relevante.

## Ações

`Actions` permite a definição de operações que o aplicativo pode realizar
invocando-as com uma `Intent`. As ações podem ser habilitadas ou desabilitadas e
recebem a instância da intenção que as invocou como um argumento para permitir a
configuração pela intenção.

### Definindo ações

As ações, em sua forma mais simples, são apenas subclasses de `Action<Intent>`
com um método `invoke()`. Aqui está uma ação simples que simplesmente invoca uma
função no modelo fornecido:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (select-all-action)"?>
```dart
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.model);

  final Model model;

  @override
  void invoke(covariant SelectAllIntent intent) => model.selectAll();
}
```

Ou, se for muito incômodo criar uma nova classe, use um `CallbackAction`:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (callback-action)"?>
```dart
CallbackAction(onInvoke: (intent) => model.selectAll());
```

Depois de ter uma ação, adicione-a ao seu aplicativo usando o widget
[`Actions`][], que recebe um mapa de tipos `Intent` para `Action`s:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (select-all-usage)"?>
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
encontrar qual ação invocar. Se o widget `Shortcuts` não encontrar um tipo de
intenção correspondente no primeiro widget `Actions` encontrado, ele considera
o próximo widget `Actions` ancestral e assim por diante, até atingir a raiz da
árvore de widgets, ou encontrar um tipo de intenção correspondente e invocar a
ação correspondente.

### Invocando ações

O sistema de ações tem várias maneiras de invocar ações. De longe, a maneira
mais comum é através do uso de um widget `Shortcuts` abordado na seção
anterior, mas existem outras maneiras de interrogar o subsistema de ações e
invocar uma ação. É possível invocar ações que não estão vinculadas a teclas.

Por exemplo, para encontrar uma ação associada a uma intenção, você pode usar:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (maybe-find)"?>
```dart
Action<SelectAllIntent>? selectAll =
    Actions.maybeFind<SelectAllIntent>(context);
```

Isso retorna uma `Action` associada ao tipo `SelectAllIntent` se houver uma
disponível no `context` fornecido. Se não houver uma disponível, ele retornará
nulo. Se uma `Action` associada sempre deve estar disponível, use `find` em vez
de `maybeFind`, que lança uma exceção quando não encontra um tipo `Intent`
correspondente.

Para invocar a ação (se ela existir), chame:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (invoke-action)"?>
```dart
Object? result;
if (selectAll != null) {
  result =
      Actions.of(context).invokeAction(selectAll, const SelectAllIntent());
}
```

Combine isso em uma chamada com o seguinte:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (maybe-invoke)"?>
```dart
Object? result =
    Actions.maybeInvoke<SelectAllIntent>(context, const SelectAllIntent());
```

Às vezes, você quer invocar uma ação como resultado de pressionar um botão ou
outro controle. Você pode fazer isso com a função `Actions.handler`. Se a
intenção tiver um mapeamento para uma ação habilitada, a função
`Actions.handler` cria um encerramento do manipulador. No entanto, se não tiver
um mapeamento, ele retorna `null`. Isso permite que o botão seja desativado se
não houver uma ação habilitada que corresponda no contexto.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (handler)"?>
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
        child: const Text('SELECIONAR TUDO'),
      ),
    ),
  );
}
```

O widget `Actions` só invoca ações quando `isEnabled(Intent intent)` retorna
verdadeiro, permitindo que a ação decida se o despachante deve considerá-la para
invocação. Se a ação não estiver habilitada, o widget `Actions` oferece a outra
ação habilitada mais alta na hierarquia de widgets (se existir) uma chance de
executar.

O exemplo anterior usa um `Builder` porque `Actions.handler` e `Actions.invoke`
(por exemplo) só encontram ações no `context` fornecido e, se o exemplo passar
o `context` dado à função `build`, o framework começa a procurar _acima_ do
widget atual. Usar um `Builder` permite que o framework encontre as ações
definidas na mesma função `build`.

Você pode invocar uma ação sem precisar de um `BuildContext`, mas como o
widget `Actions` requer um contexto para encontrar uma ação habilitada para
invocar, você precisa fornecer um, criando sua própria instância `Action` ou
encontrando uma em um contexto apropriado com `Actions.find`.

Para invocar a ação, passe a ação para o método `invoke` em um
`ActionDispatcher`, seja um que você criou ou um recuperado de um widget
`Actions` existente usando o método `Actions.of(context)`. Verifique se a ação
está habilitada antes de chamar `invoke`. Claro, você também pode simplesmente
chamar `invoke` na própria ação, passando uma `Intent`, mas então você opta por
não usar nenhum serviço que um despachante de ação possa fornecer (como registro,
desfazer/refazer e assim por diante).

### Despachantes de ação

Na maioria das vezes, você só quer invocar uma ação, fazê-la funcionar e
esquecê-la. Às vezes, porém, você pode querer registrar as ações executadas.

É aqui que entra em jogo a substituição do `ActionDispatcher` padrão por um
despachante personalizado. Você passa seu `ActionDispatcher` para o widget
`Actions` e ele invoca ações de quaisquer widgets `Actions` abaixo daquele que
não define um despachante por conta própria.

A primeira coisa que `Actions` faz ao invocar uma ação é procurar o
`ActionDispatcher` e passar a ação para ele para invocação. Se não houver
nenhum, ele cria um `ActionDispatcher` padrão que simplesmente invoca a ação.

Se você quiser um registro de todas as ações invocadas, no entanto, você pode
criar seu próprio `LoggingActionDispatcher` para fazer o trabalho:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher)"?>
```dart
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Ação invocada: $action($intent) de $context');
    super.invokeAction(action, intent, context);

    return null;
  }

  @override
  (bool, Object?) invokeActionIfEnabled(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Ação invocada: $action($intent) de $context');
    return super.invokeActionIfEnabled(action, intent, context);
  }
}
```

Em seguida, você passa isso para seu widget `Actions` de nível superior:

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher-usage)"?>
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
        child: const Text('SELECIONAR TUDO'),
      ),
    ),
  );
}
```

Isso registra cada ação conforme ela é executada, assim:

```console
flutter: Ação invocada: SelectAllAction#906fc(SelectAllIntent#a98e3) de Builder(dependencies: _[ActionsMarker])
```

## Juntando tudo

A combinação de `Actions` e `Shortcuts` é poderosa: você pode definir intenções
genéricas que mapeiam para ações específicas no nível do widget. Aqui está um
aplicativo simples que ilustra os conceitos descritos acima. O aplicativo cria
um campo de texto que também tem botões "selecionar tudo" e "copiar para a
área de transferência" ao lado dele. Os botões invocam ações para realizar seu
trabalho. Todas as ações e atalhos invocados são registrados.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/copyable_text.dart"?>
```dartpad title="Exemplo prático de texto copiável no DartPad" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Um campo de texto que também tem botões para selecionar todo o texto e
/// copiar o texto selecionado para a área de transferência.
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

/// Um ShortcutManager que registra todas as teclas que ele manipula.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Atalho tratado $event em $context');
    }
    return result;
  }
}

/// Um ActionDispatcher que registra todas as ações que ele invoca.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Ação invocada: $action($intent) de $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

/// Uma intenção que está vinculada ao ClearAction para limpar seu
/// TextEditingController.
class ClearIntent extends Intent {
  const ClearIntent();
}

/// Uma ação que está vinculada ao ClearIntent que limpa seu
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

/// Uma intenção que está vinculada ao CopyAction para copiar de seu
/// TextEditingController.
class CopyIntent extends Intent {
  const CopyIntent();
}

/// Uma ação que está vinculada ao CopyIntent que copia o texto em seu
/// TextEditingController para a área de transferência.
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

/// Uma intenção que está vinculada ao SelectAllAction para selecionar todo o
/// texto em seu controller.
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

/// Uma ação que está vinculada ao SelectAllAction que seleciona todo o texto em
/// seu TextEditingController.
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

/// A classe de aplicativo de nível superior.
///
/// Os atalhos definidos aqui estão em vigor para todo o aplicativo,
/// embora widgets diferentes possam cumpri-los de forma diferente.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Demonstração de Atalhos e Ações';

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
[Diagrama Usando Atalhos]: /assets/images/docs/using_shortcuts.png
