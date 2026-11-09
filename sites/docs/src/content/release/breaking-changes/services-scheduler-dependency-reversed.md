---
title: Inversão da dependência entre as camadas scheduler e services
description: A camada services agora depende da camada scheduler.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A camada services agora depende da camada scheduler.
Antes, era o contrário. Isso pode afetar você
se tiver definido bindings personalizados que substituem
`SchedulerBinding` ou `ServicesBinding` do Flutter.

## Contexto {:#context}

Antes desta mudança, a camada scheduler dependia
da camada services. Esta mudança inverte a cadeia de dependência e
permite que a camada services use as primitivas de agendamento da
camada scheduler. Por exemplo, serviços na camada services agora podem
agendar tarefas usando `SchedulerBinding.scheduleTask`.

## Descrição da mudança {:#description-of-change}

A mudança afeta apenas usuários que definem seus próprios bindings
personalizados baseados em `SchedulerBinding` e `ServicesBinding`
do Flutter.

## Guia de migração {:#migration-guide}

Antes desta mudança, o `ServiceBinding` precisava ser definido antes do
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

## Linha do tempo {:#timeline}

Incluído na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências {:#references}

Documentação da API:

* [`ServicesBinding`][`ServicesBinding`]
* [`SchedulerBinding`][`SchedulerBinding`]

PRs relevantes:

* [Inversão da dependência entre services e scheduler][Reverse dependency between services and scheduler]
* [Reversão do workaround de dependência dos bindings][Revert bindings dependency workaround]

[Reverse dependency between services and scheduler]: {{site.repo.flutter}}/pull/54212
[Revert bindings dependency workaround]: {{site.repo.flutter}}/pull/54286
[`SchedulerBinding`]: {{site.api}}/flutter/scheduler/SchedulerBinding-mixin.html
[`ServicesBinding`]: {{site.api}}/flutter/scheduler/ServicesBinding-mixin.html
