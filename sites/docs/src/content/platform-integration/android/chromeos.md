---
ia-translate: true
title: Direcionando ChromeOS com Android
description: Considerações específicas de plataforma para fazer build para ChromeOS com Flutter.
---

Esta página discute considerações únicas para fazer build de
apps Android que suportam ChromeOS com Flutter.

## Dicas e truques Flutter & ChromeOS

Para as versões atuais do ChromeOS, apenas certas portas do
Linux são expostas para o resto do ambiente.
Aqui está um exemplo de como lançar o
Flutter DevTools para um app Android com portas
que funcionarão:

```console
$ flutter pub global run devtools --port 8000
$ cd path/to/your/app
$ flutter run --observatory-port=8080
```

Então, navegue até http://127.0.0.1:8000/#
em seu navegador Chrome e digite a URL para sua
aplicação. O último comando `flutter run` que você
acabou de executar deve gerar uma URL similar ao formato
de `http://127.0.0.1:8080/auth_code=/`. Use esta URL
e selecione "Connect" para iniciar o Flutter DevTools
para seu app Android.

#### Análise de lint ChromeOS do Flutter

O Flutter tem verificações de análise de lint específicas do ChromeOS
para garantir que o app que você está construindo
funcione bem no ChromeOS. Ele procura por coisas
como hardware obrigatório em seu Android Manifest
que não estão disponíveis em dispositivos ChromeOS,
permissões que implicam solicitações de hardware
não suportado, bem como outras propriedades ou código
que trariam uma experiência inferior nesses dispositivos.

Para ativar estas,
você precisa criar um novo arquivo analysis_options.yaml
na pasta do seu projeto para incluir essas opções.
(Se você tem um arquivo analysis_options.yaml existente,
você pode atualizá-lo)

```yaml
include: package:flutter/analysis_options_user.yaml
analyzer:
 optional-checks:
   chrome-os-manifest-checks
```

Para executar estas a partir da linha de comando, use o seguinte comando:

```console
$ flutter analyze
```

Uma saída de exemplo para este comando pode se parecer com:

```console
Analyzing ...
warning • This hardware feature is not supported on ChromeOS •
android/app/src/main/AndroidManifest.xml:4:33 • unsupported_chrome_os_hardware
```
