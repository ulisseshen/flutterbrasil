---
title: Escreva seu primeiro app Flutter na web
description: Como criar um app Flutter para web.
short-title: Escreva seu primeiro app web
ia-translate: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="get-started/codelab_web"?>

:::tip
Este codelab orienta você na escrita do
seu primeiro app Flutter na web, especificamente.
Você pode preferir experimentar
[outro codelab][first_flutter_codelab]
que adota uma abordagem mais genérica.
Note que o codelab nesta página
funciona em mobile e desktop
uma vez que você baixe e configure as ferramentas apropriadas.
:::

<img src="/assets/images/docs/get-started/sign-up.gif" alt="The web app that you'll be building." class='site-image-right'>

Este é um guia para criar seu primeiro app Flutter para **web**.
Se você está familiarizado com programação orientada a objetos,
e conceitos como variáveis, loops e condicionais,
você pode completar este tutorial.
Você não precisa de experiência prévia com Dart,
programação mobile ou web.

## O que você vai construir {:.no_toc}

Você vai implementar um app web simples que exibe uma tela de login.
A tela contém três campos de texto: primeiro nome,
sobrenome e nome de usuário. À medida que o usuário preenche os campos,
uma barra de progresso anima ao longo do topo da área de login.
Quando todos os três campos são preenchidos, a barra de progresso exibe
em verde ao longo de toda a largura da área de login,
e o botão **Sign up** se torna habilitado.
Clicar no botão **Sign up** faz com que uma tela de boas-vindas
apareça com animação a partir da parte inferior da tela.

O GIF animado mostra como o app funciona ao final deste lab.

:::secondary O que você vai aprender
* Como escrever um app Flutter que pareça natural na web.
* Estrutura básica de um app Flutter.
* Como implementar uma animação Tween.
* Como implementar um widget stateful.
* Como usar o debugger para definir breakpoints.
:::

:::secondary O que você vai usar
Você precisa de três peças de software para completar este lab:

* [Flutter SDK][]
* [Chrome browser][]
* [Editor de texto ou IDE][editor]

Durante o desenvolvimento, execute seu app web no Chrome,
para que você possa debugar com Dart DevTools
(também chamado Flutter DevTools).
:::

## Passo 0: Obtenha o app web inicial

Você vai começar com um app web simples que fornecemos para você.

<ol>
<li>Habilite o desenvolvimento web.<br>
Na linha de comando, execute o seguinte comando para
ter certeza de que você instalou o Flutter corretamente.

```console
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, {{site.appnow.flutter}}, on macOS darwin-arm64, locale en)
[✓] Android toolchain - develop for Android devices (Android SDK version {{site.appnow.android_sdk}})
[✓] Xcode - develop for iOS and macOS (Xcode {{site.appnow.xcode}})
[✓] Chrome - develop for the web
[✓] Android Studio (version {{site.appnow.android_studio}})
[✓] VS Code (version {{site.appnow.vscode}})
[✓] Connected device (4 available)
[✓] HTTP Host Availability

• No issues found!
```

Se você vir "flutter: command not found",
então certifique-se de que você instalou o
[Flutter SDK][] e que ele está no seu path.

Não tem problema se o Android toolchain, Android Studio
e as ferramentas Xcode não estiverem instalados,
já que o app é destinado apenas para web.
Se você quiser mais tarde que este app funcione em mobile,
você precisará fazer instalação e configuração adicionais.
</li>

<li>

Liste os dispositivos.<br>
Para garantir que web _esteja_ instalado,
liste os dispositivos disponíveis.
Você deverá ver algo como o seguinte:

```console
$ flutter devices
4 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554                        •
android-arm64  • Android 13 (API 33) (emulator)
iPhone 14 Pro Max (mobile)  • 45A72BE1-2D4E-4202-9BB3-D6AE2601BEF8 • ios
• com.apple.CoreSimulator.SimRuntime.iOS-16-0 (simulator)
macOS (desktop)             • macos                                •
darwin-arm64   • macOS 12.6 21G115 darwin-arm64
Chrome (web)                • chrome                               •
web-javascript • Google Chrome 105.0.5195.125
```

