---
ia-translate: true
title: Acessibilidade web
description: Informações sobre acessibilidade web
---

## Contexto {:#background}

Flutter suporta acessibilidade web traduzindo sua
árvore Semantics interna em uma estrutura DOM HTML acessível que
leitores de tela podem entender.
Como o Flutter renderiza sua UI em um único canvas, ele precisa de uma camada especial
para expor o significado e estrutura da UI aos navegadores web.


## Opt-in de acessibilidade web {:#opt-in-web-accessibility}

### Botão invisível {:#invisible-button}

Por razões de desempenho, a acessibilidade web do Flutter não está ativada por padrão.
Para ativar a acessibilidade, o usuário precisa pressionar um botão invisível com
`aria-label="Enable accessibility"`.
Após pressionar o botão, a árvore DOM refletirá todas as informações de acessibilidade
dos widgets.
Em web apps incorporados ou com múltiplas views em navegadores móveis, o Flutter restringe
esse botão placeholder a cada view do Flutter para que ele não bloqueie toques na
página HTML ao redor.

### Ativar modo de acessibilidade no código {:#turn-on-accessibility-mode-in-code}

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

### O que são roles semânticos? {:#what-are-semantic-roles}

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

### Usando `SemanticsRole` no Flutter para web {:#using-semanticsrole-in-flutter-for-web}

Flutter fornece o [widget `Semantics`][] com o [enum `SemanticsRole`][]
para permitir que desenvolvedores atribuam roles específicos aos seus widgets. Quando seu
app Flutter web é renderizado, esses roles específicos do Flutter são traduzidos em
roles ARIA correspondentes na estrutura HTML da página web.

[widget `Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[enum `SemanticsRole`]: {{site.api}}/flutter/dart-ui/SemanticsRole.html

**1. Semantics automáticos de widgets padrão**

:::version-note
A semântica aprimorada de `<input type="range" role="slider">` para `Slider`,
`RangeSlider` e `SemanticsRole.slider`, landmarks `role="region"` para rotas
nomeadas, a preservação do foco do DOM em atualizações de role e em diálogos de
`WidgetsApp.router`, e o fechamento de tooltips com a tecla `Escape` exigem Flutter 3.50 ou posterior.
:::

Muitos widgets padrão do Flutter, como `TabBar`, `MenuAnchor`, `Slider`,
`RangeSlider` e `Table`, incluem automaticamente informações semânticas junto
com seus roles:

* **Sliders**: `Slider` e `RangeSlider` (usando `SemanticsFlag.isSlider`) e
  widgets personalizados com `SemanticsRole.slider` renderizam um elemento
  focável `<input type="range" role="slider">` com `aria-label`,
  `aria-valuenow` e `aria-valuetext` sincronizados, e navegação pelas
  setas do teclado.
* **Landmarks e menus**: Rotas nomeadas com `scopesRoute: true`,
  `namesRoute: true` e um `label` não vazio emitem landmarks `role="region"`,
  e menus roláveis (`MenuAnchor`, `DropdownMenu`) expõem a contagem direta de itens
  para leitores de tela sem wrappers `group` intermediários.

Além disso, a engine web preserva o foco do DOM em mudanças de role semântico
sem rolar a página, restaura o foco quando diálogos ou rotas modais fecham em
apps com `WidgetsApp.router`, e fecha widgets `Tooltip` visíveis quando o usuário
pressiona `Escape`.

Sempre que possível, prefira usar esses widgets padrão
pois eles lidam com muitos aspectos de acessibilidade prontos para uso.

**2. Adicionando ou sobrescrevendo roles explicitamente**

Para componentes customizados ou quando as semânticas padrão não são suficientes,
use o widget `Semantics` para definir o role:

Aqui está um exemplo de como você pode definir explicitamente uma lista e seus itens:

```dart
import 'package:material_ui/material_ui.dart';
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

## Zoom do viewport e entradas de texto em dispositivos móveis {:#viewport-zoom-and-mobile-text-inputs}

:::version-note
O pinch-to-zoom padrão de 500% (`maximum-scale=5.0`) e o dimensionamento automático
da fonte de entradas de texto para 16px no iOS Safari requerem Flutter 3.50 ou posterior.
:::

Por padrão, no modo de página inteira, o Flutter configura a tag
`<meta name="viewport" flt-viewport>` da página com `maximum-scale=5.0` e sem
`user-scalable=no`. Isso permite que os usuários usem pinch-to-zoom até 500% para atender
às diretrizes de redimensionamento de texto da WCAG 2.1 AA.

No iOS Safari, o Flutter também define automaticamente um tamanho mínimo de fonte de `16px` em
seus elementos semânticos ocultos `<input>` e `<textarea>` para que o navegador não
faça zoom automático inesperadamente quando um usuário foca um campo de texto.
