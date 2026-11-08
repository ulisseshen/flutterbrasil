---
title: Fórmula de spring underdamped alterada
description: >-
  A fórmula para `SpringDescription` foi alterada para corrigir um erro anterior,
  afetando springs underdamped (relação de amortecimento menor que 1).
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

A fórmula para `SpringDescription` foi alterada para corrigir um erro anterior,
afetando springs underdamped (relação de amortecimento menor que 1)
com valores de massa diferentes de 1.
Springs criados antes dessa alteração podem exibir
comportamentos de ricochete diferentes após a atualização.

## Contexto

A classe [`SpringDescription`][] descreve o comportamento de springs amortecidas,
permitindo que os widgets do Flutter animem de forma realista com base nos parâmetros fornecidos.
A física de springs amortecidas é amplamente estudada e documentada. Para uma visão geral
do amortecimento, consulte [Wikipedia: Damping][].

Anteriormente, a fórmula do Flutter para calcular o comportamento de spring underdamped estava
incorreta, conforme relatado em [Issue 163858][]. Este erro afetou todas as springs com
uma relação de amortecimento menor que 1 e uma massa diferente de 1. Consequentemente, as animações
não correspondiam à física esperada do mundo real, e o comportamento em torno do ponto de amortecimento
crítico (relação de amortecimento de exatamente 1) exibia descontinuidades.
Especificamente, ao usar `SpringDescription.withDampingRatio`, pequenas
diferenças, como relações de amortecimento de 1.0001 versus 0.9999, resultavam em
animações significativamente diferentes.

O problema foi corrigido no PR [Fix SpringSimulation formula for underdamping][],
que atualizou o cálculo subjacente. Como resultado, as animações afetadas anteriormente
agora se comportam de maneira diferente, embora nenhum erro explícito seja relatado pelo
framework.

## Guia de migração

A migração é necessária apenas para springs com relações de amortecimento menores que 1 e
massas diferentes de 1.

Para restaurar o comportamento de animação anterior, atualize os parâmetros da sua spring
de acordo. Você pode calcular os ajustes de parâmetros necessários usando o
[JSFiddle for migration][] fornecido. Fórmulas detalhadas e explicações seguem
nas próximas seções.

### Construtor padrão

Se o `SpringDescription` foi construído com o construtor padrão com
massa `m`, rigidez `k` e amortecimento `c`,
então ele deve ser alterado com a seguinte fórmula:

```plaintext
new_m = 1
new_c = c * m
new_k = (4 * (k / m) - (c / m)^2 + (c * m)^2) / 4
```

Código antes da migração:

```dart
const spring = SpringDescription(
  mass: 20.0,
  stiffness: 10,
  damping: 1,
);
```

Código após a migração:

```dart
const spring = SpringDescription(
  mass: 1.0,
  stiffness: 100.499375,
  damping: 20,
);
```

### Construtor `.withDampingRatio`

Se o `SpringDescription` foi construído com o construtor `.withDampingRatio`
com massa `m`, rigidez `k` e relação `z`, então primeiro calcule o amortecimento:

```plaintext
c = z * 2 * sqrt(m * k)
```

Em seguida, aplique a fórmula acima.
Opcionalmente, você pode converter o resultado de volta para a relação de amortecimento com:

```plaintext
new_z = new_c / 2 / sqrt(new_m * new_k)
```

Código antes da migração:

```dart
const spring = SpringDescription.withDampingRatio(
  mass: 5.0,
  stiffness: 6.0,
  damping: 0.03,
);
```

Código após a migração:

```dart
const spring = SpringDescription.withDampingRatio(
  mass: 1,
  stiffness: 1.87392,
  ratio: 0.60017287468545,
);
```

## Linha do tempo

Disponibilizado na versão: 3.31.0-0.1.pre<br>
Na versão estável: 3.32

## Referências

Documentação da API:

* [`SpringDescription`][]

Issues relevantes:

* [Issue 163858][], onde o bug foi descoberto e mais contexto pode ser encontrado.

PRs relevantes:

* [Fix SpringSimulation formula for underdamping][]

Ferramenta:
* [JSFiddle for migration][]

[Fix SpringSimulation formula for underdamping]: {{site.repo.flutter}}/pull/165017
[Issue 163858]: {{site.repo.flutter}}/issues/163858
[JSFiddle for migration]: https://jsfiddle.net/6jgvbzps/30/
[`SpringDescription`]: {{site.api}}/flutter/physics/SpringDescription-class.html
[Wikipedia: Damping]: https://en.wikipedia.org/wiki/Damping
