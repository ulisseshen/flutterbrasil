---
title: iOS FlutterViewController splashScreenView tornado anulável
description: >
  FlutterViewController splashScreenView mudou de nonnull para nullable.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A propriedade `splashScreenView` de `FlutterViewController` foi
alterada de `nonnull` para `nullable`.

Declaração antiga de `splashScreenView`:

```objc
@property(strong, nonatomic) UIView* splashScreenView;
```

Nova declaração de `splashScreenView`:

```objc
@property(strong, nonatomic, nullable) UIView* splashScreenView;
```

## Contexto {:#context}

Antes desta mudança, no iOS a propriedade `splashScreenView` retornava `nil`
quando nenhuma view de splash screen estava definida, e
definir a propriedade como `nil` removia a view de splash screen.
No entanto, a API `splashScreenView` estava incorretamente marcada como `nonnull`.
Esta propriedade é usada com mais frequência ao fazer transição para
views Flutter em cenários de add-to-app no iOS.

## Descrição da mudança {:#description-of-change}

Embora fosse possível em Objective-C contornar a
anotação `nonnull` incorreta definindo `splashScreenView` como
um `UIView` `nil`, no Swift isso causava um erro de compilação:

```plaintext
error build: Value of optional type 'UIView?' must be unwrapped to a value of type 'UIView'
```

[PR #34743][] atualiza o atributo da propriedade para `nullable`.
Ela pode retornar `nil` e pode ser definida como `nil` para
remover a view tanto em Objective-C quanto em Swift.

## Guia de migração {:#migration-guide}

Se `splashScreenView` está armazenada em uma variável `UIView` no Swift,
atualize para um tipo opcional `UIView?`.

Código antes da migração:

```swift
  var splashScreenView = UIView()
  var flutterEngine = FlutterEngine(name: "my flutter engine")
  let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
  splashScreenView = flutterViewController.splashScreenView // compilation error: Value of optional type 'UIView?' must be unwrapped to a value of type 'UIView'
```

Código após a migração:

```swift
  var splashScreenView : UIView? = UIView()
  var flutterEngine = FlutterEngine(name: "my flutter engine")
  let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
  let splashScreenView = flutterViewController.splashScreenView // compiles successfully
  if let splashScreenView = splashScreenView {
  }
```

## Cronograma {:#timeline}

Na versão estável: 3.7

## Referências {:#references}

PR relevante:

* [Make splashScreenView of FlutterViewController nullable][]

[Make splashScreenView of FlutterViewController nullable]: {{site.repo.engine}}/pull/34743
[PR #34743]: {{site.repo.engine}}/pull/34743
