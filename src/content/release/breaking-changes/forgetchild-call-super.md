---
title: O método forgetChild() deve chamar super
description: >
    Quaisquer subclasses de element que sobrescrevem forgetChild são obrigadas a chamar super.
ia-translate: true
---

## Resumo

Uma recente refatoração de detecção de duplicação de chave global agora requer
que subclasses de `Element` que sobrescrevem o `forgetChild()` chamem `super()`.

## Contexto

Ao encontrar uma duplicação de chave global que será
limpa por uma reconstrução de elemento posteriormente,
não devemos reportar duplicação de chave global.
Nossa implementação anterior lançava um erro assim que
a duplicação era detectada, e não esperava pela reconstrução se o
elemento com a chave global duplicada fosse ser reconstruído.

A nova implementação mantém rastreamento de todas as
duplicações de chave global durante um ciclo de build, e apenas verifica
duplicação de chave global no final desse ciclo em vez de
lançar um erro imediatamente. Como parte da refatoração,
implementamos um mecanismo para remover duplicação de chave global
anterior em `forgetChild` se a reconstrução tivesse acontecido.
Isso, no entanto, requer que todas as subclasses de `Element` que
sobrescrevem `forgetChild` chamem o método `super`.

## Descrição da mudança

O `forgetChild` da classe abstrata `Element` tem uma implementação
base para remover reserva de chave global,
e é enforçado pela meta tag `@mustCallSuper`.
Todas as subclasses que sobrescrevem o método têm que chamar `super`;
caso contrário, o analyzer mostra um erro de linting e
a detecção de duplicação de chave global pode lançar um erro inesperado.

## Guia de migração

No exemplo seguinte, a subclasse `Element` de um aplicativo
sobrescreve o método `forgetChild`.

Código antes da migração:

```dart
class CustomElement extends Element {

    @override
    void forgetChild(Element child) {
        ...
    }
}
```

Código após a migração:

```dart
class CustomElement extends Element {

    @override
    void forgetChild(Element child) {
        ...
        super.forgetChild(child);
    }
}
```

## Linha do tempo

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`Element`][]
* [`forgetChild()`][]

Issues relevantes:

* [Issue 43780][]

PRs relevantes:

* [PR 43790: Fix global key error][]


[`Element`]: {{site.api}}/flutter/widgets/Element-class.html
[`forgetChild()`]: {{site.api}}/flutter/widgets/Element/forgetChild.html
[Issue 43780]: {{site.repo.flutter}}/issues/43780
[PR 43790: Fix global key error]: {{site.repo.flutter}}/pull/46183
