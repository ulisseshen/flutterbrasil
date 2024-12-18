---
ia-translate: true
title: Foco e campos de texto
description: Como o foco funciona com campos de texto.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/focus/"?>

Quando um campo de texto é selecionado e aceitando entrada,
diz-se que ele tem "foco".
Geralmente, os usuários transferem o foco para um campo de texto tocando,
e os desenvolvedores transferem o foco para um campo de texto programaticamente
usando as ferramentas descritas nesta receita.

Gerenciar o foco é uma ferramenta fundamental para criar formulários com um fluxo
intuitivo. Por exemplo, digamos que você tenha uma tela de pesquisa com um campo de texto.
Quando o usuário navega até a tela de pesquisa,
você pode definir o foco para o campo de texto do termo de pesquisa.
Isso permite que o usuário comece a digitar assim que a tela
estiver visível, sem a necessidade de tocar manualmente no campo de texto.

Nesta receita, aprenda como dar o foco
para um campo de texto assim que ele estiver visível,
bem como como dar foco a um campo de texto
quando um botão é tocado.

## Focar um campo de texto assim que ele estiver visível

Para dar foco a um campo de texto assim que ele estiver visível,
use a propriedade `autofocus`.

```dart
TextField(
  autofocus: true,
);
```

Para obter mais informações sobre como lidar com entradas e criar campos de texto,
consulte a seção [Formulários][] do cookbook.

## Focar um campo de texto quando um botão é tocado

Em vez de transferir o foco imediatamente para um campo de texto específico,
você pode precisar dar foco a um campo de texto em um momento posterior.
No mundo real, você também pode precisar dar foco a um campo de texto específico
em resposta a uma chamada de API ou um erro de validação.
Neste exemplo, dê foco a um campo de texto depois que o usuário
pressionar um botão, usando as seguintes etapas:

  1. Crie um `FocusNode`.
  2. Passe o `FocusNode` para um `TextField`.
  3. Dê foco ao `TextField` quando um botão é tocado.

### 1. Crie um `FocusNode`

Primeiro, crie um [`FocusNode`][].
Use o `FocusNode` para identificar um `TextField` específico na
"árvore de foco" do Flutter. Isso permite que você dê foco ao `TextField`
nas próximas etapas.

Como os nós de foco são objetos de longa duração, gerencie o ciclo de vida
usando um objeto `State`. Use as seguintes instruções para criar
uma instância de `FocusNode` dentro do método `initState()` de uma
classe `State` e limpe-o no método `dispose()`:

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// Define um widget Form personalizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém dados relacionados ao formulário.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define o nó de foco. Para gerenciar o ciclo de vida, crie o FocusNode no
  // método initState e limpe-o no método dispose.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Limpa o nó de foco quando o Form é descartado.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preencha isso na próxima etapa.
  }
}
```

### 2. Passe o `FocusNode` para um `TextField`

Agora que você tem um `FocusNode`,
passe-o para um `TextField` específico no método `build()`.

<?code-excerpt "lib/step2.dart (Build)"?>
```dart
@override
Widget build(BuildContext context) {
  return TextField(
    focusNode: myFocusNode,
  );
}
```

### 3. Dê foco ao `TextField` quando um botão é tocado

Finalmente, foque o campo de texto quando o usuário tocar em um botão de
ação flutuante. Use o método [`requestFocus()`][] para executar
esta tarefa.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // Quando o botão é pressionado,
  // dê foco ao campo de texto usando myFocusNode.
  onPressed: () => myFocusNode.requestFocus(),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de foco de texto no Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Foco de Campo de Texto',
      home: MyCustomForm(),
    );
  }
}

// Define um widget Form personalizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém dados relacionados ao formulário.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define o nó de foco. Para gerenciar o ciclo de vida, crie o FocusNode no
  // método initState e limpe-o no método dispose.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Limpa o nó de foco quando o Form é descartado.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foco de Campo de Texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // O primeiro campo de texto é focado assim que o aplicativo é iniciado.
            const TextField(
              autofocus: true,
            ),
            // O segundo campo de texto é focado quando um usuário toca no
            // FloatingActionButton.
            TextField(
              focusNode: myFocusNode,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Quando o botão é pressionado,
        // dê foco ao campo de texto usando myFocusNode.
        onPressed: () => myFocusNode.requestFocus(),
        tooltip: 'Focar Segundo Campo de Texto',
        child: const Icon(Icons.edit),
      ), // Esta vírgula à direita torna a formatação automática mais agradável para métodos de construção.
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/focus.gif" alt="Demonstração de Foco de Campo de Texto" class="site-mobile-screenshot" />
</noscript>


[fix has landed]: {{site.repo.flutter}}/pull/50372
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[Formulários]: /cookbook#forms
[flutter/flutter@bf551a3]: {{site.repo.flutter}}/commit/bf551a31fe7ef45c854a219686b6837400bfd94c
[Issue 52221]: {{site.repo.flutter}}/issues/52221
[`requestFocus()`]: {{site.api}}/flutter/widgets/FocusNode/requestFocus.html
[workaround]: {{site.repo.flutter}}/issues/52221#issuecomment-598244655
