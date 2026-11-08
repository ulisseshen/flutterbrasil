---
title: Mudança na assinatura do attachToActivity do ActivityControlSurface do Android
description: >
  O parâmetro activity do attachToActivity mudou para
  ExclusiveAppComponent em vez de Activity.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

:::note
Se você usa classes Java de embedding Android padrão como
[`FlutterActivity`][] ou [`FlutterFragment`][],
e não incorpora manualmente um [`FlutterView`][]
dentro de sua própria `Activity` personalizada (isso deve ser incomum),
você pode parar de ler.
:::

Um novo método [`ActivityControlSurface`][]:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

está substituindo o método agora descontinuado:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

O método descontinuado existente com o parâmetro `Activity`
foi removido no Flutter 2.

## Contexto

Para que Activities personalizados também forneçam os eventos
de ciclo de vida de `Activity` que plugins Flutter esperam usando a
interface [`ActivityAware`][], o [`FlutterEngine`][]
expôs uma API [`getActivityControlSurface()`][].

Isso permite que Activities personalizados sinalizem ao engine
(com o qual tem um relacionamento `(0|1):1`) que
estava sendo anexado ou desanexado do engine.

:::note
Esta sinalização de ciclo de vida é feita automaticamente quando você
usa os [`FlutterActivity`][] ou [`FlutterFragment`][]
empacotados do engine, que deve ser o caso
mais comum.
:::

No entanto, a API anterior tinha a falha de não
impor exclusão entre activities conectando ao
engine, assim habilitando relacionamentos `n:1` entre
o activity e o engine,
causando problemas de cross-talk de ciclo de vida.

## Descrição da mudança

Após [Issue #21272][], em vez de anexar seu activity
ao [`FlutterEngine`][] usando a:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

API, que agora está descontinuada, use em vez disso:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

Uma interface `ExclusiveAppComponent<Activity>`
é agora esperada em vez de um `Activity`.
O `ExclusiveAppComponent<Activity>` fornece um callback
caso seu activity exclusivo esteja sendo substituído por
outro activity se anexando ao `FlutterEngine`.

```java
void detachFromActivity();
```

A API permanece inalterada e você ainda é esperado
para chamá-la quando seu activity
personalizado está sendo destruído naturalmente.

## Guia de migração

Se você tem seu próprio activity contendo um
[`FlutterView`][], substitua chamadas a:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

por chamadas a:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

no [`ActivityControlSurface`][] que você obteve chamando
[`getActivityControlSurface()`][] no [`FlutterEngine`][].

Envolva seu activity com um `ExclusiveAppComponent<Activity>`
e implemente o método de callback:

```java
void detachFromFlutterEngine();
```

para lidar com seu activity sendo substituído por outro
activity sendo anexado ao [`FlutterEngine`][].
Geralmente, você quer realizar as mesmas operações de desanexação
como realizadas quando o activity está sendo destruído naturalmente.

## Linha do tempo

Lançado na versão: 1.23.0-7.0.pre<br>
Na versão estável: 2.0.0

## Referências

Bug motivador: [Issue #66192][]—Componentes de
UI não exclusivos anexados ao FlutterEngine causam
crosstalk de eventos


[`ActivityAware`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityAware.html
[`ActivityControlSurface`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityControlSurface.html
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[`FlutterView`]: {{site.api}}/javadoc/io/flutter/view/FlutterView.html
[`getActivityControlSurface()`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html#getActivityControlSurface--
[Issue #66192]: {{site.repo.flutter}}/issues/66192.
[Issue #21272]: {{site.repo.engine}}/pull/21272
