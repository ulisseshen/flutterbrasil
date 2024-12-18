---
ia-translate: true
title: Construindo aplicativos macOS com Flutter
description: Considerações específicas da plataforma para construir para macOS com Flutter.
toc: true
short-title: Desenvolvimento macOS
---

Esta página discute considerações exclusivas para a construção de aplicativos macOS com Flutter, incluindo a integração com o shell e a distribuição de aplicativos macOS por meio da Apple Store.

## Integrando com a aparência do macOS

Embora você possa usar qualquer estilo visual ou tema que escolher para construir um aplicativo macOS, talvez você queira adaptar seu aplicativo para se alinhar mais totalmente com a aparência do macOS. O Flutter inclui o conjunto de widgets [Cupertino], que fornece um conjunto de widgets para a linguagem de design iOS atual. Muitos desses widgets, incluindo controles deslizantes, switches e controles segmentados, também são apropriados para uso no macOS.

Como alternativa, você pode achar o pacote [macos_ui][] adequado às suas necessidades. Este pacote fornece widgets e temas que implementam a linguagem de design do macOS, incluindo um frame e scaffold `MacosWindow`, toolbars, botões suspensos e pop-up e caixas de diálogo modais.

[Cupertino]: /ui/widgets/cupertino
[macos_ui]: {{site.pub}}/packages/macos_ui

## Construindo aplicativos macOS

Para distribuir seu aplicativo macOS, você pode distribuí-lo por meio da [macOS App Store][], ou pode distribuir o `.app` em si, talvez de seu próprio site. A partir do macOS 10.14.5, você precisa autenticar seu aplicativo macOS antes de distribuí-lo fora da macOS App Store.

A primeira etapa em ambos os processos acima envolve trabalhar com seu aplicativo dentro do Xcode. Para poder compilar seu aplicativo de dentro do Xcode, você primeiro precisa construir o aplicativo para lançamento usando o comando `flutter build`, e então abrir o aplicativo Flutter macOS Runner.

```bash
flutter build macos
open macos/Runner.xcworkspace
```

Uma vez dentro do Xcode, siga a [documentação da Apple sobre como autenticar aplicativos macOS][], ou [sobre como distribuir um aplicativo pela App Store][]. Você também deve ler a seção [suporte específico para macOS](#entitlements-and-the-app-sandbox) abaixo para entender como os entitlements, o App Sandbox e o Hardened Runtime impactam seu aplicativo distribuível.

[Build and release a macOS app][] fornece um passo a passo mais detalhado sobre o lançamento de um aplicativo Flutter na App Store.

[distribute it through the macOS App Store]: {{site.apple-dev}}/macos/submit/
[documentation on notarizing macOS Applications]:{{site.apple-dev}}/documentation/xcode/notarizing_macos_software_before_distribution
[on distributing an application through the App Store]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[Build and release a macOS app]: /deployment/macos

## Entitlements e o App Sandbox

As compilações do macOS são configuradas por padrão para serem assinadas e em sandbox com o App Sandbox. Isso significa que, se você deseja conferir recursos ou serviços específicos em seu aplicativo macOS, como os seguintes:

* Acessar a internet
* Capturar filmes e imagens da câmera integrada
* Acessar arquivos

Então você deve configurar _entitlements_ específicos no Xcode. A seção a seguir informa como fazer isso.

### Configurando entitlements

O gerenciamento das configurações do sandbox é feito nos arquivos `macos/Runner/*.entitlements`. Ao editar esses arquivos, você não deve remover as exceções originais `Runner-DebugProfile.entitlements` (que oferecem suporte a conexões de rede de entrada e JIT), pois elas são necessárias para que os modos `debug` e `profile` funcionem corretamente.

Se você está acostumado a gerenciar arquivos de entitlements por meio da **IU de recursos do Xcode**, esteja ciente de que o editor de recursos atualiza apenas um dos dois arquivos ou, em alguns casos, cria um novo arquivo de entitlements e muda o projeto para usá-lo para todas as configurações. Qualquer um dos cenários causa problemas. Recomendamos que você edite os arquivos diretamente. A menos que você tenha um motivo muito específico, você sempre deve fazer mudanças idênticas em ambos os arquivos.

Se você mantiver o App Sandbox habilitado (o que é necessário se você planeja distribuir seu aplicativo na [App Store][]), você precisará gerenciar os entitlements para seu aplicativo quando adicionar certos plugins ou outras funcionalidades nativas. Por exemplo, usar o plugin [`file_chooser`][] requer adicionar o entitlement `com.apple.security.files.user-selected.read-only` ou `com.apple.security.files.user-selected.read-write`. Outro entitlement comum é `com.apple.security.network.client`, que você deve adicionar se fizer qualquer solicitação de rede.

Sem o entitlement `com.apple.security.network.client`, por exemplo, as solicitações de rede falham com uma mensagem como:

```console
flutter: SocketException: Connection failed
(OS Error: Operation not permitted, errno = 1),
address = example.com, port = 443
```

:::important
O entitlement `com.apple.security.network.server`, que permite conexões de rede de entrada, é habilitado por padrão apenas para compilações `debug` e `profile` para permitir comunicações entre as ferramentas Flutter e um aplicativo em execução. Se você precisar permitir solicitações de rede de entrada em seu aplicativo, você deve adicionar o entitlement `com.apple.security.network.server` ao `Runner-Release.entitlements` também, caso contrário, seu aplicativo funcionará corretamente para testes de depuração ou perfil, mas falhará com compilações de lançamento.
:::

Para mais informações sobre esses tópicos, veja [App Sandbox][] e [Entitlements][] no site Apple Developer.

[App Sandbox]: {{site.apple-dev}}/documentation/security/app_sandbox
[App Store]: {{site.apple-dev}}/app-store/submissions/
[Entitlements]: {{site.apple-dev}}/documentation/bundleresources/entitlements
[`file_chooser`]: {{site.github}}/google/flutter-desktop-embedding/tree/master/plugins/file_chooser

## Hardened Runtime

Se você optar por distribuir seu aplicativo fora da App Store, precisará autenticar seu aplicativo para compatibilidade com o macOS. Isso requer habilitar a opção Hardened Runtime. Depois de habilitá-lo, você precisa de um certificado de assinatura válido para construir.

Por padrão, o arquivo de entitlements permite JIT para compilações de depuração, mas, como com o App Sandbox, você pode precisar gerenciar outros entitlements. Se você tiver o App Sandbox e o Hardened Runtime habilitados, pode precisar adicionar vários entitlements para o mesmo recurso. Por exemplo, o acesso ao microfone exigiria tanto `com.apple.security.device.audio-input` (para Hardened Runtime) quanto `com.apple.security.device.microphone` (para App Sandbox).

Para mais informações sobre este tópico, veja [Hardened Runtime][] no site Apple Developer.

[Hardened Runtime]: {{site.apple-dev}}/documentation/security/hardened_runtime
