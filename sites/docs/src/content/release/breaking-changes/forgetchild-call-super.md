---
ia-translate: true
title: O método forgetChild() deve chamar super
description: >
    Qualquer subclasse de element que sobrescreva forgetChild é obrigada a chamar super.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Uma refatoração recente da detecção de duplicação de global key agora requer que
subclasses de `Element` que sobrescrevam o `forgetChild()` chamem `super()`.

## Contexto

Ao encontrar uma duplicação de global key que será
limpa por uma reconstrução de element posteriormente,
não devemos reportar duplicação de global key.
Nossa implementação anterior lançava um erro assim que
a duplicação era detectada, e não esperava pela reconstrução se o
element com a global key duplicada fosse reconstruído.

A nova implementação mantém o rastreamento de todas as
duplicações de global key durante um ciclo de build, e apenas verifica a
duplicação de global key no final daquele ciclo ao invés de
lançar um erro imediatamente. Como parte da refatoração,
implementamos um mecanismo para remover a duplicação de global key
anterior em `forgetChild` se a reconstrução havia acontecido.
Isso, no entanto, requer que todas as subclasses de `Element` que
sobrescrevam `forgetChild` chamem o método `super`.

## Descrição da mudança

O `forgetChild` da classe abstrata `Element` tem uma
implementação base para remover a reserva de global key,
e é imposta pela meta tag `@mustCallSuper`.
Todas as subclasses que sobrescrevem o método têm que chamar `super`;
caso contrário, o analyzer mostra um erro de linting e
a detecção de duplicação de global key pode lançar um erro inesperado.

## Guia de migração

No exemplo a seguir, uma subclasse de `Element` de um app
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

## Cronograma

Aterrissou na versão: 1.16.3<br>
No lançamento estável: 1.17

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
