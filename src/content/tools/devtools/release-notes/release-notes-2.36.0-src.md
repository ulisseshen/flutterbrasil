# Notas de lançamento do DevTools 2.36.0

A versão 2.36.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações do Performance

* Adicionado a feature for showing widget build counts.
  Enable this setting to see widget build counts for
  each Flutter frame in the "Frame Analysis" tool, or to see
  an aggregate summary of these counts in the new "Rebuild Stats" tool. -
  [#7838](https://github.com/flutter/devtools/pull/7838), [#7847](https://github.com/flutter/devtools/pull/7847)

    ![Track widget build counts setting](/tools/devtools/release-notes/images-2.36.0/track_build_counts_setting.png "Track widget build counts setting")

    ![Widget rebuild counts in the Frame Analysis view](/tools/devtools/release-notes/images-2.36.0/rebuild_counts_frame_analysis.png "Widget rebuilds counts for a flutter frame")

    ![Widget rebuild counts in the Rebuild Stats view](/tools/devtools/release-notes/images-2.36.0/rebuild_stats.png "Widget rebuilds counts aggregate stats")

## Atualizações do Network profiler

* Adicionado better support for narrow viewing windows, like when
  this screen is embedded in an IDE. - [#7726](https://github.com/flutter/devtools/pull/7726)

## Deep links tool updates

* Adds an error page to explain the issue when
  the tool fails to parse the project. - [#7767](https://github.com/flutter/devtools/pull/7767)

## DevTools Extension updates

* Corrigido an issue with detecting extensions for
  Dart or Flutter tests. - [#7717](https://github.com/flutter/devtools/pull/7717)
* Corrigido an issue with detecting extensions for
  nested Dart or Flutter projects. - [#7742](https://github.com/flutter/devtools/pull/7742)
* Adicionado an example to `package:devtools_extensions` that shows
  how to interact with the Dart Tooling Daemon from
  a DevTools extension. - [#7752](https://github.com/flutter/devtools/pull/7752)
* Corrigido a DevTools routing bug related to
  disabling an extension. - [#7791](https://github.com/flutter/devtools/pull/7791)
* Corrigido a bug causing a "Page Not Found" error when
  refreshing DevTools from an extension screen. - [#7822](https://github.com/flutter/devtools/pull/7822)
* Corrigido a theming issue when extensions are
  embedded in an IDE - [#7824](https://github.com/flutter/devtools/pull/7824)

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.36.0).
