---
ia-translate: true
title: Mudança na assinatura do método attachToActivity de ActivityControlSurface no Android
description: >
  O parâmetro `activity` de `attachToActivity` foi alterado para
  `ExclusiveAppComponent` em vez de `Activity`.
---

## Resumo

:::note
Se você usa classes Java de incorporação Android padrão, como
[`FlutterActivity`][] ou [`FlutterFragment`][],
e não incorpora manualmente uma [`FlutterView`][]
dentro de sua própria `Activity` personalizada (o que deve ser incomum),
você pode parar de ler.
:::

Um novo método [`ActivityControlSurface`][]:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

está substituindo o método agora obsoleto:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

O método obsoleto existente com o parâmetro `Activity`
foi removido no Flutter 2.

## Contexto

Para que as Activities personalizadas também forneçam os eventos
de ciclo de vida `Activity` que os plugins do Flutter esperam
usando a interface [`ActivityAware`][], o [`FlutterEngine`][]
expôs uma API [`getActivityControlSurface()`][].

Isso permite que Activities personalizadas sinalizem para o engine
(com o qual tem um relacionamento `(0|1):1`) que
estava sendo anexado ou desanexado do engine.

:::note
Essa sinalização de ciclo de vida é feita automaticamente quando você
usa o [`FlutterActivity`][] ou [`FlutterFragment`][] que já vem com o engine,
que deve ser o caso mais comum.
:::

No entanto, a API anterior tinha a falha de que não
aplicava a exclusão entre as activities que se conectam ao
engine, permitindo assim relacionamentos `n:1` entre
a activity e o engine,
causando problemas de crosstalk no ciclo de vida.

## Descrição da mudança

Após o [Issue #21272][], em vez de anexar sua activity
ao [`FlutterEngine`][] usando:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

API, que agora está obsoleta, use:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

Uma interface `ExclusiveAppComponent<Activity>`
é esperada agora em vez de uma `Activity`.
O `ExclusiveAppComponent<Activity>` fornece um callback
caso sua activity exclusiva esteja sendo substituída por
outra activity que esteja se anexando ao `FlutterEngine`.

```java
void detachFromActivity();
```

A API permanece inalterada e ainda se espera
que você a chame quando sua activity
personalizada estiver sendo destruída naturalmente.

## Guia de migração

Se você tem sua própria activity que contém uma
[`FlutterView`][], substitua as chamadas para:

```java
void attachToActivity(@NonNull Activity activity, @NonNull Lifecycle lifecycle);
```

por chamadas para:

```java
void attachToActivity(
    @NonNull ExclusiveAppComponent<Activity> exclusiveActivity,
    @NonNull Lifecycle lifecycle);
```

na [`ActivityControlSurface`][] que você obteve chamando
[`getActivityControlSurface()`][] no [`FlutterEngine`][].

Envolva sua activity com um `ExclusiveAppComponent<Activity>`
e implemente o método de callback:

```java
void detachFromFlutterEngine();
```

para lidar com sua activity sendo substituída por outra
activity sendo anexada ao [`FlutterEngine`][].
Geralmente, você deseja realizar as mesmas operações de desanexação
executadas quando a activity está sendo destruída naturalmente.

## Cronograma

Implementado na versão: 1.23.0-7.0.pre<br>
Na versão estável: 2.0.0

## Referências

Bug motivador: [Issue #66192][] — Componentes de UI não exclusivos anexados ao FlutterEngine causam crosstalk de eventos

[`ActivityAware`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityAware.html
[`ActivityControlSurface`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/activity/ActivityControlSurface.html
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[`FlutterView`]: {{site.api}}/javadoc/io/flutter/view/FlutterView.html
[`getActivityControlSurface()`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html#getActivityControlSurface--
[Issue #66192]: {{site.repo.flutter}}/issues/66192
[Issue #21272]: {{site.repo.engine}}/pull/21272

