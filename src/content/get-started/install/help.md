---
ia-translate: true
title: Ajuda na instalação
description: Esta página descreve alguns problemas comuns de instalação que novos usuários do Flutter encontraram e oferece sugestões para resolvê-los.
---

Esta página descreve alguns problemas comuns de instalação que novos usuários do Flutter encontraram e oferece sugestões sobre como resolvê-los. Se você ainda estiver enfrentando problemas, considere entrar em contato com qualquer um dos recursos listados em [canais de suporte da comunidade][]. Para adicionar um tópico a esta página ou fazer uma correção, você pode registrar um problema ou uma solicitação pull usando os botões na parte superior da página.

## Obtenha o SDK Flutter

### Impossível encontrar o comando `flutter`

__Como é esse problema?__

Quando você tenta executar o comando `flutter`, o console não consegue encontrá-lo. O erro geralmente se parece com o seguinte:

```plaintext
'flutter' não é reconhecido como um comando interno ou externo, programa operável ou arquivo em lotes
```

As mensagens de erro no macOS e Linux podem ser ligeiramente diferentes da do Windows.

__Explicação e sugestões__

Você adicionou o Flutter à variável de ambiente `PATH` para sua plataforma? No Windows, siga estas [instruções para adicionar um comando ao seu path][windows path].

Se você já [configurou o VS Code][] para desenvolvimento Flutter, pode usar o prompt **Localizar SDK** da extensão Flutter para identificar a localização da sua pasta `flutter`.

Veja também: [Configurando PATH e Variáveis de Ambiente - Dart Code][config path]

### Flutter em pastas especiais

__Como é esse problema?__

Executar seu projeto Flutter produz um erro como o seguinte:

```plaintext
O SDK Flutter está instalado em uma pasta protegida e pode não funcionar corretamente.
Mova o SDK para um local que possa ser gravado pelo usuário sem permissões de administrador e reinicie.
```

__Explicação e sugestões__

No Windows, isso geralmente acontece quando o Flutter é instalado em um diretório como `C:\Program Files\` que exige privilégios elevados. Tente realocar o Flutter para uma pasta diferente, como `C:\src\flutter`.

## Configuração do Android

### Ter várias versões do Java instaladas

__Como é esse problema?__

O comando `flutter doctor --android-licenses` falha. Executar `flutter doctor –verbose` fornece uma mensagem de erro como a seguinte:

```plaintext
java.lang.UnsupportedClassVersionError: com/android/prefs/AndroidLocationsProvider 
foi compilado por uma versão mais recente do Java Runtime (versão do arquivo de classe 55.0), 
esta versão do Java Runtime reconhece apenas versões de arquivo de classe até 52.0
```

__Explicação e sugestões__

O erro ocorre quando uma versão mais antiga do Java Development Kit (JDK) está instalada no seu computador.

Se você não precisar de várias versões do Java, desinstale os JDKs existentes do seu computador. O Flutter usa automaticamente o JDK incluído no Android Studio.

Se você precisar de outra versão do Java, tente a solução alternativa descrita nesta [questão do GitHub][java binary path] até que uma solução de longo prazo seja implementada. Para obter mais informações, consulte o [guia de migração do Android Java Gradle][] ou [flutter doctor --android-licenses não funcionando devido a java.lang.UnsupportedClassVersionError - Stack Overflow][so java version].

### Componente `cmdline-tools` ausente

__Como é esse problema?__

O comando `flutter doctor` reclama que o `cmdline-tools` está ausente da toolchain do Android. Por exemplo:

```plaintext noHighlight
[!] Android toolchain - desenvolver para dispositivos Android (Android SDK versão 33.0.2) 
    • Android SDK em C:\Users\My PC\AppData\Local\Android\sdk 
    X componente cmdline-tools ausente
```

__Explicação e sugestões__

A maneira mais fácil de obter o cmdline-tools é através do SDK Manager no Android Studio. Para fazer isso, use as seguintes instruções:

1. Abra o SDK Manager no Android Studio, selecionando **Tools > SDK Manager** na barra de menu.
2. Selecione o SDK Android mais recente (ou uma versão específica que seu aplicativo exija), Android SDK Command-line Tools e Android SDK Build-Tools.
3. Clique em **Apply** para instalar os artefatos selecionados.

![Android Studio SDK Manager](/assets/images/docs/get-started/install_android_tools.png)

Se você não estiver usando o Android Studio, pode baixar as ferramentas usando a ferramenta de linha de comando [sdkmanager][].

## Outros problemas

### Código de saída 69

__Como é esse problema?__

Executar um comando `flutter` produz um erro de "código de saída: 69", como mostrado no exemplo a seguir:

```plaintext
Executando "flutter pub get" em flutter_tools...
Resolvendo dependências em .../flutter/packages/flutter_tools... (28.0s)
Obteve erro TLS ao tentar encontrar o pacote test em https://pub.dev/.
pub get falhou
comando:
".../flutter/bin/cache/dart-sdk/bin/
dart __deprecated_pub --color --directory
.../flutter/packages/flutter_tools get --example"
pub env: {
  "FLUTTER_ROOT": ".../flutter",
  "PUB_ENVIRONMENT": "flutter_cli:get",
  "PUB_CACHE": ".../.pub-cache",
}
código de saída: 69
```

__Explicação e sugestões__

Este problema está relacionado à rede. Tente as seguintes instruções para solucionar problemas:

* Verifique sua conexão com a internet. Certifique-se de que você está conectado à internet e que sua conexão está estável.
* Reinicie seus dispositivos, incluindo seu computador e equipamentos de rede.
* Use uma VPN para ajudar a contornar quaisquer restrições que possam impedi-lo de se conectar à rede.
* Se você tentou todas essas etapas e ainda está recebendo o erro, imprima logs detalhados com o comando `flutter doctor -v` e peça ajuda em um dos [canais de suporte da comunidade][].

## Suporte da comunidade

A comunidade Flutter é prestativa e acolhedora. Se nenhuma das sugestões acima resolver o problema de instalação, considere pedir suporte em um dos seguintes canais:

* [/r/flutterhelp](https://www.reddit.com/r/flutterhelp/) no Reddit
* [/r/flutterdev](https://discord.gg/rflutterdev) no Discord, particularmente o canal `install-and-setup` neste servidor.
* [StackOverflow][], em particular, perguntas marcadas com [#flutter][] ou [#dart][].

Para ser respeitoso com o tempo de todos, pesquise no arquivo um problema semelhante antes de postar um novo.

[StackOverflow]: {{site.so}}
[#dart]: {{site.so}}/questions/tagged/dart
[#flutter]: {{site.so}}/questions/tagged/flutter
[guia de migração do Android Java Gradle]: /release/breaking-changes/android-java-gradle-migration-guide
[canais de suporte da comunidade]: #community-support
[java binary path]: {{site.repo.flutter}}/issues/106416#issuecomment-1522198064
[so java version]: {{site.so}}/questions/75328050/
[configurou o VS Code]: /get-started/editor
[config path]: https://dartcode.org/docs/configuring-path-and-environment-variables/
[sdkmanager]: {{site.android-dev}}/studio/command-line/sdkmanager
[windows path]: https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows
