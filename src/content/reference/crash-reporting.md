---
ia-translate: true
title: Relatórios de falhas no Flutter
description: >-
  Como o Google usa os relatórios de falhas, o que é coletado e como desativar.
---

Se você não desativou a análise e os relatórios de falhas do Flutter,
quando um comando `flutter` falha,
ele tenta enviar um relatório de falha para o Google a fim de
ajudar o Google a contribuir com melhorias para o Flutter ao longo do tempo.
Um relatório de falha pode conter as seguintes informações:

*   O nome e a versão do seu sistema operacional local.
*   A versão do Flutter usada para executar o comando.
*   O tipo de erro em tempo de execução, por exemplo,
    `StateError` ou `NoSuchMethodError`.
*   O stack trace gerado pela falha, que contém referências ao
    código da própria CLI do Flutter e não contém referências ao
    código do seu aplicativo.
*   Um ID de cliente: um número constante e único gerado para
    o computador onde o Flutter está instalado.
    Ele nos ajuda a eliminar a duplicação de vários relatórios de falhas idênticos
    vindos do mesmo computador.
    Ele também nos ajuda a verificar se uma correção funciona conforme o esperado depois que
    você atualiza para a próxima versão do Flutter.

O Google lida com todos os dados relatados por esta ferramenta de acordo com a
[Política de Privacidade do Google][].

Você pode revisar os dados relatados recentemente no
arquivo `.dart-tool/dart-flutter-telemetry.log`.
No macOS ou Linux, este log está localizado no diretório home (`~/`).
No Windows, este log está localizado no diretório Roaming AppData (`%APPDATA%`).

## Desativando os relatórios de análise

Para desativar os relatórios de falhas anônimos e as
estatísticas de uso de recursos, execute o seguinte comando:

```console
$ flutter --disable-analytics
```

Se você optar por sair da análise, o Flutter enviará um evento de opt-out.
Esta instalação do Flutter não envia nem armazena mais nenhuma informação.

Para optar por participar da análise, execute o seguinte comando:

```console
$ flutter --enable-analytics
```

Para exibir a configuração atual, execute o seguinte comando:

```console
$ flutter config
```

[Política de Privacidade do Google]: https://policies.google.com/privacy

