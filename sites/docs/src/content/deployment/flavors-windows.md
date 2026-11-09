---
ia-translate: true
title: Configurar flavors Flutter para Windows
shortTitle: Flavors (Windows)
description: >-
  Como criar flavors Flutter para apps desktop Windows.
---

Este guia mostra como criar flavors Flutter para
apps desktop Windows.

:::note
Para criar flavors de app para outras plataformas,
acesse as páginas sobre como configurar flavors para:

* [Android][]
* [iOS e macOS][iOS and macOS]
* [Linux][]
:::

## Visão geral {:#overview}

Um flavor Flutter representa um conjunto de configurações que define
como uma versão específica do seu app é compilada e executada.
Por exemplo, um flavor pode determinar o título da janela,
o ícone do aplicativo, o endpoint da API, o conjunto de assets
e a configuração de logs de uma build.

:::version-note
O suporte nativo a flavors no Windows requer o Flutter 3.47 ou posterior.
:::

No Windows, o Flutter usa o [CMake][] para configurar e compilar
o runner nativo para desktop.
Quando você executa `flutter run` ou `flutter build` com a flag `--flavor`,
o Flutter grava o nome do flavor em
`windows/flutter/ephemeral/generated_config.cmake`,
como a variável `FLUTTER_APP_FLAVOR`, e isola os arquivos de saída
da build em um diretório específico do flavor.

:::important
O arquivo `generated_config.cmake` é incluído a partir de
`windows/flutter/CMakeLists.txt`, então `FLUTTER_APP_FLAVOR`
só fica visível no seu `CMakeLists.txt` de nível superior **depois**
da linha `add_subdirectory(${FLUTTER_MANAGED_DIR})`.
Qualquer bloco `if(DEFINED FLUTTER_APP_FLAVOR)` colocado antes dessa linha
é ignorado silenciosamente.
:::

A tabela a seguir ilustra os diretórios de build que o Flutter cria
quando um projeto define dois flavors (`staging`, `production`)
e dois modos de build (`debug`, `release`):

| Flavor     | Modo de build | Diretório de saída                                      |
|------------|---------------|---------------------------------------------------------|
| staging    | debug         | `build/windows/<arch>/staging/runner/Debug/`            |
| production | debug         | `build/windows/<arch>/production/runner/Debug/`         |
| staging    | release       | `build/windows/<arch>/staging/runner/Release/`          |
| production | release       | `build/windows/<arch>/production/runner/Release/`       |
{:.table .table-striped}

[CMake]: https://cmake.org/

## Criar e executar flavors {:#create-and-run-flavors}

Passar `--flavor` funciona no Windows sem nenhuma configuração do CMake.
Projetos Flutter existentes suportam flavors sem necessidade de atualizar
templates ou alterar configurações.
Quando você passa `--flavor`, o Flutter isola o diretório de build,
preenche `appFlavor` e filtra os assets específicos do flavor automaticamente.

Para testar os flavors com um projeto de exemplo,
siga estes passos:

1.  Crie um novo projeto Flutter chamado `flavors_example`:

    ```console
    $ flutter create flavors_example
    $ cd flavors_example
    ```

1.  Verifique se os seus flavors são executados corretamente:

    Execute o flavor `staging`:

    ```console
    $ flutter run -d windows --flavor staging
    ```

    Execute o flavor `production`:

    ```console
    $ flutter run -d windows --flavor production
    ```

