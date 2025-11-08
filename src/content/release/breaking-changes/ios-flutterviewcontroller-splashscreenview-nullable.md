---
title: splashScreenView do FlutterViewController do iOS tornado nullable
description: >
  splashScreenView do FlutterViewController alterado de nonnull para nullable.
ia-translate: true
---

## Resumo

A propriedade `splashScreenView` do `FlutterViewController` foi
alterada de `nonnull` para `nullable`.

Declaração antiga de `splashScreenView`:

```objc
@property(strong, nonatomic) UIView* splashScreenView;
```

Nova declaração de `splashScreenView`:

```objc
@property(strong, nonatomic, nullable) UIView* splashScreenView;
```

## Contexto

Antes desta mudança, no iOS a propriedade `splashScreenView` retornava `nil`
quando nenhuma view de splash screen estava definida, e
definir a propriedade como `nil` removia a view de splash screen.
No entanto, a API `splashScreenView` estava incorretamente marcada como `nonnull`.
Esta propriedade é mais frequentemente usada ao fazer transição para
views do Flutter em cenários de add-to-app no iOS.

## Descrição da mudança

Embora fosse possível em Objective-C contornar a
anotação `nonnull` incorreta definindo `splashScreenView` como
uma `UIView` `nil`, em Swift isso causava um erro de compilação:

```plaintext
error build: Value of optional type 'UIView?' must be unwrapped to a value of type 'UIView'
```

A [PR #34743][] atualiza o atributo da propriedade para `nullable`.
Ela pode retornar `nil` e pode ser definida como `nil` para
remover a view tanto em Objective-C quanto em Swift.

## Guia de migração

Se `splashScreenView` for armazenada em uma variável `UIView` em Swift,
atualize para um tipo opcional `UIView?`.

Código antes da migração:

```swift
  var splashScreenView = UIView()
  var flutterEngine = FlutterEngine(name: "my flutter engine")
  let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
  splashScreenView = flutterViewController.splashScreenView // erro de compilação: Value of optional type 'UIView?' must be unwrapped to a value of type 'UIView'
```

Código após a migração:

```swift
  var splashScreenView : UIView? = UIView()
  var flutterEngine = FlutterEngine(name: "my flutter engine")
  let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
  let splashScreenView = flutterViewController.splashScreenView // compila com sucesso
  if let splashScreenView = splashScreenView {
  }
```

## Linha do tempo

Na versão estável: 3.7

## Referências

PR relevante:

* [Make splashScreenView of FlutterViewController nullable][]

[Make splashScreenView of FlutterViewController nullable]: {{site.repo.engine}}/pull/34743
[PR #34743]: {{site.repo.engine}}/pull/34743
