---
ia-translate: true
title: Relatórios de falhas do Flutter
description: >-
  Como o Google usa os relatórios de falhas, quais informações são coletadas e como desativar.
---

Se você não desativou os relatórios de análise e falhas do Flutter,
quando um comando `flutter` falha,
ele tenta enviar um relatório de falha ao Google para
ajudar o Google a contribuir com melhorias ao Flutter ao longo do tempo.
Um relatório de falha pode conter as seguintes informações:

* O nome e a versão do seu sistema operacional local.
* A versão do Flutter usada para executar o comando.
* O tipo de erro em tempo de execução, por exemplo
  `StateError` ou `NoSuchMethodError`.
* O stack trace gerado pela falha, que contém referências ao
  código próprio do Flutter CLI e não contém referências ao
  código da sua aplicação.
* Um ID de cliente: um número constante e único gerado para
  o computador onde o Flutter está instalado.
  Ele nos ajuda a eliminar duplicatas de múltiplos relatórios
  de falhas idênticos vindos do mesmo computador.
  Ele também nos ajuda a verificar se uma correção funciona conforme o esperado após
  você atualizar para a próxima versão do Flutter.

O Google trata todos os dados reportados por esta ferramenta de acordo com a
[Google Privacy Policy][].

Você pode revisar os dados reportados recentemente no arquivo
`.dart-tool/dart-flutter-telemetry.log`.
No macOS ou Linux, este log está localizado no diretório home (`~/`).
No Windows, este log está localizado no diretório Roaming AppData (`%APPDATA%`).

## Desativando relatórios de análise

Para desativar relatórios anônimos de falhas e
estatísticas de uso de recursos, execute o seguinte comando:

```console
$ flutter --disable-analytics
```

Se você desativar a análise, o Flutter envia um evento de desativação.
Esta instalação do Flutter não envia nem armazena nenhuma informação adicional.

Para ativar a análise novamente, execute o seguinte comando:

```console
$ flutter --enable-analytics
```

Para exibir a configuração atual, execute o seguinte comando:

```console
$ flutter config
```

[Google Privacy Policy]: https://policies.google.com/privacy
