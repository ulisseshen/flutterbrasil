# Notas de lançamento do DevTools 2.38.0

A versão 2.38.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações do Performance

* Renamed the "Track" builds, paints, and layouts settings to "Trace"
builds, paints, and layouts. - [#8084](https://github.com/flutter/devtools/pull/8084)
* Renamed the "Track widget build counts" setting to "Count widget builds". - [#8084](https://github.com/flutter/devtools/pull/8084)

## Atualizações do Debugger

* Adicionado recommendation to debug code from an IDE, with links to IDE instructions. - [#8085](https://github.com/flutter/devtools/pull/8085)

## Atualizações do Network profiler

* Adicionado support to export network requests as a HAR file (thanks to @hrajwade96!). - [#7970](https://github.com/flutter/devtools/pull/7970)

## DevTools Extension updates

* Corrigido an issue where extensions did not load with the proper theme when
embedded in an IDE. - [#8034](https://github.com/flutter/devtools/pull/8034)
* Adicionado an API for copying text to clipboard by proxy of the parent DevTools web app, which has
workarounds for copy issues when embedded inside an IDE. - [#8130](https://github.com/flutter/devtools/pull/8130)

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.38.0).
