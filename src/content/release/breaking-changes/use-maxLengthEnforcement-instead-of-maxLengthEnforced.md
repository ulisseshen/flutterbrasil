---
ia-translate: true
title: Use maxLengthEnforcement em vez de maxLengthEnforced
description: Apresentando o enum MaxLengthEnforcement.
---

## Resumo

Para controlar o comportamento de `maxLength` em
`LengthLimitingTextInputFormatter`, use `maxLengthEnforcement`
em vez do agora obsoleto `maxLengthEnforced`.

## Contexto

O parâmetro `maxLengthEnforced` era usado para decidir
se os campos de texto deveriam truncar o valor de entrada
quando ele atingisse o limite de `maxLength`, ou se
(para `TextField` e `TextFormField`)
uma mensagem de aviso deveria ser exibida na contagem de
caracteres quando o comprimento da entrada do usuário
excedesse `maxLength`.

No entanto, para inserir caracteres CJK, alguns métodos de
entrada exigem que o usuário insira uma sequência de
caracteres latinos no campo de texto e, em seguida,
transforme essa sequência em caracteres CJK desejados (o
que é conhecido como *composição de texto*). A sequência
latina geralmente é mais longa do que os caracteres CJK
resultantes, portanto, definir um limite máximo fixo de
caracteres em um campo de texto pode significar que o
usuário não poderá concluir a composição de texto
normalmente devido ao limite de caracteres `maxLength`.

A composição de texto também é usada por alguns métodos
de entrada para indicar que o texto dentro da região de
composição destacada está sendo editado ativamente, mesmo
ao inserir caracteres latinos. Por exemplo, o teclado
inglês do Gboard no Android (assim como muitos outros
métodos de entrada no Android) coloca a palavra atual em
uma região de composição.

Para melhorar a experiência de entrada nesses cenários,
um novo enum de três estados, `MaxLengthEnforcement`, foi
introduzido. Seus valores descrevem as estratégias
suportadas para lidar com regiões de composição ativas ao
aplicar um `LengthLimitingTextInputFormatter`. Um novo
parâmetro `maxLengthEnforcement` que usa este enum foi
adicionado aos campos de texto para substituir o parâmetro
booleano `maxLengthEnforced`. Com o novo parâmetro enum,
os desenvolvedores podem escolher diferentes estratégias
com base no tipo de conteúdo que o campo de texto espera.

Para mais informações, veja a documentação para [`maxLength`][] e
[`MaxLengthEnforcement`][].

O valor padrão do parâmetro `maxLengthEnforcement` é
inferido do `TargetPlatform` da aplicação, para estar em
conformidade com as convenções da plataforma:

## Descrição da mudança

* Adicionado um parâmetro `maxLengthEnforcement` usando
  o novo tipo enum `MaxLengthEnforcement`, como um
  substituto para o agora obsoleto parâmetro booleano
  `maxLengthEnforced` nas classes `TextField`,
  `TextFormField`, `CupertinoTextField` e
  `LengthLimitingTextInputFormatter`.

## Guia de migração

_Usar o comportamento padrão para a plataforma atual é
recomendado, pois este será o comportamento mais familiar
para o usuário._

### Valores padrão de `maxLengthEnforcement`

* Android, Windows: `MaxLengthEnforcement.enforced`.
  O comportamento nativo dessas plataformas é aplicado.
  O valor de entrada será truncado se o usuário estiver
  digitando com composição ou não.
* iOS, macOS: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Essas plataformas não têm um recurso de "comprimento
  máximo" e, portanto, exigem que os desenvolvedores
  implementem o comportamento eles mesmos. Nenhuma
  convenção padrão parece ter evoluído nessas plataformas.
  Escolhemos permitir que a composição exceda o
  comprimento máximo para evitar quebrar a entrada CJK.
* Web e Linux: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Embora não haja padrão nessas plataformas (e muitas
  implementações existam com comportamento conflitante), a
  convenção comum parece ser permitir que a composição
  exceda o comprimento máximo por padrão.
* Fuchsia: `MaxLengthEnforcement.truncateAfterCompositionEnds`.
  Ainda não há convenção de plataforma nesta plataforma,
  então escolhemos usar como padrão a convenção que é
  menos provável de resultar em perda de dados.

