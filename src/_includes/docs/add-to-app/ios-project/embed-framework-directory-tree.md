O exemplo a seguir assume que você deseja gerar os
frameworks em `/path/to/MyApp/Flutter/`.

```console
$ flutter build ios-framework --output=/path/to/MyApp/Flutter/
```

Execute isso _toda vez_ que você alterar o código no seu módulo Flutter.

A estrutura do projeto resultante deve se assemelhar a esta árvore de diretórios.

```plaintext
/path/to/MyApp/
└── Flutter/
    ├── Debug/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework (somente se você tiver plugins com código de plataforma iOS)
    │   └── example_plugin.xcframework (cada plugin é um framework separado)
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
Sempre use os pacotes `Flutter.xcframework` e `App.xcframework`
localizados no mesmo diretório.
Misturar importações de `.xcframework` de diferentes diretórios
(como `Profile/Flutter.xcframework` com `Debug/App.xcframework`)
causa travamentos em tempo de execução.
:::
