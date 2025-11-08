# Notas de lançamento do DevTools 2.39.0

A versão 2.39.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Changed table columns to be sortable by default. - [#8175](https://github.com/flutter/devtools/pull/8175)
* Atualizado DevTools screen icons to match what is used in the Flutter-supported IDEs. - [#8181](https://github.com/flutter/devtools/pull/8181)

## Atualizações do Memory

* Habilitado offline analysis of memory snapshots, as well as support for viewing memory
data when an app disconnects. For example, this may happen when an app unexpectedly
crashes or hits an out-of-memory issue. - [#7843](https://github.com/flutter/devtools/pull/7843),
[#8093](https://github.com/flutter/devtools/pull/8093),
[#8096](https://github.com/flutter/devtools/pull/8096)

* Corrigido issue where the memory chart could cause the connected application to hit an
out of memory exception while allocating large, short-lived objects repeatedly. - [#8209](https://github.com/flutter/devtools/pull/8209)

## App size tool updates

* Adicionado UI polish to the file import views. [#8232](https://github.com/flutter/devtools/pull/8232)

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.39.0).