### Para aplicar o limite o tempo todo

Para aplicar o limite que sempre trunca o valor quando
ele atinge o limite (por exemplo, ao inserir um código de
verificação), use `MaxLengthEnforcement.enforced` em
campos de texto editáveis.

_Esta opção pode fornecer uma experiência de usuário
subótima quando usada com métodos de entrada que dependem
da composição de texto. Considere usar a opção
`truncateAfterCompositionEnds` quando o campo de texto
esperar uma entrada arbitrária do usuário que pode
conter caracteres CJK. Veja a seção [Contexto](#context)
para mais informações._

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

Para mostrar um erro de comprimento máximo em `TextField`,
mas _não_ truncar quando o limite for excedido, use
`MaxLengthEnforcement.none` em vez de
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

Para `CupertinoTextField`, que não é capaz de mostrar uma
mensagem de erro, apenas não defina o valor `maxLength`.

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

### Para aplicar o limite, mas não para texto de composição

Para evitar truncar o texto enquanto o usuário está
inserindo texto usando composição, especifique
`MaxLengthEnforcement.truncateAfterCompositionEnds`. Este
comportamento permite que métodos de entrada que usam
regiões de composição maiores que o texto resultante,
como é comum, por exemplo, com texto chinês, japonês e
coreano (CJK), ignorem temporariamente o limite até que a
edição seja concluída.

_O teclado inglês do Gboard no Android (e muitos outros
métodos de entrada do Android) cria uma região de
composição para a palavra que está sendo inserida. Quando
usado em um campo de texto
`truncateAfterCompositionEnds`, o usuário não será
interrompido imediatamente no limite de `maxLength`.
Considere a opção `enforced` se você estiver confiante de
que o campo de texto não será usado com métodos de
entrada que usam regiões de composição temporariamente
longas, como texto CJK._

Código para a implementação:

```dart
TextField(
  maxLength: 6,
  maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds, // Remove temporariamente o limite.
)
```

### Tenha cuidado ao presumir que a entrada não usará regiões de composição

É tentador, ao direcionar um determinado local, presumir
que todos os usuários ficarão satisfeitos com a entrada
desse local. Por exemplo, pode-se presumir que um
software de fórum direcionado a uma comunidade de língua
inglesa só precisará lidar com texto em inglês. No
entanto, esse tipo de suposição geralmente está incorreto.
Por exemplo, talvez os participantes do fórum de língua
inglesa queiram discutir anime japonês ou culinária
vietnamita. Talvez um dos participantes seja coreano e
prefira expressar seu nome em seus ideogramas nativos.
Por esse motivo, os campos de formato livre raramente
devem usar o valor `enforced` e, em vez disso, devem
preferir o valor `truncateAfterCompositionEnds` se
possível.

## Linha do tempo

Incluído na versão: v1.26.0-1.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documento de design:

* [`MaxLengthEnforcement` design doc][]

Documentação da API:

* [`MaxLengthEnforcement`][]
* [`LengthLimitingTextInputFormatter`][]
* [`maxLength`][]

Issues relevantes:

* [Issue 63753][]
* [Issue 67898][]

PRs relevantes:

* [PR 63754][]: Corrige o crash do TextField com composição e maxLength definido
* [PR 68086][]: Introduz `MaxLengthEnforcement`

[`MaxLengthEnforcement` design doc]: /go/max-length-enforcement
[`MaxLengthEnforcement`]: {{site.api}}/flutter/services/MaxLengthEnforcement.html
[`LengthLimitingTextInputFormatter`]: {{site.api}}/flutter/services/LengthLimitingTextInputFormatter-class.html
[`maxLength`]: {{site.api}}/flutter/services/LengthLimitingTextInputFormatter/maxLength.html
[Issue 63753]: {{site.repo.flutter}}/issues/63753
[Issue 67898]: {{site.repo.flutter}}/issues/67898
[PR 63754]: {{site.github}}//flutter/flutter/pull/63754
[PR 68086]: {{site.repo.flutter}}/pull/68086
