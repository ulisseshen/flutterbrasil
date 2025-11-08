---
ia-translate: true
title: Criar relatórios de bugs úteis
description: >
  Onde relatar bugs e solicitar melhorias para o
  Flutter e o site.
---

As instruções neste documento detalham as etapas atuais
necessárias para fornecer os relatórios de bugs mais acionáveis para
crashes e outros comportamentos ruins. Cada etapa é opcional, mas
irá melhorar muito a rapidez com que os problemas são diagnosticados e tratados.
Apreciamos seu esforço em nos enviar o máximo de feedback possível.

## Criar uma issue no GitHub

* Para relatar um crash ou bug do Flutter,
  [crie uma issue no projeto flutter/flutter][Flutter issue].
* Para relatar um problema com o site,
  [crie uma issue no projeto flutter/website][Website issue].

## Fornecer um exemplo de código mínimo reproduzível

Crie um app Flutter mínimo que mostre o problema que você está enfrentando
e cole-o na issue do GitHub.

Para criá-lo, você pode usar o comando `flutter create bug` e atualizar
o arquivo `main.dart`.

Alternativamente, você pode usar o [DartPad][], que é capaz
de criar e executar pequenos apps Flutter.

Se o seu problema vai além do que pode ser colocado em um único arquivo, por exemplo,
você tem um problema com canais nativos, você pode fazer upload do código completo da
reprodução em um repositório separado e vinculá-lo.

## Fornecer diagnósticos do Flutter {#provide-some-flutter-diagnostics}

* Execute `flutter doctor -v` no diretório do seu projeto e cole
  os resultados na issue do GitHub:

```plaintext
[✓] Flutter (Channel stable, 1.22.3, on Mac OS X 10.15.7 19H2, locale en-US)
    • Flutter version 1.22.3 at /Users/me/projects/flutter
    • Framework revision 8874f21e79 (5 days ago), 2020-10-29 14:14:35 -0700
    • Engine revision a1440ca392
    • Dart version 2.10.3

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
    • Android SDK at /Users/me/Library/Android/sdk
    • Platform android-30, build-tools 29.0.2
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 12.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.2, Build version 12B5035g
    • CocoaPods version 1.9.3

[✓] Android Studio (version 4.0)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 50.0.1
    • Dart plugin version 193.7547
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)

[✓] VS Code (version 1.50.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.13.2

[✓] Connected device (1 available)
    • iPhone (mobile) • 00000000-0000000000000000 • ios • iOS 14.0
```

## Executar o comando em modo verbose

Siga essas etapas apenas se o seu problema estiver relacionado à
ferramenta `flutter`.

* Todos os comandos do Flutter aceitam a flag `--verbose`.
  Se anexada à issue, a saída deste comando
  pode ajudar no diagnóstico do problema.
* Anexe os resultados do comando à issue do GitHub.
![flutter verbose](/assets/images/docs/verbose_flag.png){:width="100%"}

## Fornecer os logs mais recentes

* Os logs do dispositivo atualmente conectado são acessados
  usando `flutter logs`.
* Se o crash for reproduzível, limpe os logs
  (⌘ + k no Mac), reproduza o crash e copie os
  logs recém-gerados em um arquivo anexado ao relatório de bug.
* Se você estiver recebendo exceções lançadas pelo framework,
  inclua toda a saída entre e incluindo as linhas
  tracejadas da primeira exceção.
![flutter logs](/assets/images/docs/logs.png){:width="100%"}

## Fornecer o relatório de crash

* Quando o simulador iOS trava,
  um relatório de crash é gerado em `~/Library/Logs/DiagnosticReports/`.
* Quando um dispositivo iOS trava,
  um relatório de crash é gerado em `~/Library/Logs/CrashReporter/MobileDevice`.
* Encontre o relatório correspondente ao crash (geralmente o mais recente)
  e anexe-o à issue do GitHub.
![crash report](/assets/images/docs/crash_reports.png){:width="100%"}


[DartPad]: {{site.dartpad}}
[Flutter issue]: {{site.repo.flutter}}/issues/new/choose
[Website issue]: {{site.repo.this}}/issues/new/choose
