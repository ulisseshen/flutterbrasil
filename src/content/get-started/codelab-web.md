---
ia-translate: true
title: Escreva seu primeiro aplicativo Flutter na web
description: Como criar um aplicativo Flutter para a web.
short-title: Escreva seu primeiro aplicativo web
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="get-started/codelab_web"?>

:::tip
Este codelab orienta você na escrita do seu
primeiro aplicativo Flutter na web, especificamente.
Você pode preferir experimentar
[outro codelab][first_flutter_codelab]
que adota uma abordagem mais genérica.
Observe que o codelab nesta página
funciona em dispositivos móveis e desktop
assim que você baixar e configurar as ferramentas apropriadas.
:::

<img src="/assets/images/docs/get-started/sign-up.gif" alt="O aplicativo web que você estará construindo." class='site-image-right'>

Este é um guia para criar seu primeiro aplicativo Flutter **web**.
Se você estiver familiarizado com programação orientada a objetos,
e conceitos como variáveis, loops e condicionais,
você pode concluir este tutorial.
Você não precisa de experiência anterior com Dart,
programação para celular ou web.

## O que você vai construir  {:.no_toc}

Você implementará um aplicativo web simples que exibe uma tela de login.
A tela contém três campos de texto: primeiro nome,
sobrenome e nome de usuário. À medida que o usuário preenche os campos,
uma barra de progresso é animada ao longo da parte superior da área de login.
Quando todos os três campos são preenchidos, a barra de progresso é exibida
em verde em toda a largura da área de login,
e o botão **Sign up** é habilitado.
Clicar no botão **Sign up** faz com que uma tela de boas-vindas
seja animada a partir da parte inferior da tela.

O GIF animado mostra como o aplicativo funciona após a conclusão deste laboratório.

:::secondary O que você vai aprender
* Como escrever um aplicativo Flutter que pareça natural na web.
* Estrutura básica de um aplicativo Flutter.
* Como implementar uma animação Tween.
* Como implementar um widget stateful.
* Como usar o depurador para definir breakpoints.
:::

:::secondary O que você vai usar
Você precisa de três softwares para concluir este laboratório:

* [Flutter SDK][Flutter SDK]
* [Navegador Chrome][Chrome browser]
* [Editor de texto ou IDE][editor]

Durante o desenvolvimento, execute seu aplicativo web no Chrome,
para que você possa depurar com o Dart DevTools
(também chamado de Flutter DevTools).
:::

## Etapa 0: Obtenha o aplicativo web inicial

Você começará com um aplicativo web simples que fornecemos para você.

<ol>
<li>Habilite o desenvolvimento web.<br>
Na linha de comando, execute o seguinte comando para
certificar-se de que o Flutter esteja instalado corretamente.

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
certifique-se de ter instalado o
[Flutter SDK][Flutter SDK] e que ele está no seu path.

Não há problema se o conjunto de ferramentas Android, o Android Studio
e as ferramentas Xcode não estiverem instalados,
já que o aplicativo se destina apenas à web.
Se você quiser que este aplicativo funcione em dispositivos móveis posteriormente,
será necessário fazer instalação e configuração adicionais.
</li>

<li>

Liste os dispositivos.<br>
Para garantir que a web _esteja_ instalada,
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

O dispositivo **Chrome** inicia automaticamente o Chrome e permite o uso
das ferramentas do Flutter DevTools.

</li>

<li>

O aplicativo inicial é exibido no seguinte DartPad.

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
Esta página usa uma versão incorporada do [DartPad][DartPad]
para exibir exemplos e exercícios.
Se você vir caixas vazias em vez de DartPads,
vá para a [página de solução de problemas do DartPad][DartPad troubleshooting page].
:::

</li>

<li>

Execute o exemplo.<br>
Clique no botão **Run** para executar o exemplo.
Observe que você pode digitar nos campos de texto,
mas o botão **Sign up** está desativado.

</li>

<li>

Copie o código.<br>
Clique no ícone da área de transferência no canto superior direito do
painel de código para copiar o código Dart para a sua área de transferência.

</li>

<li>

Crie um novo projeto Flutter.<br>
Em seu IDE, editor ou na linha de comando,
[crie um novo projeto Flutter][criar um novo projeto Flutter] e nomeie-o como `signin_example`.

</li>

<li>

