---
ia-translate: true
title: "Mensagem de \"incompatibilidade de Zone\""
description: >
  Quando os bindings do Flutter são inicializados em um Zone diferente do
  Zone usado para `runApp`, um aviso é impresso no console.
---

## Resumo

A partir do Flutter 3.10, o framework detecta incompatibilidades
ao usar Zones e as reporta para o console em builds de depuração.

## Contexto

Zones são um mecanismo para gerenciar callbacks em Dart.
Embora sejam primariamente úteis para sobrescrever a lógica de `print` e `Timer` em testes,
e para capturar erros em testes,
eles às vezes são usados para escopo de variáveis globais
para certas partes de um aplicativo.

O Flutter requer (e sempre exigiu)
que todo o código do framework seja executado no mesmo zone.
Notavelmente, isso significa que chamadas para
`WidgetsFlutterBinding.ensureInitialized()` devem ser executadas no mesmo zone
que as chamadas para `runApp()`.

Historicamente, o Flutter não detectava tais incompatibilidades.
Isso às vezes leva a problemas obscuros e difíceis de depurar.
Por exemplo,
um callback para entrada de teclado pode ser invocado
usando um zone que não tem acesso aos `zoneValues` que espera.
Em nossa experiência,
a maioria, senão todo o código que usa Zones
de uma forma que não garante que todas as partes do
framework Flutter estão funcionando no mesmo Zone
tem algum bug latente.
Frequentemente, esses bugs parecem não relacionados ao uso de Zones.

Para ajudar os desenvolvedores que violaram acidentalmente essa invariante,
a partir do Flutter 3.10,
um aviso não fatal é impresso em builds de depuração quando uma incompatibilidade é detectada.
O aviso se parece com o seguinte:

```plaintext
════════ Exceção capturada pelo framework Flutter ════════════════════════════════════
A seguinte asserção foi lançada durante runApp:
Incompatibilidade de Zone.

Os bindings do Flutter foram inicializados em um zone diferente do que está sendo usado agora.
Isso provavelmente causará confusão e bugs, pois qualquer configuração específica do zone usará
inconsistentemente a configuração do zone de inicialização do binding original ou
este zone com base em fatores difíceis de prever, como qual zone estava ativo quando um
callback particular foi definido.
É importante usar o mesmo zone ao chamar `ensureInitialized` no
binding como ao chamar `runApp` posteriormente.
Para tornar este aviso fatal, defina BindingBase.debugZoneErrorsAreFatal como true antes
que os bindings sejam inicializados (ou seja, como a primeira instrução em `void main() { }`).
[...]
═══════════════════════════════════════════════════════════════════════════════════
```

O aviso pode ser tornado fatal
definindo [`BindingBase.debugZoneErrorsAreFatal`][] como `true`.
Esta flag pode ser alterada para `true` por padrão em uma versão futura do Flutter.

## Guia de migração

A melhor maneira de silenciar esta mensagem é
remover o uso de Zones de dentro do aplicativo.
Zones podem ser muito difíceis de depurar,
porque são essencialmente variáveis globais,
e quebram o encapsulamento.
A melhor prática é evitar variáveis globais e zones.

Se remover zones não for uma opção
(por exemplo, porque o aplicativo depende de uma biblioteca de terceiros
que depende de zones para sua configuração),
então as várias chamadas para o framework Flutter
devem ser movidas para estarem todas no mesmo zone.
Tipicamente, isso significa mover a chamada para
`WidgetsFlutterBinding.ensureInitialized()` para o
mesmo closure que a chamada para `runApp()`.

Isso pode ser complicado quando o zone no qual `runApp` é executado
está sendo inicializado com `zoneValues` obtidos de um plugin
(o que requer que `WidgetsFlutterBinding.ensureInitialized()`
tenha sido chamado).

Uma opção neste tipo de cenário é
colocar um objeto mutável nos `zoneValues`, e
atualizar esse objeto com o valor assim que o valor estiver disponível.

```dart
import 'dart:async';
import 'package:flutter/material.dart';

class Mutable<T> {
  Mutable(this.value);
  T value;
}

void main() {
  var myValue = Mutable<double>(0.0);
  Zone.current.fork(
    zoneValues: {
      'myKey': myValue,
    }
  ).run(() {
    WidgetsFlutterBinding.ensureInitialized();
    var newValue = ...; // obter valor do plugin
    myValue.value = newValue; // atualizar valor no Zone
    runApp(...);
  });
}
```

Em código que precisa usar `myKey`,
ele pode ser obtido indiretamente usando `Zone.current['myKey'].value`.

Quando tal solução não funciona
porque uma dependência de terceiros requer o uso
de um tipo específico para uma chave `zoneValues` específica,
todas as chamadas para a dependência podem ser
envolvidas em chamadas `Zone` que fornecem valores adequados.

É fortemente recomendado que os pacotes que usam zones desta forma
migrem para soluções mais sustentáveis.

## Cronologia

Incluído na versão: 3.9.0-9.0.pre<br>
Na versão estável: 3.10.0

## Referências

Documentação da API:

* [`Zone`][]
* [`BindingBase.debugZoneErrorsAreFatal`][]

Problemas relevantes:

* [Issue 94123][]: O framework Flutter não avisa quando ensureInitialized
  é chamado em um zone diferente de runApp

PRs relevantes:

* [PR 122836][]: Asserir que runApp é chamado
  no mesmo zone que binding.ensureInitialized

[`Zone`]: {{site.api}}/flutter/dart-async/Zone-class.html
[`BindingBase.debugZoneErrorsAreFatal`]: {{site.api}}/flutter/foundation/BindingBase/debugZoneErrorsAreFatal.html
[Issue 94123]: {{site.repo.flutter}}/issues/94123
[PR 122836]: {{site.repo.flutter}}/pull/122836
