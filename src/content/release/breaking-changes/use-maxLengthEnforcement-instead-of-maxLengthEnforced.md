---
title: Use maxLengthEnforcement em vez de maxLengthEnforced
description: Introduzindo o enum MaxLengthEnforcement.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Para controlar o comportamento de `maxLength` no
`LengthLimitingTextInputFormatter`, use `maxLengthEnforcement`
em vez do agora obsoleto `maxLengthEnforced`.

## Contexto {:#context}

O parâmetro `maxLengthEnforced` era usado para decidir
se os campos de texto deveriam truncar o valor de entrada
quando ele atingisse o limite de `maxLength`, ou se
(para `TextField` e `TextFormField`)
uma mensagem de aviso deveria ser mostrada no
contador de caracteres quando o comprimento da entrada do usuário
excedesse `maxLength`.

No entanto, para inserir caracteres CJK, alguns métodos de entrada
exigem que o usuário insira uma sequência de caracteres latinos
no campo de texto, e então converta essa sequência
em caracteres CJK desejados (referido como *composição de texto*).
A sequência latina geralmente é mais longa que os caracteres CJK resultantes,
então definir um limite máximo rígido de caracteres em um campo de texto pode significar que
o usuário não consiga finalizar a composição de texto normalmente devido ao
limite de caracteres de `maxLength`.

A composição de texto também é usada por alguns métodos de entrada para
indicar que o texto dentro da região de composição destacada está sendo editado ativamente,
mesmo ao inserir caracteres latinos. Por exemplo, o teclado inglês do Gboard no Android
(assim como muitos outros métodos de entrada no Android) coloca a palavra atual
em uma região de composição.

Para melhorar a experiência de entrada nesses cenários,
um novo enum de três estados, `MaxLengthEnforcement`, foi introduzido.
Seus valores descrevem estratégias suportadas para lidar com
regiões de composição ativas ao aplicar um
`LengthLimitingTextInputFormatter`.
Um novo parâmetro `maxLengthEnforcement` que usa
esse enum foi adicionado aos campos de texto para substituir
o parâmetro booleano `maxLengthEnforced`.
Com o novo parâmetro enum,
os desenvolvedores podem escolher diferentes estratégias
com base no tipo de conteúdo que o campo de texto espera.

Para mais informações, consulte a documentação de [`maxLength`][] e
[`MaxLengthEnforcement`][].

O valor padrão do parâmetro `maxLengthEnforcement`
é inferido da `TargetPlatform`
do aplicativo, para estar de acordo com as convenções da plataforma:

## Descrição da mudança

* Adicionado um parâmetro `maxLengthEnforcement` usando o
  novo tipo enum `MaxLengthEnforcement`,
  como substituto do agora obsoleto parâmetro booleano
  `maxLengthEnforced` nas
  classes `TextField`, `TextFormField`, `CupertinoTextField` e
  `LengthLimitingTextInputFormatter`.

## Guia de migração

_Usar o comportamento padrão para a plataforma atual é recomendado,
pois este será o comportamento mais familiar para o usuário._

### Valores padrão de `maxLengthEnforcement`

* Android, Windows: `MaxLengthEnforcement.enforced`.
  O comportamento nativo dessas plataformas é aplicado.
  O valor de entrada será truncado se
  o usuário estiver inserindo com composição ou não.
* iOS, macOS: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Essas plataformas não têm um recurso de "comprimento máximo"
  e, portanto, exigem que os desenvolvedores implementem
  o comportamento eles mesmos. Nenhuma convenção padrão parece
  ter evoluído nessas plataformas. Optamos por
  permitir que a composição exceda o comprimento máximo
  para evitar quebrar a entrada CJK.
* Web e Linux: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Embora não haja um padrão nessas plataformas
  (e muitas implementações existem com comportamento conflitante),
  a convenção comum parece ser permitir que a composição
  exceda o comprimento máximo por padrão.
* Fuchsia: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Ainda não há convenção de plataforma nesta plataforma,
  então optamos por usar como padrão a convenção que é
  menos provável de resultar em perda de dados.

### Para aplicar o limite o tempo todo

Para aplicar o limite que sempre trunca o valor quando
ele atinge o limite (por exemplo, ao inserir um
código de verificação), use `MaxLengthEnforcement.enforced` em
campos de texto editáveis.

