---
ia-translate: true
title: Segmentando o ChromeOS com Android
description: Considerações específicas da plataforma para construir para ChromeOS com Flutter.
---

Esta página discute considerações exclusivas para construir aplicativos
Android que oferecem suporte ao ChromeOS com Flutter.

## Dicas e truques do Flutter & ChromeOS

Para as versões atuais do ChromeOS, apenas certas portas do
Linux são expostas ao restante do ambiente.
Aqui está um exemplo de como iniciar o
Flutter DevTools para um aplicativo Android com portas
que funcionarão:

```console
$ flutter pub global run devtools --port 8000
$ cd path/para/seu/app
$ flutter run --observatory-port=8080
```

Em seguida, navegue até http://127.0.0.1:8000/#
em seu navegador Chrome e insira o URL para seu
aplicativo. O último comando `flutter run` que você
acabou de executar deve gerar um URL semelhante ao formato
de `http://127.0.0.1:8080/auth_code=/`. Use este URL
e selecione "Conectar" para iniciar o Flutter DevTools
para seu aplicativo Android.

#### Análise de lint do Flutter ChromeOS

O Flutter possui verificações de análise de lint específicas do ChromeOS
para garantir que o aplicativo que você está construindo
funcione bem no ChromeOS. Ele procura coisas
como hardware necessário em seu Android Manifest
que não estão disponíveis em dispositivos ChromeOS,
permissões que implicam solicitações para hardware não suportado,
bem como outras propriedades ou código
que trariam uma experiência inferior nesses dispositivos.

Para ativá-los,
você precisa criar um novo arquivo analysis_options.yaml
na pasta do seu projeto para incluir essas opções.
(Se você tiver um arquivo analysis_options.yaml existente,
você pode atualizá-lo)

```yaml
include: package:flutter/analysis_options_user.yaml
analyzer:
 optional-checks:
   chrome-os-manifest-checks
```

Para executá-los na linha de comando, use o seguinte comando:

```console
$ flutter analyze
```

Um exemplo de saída para este comando pode ser parecido com:

```console
Analisando ...
warning • Este recurso de hardware não é suportado no ChromeOS •
android/app/src/main/AndroidManifest.xml:4:33 • unsupported_chrome_os_hardware
```
