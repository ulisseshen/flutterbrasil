---
ia-translate: true
title: Depreciação de `findChildIndexCallback` em favor de `findItemIndexCallback` nos construtores separated de `ListView` e `SliverList`
description: >-
  O parâmetro findChildIndexCallback de ListView.separated e
  SliverList.separated foi depreciado em favor de findItemIndexCallback.
---

## Resumo {:#summary}

Os parâmetros `findChildIndexCallback` dos construtores `ListView.separated` e
`SliverList.separated` foram depreciados em favor de
`findItemIndexCallback`. O novo callback retorna os índices dos itens diretamente,
eliminando a necessidade de cálculos manuais de índice para considerar os separadores.

## Contexto {:#background}

Nos construtores `ListView.separated` e `SliverList.separated`,
o `findChildIndexCallback` era usado para localizar widgets pela sua key.
No entanto, esse callback retornava índices de filhos, que incluem tanto
os itens quanto os separadores na árvore interna de widgets. Isso significava que
os desenvolvedores precisavam multiplicar os índices dos itens por 2 para obter o
índice correto do filho, o que gerava confusão e código propenso a erros.

O novo parâmetro `findItemIndexCallback` simplifica isso, trabalhando
diretamente com os índices dos itens, que não incluem os separadores.
Isso torna a API mais intuitiva e reduz a probabilidade de
erros de cálculo de índice.

Se você usar o parâmetro depreciado `findChildIndexCallback`,
verá um aviso de depreciação:

```plaintext
'findChildIndexCallback' is deprecated and shouldn't be used.
Use findItemIndexCallback instead.
findChildIndexCallback returns child indices (which include separators),
while findItemIndexCallback returns item indices (which do not).
If you were multiplying results by 2 to account for separators,
you can remove that workaround when migrating to findItemIndexCallback.
This feature was deprecated after v3.37.0-1.0.pre.
```

Além disso, se você tentar fornecer os dois parâmetros, verá um erro de assertion:

```plaintext
Cannot provide both findItemIndexCallback and findChildIndexCallback.
Use findItemIndexCallback as findChildIndexCallback is deprecated.
```

## Guia de migração {:#migration-guide}

Para migrar de `findChildIndexCallback` para `findItemIndexCallback`,
troque o nome do parâmetro e remova quaisquer multiplicações de índice
usadas para considerar os separadores.

Código antes da migração:

```dart
ListView.separated(
  itemCount: items.length,
  findChildIndexCallback: (Key key) {
    final ValueKey<String> valueKey = key as ValueKey<String>;
    final int itemIndex = items.indexOf(valueKey.value);
    // Multiply by 2 to account for separators.
    return itemIndex == -1 ? null : itemIndex * 2;
  },
  itemBuilder: (BuildContext context, int index) {
    return ListTile(
      key: ValueKey<String>(items[index]),
      title: Text(items[index]),
    );
  },
  separatorBuilder: (BuildContext context, int index) => const Divider(),
)
```

Código após a migração:

```dart
ListView.separated(
  itemCount: items.length,
  findItemIndexCallback: (Key key) {
    final ValueKey<String> valueKey = key as ValueKey<String>;
    final int itemIndex = items.indexOf(valueKey.value);
    // Return item index directly - no need to multiply by 2.
    return itemIndex == -1 ? null : itemIndex;
  },
  itemBuilder: (BuildContext context, int index) {
    return ListTile(
      key: ValueKey<String>(items[index]),
      title: Text(items[index]),
    );
  },
  separatorBuilder: (BuildContext context, int index) => const Divider(),
)
```

A mesma migração se aplica a `SliverList.separated`:

Código antes da migração:

```dart
SliverList.separated(
  itemCount: items.length,
  findChildIndexCallback: (Key key) {
    final ValueKey<String> valueKey = key as ValueKey<String>;
    final int itemIndex = items.indexOf(valueKey.value);
    return itemIndex == -1 ? null : itemIndex * 2;
  },
  itemBuilder: (BuildContext context, int index) {
    return Container(
      key: ValueKey<String>(items[index]),
      child: Text(items[index]),
    );
  },
  separatorBuilder: (BuildContext context, int index) => const Divider(),
)
```

Código após a migração:

```dart
SliverList.separated(
  itemCount: items.length,
  findItemIndexCallback: (Key key) {
    final ValueKey<String> valueKey = key as ValueKey<String>;
    final int itemIndex = items.indexOf(valueKey.value);
    return itemIndex == -1 ? null : itemIndex;
  },
  itemBuilder: (BuildContext context, int index) {
    return Container(
      key: ValueKey<String>(items[index]),
      child: Text(items[index]),
    );
  },
  separatorBuilder: (BuildContext context, int index) => const Divider(),
)
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.38.0-1.0.pre<br>
Na versão estável: 3.41

## Referências {:#references}

Documentação da API:

* [`ListView.separated`][`ListView.separated`]
* [`SliverList.separated`][`SliverList.separated`]

PRs relevantes:

* [Depreciar findChildIndexCallback nos construtores separated][Deprecate findChildIndexCallback for separated constructors]

[`ListView.separated`]: {{site.api}}/flutter/widgets/ListView/ListView.separated.html
[`SliverList.separated`]: {{site.api}}/flutter/widgets/SliverList/SliverList.separated.html
[Deprecate findChildIndexCallback for separated constructors]: {{site.repo.flutter}}/pull/174491