_Esta opção pode dar uma experiência de usuário subótima quando usada
com métodos de entrada que dependem da composição de texto.
Considere usar a opção `truncateAfterCompositionEnds`
quando o campo de texto espera entrada arbitrária do usuário
que pode conter caracteres CJK.
Consulte a seção [Contexto](#context) para mais informações._

Código antes da migração:

```dart
TextField(maxLength: 6)
```

ou:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforced: true,
)
```

Código após a migração:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforcement: MaxLengthEnforcement.enforced,
)
```

### Para não aplicar a limitação

Para mostrar um erro de comprimento máximo no `TextField`,
mas _não_ truncar quando o limite for excedido,
use `MaxLengthEnforcement.none` em vez de
`maxLengthEnforced: false`.

Código antes da migração:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforced: false,
)
```

Código após a migração:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforcement: MaxLengthEnforcement.none,
)
```

Para `CupertinoTextField`, que não consegue mostrar uma mensagem de erro,
apenas não defina o valor `maxLength`.

Código antes da migração:

```dart
CupertinoTextField(
  maxLength: 6,
  maxLengthEnforced: false,
)
```

Código após a migração:

```dart
CupertinoTextField()
```

### Para aplicar o limite, mas não para texto em composição

Para evitar truncar texto enquanto o usuário está inserindo texto
usando composição, especifique
`MaxLengthEnforcement.truncateAfterCompositionEnds`.
Este comportamento permite métodos de entrada que usam regiões de composição
maiores que o texto resultante,
como é comum, por exemplo, com texto chinês, japonês,
e coreano (CJK), para temporariamente
ignorar o limite até que a edição esteja completa.

_O teclado inglês do Gboard no Android
(e muitos outros métodos de entrada do Android)
cria uma região de composição para a palavra que está sendo inserida.
Quando usado em um campo de texto `truncateAfterCompositionEnds`,
o usuário não será parado imediatamente no limite `maxLength`.
Considere a opção `enforced` se você está confiante de que
o campo de texto não será usado com métodos de entrada
que usam regiões de composição temporariamente longas, como texto CJK._

Código para a implementação:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds, // Temporarily lifts the limit.
)
```

### Tenha cuidado ao assumir que a entrada não usará regiões de composição

É tentador ao direcionar uma localidade específica assumir
que todos os usuários ficarão satisfeitos com a entrada dessa localidade.
Por exemplo, software de fórum direcionado a uma comunidade de língua inglesa
pode ser assumido que só precisa lidar com texto em inglês. No entanto, esse tipo de suposição geralmente está incorreta.
Por exemplo, talvez os participantes do fórum em inglês
queiram discutir anime japonês ou culinária vietnamita.
Talvez um dos participantes seja coreano e prefira expressar
seu nome em seus ideogramas nativos. Por esse motivo,
campos de formato livre raramente devem usar o valor `enforced`
e devem, em vez disso, preferir o
valor `truncateAfterCompositionEnds`, se possível.

## Linha do tempo

Lançado na versão: v1.26.0-1.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documento de design:

* [Documento de design de `MaxLengthEnforcement`][]

Documentação da API:

* [`MaxLengthEnforcement`][]
* [`LengthLimitingTextInputFormatter`][]
* [`maxLength`][]

Issues relevantes:

* [Issue 63753][]
* [Issue 67898][]

PR relevante:

* [PR 63754][]: Fix TextField crashed with composing and maxLength set
* [PR 68086][]: Introduce `MaxLengthEnforcement`

[Documento de design de `MaxLengthEnforcement`]: /go/max-length-enforcement
[`MaxLengthEnforcement`]: {{site.api}}/flutter/services/MaxLengthEnforcement.html
[`LengthLimitingTextInputFormatter`]: {{site.api}}/flutter/services/LengthLimitingTextInputFormatter-class.html
[`maxLength`]: {{site.api}}/flutter/services/LengthLimitingTextInputFormatter/maxLength.html
[Issue 63753]: {{site.repo.flutter}}/issues/63753
[Issue 67898]: {{site.repo.flutter}}/issues/67898
[PR 63754]: {{site.github}}/flutter/flutter/pull/63754
[PR 68086]: {{site.repo.flutter}}/pull/68086
