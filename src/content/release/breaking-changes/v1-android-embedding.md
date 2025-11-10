---
title: Remoção das APIs Java do Android v1 embedding
description: >-
  Saiba como considerar a remoção das APIs do Android v1 embedding.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

O v1 embedding do Android foi removido no Flutter 3.29.0.
Isso segue a descontinuação descrita em
[Android v1 embedding app and plugin creation deprecation][].
A seguir está uma lista completa das classes removidas.

```text
io.flutter.app.FlutterActivity
io.flutter.app.FlutterActivityDelegate
io.flutter.app.FlutterActivityEvents
io.flutter.app.FlutterApplication
io.flutter.app.FlutterFragmentActivity
io.flutter.app.FlutterPlayStoreSplitApplication
io.flutter.app.FlutterPluginRegistry

io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
io.flutter.embedding.engine.plugins.shim.ShimRegistrar

io.flutter.view.FlutterMain
io.flutter.view.FlutterNativeView
io.flutter.view.FlutterView
```

Se seu projeto referencia qualquer uma das classes acima, consulte a
lista a seguir para instruções sobre migração.

* `io.flutter.app.FlutterActivity` foi
   substituído por `io.flutter.embedding.android.FlutterActivity`.
* `io.flutter.app.FlutterActivityDelegate` foi
   substituído por `io.flutter.embedding.android.FlutterActivityAndFragmentDelegate`.
* `io.flutter.app.FlutterActivityEvents` foi removido.
* `io.flutter.app.FlutterApplication` foi removido.
   Projetos Flutter com implementações personalizadas de `Application` devem
   em vez disso estender a base `android.app.Application`.
* `io.flutter.app.FlutterFragmentActivity` foi
  substituído por `io.flutter.embedding.android.FlutterFragmentActivity`.
* `io.flutter.app.FlutterPlayStoreSplitApplication` foi
  substituído por `io.flutter.embedding.android.FlutterPlayStoreSplitApplication`.
* `io.flutter.app.FlutterPluginRegistry` foi removido,
   pois servia apenas para permitir que plugins suportassem aplicativos usando o v1 embedding.
* `io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry` foi removido,
   pois servia apenas para permitir que plugins suportassem aplicativos usando o v1 embedding.
* `io.flutter.embedding.engine.plugins.shim.ShimRegistrar` foi removido,
   pois servia apenas para permitir que plugins suportassem aplicativos usando o v1 embedding.
* `io.flutter.view.FlutterMain` foi
   substituído por `io.flutter.embedding.engine.loader.FlutterLoader`.
* `io.flutter.view.FlutterNativeView` foi
   substituído por `io.flutter.embedding.android.FlutterView`.
* `io.flutter.view.FlutterView` foi
   substituído por `io.flutter.embedding.android.FlutterView`.

[Android v1 embedding app and plugin creation deprecation]: /release/breaking-changes/android-v1-embedding-create-deprecation

## Autores de plugins

Plugins devem remover o método `registerWith` de
sua implementação da interface `FlutterPlugin`:

```java
public static void registerWith(@NonNull io.flutter.plugin.common.PluginRegistry.Registrar registrar);
```

Para um exemplo desta migração,
confira o pull request para remover este método dos
plugins de propriedade da equipe Flutter: [flutter/packages#6494][].

[flutter/packages#6494]: {{site.github}}/flutter/packages/pull/6494

## Linha do tempo

Disponibilizado na versão: 3.28.0-0.1.pre<br>
Na versão estável: 3.29
