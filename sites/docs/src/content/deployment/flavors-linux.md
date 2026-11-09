---
ia-translate: true
title: Configurar flavors Flutter para Linux
shortTitle: Flavors (Linux)
description: >-
  Como criar flavors Flutter para apps desktop Linux.
---

Este guia mostra como criar flavors Flutter para
apps desktop Linux.

:::note
Para criar flavors de app para outras plataformas,
visite as páginas sobre como configurar flavors para:

* [Android][Android]
* [iOS e macOS][iOS and macOS]
* [Windows][Windows]
:::

## Visão geral {:#overview}

Um flavor Flutter representa um conjunto de configurações que definem
como uma versão específica do seu app é compilada e executada.
Por exemplo, um flavor pode determinar o título da janela,
o ID do app, o endpoint da API, o conjunto de assets e a configuração de logs
de um build.

:::version-note
O suporte nativo a flavors no Linux requer o Flutter 3.47 ou posterior.
:::

No Linux, o Flutter usa o [CMake][CMake] para configurar e compilar
o runner nativo do desktop.
Quando você executa `flutter run` ou `flutter build` com a flag `--flavor`,
o Flutter grava o nome do flavor em
`linux/flutter/ephemeral/generated_config.cmake`, como a
variável `FLUTTER_APP_FLAVOR`, e isola os arquivos de saída do build
em um diretório específico do flavor.

:::important
O arquivo `generated_config.cmake` é incluído a partir de
`linux/flutter/CMakeLists.txt`, então `FLUTTER_APP_FLAVOR`
só fica visível no seu `CMakeLists.txt` de nível superior **depois** da
linha `add_subdirectory(${FLUTTER_MANAGED_DIR})`.
Qualquer bloco `if(DEFINED FLUTTER_APP_FLAVOR)` colocado antes dessa linha
é ignorado silenciosamente.
:::

A tabela a seguir ilustra os diretórios de build que o Flutter cria
quando um projeto define dois flavors (`staging`, `production`)
e dois modos de build (`debug`, `release`):

| Flavor     | Modo de build | Diretório de saída                                   |
|------------|---------------|------------------------------------------------------|
| staging    | debug         | `build/linux/<arch>/staging/debug/bundle/`           |
| production | debug         | `build/linux/<arch>/production/debug/bundle/`        |
| staging    | release       | `build/linux/<arch>/staging/release/bundle/`         |
| production | release       | `build/linux/<arch>/production/release/bundle/`      |
{:.table .table-striped}

[CMake]: https://cmake.org/

## Configurar o CMake para flavors (opcional) {: #configure-cmake }

Passar `--flavor` funciona no Linux sem nenhuma configuração do projeto.
Projetos Flutter existentes oferecem suporte a flavors sem precisar de
atualizações de templates ou de alterações de configuração.
Ao passar `--flavor`, o Flutter isola o diretório de build,
preenche `appFlavor` e filtra os assets específicos do flavor automaticamente.

Siga os passos opcionais a seguir somente se quiser diferenciar o runner nativo
por flavor, por exemplo, o ID de aplicação GTK ou o título da janela.
Este exemplo configura dois flavors chamados `staging` e `production`.

1.  Crie um novo projeto Flutter chamado `flavors_example`:

    ```console
    $ flutter create flavors_example
    $ cd flavors_example
    ```

1.  Configure IDs de aplicação específicos por flavor em `linux/CMakeLists.txt`:

    Abra `linux/CMakeLists.txt` e encontre a linha
    `add_subdirectory(${FLUTTER_MANAGED_DIR})`.
    Defina o `APPLICATION_ID` por flavor logo após essa linha:

    ```cmake title="linux/CMakeLists.txt"
    # Flutter library and tool build rules.
    set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
    add_subdirectory(${FLUTTER_MANAGED_DIR})

    if(DEFINED FLUTTER_APP_FLAVOR)
      if(FLUTTER_APP_FLAVOR STREQUAL "staging")
        set(APPLICATION_ID "com.example.staging")
      elseif(FLUTTER_APP_FLAVOR STREQUAL "production")
        set(APPLICATION_ID "com.example.production")
      endif()
    endif()
    ```

    `APPLICATION_ID` deve ser configurado depois de
    `add_subdirectory(${FLUTTER_MANAGED_DIR})`, porque
    `FLUTTER_APP_FLAVOR` só fica disponível nesse ponto,
    e antes de `add_subdirectory("runner")`, onde `APPLICATION_ID` é usado.

    :::important
    Não altere a linha `set(BINARY_NAME ...)`.
    A CLI do Flutter resolve o caminho do executável lendo essa linha literalmente,
    então renomear o binário por flavor impede que o `flutter run`
    inicie o app.
    :::

1.  Verifique se os seus flavors são executados corretamente:

    Execute o flavor `staging`:

    ```console
    $ flutter run -d linux --flavor staging
    ```

    Execute o flavor `production`:

    ```console
    $ flutter run -d linux --flavor production
    ```

## Iniciar um flavor {:#launch-a-flavor}

Depois de configurar os flavors do seu app,
execute, compile ou teste um flavor específico usando a flag `--flavor`
com a CLI do Flutter.

### Executar um flavor em modo debug {: #run-a-flavor }

Para executar um flavor específico durante o desenvolvimento,
passe a opção `--flavor` para o `flutter run`:

```console
$ flutter run -d linux --flavor <flavor_name>
```

