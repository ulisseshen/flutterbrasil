---
ia-translate: true
title: Direcionando para ChromeOS com Android
description: Considerações específicas da plataforma para desenvolvimento para ChromeOS com Flutter.
---

Esta página discute considerações únicas para construir
apps Android que suportam ChromeOS com Flutter.

## Dicas e truques de Flutter & ChromeOS

Para as versões atuais do ChromeOS, apenas certas portas do
Linux são expostas para o resto do ambiente.
Aqui está um exemplo de como iniciar
o Flutter DevTools para um app Android com portas
que funcionarão:

```console
$ flutter pub global run devtools --port 8000
$ cd path/to/your/app
$ flutter run --observatory-port=8080
```

Em seguida, navegue para http://127.0.0.1:8000/#
no seu navegador Chrome e insira a URL do seu
aplicativo. O último comando `flutter run` que você
acabou de executar deve produzir uma URL similar ao formato
`http://127.0.0.1:8080/auth_code=/`. Use esta URL
e selecione "Connect" para iniciar o Flutter DevTools
para seu app Android.

#### Análise de lint ChromeOS do Flutter

O Flutter tem verificações de análise de lint específicas do ChromeOS
para garantir que o app que você está construindo
funcione bem no ChromeOS. Ele procura por coisas
como hardware obrigatório no seu Android Manifest
que não estão disponíveis em dispositivos ChromeOS,
permissões que implicam solicitações de hardware não suportado,
assim como outras propriedades ou código
que trariam uma experiência inferior nesses dispositivos.

Para ativá-las,
você precisa criar um novo arquivo analysis_options.yaml
na pasta do seu projeto para incluir essas opções.
(Se você já tem um arquivo analysis_options.yaml existente,
pode atualizá-lo)

```yaml
include: package:flutter/analysis_options_user.yaml
analyzer:
 optional-checks:
   chrome-os-manifest-checks
```

Para executá-las a partir da linha de comando, use o seguinte comando:

```console
$ flutter analyze
```

Uma saída de exemplo para este comando pode parecer assim:

```console
Analyzing ...
warning • This hardware feature is not supported on ChromeOS •
android/app/src/main/AndroidManifest.xml:4:33 • unsupported_chrome_os_hardware
```
