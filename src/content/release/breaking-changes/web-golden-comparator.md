---
title: Comparações golden específicas da Web não são mais suportadas
description: >-
  A classe `WebGoldenComparator` e a instância de nível superior `webGoldenComparator`
  foram descontinuadas, pendentes de remoção, e os backends de renderização web (incluindo
  tanto CanvasKit quanto skWasm) agora usam `GoldenFileComparator` e
  `goldenFileComparator` diretamente.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

O pacote `flutter_test` e a ferramenta `flutter` não usarão mais a
variável de nível superior [`webGoldenComparator`][], e em vez disso usarão a
variável de nível superior [`goldenFileComparator`][] original (como as plataformas não-web).

Para _usuários_ do `flutter_test`, essas alterações serão feitas automaticamente.

## Contexto

Originalmente, [`WebGoldenComparator`][class-WebGoldenComparator] foi adicionado para
o backend HTML do Flutter web, pois não era possível criar um PNG
codificado (buffer de bytes), e uma nova API era necessária. Como [o backend HTML está sendo
descontinuado e removido][Issue 145954], esta API separada não é mais necessária.

## Guia de migração

Para a maioria dos usuários, nenhuma alteração é necessária (além de migrar do backend HTML,
que não é coberto aqui), a ferramenta `flutter` configurará automaticamente
[`goldenFileComparator`][] e o usará (ao usar um backend web não-HTML).

Para usuários que implementam um [`WebGoldenComparator`][] personalizado, você
migrará a implementação para [`GoldenFileComparator`][]. Felizmente os
backends Canvas Kit e SkWasm já exigiam métodos semelhantes (`compareButes`
e `updateBytes`).

Por exemplo:

```dart
// Before
class MyWebGoldenComparator extends WebGoldenComparator {
  @override
  Future<bool> compare(double width, double height, Uri golden) {
    // will be removed in the migration
  }

  @override
  Future<bool> update(double width, double height, Uri golden) {
    // will be removed in the migration
  }

  @override
  Future<bool> compareBytes(Uint8List bytes, Uri golden) {
    // will be renamed "compare"
  }

  @override
  Future<bool> updateBytes(Uint8List bytes, Uri golden) {
    // will be renamed "update" and the parameter orders swapped
  }
}

// After
class MyGenericGoldenComparator extends GoldenFileComparator {
  @override
  Future<bool> compare(Uint8List bytes, Uri golden) {
    // used to be "compareBytes"
  }

  @override
  Future<bool> update(Uri golden, Uint8List bytes) {
    // used to be "updateBytes"
  }
}
```

## Linha do tempo

Disponibilizado na versão: 3.29.0-0.0.pre<br>
Na versão estável: 3.29

## Referências

Issues relevantes:

- [Issue 145954][], onde o renderizador HTML foi descontinuado.
- [Issue 160261][], onde foi proposto consolidar `GoldenFileComparator` e `WebGoldenComparator`.

PRs relevantes:

- [PR 161196][], onde `WebGoldenComparator` foi descontinuado e a CLI `flutter` começou a usar `goldenFileComparator`.

[Issue 145954]: {{site.github}}/flutter/flutter/issues/145954
[Issue 160261]: {{site.github}}/flutter/flutter/issues/160261
[PR 161196]: https://github.com/flutter/flutter/pull/161196
[class-WebGoldenComparator]: {{site.api}}/flutter/flutter_test/WebGoldenComparator-class.html
[`webGoldenComparator`]: {{site.api}}/flutter/flutter_test/webGoldenComparator.html
[`goldenFileComparator`]: {{site.api}}/flutter/flutter_test/goldenFileComparator.html
