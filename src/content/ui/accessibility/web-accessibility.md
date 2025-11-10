---
ia-translate: true
title: Acessibilidade web
description: Informações sobre acessibilidade web
---

## Contexto

Flutter suporta acessibilidade web traduzindo sua
árvore Semantics interna em uma estrutura DOM HTML acessível que
leitores de tela podem entender.
Como o Flutter renderiza sua UI em um único canvas, ele precisa de uma camada especial
para expor o significado e estrutura da UI aos navegadores web.


## Opt-in de acessibilidade web

### Botão invisível

Por razões de desempenho, a acessibilidade web do Flutter não está ativada por padrão.
Para ativar a acessibilidade, o usuário precisa pressionar um botão invisível com
`aria-label="Enable accessibility"`.
Após pressionar o botão, a árvore DOM refletirá todas as informações de acessibilidade
dos widgets.

### Ativar modo de acessibilidade no código

Uma abordagem alternativa é ativar o modo de acessibilidade
adicionando o seguinte código ao executar um app.

```dart
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
  if (kIsWeb) {
    SemanticsBinding.instance.ensureSemantics();
  }
}
```



## Melhorando a acessibilidade com roles semânticos {:#enhancing-accessibility-with-semantic-roles}

### O que são roles semânticos?

Roles semânticos definem o propósito de um elemento de UI, ajudando leitores de tela
e outras ferramentas assistivas a interpretar e apresentar sua aplicação efetivamente
aos usuários. Por exemplo, um role pode indicar se um widget é um botão, um link,
um cabeçalho, um slider ou parte de uma tabela.

Enquanto os widgets padrão do Flutter frequentemente fornecem essas semânticas automaticamente,
um componente customizado sem um role claramente definido pode ser incompreensível
para um usuário de leitor de tela.


Ao atribuir roles apropriados, você garante que:

* Leitores de tela podem anunciar o tipo e propósito dos elementos corretamente.
* Usuários podem navegar em sua aplicação de forma mais eficaz usando tecnologias assistivas.
* Sua aplicação adere aos padrões de acessibilidade web, melhorando a usabilidade.

### Usando `SemanticsRole` no Flutter para web

Flutter fornece o [widget `Semantics`][] com o [enum `SemanticsRole`][]
para permitir que desenvolvedores atribuam roles específicos aos seus widgets. Quando seu
app Flutter web é renderizado, esses roles específicos do Flutter são traduzidos em
roles ARIA correspondentes na estrutura HTML da página web.

[widget `Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[enum `SemanticsRole`]: {{site.api}}/flutter/dart-ui/SemanticsRole.html

**1. Semantics automáticos de widgets padrão**

Muitos widgets padrão do Flutter, como `TabBar`, `MenuAnchor` e `Table`,
incluem automaticamente informações semânticas junto com seus roles.
Sempre que possível, prefira usar esses widgets padrão
pois eles lidam com muitos aspectos de acessibilidade prontos para uso.

**2. Adicionando ou sobrescrevendo roles explicitamente**

Para componentes customizados ou quando as semânticas padrão não são suficientes,
use o widget `Semantics` para definir o role:

Aqui está um exemplo de como você pode definir explicitamente uma lista e seus itens:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';


class MyCustomListWidget extends StatelessWidget {
  const MyCustomListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This example shows how to explicitly assign list and listitem roles
    // when building a custom list structure.
    return Semantics(
      role: SemanticsRole.list,
      explicitChildNodes: true,
      child: Column(
        children: <Widget>[
          Semantics(
            role: SemanticsRole.listItem,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Content of the first custom list item.'),
            ),
          ),
          Semantics(
            role: SemanticsRole.listItem,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Content of the second custom list item.'),
            ),
          ),
        ],
      ),
    );
  }
}
```