O dispositivo **Chrome** inicia automaticamente o Chrome e habilita o uso
das ferramentas Flutter DevTools.

</li>

<li>

O app inicial é exibido no seguinte DartPad.

<?code-excerpt "lib/starter.dart" remove="prefer_final_fields"?>
```dartpad title="Flutter beginning getting started hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
```

:::important
Esta página usa uma versão embarcada do [DartPad][]
para exibir exemplos e exercícios.
Se você vir caixas vazias ao invés de DartPads,
vá para a [página de troubleshooting do DartPad][DartPad troubleshooting page].
:::

</li>

<li>

Execute o exemplo.<br>
Clique no botão **Run** para executar o exemplo.
Note que você pode digitar nos campos de texto,
mas o botão **Sign up** está desabilitado.

</li>

<li>

Copie o código.<br>
Clique no ícone da área de transferência no canto superior direito do
painel de código para copiar o código Dart para sua área de transferência.

</li>

<li>

Crie um novo projeto Flutter.<br>
Do seu IDE, editor ou na linha de comando,
[crie um novo projeto Flutter][create a new Flutter project] e nomeie-o como `signin_example`.

</li>

<li>

Substitua o conteúdo de `lib/main.dart`
pelo conteúdo da área de transferência.

</li>
</ol>

### Observações {:.no_toc}

* Todo o código deste exemplo está no
  arquivo `lib/main.dart`.
* Se você conhece Java, a linguagem Dart deve parecer muito familiar.
* Toda a UI do app é criada em código Dart.
  Para mais informações, veja [Introduction to declarative UI][].
* A UI do app adere ao [Material Design][],
  uma linguagem de design visual que roda em qualquer dispositivo ou plataforma.
  Você pode customizar os widgets Material Design,
  mas se você preferir algo diferente,
  Flutter também oferece a biblioteca de widgets Cupertino,
  que implementa a linguagem de design atual do iOS.
  Ou você pode criar sua própria biblioteca de widgets customizada.
* No Flutter, quase tudo é um [Widget][].
  Até o app em si é um widget.
  A UI do app pode ser descrita como uma árvore de widgets.

## Passo 1: Mostre a tela Welcome

A classe `SignUpForm` é um widget stateful.
Isso simplesmente significa que o widget armazena informações
que podem mudar, como entrada do usuário ou dados de um feed.
Como os widgets em si são imutáveis
(não podem ser modificados uma vez criados),
Flutter armazena informações de estado em uma classe companheira,
chamada classe `State`. Neste lab,
todas as suas edições serão feitas na classe privada
`_SignUpFormState`.

:::tip Fato interessante
O compilador Dart impõe privacidade para qualquer identificador
prefixado com um underscore. Para mais informações,
veja o [Effective Dart Style Guide][].
:::

Primeiro, no seu arquivo `lib/main.dart`,
adicione a seguinte definição de classe para o
widget `WelcomeScreen` após a classe `SignUpScreen`:

<?code-excerpt "lib/step1.dart (welcome-screen)"?>
```dart
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
```

Em seguida, você vai habilitar o botão para exibir a tela
e criar um método para exibi-la.

<ol>

<li>

Localize o método `build()` para a
classe `_SignUpFormState`. Esta é a parte do código
que constrói o botão SignUp.
Note como o botão é definido:
É um `TextButton` com um fundo azul,
texto branco que diz **Sign up** e, quando pressionado,
não faz nada.

</li>

<li>

Atualize a propriedade `onPressed`.<br>
Altere a propriedade `onPressed` para chamar o método (não existente)
que exibirá a tela de boas-vindas.

Mude `onPressed: null` para o seguinte:

<?code-excerpt "lib/step1.dart (on-pressed)"?>
```dart
onPressed: _showWelcomeScreen,
```

</li>

<li>

