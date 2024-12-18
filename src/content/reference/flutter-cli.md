---
ia-translate: true
title: "flutter: A ferramenta de linha de comando do Flutter"
description: "A página de referência para usar 'flutter' em uma janela de terminal."
---

A ferramenta de linha de comando `flutter` é como desenvolvedores (ou IDEs em nome de desenvolvedores) interagem com o Flutter. Para comandos relacionados ao Dart, você pode usar a ferramenta de linha de comando [`dart`][].

Veja como você pode usar a ferramenta `flutter` para criar, analisar, testar e executar um aplicativo:

```console
$ flutter create meu_app
$ cd meu_app
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

Para visualizar todos os comandos que o `flutter` suporta:

```console
$ flutter --help --verbose
```

Para obter a versão atual do SDK do Flutter, incluindo seu framework, engine e ferramentas:

```console
$ flutter --version
```

## Comandos `flutter`

A tabela a seguir mostra quais comandos você pode usar com a ferramenta `flutter`:

| Comando         | Exemplo de uso                                 | Mais informações                                                                  |
|-----------------|------------------------------------------------|-----------------------------------------------------------------------------------|
| analyze         | `flutter analyze -d <DEVICE_ID>`               | Analisa o código-fonte Dart do projeto.<br>Use em vez de [`dart analyze`][].        |
| assemble        | `flutter assemble -o <DIRECTORY>`              | Monta e constrói recursos do Flutter.                                             |
| attach          | `flutter attach -d <DEVICE_ID>`                | Anexa a um aplicativo em execução.                                                 |
| bash-completion | `flutter bash-completion`                      | Imprime scripts de configuração de preenchimento de linha de comando.                |
| build           | `flutter build <DIRECTORY>`                    | Comandos de construção do Flutter.                                                |
| channel         | `flutter channel <CHANNEL_NAME>`               | Lista ou alterna canais do Flutter.                                                 |
| clean           | `flutter clean`                                | Exclui os diretórios `build/` e `.dart_tool/`.                                   |
| config          | `flutter config --build-dir=<DIRECTORY>`       | Configura as definições do Flutter. Para remover uma configuração, defina-a como uma string vazia. |
| create          | `flutter create <DIRECTORY>`                   | Cria um novo projeto.                                                            |
| custom-devices  | `flutter custom-devices list`                  | Adiciona, exclui, lista e redefine dispositivos personalizados.                       |
| devices         | `flutter devices -d <DEVICE_ID>`               | Lista todos os dispositivos conectados.                                            |
| doctor          | `flutter doctor`                               | Exibe informações sobre as ferramentas instaladas.                               |
| downgrade       | `flutter downgrade`                            | Rebaixa o Flutter para a última versão ativa do canal atual.                      |
| drive           | `flutter drive`                                | Executa testes do Flutter Driver para o projeto atual.                              |
| emulators       | `flutter emulators`                            | Lista, inicia e cria emuladores.                                                 |
| gen-l10n        | `flutter gen-l10n <DIRECTORY>`                 | Gera localizações para o projeto Flutter.                                         |
| install         | `flutter install -d <DEVICE_ID>`               | Instala um aplicativo Flutter em um dispositivo conectado.                           |
| logs            | `flutter logs`                                 | Exibe a saída de log para aplicativos Flutter em execução.                       |
| precache        | `flutter precache <ARGUMENTS>`                 | Preenche o cache de artefatos binários da ferramenta Flutter.                      |
| pub             | `flutter pub <PUB_COMMAND>`                    | Trabalha com pacotes.<br>Use em vez de [`dart pub`][].                              |
| run             | `flutter run <DART_FILE>`                      | Executa um programa Flutter.                                                      |
| screenshot      | `flutter screenshot`                           | Tira uma captura de tela de um aplicativo Flutter de um dispositivo conectado.       |
| symbolize       | `flutter symbolize --input=<STACK_TRACK_FILE>` | Simboliza um rastreamento de pilha do aplicativo Flutter compilado AOT.              |
| test            | `flutter test [<DIRECTORYDART_FILE>]`          | Executa testes neste pacote.<br>Use em vez de [`dart test`][`dart test`].          |
| upgrade         | `flutter upgrade`                              | Atualiza sua cópia do Flutter.                                                   |

{:.table .table-striped .nowrap}

Para obter ajuda adicional sobre qualquer um dos comandos, insira `flutter help <comando>` ou siga os links na coluna **Mais informações**. Você também pode obter detalhes sobre os comandos `pub` — por exemplo, `flutter help pub outdated`.

[`dart`]: {{site.dart-site}}/tools/dart-tool
[`dart analyze`]: {{site.dart-site}}/tools/dart-analyze
[`dart format`]: {{site.dart-site}}/tools/dart-format
[`dart pub`]: {{site.dart-site}}/tools/dart-pub
[`dart test`]: {{site.dart-site}}/tools/dart-test