Substitua o conteúdo de `lib/main.dart`
pelo conteúdo da área de transferência.

</li>
</ol>

### Observações  {:.no_toc}

* O código inteiro para este exemplo reside no
  arquivo `lib/main.dart`.
* Se você conhece Java, a linguagem Dart deve parecer muito familiar.
* Toda a IU do aplicativo é criada em código Dart.
  Para obter mais informações, consulte [Introdução à IU declarativa][Introdução à UI declarativa].
* A IU do aplicativo adere ao [Material Design][Material Design],
  uma linguagem de design visual que é executada em qualquer dispositivo ou plataforma.
  Você pode personalizar os widgets do Material Design,
  mas se preferir algo diferente,
  o Flutter também oferece a biblioteca de widgets Cupertino,
  que implementa a linguagem de design iOS atual.
  Ou você pode criar sua própria biblioteca de widgets personalizada.
* No Flutter, quase tudo é um [Widget][Widget].
  Até mesmo o próprio aplicativo é um widget.
  A IU do aplicativo pode ser descrita como uma árvore de widgets.

## Etapa 1: Mostrar a tela de boas-vindas

A classe `SignUpForm` é um widget stateful.
Isso significa simplesmente que o widget armazena informações
que podem mudar, como entrada do usuário ou dados de um feed.
Como os próprios widgets são imutáveis
(não podem ser modificados depois de criados),
o Flutter armazena informações de estado em uma classe complementar,
chamada classe `State`. Neste laboratório,
todas as suas edições serão feitas no privado
classe `_SignUpFormState`.

:::tip Curiosidade
O compilador Dart impõe privacidade para qualquer identificador
prefixado com um sublinhado. Para mais informações,
consulte o [Guia de estilo Dart eficaz][Effective Dart Style Guide].
:::

Primeiro, em seu arquivo `lib/main.dart`,
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

Em seguida, você habilitará o botão para exibir a tela
e criar um método para exibi-la.

<ol>

<li>

Localize o método `build()` para o
classe `_SignUpFormState`. Esta é a parte do código
que cria o botão SignUp.
Observe como o botão é definido:
É um `TextButton` com fundo azul,
texto branco que diz **Sign up** e, quando pressionado,
não faz nada.

</li>

<li>

Atualize a propriedade `onPressed`.<br>
Altere a propriedade `onPressed` para chamar o método (inexistente)
que exibirá a tela de boas-vindas.

Altere `onPressed: null` para o seguinte:

<?code-excerpt "lib/step1.dart (on-pressed)"?>
```dart
onPressed: _showWelcomeScreen,
```

</li>

<li>

Adicione o método `_showWelcomeScreen`.<br>
Corrija o erro relatado pelo analisador de que `_showWelcomeScreen`
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
Crie a conexão para exibir a nova tela.
No método `build()` para `SignUpApp`,
adicione a seguinte rota abaixo de `'/'`:

<?code-excerpt "lib/step1.dart (welcome-route)"?>
```dart
'/welcome': (context) => const WelcomeScreen(),
```

</li>

<li>

Execute o aplicativo.<br>
O botão **Sign up** agora deve estar habilitado.
Clique nele para abrir a tela de boas-vindas.
Observe como ele é animado a partir da parte inferior.
Você obtém esse comportamento gratuitamente.

</li>

</ol>

### Observações  {:.no_toc}

* A função `_showWelcomeScreen()` é usada no `build()`
  método como uma função de callback. As funções de callback são frequentemente
  usadas no código Dart e, neste caso, isso significa
  "chamar este método quando o botão for pressionado".
* A palavra-chave `const` na frente do construtor é muito
  importante. Quando o Flutter encontra um widget constante, ele
  curto-circuita a maior parte do trabalho de reconstrução sob o capô
  tornando a renderização mais eficiente.
* O Flutter tem apenas um objeto `Navigator`.
  Este widget gerencia as telas do Flutter
  (também chamadas de _rotas_ ou _páginas_) dentro de uma pilha.
  A tela na parte superior da pilha é a visualização que
  está sendo exibida no momento. Enviar uma nova tela para esta
  pilha alterna a exibição para essa nova tela.
  É por isso que a função `_showWelcomeScreen` envia
  a `WelcomeScreen` para a pilha do Navigator.
  O usuário clica no botão e, voilà,
  a tela de boas-vindas aparece. Da mesma forma,
  chamar `pop()` no `Navigator` retorna ao
  tela anterior. Como a navegação do Flutter é
  integrada à navegação do navegador,
  isso acontece implicitamente ao clicar no navegador
  botão de seta para trás.

## Etapa 2: Habilitar o rastreamento do progresso do login

Esta tela de login tem três campos.
Em seguida, você habilitará a capacidade de rastrear o
progresso do usuário no preenchimento dos campos do formulário,
e atualize a interface do usuário do aplicativo quando o formulário for concluído.

:::note
Este exemplo **não** valida a precisão da entrada do usuário.
Isso é algo que você pode adicionar posteriormente usando a validação de formulário, se desejar.
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

Este método atualiza o campo `_formProgress` com base em
o número de campos de texto não vazios.

</li>

<li>

Chame `_updateFormProgress` quando o formulário mudar.<br>
No método `build()` da classe `_SignUpFormState`,
adicione um callback ao argumento `onChanged` do widget `Form`.
Adicione o código abaixo marcado como NOVO:

<?code-excerpt "lib/step2.dart (on-changed)"?>
```dart
return Form(
  onChanged: _updateFormProgress, // NEW
  child: Column(
```

</li>

<li>

Atualize a propriedade `onPressed` (novamente).<br>
Na `etapa 1`, você modificou a propriedade `onPressed` para o
botão **Sign up** para exibir a tela de boas-vindas.
Agora, atualize esse botão para exibir as boas-vindas
tela somente quando o formulário estiver completamente preenchido:

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

Execute o aplicativo.<br>
O botão **Sign up** está inicialmente desativado,
mas fica habilitado quando todos os três campos de texto contêm
(qualquer) texto.

</li>
</ol>

### Observações  {:.no_toc}

* Chamar o método `setState()` de um widget informa ao Flutter que o
  widget precisa ser atualizado na tela.
  A estrutura então descarta o widget imutável anterior
  (e seus filhos), cria um novo
  (com sua árvore de widgets filho acompanhante),
  e o renderiza na tela. Para que isso funcione perfeitamente,
  O Flutter precisa ser rápido.
  A nova árvore de widgets deve ser criada e renderizada na tela
  em menos de 1/60 de segundo para criar um visual suave
  transição — especialmente para uma animação.
  Felizmente, o Flutter _é_ rápido.
* O campo `progress` é definido como um valor flutuante,
  e é atualizado no método `_updateFormProgress`.
  Quando todos os três campos são preenchidos, `_formProgress` é definido como 1.0.
  Quando `_formProgress` é definido como 1.0, o callback `onPressed` é definido para o
  método `_showWelcomeScreen`. Agora que seu argumento `onPressed` não é nulo, o botão está habilitado.
  Como a maioria dos botões do Material Design no Flutter,
  [TextButton][TextButton]s são desativados por padrão se seus callbacks `onPressed` e `onLongPress` forem nulos.
* Observe que o `_updateFormProgress` passa uma função para `setState()`.
  Isso é chamado de anônimo
  função e tem a seguinte sintaxe:

  ```dart
  methodName(() {...});
  ```
  
  Onde `methodName` é uma função nomeada que recebe um anônimo
  função de callback como um argumento.
* A sintaxe Dart na última etapa que exibe o
  tela de boas-vindas é:
  <?code-excerpt "lib/step2.dart (ternary)" replace="/, \/\/ UPDATED//g"?>
  ```dart
  _formProgress == 1 ? _showWelcomeScreen : null
  ```
  Esta é uma atribuição condicional do Dart e tem a sintaxe:
  `condition ? expression1 : expression2`.
  Se a expressão `_formProgress == 1` for verdadeira, toda a expressão resulta
  no valor do lado esquerdo de `:`, que é o
  método `_showWelcomeScreen` neste caso.

## Etapa 2.5: Iniciar o Dart DevTools

Como você depura um aplicativo web Flutter?
Não é muito diferente de depurar qualquer aplicativo Flutter.
Você deseja usar o [Dart DevTools][Dart DevTools]!
(Não confundir com o Chrome DevTools.)

Nosso aplicativo atualmente não tem bugs, mas vamos dar uma olhada nele de qualquer maneira.
As seguintes instruções para iniciar o DevTools se aplicam a qualquer fluxo de trabalho,
mas há um atalho se você estiver usando o IntelliJ.
Veja a dica no final desta seção para mais informações.

<ol>
<li>

Execute o aplicativo.<br>
Se seu aplicativo não estiver em execução no momento, inicie-o.
Selecione o dispositivo **Chrome** no menu suspenso
e inicie-o em seu IDE ou,
na linha de comando, use `flutter run -d chrome`.

</li>

<li>

Obtenha as informações do web socket para o DevTools.<br>
Na linha de comando ou no IDE,
você deve ver uma mensagem dizendo algo como o seguinte:

```console
Launching lib/main.dart on Chrome in debug mode...
Building application for the web...                                11.7s
Attempting to connect to browser instance..
Debug service listening on <b>ws://127.0.0.1:54998/pJqWWxNv92s=</b>
```

Copie o endereço do serviço de depuração, mostrado em negrito.
Você precisará disso para iniciar o DevTools.

</li>

<li>

Certifique-se de que os plugins Dart e Flutter estejam instalados.<br>
Se você estiver usando um IDE,
certifique-se de ter os plugins Flutter e Dart configurados,
conforme descrito nas páginas [VS Code][VS Code] e
[Android Studio e IntelliJ][Android Studio and IntelliJ].
Se você estiver trabalhando na linha de comando,
inicie o servidor DevTools conforme explicado no
página [Linha de comando do DevTools][DevTools command line].

</li>

<li>

Conecte-se ao DevTools.<br>
Quando o DevTools for iniciado, você deverá ver algo
como o seguinte:

```console
Serving DevTools at http://127.0.0.1:9100
```

Vá para este URL em um navegador Chrome. Você deve ver o DevTools
tela de lançamento. Deve ser parecido com o seguinte:

![Captura de tela da tela de lançamento do DevTools](/assets/images/docs/get-started/devtools-launch-screen.png){:width="100%"}

</li>

<li>

Conecte-se ao aplicativo em execução.<br>
Em **Connect to a running site**,
cole o local do web socket (ws) que você copiou na etapa 2,
e clique em **Connect**. Agora você deve ver o Dart DevTools
executando com sucesso em seu navegador Chrome:

![Captura de tela da tela de execução do DevTools](/assets/images/docs/get-started/devtools-running.png){:width="100%"}

Parabéns, agora você está executando o Dart DevTools!

</li>
</ol>

:::note
Esta não é a única maneira de iniciar o DevTools.
Se você estiver usando o IntelliJ,
você pode abrir o DevTools acessando
**Flutter Inspector** -> **More Actions** -> **Open DevTools**:

![Captura de tela do inspetor do Flutter com o menu DevTools](/assets/images/docs/get-started/intellij-devtools.png){:width="100%"}
:::

<ol>
<li>

Defina um breakpoint.<br>
Agora que você tem o DevTools em execução,
selecione a guia **Debugger** na barra azul na parte superior.
O painel do depurador aparece e, no canto inferior esquerdo,
veja uma lista de bibliotecas usadas no exemplo.
Selecione `lib/main.dart` para exibir seu código Dart
no painel central.

![Captura de tela do depurador do DevTools](/assets/images/docs/get-started/devtools-debugging.png){:width="100%"}

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

Coloque um breakpoint na linha com o loop for clicando no
esquerda do número da linha. O breakpoint agora aparece
na seção **Breakpoints** à esquerda da janela.

</li>

<li>

Acione o breakpoint.<br>
No aplicativo em execução, clique em um dos campos de texto para ganhar foco.
O aplicativo atinge o breakpoint e pausa.
Na tela do DevTools, você pode ver à esquerda
o valor de `progress`, que é 0. Isso é esperado,
já que nenhum dos campos está preenchido.
Percorra o loop for para ver
a execução do programa.

</li>

<li>

Retome o aplicativo.<br>
Retome o aplicativo clicando no verde **Resume**
botão na janela do DevTools.

</li>

<li>

Exclua o breakpoint.<br>
Exclua o breakpoint clicando nele novamente e retome o aplicativo.

</li>
</ol>

Isso dá a você um pequeno vislumbre do que é possível usando o DevTools,
mas há muito mais! Para mais informações,
consulte a [documentação do DevTools][DevTools documentation].

## Etapa 3: Adicionar animação para o progresso do login