Adicione o método `_showWelcomeScreen`.<br>
Corrija o erro reportado pelo analyzer de que `_showWelcomeScreen`
não está definido. Diretamente acima do método `build()`,
adicione a seguinte função:

<?code-excerpt "lib/step1.dart (show-welcome-screen)"?>
```dart
void _showWelcomeScreen() {
  Navigator.of(context).pushNamed('/welcome');
}
```

</li>

<li>

Adicione a rota `/welcome`.<br>
Crie a conexão para mostrar a nova tela.
No método `build()` para `SignUpApp`,
adicione a seguinte rota abaixo de `'/'`:

<?code-excerpt "lib/step1.dart (welcome-route)"?>
```dart
'/welcome': (context) => const WelcomeScreen(),
```

</li>

<li>

Execute o app.<br>
O botão **Sign up** agora deve estar habilitado.
Clique nele para exibir a tela de boas-vindas.
Note como ela anima a partir da parte inferior.
Você obtém esse comportamento de graça.

</li>

</ol>

### Observações {:.no_toc}

* A função `_showWelcomeScreen()` é usada no método `build()`
  como uma função de callback. Funções de callback são frequentemente
  usadas em código Dart e, neste caso, isso significa
  "chame este método quando o botão for pressionado".
* A palavra-chave `const` na frente do constructor é muito
  importante. Quando Flutter encontra um widget constante, ele
  atalha a maior parte do trabalho de reconstrução por baixo dos panos
  tornando a renderização mais eficiente.
* Flutter tem apenas um objeto `Navigator`.
  Este widget gerencia as telas do Flutter
  (também chamadas de _rotas_ ou _páginas_) dentro de uma pilha.
  A tela no topo da pilha é a view que
  está atualmente sendo exibida. Empurrar uma nova tela para esta
  pilha muda a exibição para aquela nova tela.
  É por isso que a função `_showWelcomeScreen` empurra
  a `WelcomeScreen` para a pilha do Navigator.
  O usuário clica no botão e, voilà,
  a tela de boas-vindas aparece. Da mesma forma,
  chamar `pop()` no `Navigator` retorna para a
  tela anterior. Como a navegação do Flutter está
  integrada na navegação do navegador,
  isso acontece implicitamente ao clicar no botão
  de seta voltar do navegador.

## Passo 2: Habilite o rastreamento de progresso do login

Esta tela de login tem três campos.
Em seguida, você vai habilitar a capacidade de rastrear o
progresso do usuário no preenchimento dos campos do formulário,
e atualizar a UI do app quando o formulário estiver completo.

:::note
Este exemplo **não** valida a precisão da entrada do usuário.
Isso é algo que você pode adicionar mais tarde usando validação de formulário, se quiser.
:::

<ol>
<li>

Adicione um método para atualizar `_formProgress`.
Na classe `_SignUpFormState`, adicione um novo método chamado
`_updateFormProgress()`:

<?code-excerpt "lib/step2.dart (update-form-progress)"?>
```dart
void _updateFormProgress() {
  var progress = 0.0;
  final controllers = [
    _firstNameTextController,
    _lastNameTextController,
    _usernameTextController
  ];

  for (final controller in controllers) {
    if (controller.value.text.isNotEmpty) {
      progress += 1 / controllers.length;
    }
  }

  setState(() {
    _formProgress = progress;
  });
}
```

Este método atualiza o campo `_formProgress` baseado no
número de campos de texto não vazios.

</li>

<li>

Chame `_updateFormProgress` quando o formulário mudar.<br>
No método `build()` da classe `_SignUpFormState`,
adicione um callback ao argumento `onChanged` do widget `Form`.
Adicione o código abaixo marcado como NEW:

<?code-excerpt "lib/step2.dart (on-changed)"?>
```dart
return Form(
  onChanged: _updateFormProgress, // NEW
  child: Column(
```

</li>

<li>

Atualize a propriedade `onPressed` (novamente).<br>
No `passo 1`, você modificou a propriedade `onPressed` para o
botão **Sign up** para exibir a tela de boas-vindas.
Agora, atualize aquele botão para exibir a tela de boas-vindas
apenas quando o formulário estiver completamente preenchido:

