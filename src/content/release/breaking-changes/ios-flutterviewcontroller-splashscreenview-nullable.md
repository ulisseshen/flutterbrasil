---
ia-translate: true
title: iOS FlutterViewController splashScreenView tornado anulável
description: >
  FlutterViewController splashScreenView alterado de não nulo para anulável.
---

## Sumário

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

Antes desta alteração, no iOS a propriedade `splashScreenView` retornava `nil`
quando nenhuma view de tela inicial estava definida, e
definir a propriedade como `nil` removia a view de tela inicial.
No entanto, a API `splashScreenView` estava incorretamente marcada como `nonnull`.
Essa propriedade é mais frequentemente usada ao fazer a transição para
views do Flutter em cenários de adicionar-ao-app no iOS.

## Descrição da alteração

Embora fosse possível em Objective-C contornar a
anotação incorreta `nonnull` definindo `splashScreenView` para
um `UIView` `nil`, em Swift isso causava um erro de compilação:

```plaintext
error build: Value of optional type 'UIView?' must be unwrapped to a value of type 'UIView'
```

O [PR #34743][] atualiza o atributo da propriedade para `nullable`.
Ele pode retornar `nil` e pode ser definido como `nil` para
remover a view tanto em Objective-C quanto em Swift.

## Guia de migração

Se `splashScreenView` for armazenado em uma variável `UIView` em Swift,
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

Em versão estável: 3.7

## Referências

PR relevante:

* [Tornar splashScreenView de FlutterViewController anulável][]

[Tornar splashScreenView de FlutterViewController anulável]: {{site.repo.engine}}/pull/34743
[PR #34743]: {{site.repo.engine}}/pull/34743