É hora de adicionar animação! Nesta etapa final,
você criará a animação para o
`LinearProgressIndicator` na parte superior do login
área. A animação tem o seguinte comportamento:

* Quando o aplicativo é iniciado,
  uma pequena barra vermelha aparece na parte superior da área de login.
* Quando um campo de texto contém texto,
  a barra vermelha fica laranja e anima 0,15
  do caminho pela área de login.
* Quando dois campos de texto contêm texto,
  a barra laranja fica amarela e anima metade
  do caminho pela área de login.
* Quando todos os três campos de texto contêm texto,
  a barra laranja fica verde e anima tudo
  o caminho pela área de login.
  Além disso, o botão **Sign up** é habilitado.

<ol>
<li>

Adicione um `AnimatedProgressIndicator`.<br>
Na parte inferior do arquivo, adicione este widget:

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

A função [`didUpdateWidget`][`didUpdateWidget`] atualiza
o `AnimatedProgressIndicatorState` sempre que
`AnimatedProgressIndicator` muda.

</li>

<li>

Use o novo `AnimatedProgressIndicator`.<br>
Em seguida, substitua o `LinearProgressIndicator` no `Form`
com este novo `AnimatedProgressIndicator`:

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

Execute o aplicativo.<br>
Digite qualquer coisa nos três campos para verificar se
a animação funciona e que clicar no
botão **Sign up** abre a tela **Welcome**.

</li>
</ol>
### Exemplo Completo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático completo de como começar com Flutter no DartPad" run="true"
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
          'Bem-vindo!',
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
          Text('Cadastre-se', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'Primeiro nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Sobrenome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Nome de usuário'),
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
            child: const Text('Cadastre-se'),
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
* `AnimatedBuilder` reconstrói a árvore de widgets quando o valor de uma `Animation` muda.
* Usando um `Tween`, você pode interpolar entre quase qualquer valor, neste caso, `Color`.

## Próximos Passos?

Parabéns! Você criou seu primeiro aplicativo web usando Flutter!

Se você quiser continuar explorando este exemplo, talvez possa adicionar validação de formulário. Para obter aconselhamento sobre como fazer isso, consulte a receita [Construindo um formulário com validação][Construindo um formulário com validação] no [cookbook do Flutter][cookbook do Flutter].

Para mais informações sobre aplicativos web Flutter, Dart DevTools ou animações Flutter, consulte o seguinte:

* [Documentação sobre animações][Documentação sobre animações]
* [Dart DevTools][Dart DevTools]
* Codelab de [Animações implícitas][Animações implícitas]
* [Exemplos Web][Exemplos Web]

[Android Studio and IntelliJ]: /tools/devtools/android-studio
[Documentação sobre animações]: /ui/animations
[Construindo um formulário com validação]: /cookbook/forms/validation
[Chrome browser]: https://www.google.com/chrome/?brand=CHBD&gclid=CjwKCAiAws7uBRAkEiwAMlbZjlVMZCxJDGAHjoSpoI_3z_HczSbgbMka5c9Z521R89cDoBM3zAluJRoCdCEQAvD_BwE&gclsrc=aw.ds
[criar um novo projeto Flutter]: /get-started/test-drive
[Dart DevTools]: /tools/devtools
[DartPad]: {{site.dartpad}}
[DevTools command line]: /tools/devtools/cli
[DevTools documentation]: /tools/devtools
[DevTools installed]: /tools/devtools#start
[DartPad troubleshooting page]: {{site.dart-site}}/tools/dartpad/troubleshoot
[`didUpdateWidget`]: {{site.api}}/flutter/widgets/State/didUpdateWidget.html
[editor]: /get-started/editor
[Effective Dart Style Guide]: {{site.dart-site}}/guides/language/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private
[cookbook do Flutter]: /cookbook
[Flutter SDK]: /get-started/install
[Animações implícitas]: /codelabs/implicit-animations
[Introdução à UI declarativa]: /get-started/flutter-for/declarative
[Material Design]: {{site.material}}/get-started
[TextButton]: {{site.api}}/flutter/material/TextButton-class.html
[VS Code]: /tools/devtools/vscode
[Exemplos Web]: {{site.repo.samples}}/tree/main/web
[Widget]: {{site.api}}/flutter/widgets/Widget-class.html
[first_flutter_codelab]: /get-started/codelab