<?code-excerpt "lib/step2.dart (on-pressed)"?>
```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.disabled)
          ? null
          : Colors.white;
    }),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.disabled)
          ? null
          : Colors.blue;
    }),
  ),
  onPressed:
      _formProgress == 1 ? _showWelcomeScreen : null, // UPDATED
  child: const Text('Sign up'),
),
```

</li>

<li>

Execute o app.<br>
O botão **Sign up** está inicialmente desabilitado,
mas se torna habilitado quando todos os três campos de texto contêm
(qualquer) texto.

</li>
</ol>

### Observações {:.no_toc}

* Chamar o método `setState()` de um widget diz ao Flutter que o
  widget precisa ser atualizado na tela.
  O framework então descarta o widget imutável anterior
  (e seus filhos), cria um novo
  (com sua árvore de widgets filhos acompanhante),
  e renderiza na tela. Para que isso funcione perfeitamente,
  Flutter precisa ser rápido.
  A nova árvore de widgets deve ser criada e renderizada na tela
  em menos de 1/60 de segundo para criar uma transição visual suave—especialmente para uma animação.
  Felizmente, Flutter _é_ rápido.
* O campo `progress` é definido como um valor de ponto flutuante,
  e é atualizado no método `_updateFormProgress`.
  Quando todos os três campos são preenchidos, `_formProgress` é definido como 1.0.
  Quando `_formProgress` é definido como 1.0, o callback `onPressed` é definido para o
  método `_showWelcomeScreen`. Agora que seu argumento `onPressed` não é null, o botão está habilitado.
  Como a maioria dos botões Material Design no Flutter,
  [TextButton][]s são desabilitados por padrão se seus callbacks `onPressed` e `onLongPress` forem null.
* Note que `_updateFormProgress` passa uma função para `setState()`.
  Isso é chamado de função anônima
  e tem a seguinte sintaxe:

  ```dart
  methodName(() {...});
  ```

  Onde `methodName` é uma função nomeada que recebe uma função
  de callback anônima como argumento.
* A sintaxe Dart no último passo que exibe a
  tela de boas-vindas é:
  <?code-excerpt "lib/step2.dart (ternary)" replace="/, \/\/ UPDATED//g"?>
  ```dart
  _formProgress == 1 ? _showWelcomeScreen : null
  ```
  Esta é uma atribuição condicional Dart e tem a sintaxe:
  `condition ? expression1 : expression2`.
  Se a expressão `_formProgress == 1` for verdadeira, a expressão inteira resulta
  no valor do lado esquerdo do `:`, que é o
  método `_showWelcomeScreen` neste caso.

## Passo 2.5: Inicie o Dart DevTools

Como você debuga um app Flutter web?
Não é muito diferente de debugar qualquer app Flutter.
Você quer usar [Dart DevTools][]!
(Não confundir com Chrome DevTools.)

Nosso app atualmente não tem bugs, mas vamos dar uma olhada mesmo assim.
As seguintes instruções para iniciar DevTools se aplicam a qualquer fluxo de trabalho,
mas há um atalho se você estiver usando IntelliJ.
Veja a dica no final desta seção para mais informações.

<ol>
<li>

Execute o app.<br>
Se seu app não está rodando atualmente, inicie-o.
Selecione o dispositivo **Chrome** do menu suspenso
e inicie-o do seu IDE ou,
da linha de comando, use `flutter run -d chrome`.

</li>

<li>

Obtenha as informações de web socket para DevTools.<br>
Na linha de comando, ou no IDE,
você deverá ver uma mensagem dizendo algo como o seguinte:

```console
Launching lib/main.dart on Chrome in debug mode...
Building application for the web...                                11.7s
Attempting to connect to browser instance..
Debug service listening on <b>ws://127.0.0.1:54998/pJqWWxNv92s=</b>
```

Copie o endereço do serviço de debug, mostrado em negrito.
Você precisará dele para iniciar DevTools.

