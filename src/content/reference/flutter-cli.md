---
ia-translate: true
title: "flutter: A ferramenta de linha de comando do Flutter"
description: "A página de referência para usar 'flutter' em uma janela de terminal."
showBreadcrumbs: false
---

A ferramenta de linha de comando `flutter` é como os desenvolvedores (ou IDEs em nome dos
desenvolvedores) interagem com o Flutter. Para comandos relacionados ao Dart,
você pode usar a ferramenta de linha de comando [`dart`][`dart`].

Veja como você pode usar a ferramenta `flutter` para criar, analisar, testar e executar um
app:

```console
$ flutter create my_app
$ cd my_app
$ flutter analyze
$ flutter test
$ flutter run lib/main.dart
```

Para executar comandos [`pub`][`dart pub`] usando a ferramenta `flutter`:

```console
$ flutter pub get
$ flutter pub outdated
$ flutter pub upgrade
```

Para visualizar todos os comandos que `flutter` suporta:

```console
$ flutter --help --verbose
```

Para obter a versão atual do Flutter SDK, incluindo seu framework, engine,
e ferramentas:

```console
$ flutter --version
```

## Comandos `flutter`

A tabela a seguir mostra quais comandos você pode usar com a ferramenta `flutter`:

| Comando         | Exemplo de uso                                 | Mais informações                                                                  |
|-----------------|------------------------------------------------|-----------------------------------------------------------------------------------|
| analyze         | `flutter analyze -d <DEVICE_ID>`               | Analisa o código-fonte Dart do projeto.<br>Use em vez de [`dart analyze`][`dart analyze`].    |
| assemble        | `flutter assemble -o <DIRECTORY>`              | Monta e compila recursos do Flutter.                                             |
| attach          | `flutter attach -d <DEVICE_ID>`                | Conecta a uma aplicação em execução.                                                  |
| bash-completion | `flutter bash-completion`                      | Gera scripts de auto-completar para linha de comando.                               |
| build           | `flutter build <DIRECTORY>`                    | Comandos de compilação do Flutter.                                                           |
| channel         | `flutter channel <CHANNEL_NAME>`               | Lista ou alterna canais do Flutter.                                                  |
| clean           | `flutter clean`                                | Deleta os diretórios `build/` e `.dart_tool/`.                                |
| config          | `flutter config --build-dir=<DIRECTORY>`       | Configura as definições do Flutter. Para remover uma configuração, defina-a como uma string vazia. |
| create          | `flutter create <DIRECTORY>`                   | Cria um novo projeto.                                                            |
| custom-devices  | `flutter custom-devices list`                  | Adiciona, deleta, lista e reseta dispositivos personalizados.                                      |
| devices         | `flutter devices -d <DEVICE_ID>`               | Lista todos os dispositivos conectados.                                                       |
| doctor          | `flutter doctor`                               | Mostra informações sobre as ferramentas instaladas.                                     |
| downgrade       | `flutter downgrade`                            | Faz downgrade do Flutter para a última versão ativa do canal atual.             |
| drive           | `flutter drive`                                | Executa testes do Flutter Driver para o projeto atual.                                |
| emulators       | `flutter emulators`                            | Lista, inicia e cria emuladores.                                                |
| gen-l10n        | `flutter gen-l10n <DIRECTORY>`                 | Gera localizações para o projeto Flutter.                                   |
| install         | `flutter install -d <DEVICE_ID>`               | Instala um app Flutter em um dispositivo conectado.                                      |
| logs            | `flutter logs`                                 | Mostra a saída de log para apps Flutter em execução.                                         |
| precache        | `flutter precache <ARGUMENTS>`                 | Popula o cache de artefatos binários da ferramenta Flutter.                           |
| pub             | `flutter pub <PUB_COMMAND>`                    | Trabalha com pacotes.<br>Use em vez de [`dart pub`][`dart pub`].                            |
| run             | `flutter run <DART_FILE>`                      | Executa um programa Flutter.                                                           |
| screenshot      | `flutter screenshot`                           | Tira uma captura de tela de um app Flutter de um dispositivo conectado.                       |
| symbolize       | `flutter symbolize --input=<STACK_TRACK_FILE>` | Simboliza um stack trace de uma aplicação Flutter compilada com AOT.                |
| test            | `flutter test [<DIRECTORYDART_FILE>]`          | Executa testes neste pacote.<br>Use em vez de [`dart test`][`dart test`].         |
| upgrade         | `flutter upgrade`                              | Atualiza sua cópia do Flutter.                                                     |

{:.table .table-striped .nowrap}

Para ajuda adicional sobre qualquer um dos comandos, digite `flutter help <command>`
ou siga os links na coluna **Mais informações**.
Você também pode obter detalhes sobre comandos `pub` — por exemplo,
`flutter help pub outdated`.

[`dart`]: {{site.dart-site}}/tools/dart-tool
[`dart analyze`]: {{site.dart-site}}/tools/dart-analyze
[`dart format`]: {{site.dart-site}}/tools/dart-format
[`dart pub`]: {{site.dart-site}}/tools/dart-pub
[`dart test`]: {{site.dart-site}}/tools/dart-test
