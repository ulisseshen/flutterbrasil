---
ia-translate: true
title: Diferencie entre estado efêmero e estado do app
description: Como distinguir entre estado efêmero e estado do app.
prev:
  title: Start thinking declaratively
  path: /data-and-backend/state-mgmt/declarative
next:
  title: Simple app state management
  path: /data-and-backend/state-mgmt/simple
---

_Este documento introduz estado do app, estado efêmero,
e como você pode gerenciar cada um em um app Flutter._

No sentido mais amplo possível, o estado de um app é tudo que
existe na memória quando o app está executando. Isso inclui os assets do app,
todas as variáveis que o framework Flutter mantém sobre a UI,
estado de animação, texturas, fontes e assim por diante. Embora esta definição
mais ampla possível de estado seja válida, ela não é muito útil para
arquitetar um app.

Primeiro, você nem mesmo gerencia algum estado (como texturas).
O framework cuida disso para você. Então uma definição mais útil de
estado é "quaisquer dados que você precisa para reconstruir sua UI em qualquer
momento no tempo". Segundo, o estado que você _de fato_ gerencia você mesmo pode
ser separado em dois tipos conceituais: estado efêmero e estado do app.

## Estado efêmero

Estado efêmero (às vezes chamado de _estado da UI_ ou _estado local_)
é o estado que você pode conter claramente em um único widget.

Esta é, intencionalmente, uma definição vaga, então aqui estão alguns exemplos.

* página atual em um [`PageView`][]
* progresso atual de uma animação complexa
* aba selecionada atualmente em um `BottomNavigationBar`

Outras partes da árvore de widgets raramente precisam acessar este tipo de estado.
Não há necessidade de serializá-lo, e ele não muda de formas complexas.

Em outras palavras, não há necessidade de usar técnicas de gerenciamento de estado
(ScopedModel, Redux, etc.) neste tipo de estado.
Tudo que você precisa é um `StatefulWidget`.

Abaixo, você vê como o item selecionado atualmente em uma barra de navegação inferior é
mantido no campo `_index` da classe `_MyHomepageState`.
Neste exemplo, `_index` é estado efêmero.

<?code-excerpt "state_mgmt/simple/lib/src/set_state.dart (ephemeral)" plaster="// ... items ..."?>
```dart
class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (newIndex) {
        setState(() {
          _index = newIndex;
        });
      },
      // ... items ...
    );
  }
}
```

Aqui, usar `setState()` e um campo dentro da classe State do StatefulWidget
é completamente natural. Nenhuma outra parte do seu app precisa acessar
`_index`. A variável só muda dentro do widget `MyHomepage`.
E, se o usuário fechar e reiniciar o app,
você não se importa que `_index` reinicie para zero.

## Estado do app

Estado que não é efêmero,
que você quer compartilhar entre muitas partes do seu app,
e que você quer manter entre sessões de usuário,
é o que chamamos de estado da aplicação
(às vezes também chamado de estado compartilhado).

Exemplos de estado da aplicação:

* Preferências do usuário
* Informações de login
* Notificações em um app de rede social
* O carrinho de compras em um app de e-commerce
* Estado lido/não lido de artigos em um app de notícias

Para gerenciar o estado do app, você vai querer pesquisar suas opções.
Sua escolha depende da complexidade e natureza do seu app,
da experiência prévia da sua equipe e muitos outros aspectos. Continue lendo.

## Não há uma regra clara

Para ser claro, você _pode_ usar `State` e `setState()` para gerenciar todo o
estado no seu app. De fato, o time Flutter faz isso em muitas
amostras de apps simples (incluindo o app inicial que você obtém com cada
`flutter create`).

Isso também funciona ao contrário. Por exemplo, você pode decidir que&mdash;no
contexto do seu app particular&mdash;a aba selecionada em uma barra de
navegação inferior _não_ é estado efêmero. Você pode precisar mudá-la
de fora da classe, mantê-la entre sessões, e assim por diante.
Nesse caso, a variável `_index` é estado do app.

Não há uma regra universal e clara para distinguir
se uma variável particular é estado efêmero ou estado do app.
Às vezes, você terá que refatorar um no outro.
Por exemplo, você começará com algum estado claramente efêmero,
mas à medida que sua aplicação cresce em funcionalidades,
ele pode precisar ser movido para estado do app.

Por essa razão, considere o seguinte diagrama com cautela:

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app-state.png' width="100%" class="diagram-wrap" alt="A flow chart. Start with 'Data'. 'Who needs it?'. Three options: 'Most widgets', 'Some widgets' and 'Single widget'. The first two options both lead to 'App state'. The 'Single widget' option leads to 'Ephemeral state'.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1p5Bvuagin9DZH8bNrpGfpQQvKwLartYhIvD0WKGa64k/edit?usp=sharing
{% endcomment %}

Quando perguntado sobre setState do React versus store do Redux, o autor do Redux,
Dan Abramov, respondeu:

> "A regra prática é: [Faça o que for menos estranho][Do whatever is less awkward]."

Em resumo, há dois tipos conceituais de estado em qualquer app Flutter.
Estado efêmero pode ser implementado usando `State` e `setState()`,
e é frequentemente local a um único widget. O resto é o estado do seu app.
Ambos os tipos têm seu lugar em qualquer app Flutter, e a divisão entre
os dois depende da sua própria preferência e da complexidade do app.

[Do whatever is less awkward]: {{site.github}}/reduxjs/redux/issues/1287#issuecomment-175351978
[`PageView`]: {{site.api}}/flutter/widgets/PageView-class.html