Substitua `<flavor_name>` pelo nome do seu flavor
(por exemplo, `staging` ou `production`).

### Compilar um executável de release {: #build-a-flavor }

Para compilar um executável de release para um flavor específico,
passe a opção `--flavor` para o `flutter build`:

```console
$ flutter build linux --flavor <flavor_name>
```

O Flutter gera o bundle compilado em
`build/linux/<arch>/<flavor_name>/release/bundle/`.

### Executar testes com um flavor {: #test-a-flavor }

A opção `--flavor` também funciona com `flutter test` e `flutter drive`,
permitindo executar testes de unidade, de widget ou de integração
em uma configuração de flavor específica:

```console
$ flutter test --flavor <flavor_name>
```

## Usar flavors no código Flutter {: #use-flavors-in-code }

Depois de adicionar flavors,
você pode ajustar o comportamento do app, como selecionar endpoints de API,
ativar ou desativar recursos ou definir chaves de analytics, com base no flavor ativo.

O framework Flutter oferece a constante `appFlavor` na biblioteca `services`,
que identifica o flavor usado para executar ou compilar o seu app.

1.  **Importe a biblioteca services:**

    Adicione o seguinte import ao seu arquivo Dart:

    ```dart
    import 'package:flutter/services.dart';
    ```

1.  **Leia o valor do flavor:**

    Use a constante `appFlavor` na lógica do seu app
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

Depois de adicionar flavors,
você pode personalizar configurações nativas e assets de cada configuração.

### Criar títulos de janela distintos {:#create-distinct-window-titles}

Para ajudar a diferenciar os flavors em tempo de execução,
personalize o título nativo da janela de cada flavor.

1.  Em `linux/runner/CMakeLists.txt`, passe `FLUTTER_APP_FLAVOR`
    como uma definição de pré-processador logo após a definição
    `APPLICATION_ID` existente:

    ```cmake title="linux/runner/CMakeLists.txt"
    # Add preprocessor definitions for the application ID.
    add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

    if(DEFINED FLUTTER_APP_FLAVOR AND NOT FLUTTER_APP_FLAVOR STREQUAL "")
      add_definitions(-DFLUTTER_APP_FLAVOR="${FLUTTER_APP_FLAVOR}")
    endif()
    ```

1.  Em `linux/runner/my_application.cc`, atualize o título da janela
    na função `my_application_activate`:

    ```c title="linux/runner/my_application.cc"
      const gchar* window_title = "flavors_example";
    #ifdef FLUTTER_APP_FLAVOR
      if (g_strcmp0(FLUTTER_APP_FLAVOR, "staging") == 0) {
        window_title = "Staging App";
      } else if (g_strcmp0(FLUTTER_APP_FLAVOR, "production") == 0) {
        window_title = "Production App";
      }
    #endif
    ```

    Em seguida, atualize `my_application_activate` para usar `window_title`
    no lugar das strings literais fixas:

    ```c title="linux/runner/my_application.cc"
        gtk_header_bar_set_title(header_bar, window_title);
        // ...
        gtk_window_set_title(window, window_title);
    ```

### Configurar ícones do app {:#configure-app-icons}

No Linux, os ícones dos apps não ficam incorporados diretamente no
executável binário compilado.
Em vez disso, o ambiente de desktop resolve os ícones por meio de
arquivos de atalho `.desktop` e de temas de ícones instalados.

Para oferecer ícones ou entradas de atalho diferentes para cada flavor,
configure o formato do seu pacote Linux (como Snap, Flatpak ou pacotes Debian)
para instalar entradas de desktop e assets de ícone distintos.
Para saber mais sobre como empacotar apps Linux, consulte
[Compile e publique um app desktop Linux][Build and release a Linux desktop app].

### Empacotar assets por flavor {: #bundle-assets }

Se você tiver assets que se aplicam apenas a um flavor específico,
configure o Flutter para incluir esses assets somente ao compilar esse flavor.
Isso evita que assets não usados aumentem o tamanho do bundle do seu app.

Para incluir assets condicionalmente,
adicione a lista `flavors` a uma entrada de asset no `pubspec.yaml`:

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

Para saber mais, consulte o [campo `assets`][`assets` field] em
[opções do pubspec do Flutter][Flutter pubspec options].

[`assets` field]: /tools/pubspec#assets
[Flutter pubspec options]: /tools/pubspec

### Definir um flavor padrão {: #set-default-flavor }

Para especificar um flavor a ser usado ao executar ou compilar
sem a flag `--flavor`, adicione a propriedade `default-flavor` ao `pubspec.yaml`:

```yaml title="pubspec.yaml"
flutter:
  default-flavor: staging
```

Para saber mais, consulte o [campo `default-flavor`][`default-flavor` field] em
[opções do pubspec do Flutter][Flutter pubspec options].

[`default-flavor` field]: /tools/pubspec#default-flavor

## Mais informações {:#more-information}

Para mais informações sobre flavors e deploy em desktop,
consulte os recursos a seguir:

* [Configurar flavors Flutter para Android][Android]
* [Configurar flavors Flutter para iOS e macOS][iOS and macOS]
* [Configurar flavors Flutter para Windows][Windows]
* [Compile e publique um app desktop Linux][Build and release a Linux desktop app]

[Android]: /deployment/flavors
[iOS and macOS]: /deployment/flavors-ios
[Windows]: /deployment/flavors-windows
[Build and release a Linux desktop app]: /deployment/linux
