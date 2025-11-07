---
title: Ajuda de instalação
description: Esta página descreve alguns problemas comuns de instalação que novos usuários do Flutter enfrentaram e oferece sugestões para resolvê-los.
ia-translate: true
---

Esta página descreve alguns problemas comuns de instalação que novos usuários do Flutter
enfrentaram e oferece sugestões sobre como resolvê-los.
Se você ainda está enfrentando problemas, considere entrar em contato com qualquer um dos
recursos listados em [canais de suporte da comunidade][community support channels].
Para adicionar um tópico a esta página ou fazer uma correção,
você pode abrir uma issue ou um pull request usando os botões no topo da página.

## Obter o Flutter SDK

<a id="unable-to-find-the-flutter-command"></a>
### Não é possível encontrar o comando `flutter`

__Como é esse problema?__

Quando você tenta executar o comando `flutter`,
o console falha em encontrá-lo.
O erro geralmente se parece com o seguinte:

```plaintext
'flutter' is not recognized as an internal or external command operable program or batch file
```

Mensagens de erro no macOS e Linux podem parecer ligeiramente diferentes da
do Windows.

__Explicação e sugestões__

Você adicionou o Flutter à variável de ambiente `PATH` para sua plataforma?
No Windows, siga estas [instruções para adicionar um comando
ao seu path][windows path].

Se você já [configurou o VS Code][set up VS Code] para desenvolvimento Flutter,
você pode usar o prompt **Locate SDK** da extensão Flutter
para identificar a localização da sua pasta `flutter`.

Veja também: [Configuring PATH and Environment Variables - Dart Code][config path]


### Flutter em pastas especiais


__Como é esse problema?__

Executar seu projeto Flutter produz um erro como o seguinte:

```plaintext
The Flutter SDK is installed in a protected folder and may not function correctly.
Please move the SDK to a location that is user-writable without Administration permissions and restart.
```

__Explicação e sugestões__

No Windows, isso geralmente acontece quando o Flutter é instalado
em um diretório como
`C:\Program Files\` que requer privilégios elevados.
Tente relocar o Flutter para uma pasta diferente,
como `C:\src\flutter`.

<a id="android-setup"></a>
## Configuração do Android

### Tendo múltiplas versões do Java instaladas

__Como é esse problema?__

O comando `flutter doctor --android-licenses` falha.
Executar `flutter doctor –verbose` dá uma mensagem de erro
como a seguinte:

```plaintext
java.lang.UnsupportedClassVersionError: com/android/prefs/AndroidLocationsProvider
has been compiled by a more recent version of the Java Runtime (class file version 55.0),
this version of the Java Runtime only recognizes class file versions up to 52.0
```

__Explicação e sugestões__

O erro ocorre quando uma versão mais antiga do
Java Development Kit (JDK)
está instalada no seu computador.

Se você não precisa de múltiplas versões do Java,
desinstale os JDKs existentes do seu computador.
Flutter automaticamente usa o JDK incluído no Android Studio.

Se você precisa de outra versão do Java,
tente a solução alternativa descrita nesta
[issue do GitHub][java binary path]
até que uma solução de longo prazo seja implementada.
Para mais informações,
confira o [guia de migração Android Java Gradle][Android Java Gradle migration guide]
ou [flutter doctor --android-licenses not working due to
    java.lang.UnsupportedClassVersionError - Stack Overflow][so java version].

### Componente `cmdline-tools` está faltando

__Como é esse problema?__

O comando `flutter doctor` reclama que as
`cmdline-tools` estão faltando no Android toolchain.
Por exemplo:

```plaintext noHighlight
[!] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
    • Android SDK at C:\Users\My PC\AppData\Local\Android\sdk
    X cmdline-tools component is missing
```

__Explicação e sugestões__

A forma mais fácil de obter as cmdline-tools é através do
SDK Manager no Android Studio.
Para fazer isso, use as seguintes instruções:

1. Abra o SDK Manager do Android Studio,
   selecionando **Tools > SDK Manager** na barra de menu.
2. Selecione o Android SDK mais recente
   (ou uma versão específica que seu app requer),
   Android SDK Command-line Tools e Android SDK Build-Tools.
3. Clique em **Apply** para instalar os artefatos selecionados.

![Android Studio SDK
Manager](/assets/images/docs/get-started/install_android_tools.png)

Se você não está usando Android Studio,
você pode baixar as ferramentas usando a
ferramenta de linha de comando [sdkmanager][].

## Outros problemas

### Exit code 69

__Como é esse problema?__

Executar um comando `flutter` produz um erro "exit code: 69",
como mostrado no exemplo a seguir:

```plaintext
Running "flutter pub get" in flutter_tools...
Resolving dependencies in .../flutter/packages/flutter_tools... (28.0s)
Got TLS error trying to find package test at https://pub.dev/.
pub get failed
command:
".../flutter/bin/cache/dart-sdk/bin/
dart __deprecated_pub --color --directory
.../flutter/packages/flutter_tools get --example"
pub env: {
  "FLUTTER_ROOT": ".../flutter",
  "PUB_ENVIRONMENT": "flutter_cli:get",
  "PUB_CACHE": ".../.pub-cache",
}
exit code: 69
```

__Explicação e sugestões__

Este problema está relacionado à rede.
Tente as seguintes instruções para solucionar o problema:

* Verifique sua conexão com a internet.
  Certifique-se de que você está conectado à
  internet e que sua conexão está estável.
* Reinicie seus dispositivos, incluindo seu computador
  e equipamentos de rede.
* Use uma VPN para ajudar a contornar quaisquer restrições que
  possam impedir você de se conectar à rede.
* Se você tentou todos esses passos e ainda
  está obtendo o erro, imprima logs verbosos
  com o comando `flutter doctor -v` e peça ajuda em
  um dos [canais de suporte da comunidade][community support channels].

<a id="community-support"></a>
## Suporte da comunidade

A comunidade Flutter é prestativa e acolhedora.
Se nenhuma das sugestões acima resolver seu problema de instalação,
considere pedir suporte em um dos seguintes canais:

* [/r/flutterhelp](https://www.reddit.com/r/flutterhelp/) no Reddit
* [/r/flutterdev](https://discord.gg/rflutterdev) no Discord,
  particularmente o canal `install-and-setup` neste servidor.
* [StackOverflow][],
  em particular, questões marcadas com [#flutter][] ou [#dart][].

Para ser respeitoso com o tempo de todos,
pesquise no arquivo por um problema similar antes de postar um novo. 

[StackOverflow]: {{site.so}}
[#dart]: {{site.so}}/questions/tagged/dart
[#flutter]: {{site.so}}/questions/tagged/flutter
[Android Java Gradle migration guide]: /release/breaking-changes/android-java-gradle-migration-guide
[community support channels]: #community-support
[java binary path]: {{site.repo.flutter}}/issues/106416#issuecomment-1522198064
[so java version]: {{site.so}}/questions/75328050/
[set up VS Code]: /get-started/editor
[config path]: https://dartcode.org/docs/configuring-path-and-environment-variables/
[sdkmanager]: {{site.android-dev}}/studio/command-line/sdkmanager
[windows path]: https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows
