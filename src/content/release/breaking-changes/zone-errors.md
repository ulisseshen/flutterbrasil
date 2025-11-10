---
title: "Mensagem \"Zone mismatch\""
description: >
  Quando os bindings do Flutter são inicializados em uma zone diferente
  da Zone usada para `runApp`, um aviso é impresso no console.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

A partir do Flutter 3.10, o framework detecta incompatibilidades
ao usar Zones e as reporta ao console em builds de debug.

## Contexto

Zones são um mecanismo para gerenciar callbacks em Dart.
Embora primariamente úteis para sobrescrever lógica de `print` e `Timer` em testes,
e para capturar erros em testes,
elas são às vezes usadas para delimitar variáveis globais
a certas partes de uma aplicação.

Flutter requer (e sempre requereu)
que todo código de framework seja executado na mesma zone.
Notavelmente, isso significa que chamadas a
`WidgetsFlutterBinding.ensureInitialized()` devem ser executadas na mesma zone
que chamadas a `runApp()`.

Historicamente, Flutter não detectou tais incompatibilidades.
Isso às vezes leva a problemas obscuros e difíceis de depurar.
Por exemplo,
um callback para entrada de teclado pode ser invocado
usando uma zone que não tem acesso aos `zoneValues` que espera.
Em nossa experiência,
a maioria se não todo código que usa Zones
de uma forma que não garante que todas as partes do
framework Flutter estejam trabalhando na mesma Zone
tem algum bug latente.
Frequentemente esses bugs parecem não relacionados ao uso de Zones.

Para ajudar desenvolvedores que acidentalmente violaram esta invariante,
a partir do Flutter 3.10,
um aviso não-fatal é impresso em builds de debug quando uma incompatibilidade é detectada.
O aviso se parece com o seguinte:

```plaintext
════════ Exception caught by Flutter framework ════════════════════════════════════
The following assertion was thrown during runApp:
Zone mismatch.

The Flutter bindings were initialized in a different zone than is now being used.
This will likely cause confusion and bugs as any zone-specific configuration will
inconsistently use the configuration of the original binding initialization zone or
this zone based on hard-to-predict factors such as which zone was active when a
particular callback was set.
It is important to use the same zone when calling `ensureInitialized` on the
binding as when calling `runApp` later.
To make this warning fatal, set BindingBase.debugZoneErrorsAreFatal to true before
the bindings are initialized (i.e. as the first statement in `void main() { }`).
[...]
═══════════════════════════════════════════════════════════════════════════════════
```

O aviso pode ser tornado fatal
definindo [`BindingBase.debugZoneErrorsAreFatal`][] como `true`.
Esta flag pode ser alterada para padrão `true` em uma versão futura do Flutter.

## Guia de migração

A melhor maneira de silenciar esta mensagem é
remover o uso de Zones de dentro da aplicação.
Zones podem ser muito difíceis de depurar,
porque são essencialmente variáveis globais,
e quebram encapsulamento.
A melhor prática é evitar variáveis globais e zones.

Se remover zones não é uma opção
(por exemplo porque a aplicação depende de uma biblioteca de terceiros
que depende de zones para sua configuração),
então as várias chamadas ao framework Flutter
devem ser movidas para todas estarem na mesma zone.
Tipicamente, isso significa mover a chamada a
`WidgetsFlutterBinding.ensureInitialized()` para o
mesmo closure que a chamada a `runApp()`.

Isso pode ser inconveniente quando a zone na qual `runApp` é executado
está sendo inicializada com `zoneValues` obtidos de um plugin
(que requer que `WidgetsFlutterBinding.ensureInitialized()`
tenha sido chamado).

Uma opção neste tipo de cenário é
colocar um objeto mutável nos `zoneValues`, e
atualizar esse objeto com o valor uma vez que o valor esteja disponível.

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
    var newValue = ...; // obtain value from plugin
    myValue.value = newValue; // update value in Zone
    runApp(...);
  });
}
```

Em código que precisa usar `myKey`,
ele pode ser obtido indiretamente usando `Zone.current['myKey'].value`.

Quando tal solução não funciona
porque uma dependência de terceiros requer o uso
de um tipo específico para uma chave `zoneValues` específica,
todas as chamadas à dependência podem ser
envolvidas em chamadas `Zone` que fornecem valores adequados.

É fortemente recomendado que packages que usam zones desta forma
migrem para soluções mais manuteníveis.

## Linha do tempo

Lançado na versão: 3.9.0-9.0.pre<br>
Na versão estável: 3.10.0

## Referências

Documentação da API:

* [`Zone`][]
* [`BindingBase.debugZoneErrorsAreFatal`][]

Issues relevantes:

* [Issue 94123][]: Flutter framework não avisa quando ensureInitialized
  é chamado em uma zone diferente de runApp

PRs relevantes:

* [PR 122836][]: Assert que runApp é chamado
  na mesma zone que binding.ensureInitialized

[`Zone`]: {{site.api}}/flutter/dart-async/Zone-class.html
[`BindingBase.debugZoneErrorsAreFatal`]: {{site.api}}/flutter/foundation/BindingBase/debugZoneErrorsAreFatal.html
[Issue 94123]: {{site.repo.flutter}}/issues/94123
[PR 122836]: {{site.repo.flutter}}/pull/122836
