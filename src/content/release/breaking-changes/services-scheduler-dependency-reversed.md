---
ia-translate: true
title: Revertendo a dependência entre o scheduler e a camada de serviços
description: A camada de serviços agora depende da camada do scheduler.
---

## Resumo

A camada de serviços agora depende da camada do scheduler.
Anteriormente, o oposto era verdadeiro. Isso pode afetá-lo
se você definiu associações personalizadas substituindo
`SchedulerBinding` ou `ServicesBinding` do Flutter.

## Contexto

Antes desta alteração, a camada do scheduler era dependente
da camada de serviços. Essa mudança reverte a cadeia de dependência
e permite que a camada de serviços utilize as primitivas de
agendamento na camada do scheduler. Por exemplo,
serviços na camada de serviços agora podem agendar tarefas usando
`SchedulerBinding.scheduleTask`.

## Descrição da mudança

A mudança afeta apenas os usuários que estão definindo suas próprias
associações personalizadas com base em `SchedulerBinding`
e `ServicesBinding` do Flutter.

## Guia de migração

Antes desta alteração, o `ServiceBinding` tinha que ser definido antes do
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

## Linha do tempo

Incluído na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`ServicesBinding`][]
* [`SchedulerBinding`][]

PRs relevantes:

* [Reverter dependência entre serviços e scheduler][]
* [Reverter workaround de dependência de bindings][]

[Reverter dependência entre serviços e scheduler]: {{site.repo.flutter}}/pull/54212
[Reverter workaround de dependência de bindings]: {{site.repo.flutter}}/pull/54286
[`SchedulerBinding`]: {{site.api}}/flutter/scheduler/SchedulerBinding-mixin.html
[`ServicesBinding`]: {{site.api}}/flutter/scheduler/ServicesBinding-mixin.html