</li>

<li>

Certifique-se de que os plugins Dart e Flutter estejam instalados.<br>
Se você está usando um IDE,
certifique-se de ter os plugins Flutter e Dart configurados,
conforme descrito nas páginas [VS Code][] e
[Android Studio and IntelliJ][].
Se você está trabalhando na linha de comando,
inicie o servidor DevTools conforme explicado na
página [DevTools command line][].

</li>

<li>

Conecte ao DevTools.<br>
Quando DevTools iniciar, você deverá ver algo
como o seguinte:

```console
Serving DevTools at http://127.0.0.1:9100
```

Vá para esta URL em um navegador Chrome. Você deverá ver a tela
de lançamento do DevTools. Ela deve se parecer com o seguinte:

![Screenshot of the DevTools launch screen](/assets/images/docs/get-started/devtools-launch-screen.png){:width="100%"}

</li>

<li>

Conecte ao app em execução.<br>
Em **Connect to a running site**,
cole a localização do web socket (ws) que você copiou no passo 2,
e clique em **Connect**. Agora você deverá ver o Dart DevTools
rodando com sucesso no seu navegador Chrome:

![Screenshot of DevTools running screen](/assets/images/docs/get-started/devtools-running.png){:width="100%"}

Parabéns, você agora está executando Dart DevTools!

</li>
</ol>

:::note
Esta não é a única forma de iniciar DevTools.
Se você está usando IntelliJ,
você pode abrir DevTools indo para
**Flutter Inspector** -> **More Actions** -> **Open DevTools**:

![Screenshot of Flutter inspector with DevTools menu](/assets/images/docs/get-started/intellij-devtools.png){:width="100%"}
:::

<ol>
<li>

Defina um breakpoint.<br>
Agora que você tem DevTools rodando,
selecione a aba **Debugger** na barra azul ao longo do topo.
O painel do debugger aparece e, no canto inferior esquerdo,
veja uma lista de bibliotecas usadas no exemplo.
Selecione `lib/main.dart` para exibir seu código Dart
no painel central.

![Screenshot of the DevTools debugger](/assets/images/docs/get-started/devtools-debugging.png){:width="100%"}

</li>

<li>

Defina um breakpoint.<br>
No código Dart,
role para baixo até onde `progress` é atualizado:

<?code-excerpt "lib/step2.dart (for-loop)"?>
```dart
for (final controller in controllers) {
  if (controller.value.text.isNotEmpty) {
    progress += 1 / controllers.length;
  }
}
```

Coloque um breakpoint na linha com o loop for clicando à
esquerda do número da linha. O breakpoint agora aparece
na seção **Breakpoints** à esquerda da janela.

</li>

<li>

Dispare o breakpoint.<br>
No app em execução, clique em um dos campos de texto para obter foco.
O app atinge o breakpoint e pausa.
Na tela do DevTools, você pode ver à esquerda
o valor de `progress`, que é 0. Isso é esperado,
já que nenhum dos campos está preenchido.
Avance pelo loop for para ver
a execução do programa.

</li>

<li>

Retome o app.<br>
Retome o app clicando no botão verde **Resume**
na janela do DevTools.

</li>

<li>

Delete o breakpoint.<br>
Delete o breakpoint clicando nele novamente, e retome o app.

</li>
</ol>

Isso lhe dá um pequeno vislumbre do que é possível usando DevTools,
mas há muito mais! Para mais informações,
veja a [documentação do DevTools][DevTools documentation].

## Passo 3: Adicione animação para o progresso do login

É hora de adicionar animação! Neste passo final,
você vai criar a animação para o
`LinearProgressIndicator` no topo da área de login.
A animação tem o seguinte comportamento:

* Quando o app inicia,
  uma pequena barra vermelha aparece no topo da área de login.
* Quando um campo de texto contém texto,
  a barra vermelha fica laranja e anima 0.15
  do caminho ao longo da área de login.
* Quando dois campos de texto contêm texto,
  a barra laranja fica amarela e anima metade
  do caminho ao longo da área de login.
