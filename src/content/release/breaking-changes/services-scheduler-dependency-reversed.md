---
ia-translate: true
title: Revertendo a dependência entre as camadas scheduler e services
description: A camada services agora depende da camada scheduler.
---

## Resumo

A camada services agora depende da camada scheduler.
Anteriormente, o oposto era verdadeiro. Isso pode afetar você
se você definiu bindings personalizados sobrescrevendo
o `SchedulerBinding` ou `ServicesBinding` do Flutter.

## Contexto

Antes desta mudança, a camada scheduler era dependente
da camada services. Esta mudança reverte a cadeia de dependência
e permite que a camada services faça uso das
primitivas de agendamento na camada scheduler. Por exemplo,
serviços na camada services agora podem agendar tarefas usando
`SchedulerBinding.scheduleTask`.

## Descrição da mudança

A mudança afeta apenas usuários que estão definindo seus próprios
bindings personalizados baseados no `SchedulerBinding`
e `ServicesBinding` do Flutter.

## Guia de migração

Antes desta mudança, o `ServiceBinding` tinha que ser definido antes do
`SchedulerBinding`. Com esta mudança, é o contrário:

Código antes da migração:

```dart
class FooBinding extends BindingBase with ServicesBinding, SchedulerBinding {
 // ...
}
```

Código após a migração:

```dart
class FooBinding extends BindingBase with SchedulerBinding, ServicesBinding {
 // ...
}
```

## Cronograma

Adicionado na versão: 1.18.0<br>
Na versão stable: 1.20

## Referências

Documentação da API:

* [`ServicesBinding`][]
* [`SchedulerBinding`][]

PRs relevantes:

* [Reverse dependency between services and scheduler][]
* [Revert bindings dependency workaround][]

[Reverse dependency between services and scheduler]: {{site.repo.flutter}}/pull/54212
[Revert bindings dependency workaround]: {{site.repo.flutter}}/pull/54286
[`SchedulerBinding`]: {{site.api}}/flutter/scheduler/SchedulerBinding-mixin.html
[`ServicesBinding`]: {{site.api}}/flutter/scheduler/ServicesBinding-mixin.html
