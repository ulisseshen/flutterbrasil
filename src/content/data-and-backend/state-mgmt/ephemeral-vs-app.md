---
ia-translate: true
title: Diferencie estado efêmero e estado do aplicativo
description: Como diferenciar entre estado efêmero e estado do aplicativo.
prev:
  title: Comece a pensar declarativamente
  path: /development/data-and-backend/state-mgmt/declarative
next:
  title: Gerenciamento simples de estado do aplicativo
  path: /development/data-and-backend/state-mgmt/simple
---

_Este documento introduz o estado do aplicativo, o estado efêmero e como você pode gerenciar cada um em um aplicativo Flutter._

No sentido mais amplo possível, o estado de um aplicativo é tudo que existe na memória quando o aplicativo está em execução. Isso inclui os ativos do aplicativo, todas as variáveis que o framework Flutter mantém sobre a UI, estado de animação, texturas, fontes e assim por diante. Embora esta definição mais ampla possível de estado seja válida, não é muito útil para arquitetar um aplicativo.

Primeiro, você nem mesmo gerencia algum estado (como texturas). O framework cuida disso para você. Portanto, uma definição mais útil de estado é "quaisquer dados que você precisa para reconstruir sua UI a qualquer momento". Segundo, o estado que você _realmente_ gerencia pode ser separado em dois tipos conceituais: estado efêmero e estado do aplicativo.

## Estado efêmero

O estado efêmero (às vezes chamado de _estado da UI_ ou _estado local_) é o estado que você pode conter perfeitamente em um único widget.

Esta é, intencionalmente, uma definição vaga, então aqui estão alguns exemplos.

* página atual em um [`PageView`][]
* progresso atual de uma animação complexa
* aba selecionada atual em um `BottomNavigationBar`

Outras partes da árvore de widgets raramente precisam acessar esse tipo de estado. Não há necessidade de serializá-lo e ele não muda de maneiras complexas.

Em outras palavras, não há necessidade de usar técnicas de gerenciamento de estado (ScopedModel, Redux, etc.) neste tipo de estado. Tudo o que você precisa é um `StatefulWidget`.

Abaixo, você vê como o item selecionado atualmente em uma barra de navegação inferior é mantido no campo `_index` da classe `_MyHomepageState`. Neste exemplo, `_index` é estado efêmero.

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

Aqui, usar `setState()` e um campo dentro da classe State do StatefulWidget é completamente natural. Nenhuma outra parte do seu aplicativo precisa acessar `_index`. A variável só muda dentro do widget `MyHomepage`. E, se o usuário fechar e reiniciar o aplicativo, você não se importa que `_index` seja redefinido para zero.

## Estado do aplicativo

O estado que não é efêmero, que você deseja compartilhar em muitas partes do seu aplicativo e que deseja manter entre as sessões do usuário, é o que chamamos de estado do aplicativo (às vezes também chamado de estado compartilhado).

Exemplos de estado do aplicativo:

* Preferências do usuário
* Informações de login
* Notificações em um aplicativo de rede social
* O carrinho de compras em um aplicativo de e-commerce
* Estado de leitura/não lida de artigos em um aplicativo de notícias

Para gerenciar o estado do aplicativo, você vai querer pesquisar suas opções. Sua escolha depende da complexidade e natureza do seu aplicativo, da experiência anterior da sua equipe e de muitos outros aspectos. Continue lendo.

## Não há uma regra clara

Para ser claro, você _pode_ usar `State` e `setState()` para gerenciar todo o estado em seu aplicativo. Na verdade, a equipe do Flutter faz isso em muitos exemplos de aplicativos simples (incluindo o aplicativo inicial que você recebe com cada `flutter create`).

O mesmo vale para o caminho inverso. Por exemplo, você pode decidir que&mdash;no contexto do seu aplicativo específico&mdash;a aba selecionada em uma barra de navegação inferior _não_ é um estado efêmero. Você pode precisar alterá-la de fora da classe, mantê-la entre sessões e assim por diante. Nesse caso, a variável `_index` é um estado do aplicativo.

Não há uma regra clara e universal para distinguir se uma variável específica é estado efêmero ou estado do aplicativo. Às vezes, você terá que refatorar uma em outra. Por exemplo, você começará com algum estado claramente efêmero, mas, à medida que seu aplicativo cresce em recursos, pode ser necessário movê-lo para o estado do aplicativo.

Por esse motivo, leve o seguinte diagrama com um grão de sal:

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app-state.png' width="100%" alt="Um fluxograma. Comece com 'Dados'. 'Quem precisa deles?'. Três opções: 'A maioria dos widgets', 'Alguns widgets' e 'Widget único'. As duas primeiras opções levam a 'Estado do aplicativo'. A opção 'Widget único' leva a 'Estado efêmero'.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1p5Bvuagin9DZH8bNrpGfpQQvKwLartYhIvD0WKGa64k/edit?usp=sharing
{% endcomment %}

Quando perguntado sobre o setState do React versus o store do Redux, o autor do Redux, Dan Abramov, respondeu:

> "A regra geral é: [Faça o que for menos estranho][]."

Em resumo, existem dois tipos conceituais de estado em qualquer aplicativo Flutter. O estado efêmero pode ser implementado usando `State` e `setState()`, e geralmente é local para um único widget. O resto é o estado do seu aplicativo. Ambos os tipos têm seu lugar em qualquer aplicativo Flutter, e a divisão entre os dois depende de sua própria preferência e da complexidade do aplicativo.

[Faça o que for menos estranho]: {{site.github}}/reduxjs/redux/issues/1287#issuecomment-175351978
[`PageView`]: {{site.api}}/flutter/widgets/PageView-class.html