* Quando todos os três campos de texto contêm texto,
  a barra laranja fica verde e anima todo o
  caminho ao longo da área de login.
  Além disso, o botão **Sign up** se torna habilitado.

<ol>
<li>

Adicione um `AnimatedProgressIndicator`.<br>
No final do arquivo, adicione este widget:

<?code-excerpt "lib/step3.dart (animated-progress-indicator)"?>
```dart
class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withValues(alpha: 0.4),
      ),
    );
  }
}
```

A função [`didUpdateWidget`][] atualiza o
`AnimatedProgressIndicatorState` sempre que
`AnimatedProgressIndicator` muda.

</li>

<li>

Use o novo `AnimatedProgressIndicator`.<br>
Então, substitua o `LinearProgressIndicator` no `Form`
por este novo `AnimatedProgressIndicator`:

<?code-excerpt "lib/step3.dart (use-animated-progress-indicator)"?>
```dart
child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    AnimatedProgressIndicator(value: _formProgress), // NEW
    Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
    Padding(
```

Este widget usa um `AnimatedBuilder` para animar o
indicador de progresso para o valor mais recente.

</li>

<li>

Execute o app.<br>
Digite qualquer coisa nos três campos para verificar que
a animação funciona, e que clicar no
botão **Sign up** abre a tela **Welcome**.

</li>
</ol>

### Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter complete getting started hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withValues(alpha: 0.4),
      ),
    );
  }
}
```

### Observações {:.no_toc}

* Você pode usar um `AnimationController` para executar qualquer animação.
* `AnimatedBuilder` reconstrói a árvore de widgets quando o valor
  de uma `Animation` muda.
* Usando um `Tween`, você pode interpolar entre quase qualquer valor,
  neste caso, `Color`.

## O que vem a seguir?

Parabéns!
Você criou seu primeiro app web usando Flutter!

Se você quiser continuar brincando com este exemplo,
talvez você possa adicionar validação de formulário.
Para conselhos sobre como fazer isso,
veja a receita [Building a form with validation][]
no [Flutter cookbook][].

Para mais informações sobre apps Flutter web,
Dart DevTools ou animações Flutter, veja o seguinte:

* [Documentação de animações][Animation docs]
* [Dart DevTools][]
* Codelab de [animações implícitas][Implicit animations]
* [Exemplos web][Web samples]

[Android Studio and IntelliJ]: /tools/devtools/android-studio
[Animation docs]: /ui/animations
[Building a form with validation]: /cookbook/forms/validation
[Chrome browser]: https://www.google.com/chrome/?brand=CHBD&gclid=CjwKCAiAws7uBRAkEiwAMlbZjlVMZCxJDGAHjoSpoI_3z_HczSbgbMka5c9Z521R89cDoBM3zAluJRoCdCEQAvD_BwE&gclsrc=aw.ds
[create a new Flutter project]: /get-started/test-drive
[Dart DevTools]: /tools/devtools
[DartPad]: {{site.dartpad}}
[DevTools command line]: /tools/devtools/cli
[DevTools documentation]: /tools/devtools
[DevTools installed]: /tools/devtools#start
[DartPad troubleshooting page]: {{site.dart-site}}/tools/dartpad/troubleshoot
[`didUpdateWidget`]: {{site.api}}/flutter/widgets/State/didUpdateWidget.html
[editor]: /get-started/editor
[Effective Dart Style Guide]: {{site.dart-site}}/guides/language/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private
[Flutter cookbook]: /cookbook
[Flutter SDK]: /get-started/install
[Implicit animations]: /codelabs/implicit-animations
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[Material Design]: {{site.material}}/get-started
[TextButton]: {{site.api}}/flutter/material/TextButton-class.html
[VS Code]: /tools/devtools/vscode
[Web samples]: {{site.repo.samples}}/tree/main/web
[Widget]: {{site.api}}/flutter/widgets/Widget-class.html
[first_flutter_codelab]: /get-started/codelab
