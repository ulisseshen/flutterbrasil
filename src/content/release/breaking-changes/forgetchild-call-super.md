---
ia-translate: true
title: O método forgetChild() deve chamar super
description: >
    Qualquer subclasse de elemento que sobrescreva forgetChild é obrigada a chamar super.
---

## Resumo

Uma refatoração recente na detecção de duplicação de chave global agora exige que subclasses de `Element` que sobrescrevam `forgetChild()` chamem `super()`.

## Contexto

Ao encontrar uma duplicação de chave global que será limpa por uma reconstrução de elemento posterior, não devemos reportar a duplicação de chave global. Nossa implementação anterior lançava um erro assim que a duplicação era detectada e não esperava pela reconstrução caso o elemento com a chave global duplicada tivesse sido reconstruído.

A nova implementação acompanha todas as duplicações de chave global durante um ciclo de construção e verifica a duplicação de chave global apenas ao final desse ciclo, em vez de lançar um erro imediatamente. Como parte da refatoração, implementamos um mecanismo para remover a duplicação de chave global anterior em `forgetChild` caso a reconstrução tivesse ocorrido. Isso, no entanto, exige que todas as subclasses de `Element` que sobrescrevem `forgetChild` chamem o método `super`.

## Descrição da mudança

O `forgetChild` da classe abstrata `Element` possui uma implementação base para remover a reserva de chave global e é imposto pela meta tag `@mustCallSuper`. Todas as subclasses que sobrescrevem o método devem chamar `super`; caso contrário, o analisador mostra um erro de linting e a detecção de duplicação de chave global pode lançar um erro inesperado.

## Guia de migração

No exemplo a seguir, uma subclasse `Element` de um app sobrescreve o método `forgetChild`.

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

Incluído na versão: 1.16.3<br>
Em versão estável: 1.17

## Referências

Documentação da API:

*   [`Element`][]
*   [`forgetChild()`][]

Issues relevantes:

*   [Issue 43780][]

PRs relevantes:

*   [PR 43790: Fix global key error][]


[`Element`]: {{site.api}}/flutter/widgets/Element-class.html
[`forgetChild()`]: {{site.api}}/flutter/widgets/Element/forgetChild.html
[Issue 43780]: {{site.repo.flutter}}/issues/43780
[PR 43790: Fix global key error]: {{site.repo.flutter}}/pull/46183
