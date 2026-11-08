---
ia-translate: true
title: "Atalhos de ponto no Flutter"
description: "Saiba como usar os atalhos de ponto do Dart para escrever código Flutter mais limpo e conciso."
---

O recurso de **atalhos de ponto** permite omitir o tipo explícito ao acessar
membros estáticos, construtores ou valores de enum, desde que o compilador
consiga inferir o tipo a partir do contexto ao redor.

:::note
Para uma visão técnica desse recurso, consulte o [guia de Atalhos de ponto](https://dart.dev/language/dot-shorthands)
na documentação do Dart.
:::

## Por que os atalhos de ponto importam {:#why-dot-shorthands-matter}

Construir layouts no Flutter costuma envolver árvores de widgets profundamente
aninhadas. Historicamente, isso significava digitar repetidamente nomes explícitos
de classes e enums para propriedades como cores, tipografia e alinhamento.
Os atalhos de ponto reduzem esse código repetitivo, tornando o código mais fácil
de ler e mais rápido de escrever.

Veja uma comparação lado a lado da construção de um `Container` simples:

### Sem atalhos de ponto {:#without-dot-shorthands}
```dart
Container(
  alignment: Alignment.center,
  padding: const EdgeInsets.all(16.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hello World',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
);
```

### Com atalhos de ponto {:#with-dot-shorthands}
```dart
Container(
  alignment: .center, // Instead of Alignment.center,
  padding: const .all(16.0), // Instead of EdgeInsets.all(16.0)
  child: Column(
    mainAxisAlignment: .center, // Instead of MainAxisAlignment.center
    crossAxisAlignment: .start, // Instead of CrossAxisAlignment.start
    children: [
      Text(
        'Hello World',
        style: TextStyle(
          fontWeight: .bold, // Instead of FontWeight.bold
        ),
      ),
    ],
  ),
);
```

## Onde usar atalhos de ponto {:#where-to-use-dot-shorthands}

Os atalhos de ponto funcionam em qualquer lugar em que o compilador do Dart tenha
um "tipo de contexto" claro, ou seja, saiba exatamente qual tipo espera.
No Flutter, isso acontece quase sempre dentro da lista de propriedades de um widget.

Os alvos mais comuns de atalhos de ponto no Flutter são:

*   **Enums**: `MainAxisAlignment`, `CrossAxisAlignment`, `BoxFit`, `TextDirection`.
*   **Propriedades e métodos estáticos**: `FontWeight` (constantes como `.bold`).
*   **Construtores**: `EdgeInsets.all()`, `BorderRadius.circular()`.

### Exemplo: enums {:#example-enums}

Quando uma propriedade espera um `enum`, como `mainAxisAlignment`, você pode omitir
o nome do enum e fornecer apenas o valor precedido por um ponto (`.`):

```dart
Row(
  mainAxisAlignment: .spaceEvenly, // Infers MainAxisAlignment.spaceEvenly
  children: [ /* ... */ ],
)
```

### Exemplo: propriedades estáticas {:#example-static-properties}

Propriedades estáticas funcionam quando o tipo de contexto é exatamente a classe
que define a propriedade. Um exemplo comum é a estilização de texto com `FontWeight`:

```dart
Text(
  'Feature highlights',
  style: TextStyle(
    fontWeight: .bold, // Infers FontWeight.bold
  ),
)
```

### Exemplo: construtores {:#example-constructors}

Você também pode usar atalhos de ponto para construtores nomeados. Muitas propriedades
de layout do Flutter aceitam uma classe base como `EdgeInsetsGeometry`. Para oferecer
suporte a atalhos de ponto, o Flutter adiciona construtores de redirecionamento a essas
classes base que apontam para as subclasses apropriadas.

```dart
Padding(
  padding: .symmetric(horizontal: 16.0, vertical: 8.0), // Infers EdgeInsetsGeometry.symmetric
  child: Text('Spaced out text'),
)
```

Você pode até usar `.new` para chamar um construtor sem nome, embora isso seja
menos comum em árvores de widgets padrão:

```dart
class _MyState extends State<MyWidget> {
  final ScrollController _scrollController = .new(); // Infers ScrollController()
  // ...
}
```
