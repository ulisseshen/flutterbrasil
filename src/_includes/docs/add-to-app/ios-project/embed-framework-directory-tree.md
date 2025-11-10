<!-- ia-translate: true -->

O seguinte exemplo assume que você deseja gerar os
frameworks em `/path/to/MyApp/Flutter/`.

```console
$ flutter build ios-framework --output=/path/to/MyApp/Flutter/
```

Execute isso _toda vez_ que você alterar o código no seu módulo Flutter.

A estrutura de projeto resultante deve se assemelhar a esta árvore de diretórios.

```plaintext
/path/to/MyApp/
└── Flutter/
    ├── Debug/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework (only if you have plugins with iOS platform code)
    │   └── example_plugin.xcframework (each plugin is a separate framework)
    ├── Profile/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework
    │   └── example_plugin.xcframework
    └── Release/
        ├── Flutter.xcframework
        ├── App.xcframework
        ├── FlutterPluginRegistrant.xcframework
        └── example_plugin.xcframework
```

:::warning
Sempre use os bundles `Flutter.xcframework` e `App.xcframework`
localizados no mesmo diretório.
Misturar importações `.xcframework` de diretórios diferentes
(como `Profile/Flutter.xcframework` com `Debug/App.xcframework`)
causa travamentos em tempo de execução.
:::