Para personalizar as configurações nativas do runner de cada flavor,
como o título da janela ou o ícone do aplicativo,
consulte [Personalizar configurações](#customize-configurations).

## Iniciar um flavor {:#launch-a-flavor}

Depois de definir flavors para o seu app,
execute, compile ou teste um flavor específico usando a flag `--flavor`
com a CLI do Flutter.

### Executar um flavor em modo debug {: #run-a-flavor }

Para executar um flavor específico durante o desenvolvimento,
passe a opção `--flavor` para `flutter run`:

```console
$ flutter run -d windows --flavor <flavor_name>
```

Substitua `<flavor_name>` pelo nome do seu flavor
(por exemplo, `staging` ou `production`).

### Compilar um binário de release {: #build-a-flavor }

Para compilar um executável de release de um flavor específico,
passe a opção `--flavor` para `flutter build`:

```console
$ flutter build windows --flavor <flavor_name>
```

O Flutter grava o executável compilado em
`build/windows/<arch>/<flavor_name>/runner/Release/`.

### Executar testes com um flavor {: #test-a-flavor }

A opção `--flavor` também funciona com `flutter test` e `flutter drive`,
permitindo executar testes de unidade, de widget ou de integração
contra uma configuração de flavor específica:

```console
$ flutter test --flavor <flavor_name>
```

## Usar flavors no código Flutter {: #use-flavors-in-code }

Depois de adicionar flavors, você pode ajustar o comportamento do app,
como selecionar endpoints de API, ativar funcionalidades
ou definir chaves de analytics, com base no flavor ativo.

O framework Flutter fornece a constante `appFlavor` na biblioteca `services`,
que identifica o flavor usado para executar ou compilar o seu app.

1.  **Importe a biblioteca services:**

    Adicione o seguinte import ao seu arquivo Dart:

    ```dart
    import 'package:flutter/services.dart';
    ```

1.  **Leia o valor do flavor:**

    Use a constante `appFlavor` na lógica da sua aplicação
    (geralmente em `main()`) para tratar a configuração específica do flavor:

    ```dart
    void main() {
      if (appFlavor == 'production') {
        Config.apiUrl = 'https://api.example.com';
      } else if (appFlavor == 'staging') {
        Config.apiUrl = 'https://staging.api.example.com';
      }

      runApp(const MyApp());
    }
    ```

    :::note
    O valor de `appFlavor` corresponde à string passada para a flag `--flavor`.
    Se você omitir `--flavor`,
    `appFlavor` corresponde ao [flavor padrão](#set-default-flavor)
    configurado no `pubspec.yaml`.
    Se nenhum dos dois for especificado, `appFlavor` é `null`.
    :::

## Personalizar configurações {:#customize-configurations}

Para diferenciar o runner nativo do Windows por flavor,
como dar a cada flavor um título de janela ou um ícone de aplicativo exclusivo,
configure o CMake para gerar os arquivos de código-fonte e de recursos
do runner usando `configure_file`.

### Configurar o CMake para as configurações nativas {: #configure-cmake-native }

O CMake avalia `windows/runner/CMakeLists.txt` depois que
`FLUTTER_APP_FLAVOR` é definido.
Você pode inspecionar essa variável para configurar valores específicos
do flavor e, em seguida, usar `configure_file` para substituí-los
nos arquivos de template do runner C++ (`main.cpp`)
e do script de recursos do Windows (`Runner.rc`).

Em `windows/runner/CMakeLists.txt`, adicione o bloco a seguir
antes da linha `add_executable(${BINARY_NAME} ...)`:

```cmake title="windows/runner/CMakeLists.txt"
# Configure flavor-specific settings.
if(DEFINED FLUTTER_APP_FLAVOR)
  if(FLUTTER_APP_FLAVOR STREQUAL "staging")
    set(RUNNER_APP_ICON "staging.ico")
    set(WINDOW_TITLE "Staging App")
  elseif(FLUTTER_APP_FLAVOR STREQUAL "production")
    set(RUNNER_APP_ICON "production.ico")
    set(WINDOW_TITLE "Production App")
  endif()
else()
  set(RUNNER_APP_ICON "app_icon.ico")
  set(WINDOW_TITLE "${BINARY_NAME}")
endif()

configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp.in"
  "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp"
  @ONLY
)

configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/Runner.rc.in"
  "${CMAKE_CURRENT_SOURCE_DIR}/Runner.rc"
  @ONLY
)
```

:::note
Como o `configure_file` gera `main.cpp` e `Runner.rc`
no diretório de código-fonte em tempo de build,
adicione os dois arquivos gerados ao `.gitignore` do projeto:

```gitignore title=".gitignore"
windows/runner/main.cpp
windows/runner/Runner.rc
```

Em vez disso, versione os arquivos de template `.in`.
:::

### Criar títulos de janela distintos {:#create-distinct-window-titles}

Para exibir um título de janela específico do flavor quando o app é iniciado:

1.  Renomeie `windows/runner/main.cpp` para `windows/runner/main.cpp.in`.

1.  Em `windows/runner/main.cpp.in`, encontre onde `window.Create` é chamado
    e substitua o título fixo por `@WINDOW_TITLE@`:

    ```cpp title="windows/runner/main.cpp.in"
      if (!window.Create(L"@WINDOW_TITLE@", origin, size)) {
        return EXIT_FAILURE;
      }
    ```

    Quando o CMake configurar a build,
    ele substitui `@WINDOW_TITLE@` pelo título da janela do flavor selecionado.

### Criar ícones de app distintos {:#create-distinct-app-icons}

Para fornecer ícones de desktop exclusivos para cada flavor:

1.  Prepare os seus arquivos de ícone no formato `.ico`
    (por exemplo, `staging.ico` e `production.ico`)
    e coloque-os em `windows/runner/resources/`,
    junto com o `app_icon.ico` padrão.

1.  Renomeie `windows/runner/Runner.rc` para `windows/runner/Runner.rc.in`.

1.  Em `windows/runner/Runner.rc.in`, localize a linha `IDI_APP_ICON`
    e atualize o caminho do ícone para usar `@RUNNER_APP_ICON@`:

    ```rc title="windows/runner/Runner.rc.in"
    IDI_APP_ICON            ICON                    "resources\\@RUNNER_APP_ICON@"
    ```

    Você também pode atualizar as strings de metadados, como `FileDescription`
    e `ProductName`, para usar `@WINDOW_TITLE@`:

    ```rc title="windows/runner/Runner.rc.in"
    VALUE "FileDescription", "@WINDOW_TITLE@" "\0"
    VALUE "ProductName",     "@WINDOW_TITLE@" "\0"
    ```

### Empacotar assets por flavor {: #bundle-assets }

Se você tiver assets que se aplicam apenas a um flavor específico,
configure o Flutter para empacotar esses assets somente ao compilar
esse flavor.
Isso evita que assets não utilizados aumentem o tamanho do bundle do app.

Para empacotar assets condicionalmente,
adicione a lista `flavors` a uma entrada de asset em `pubspec.yaml`:

```yaml title="pubspec.yaml"
flutter:
  assets:
    - assets/common/
    - path: assets/staging/
      flavors:
        - staging
    - path: assets/production/
      flavors:
        - production
```

Para saber mais, consulte o [campo `assets`][`assets` field]
em [Opções do pubspec do Flutter][Flutter pubspec options].

[`assets` field]: /tools/pubspec#assets
[Flutter pubspec options]: /tools/pubspec

### Definir um flavor padrão {: #set-default-flavor }

Para especificar um flavor a ser usado ao executar ou compilar
sem a flag `--flavor`, adicione a propriedade `default-flavor`
ao `pubspec.yaml`:

```yaml title="pubspec.yaml"
flutter:
  default-flavor: staging
```

Para saber mais, consulte o [campo `default-flavor`][`default-flavor` field]
em [Opções do pubspec do Flutter][Flutter pubspec options].

[`default-flavor` field]: /tools/pubspec#default-flavor

## Mais informações {:#more-information}

Para mais informações sobre flavors e deploy em desktop,
consulte os seguintes recursos:

* [Configurar flavors Flutter para Android][Android]
* [Configurar flavors Flutter para iOS e macOS][iOS and macOS]
* [Configurar flavors Flutter para Linux][Linux]
* [Compilar e publicar um app desktop para Windows][Build and release a Windows desktop app]

[Android]: /deployment/flavors
[iOS and macOS]: /deployment/flavors-ios
[Linux]: /deployment/flavors-linux
[Build and release a Windows desktop app]: /deployment/windows
