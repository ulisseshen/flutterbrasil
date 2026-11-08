<!-- ia-translate: true -->

O seguinte exemplo assume que você deseja gerar os
frameworks em `/path/to/MyApp/Flutter/`.

```console
$ flutter build ios-framework --output=/path/to/MyApp/Flutter/
```

Execute isso _toda vez_ que você alterar o código no seu módulo Flutter.

A estrutura de projeto resultante deve se assemelhar a esta árvore de diretórios.

<FileTree>

- /path/to/MyApp/
  - Flutter/
    - Debug/
      - Flutter.xcframework
      - App.xcframework
      - FlutterPluginRegistrant.xcframework (Se você tiver plugins com código da plataforma iOS)
      - example_plugin.xcframework (Um arquivo de framework para cada plugin)
    - Profile/
      - Flutter.xcframework
      - App.xcframework
      - FlutterPluginRegistrant.xcframework
      - example_plugin.xcframework
    - Release/
      - Flutter.xcframework
      - App.xcframework
      - FlutterPluginRegistrant.xcframework
      - example_plugin.xcframework

</FileTree>

:::warning
Sempre use os bundles `Flutter.xcframework` e `App.xcframework`
localizados no mesmo diretório.
Misturar importações `.xcframework` de diretórios diferentes
(como `Profile/Flutter.xcframework` com `Debug/App.xcframework`)
causa travamentos em tempo de execução.
:::
