---
title: Relatórios de falhas do Flutter
description: >-
  Como o Google usa relatórios de falhas, o que é coletado e como desativar.
showBreadcrumbs: false
ia-translate: true
---

Se você não desativou os relatórios de análise e falhas do Flutter,
quando um comando `flutter` falha,
ele tenta enviar um relatório de falha ao Google para
ajudar o Google a contribuir com melhorias ao Flutter ao longo do tempo.
Um relatório de falha pode conter as seguintes informações:

* O nome e versão do seu sistema operacional local.
* A versão do Flutter usada para executar o comando.
* O tipo de runtime do erro, por exemplo
  `StateError` ou `NoSuchMethodError`.
* O stack trace gerado pela falha, que contém referências ao
  código do CLI do Flutter e não contém referências ao
  código da sua aplicação.
* Um ID de cliente: um número constante e único gerado para
  o computador onde o Flutter está instalado.
  Isso nos ajuda a desduplicar múltiplos relatórios de falha
  idênticos vindos do mesmo computador.
  Também nos ajuda a verificar se uma correção funciona como pretendido depois
  que você atualiza para a próxima versão do Flutter.

O Google lida com todos os dados relatados por esta ferramenta de acordo com a
[Política de Privacidade do Google][Google Privacy Policy].

Você pode revisar os dados relatados recentemente no arquivo
`.dart-tool/dart-flutter-telemetry.log`.
No macOS ou Linux, este log está localizado no diretório home (`~/`).
No Windows, este log está localizado no diretório Roaming AppData (`%APPDATA%`).

## Desabilitando relatórios de análise {:#disabling-analytics-reporting}

Para desativar os relatórios anônimos de falhas e estatísticas
de uso de recursos, execute o seguinte comando:

```console
$ flutter --disable-analytics
```

Se você desativar a análise, o Flutter envia um evento de desativação.
Esta instalação do Flutter não envia nem armazena mais nenhuma informação adicional.

Para ativar a análise, execute o seguinte comando:

```console
$ flutter --enable-analytics
```

Para exibir a configuração atual, execute o seguinte comando:

```console
$ flutter config
```

[Google Privacy Policy]: https://policies.google.com/privacy
