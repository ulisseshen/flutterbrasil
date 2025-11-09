---
ia-translate: true
title: Criando apps macOS com Flutter
description: Considerações específicas da plataforma para criar apps macOS com Flutter.
shortTitle: Desenvolvimento macOS
---

Esta página discute considerações exclusivas para criar
apps macOS com Flutter, incluindo integração com o shell
e distribuição de apps macOS através da Apple Store.

## Integrando com a aparência do macOS

Embora você possa usar qualquer estilo visual ou tema que escolher
para criar um app macOS, você pode querer adaptar seu app
para alinhar mais completamente com a aparência do macOS.
Flutter inclui o conjunto de widgets [Cupertino][Cupertino],
que fornece um conjunto de widgets para
a linguagem de design atual do iOS.
Muitos desses widgets, incluindo sliders,
switches e controles segmentados,
também são apropriados para uso no macOS.

Alternativamente, você pode achar que o pacote [macos_ui][macos_ui]
é adequado para suas necessidades.
Este pacote fornece widgets e temas que
implementam a linguagem de design do macOS,
incluindo um frame e scaffold `MacosWindow`,
toolbars, botões pulldown e
pop-up, e diálogos modais.

[Cupertino]: /ui/widgets/cupertino
[macos_ui]: {{site.pub}}/packages/macos_ui

## Criando apps macOS

Para distribuir sua aplicação macOS, você pode
[distribuí-la através da macOS App Store][distribute it through the macOS App Store],
ou pode distribuir o `.app` em si,
talvez a partir do seu próprio site.
Você precisa notarizar sua aplicação macOS antes
de distribuí-la fora da macOS App Store.

O primeiro passo em ambos os processos acima
envolve trabalhar com sua aplicação dentro do Xcode.
Para poder compilar sua aplicação de dentro do
Xcode, você primeiro precisa criar a aplicação para release
usando o comando `flutter build`, e então abrir a
aplicação Flutter macOS Runner.

```bash
flutter build macos
open macos/Runner.xcworkspace
```

Uma vez dentro do Xcode, siga a
[documentação da Apple sobre notarização de aplicações macOS][documentation on notarizing macOS Applications], ou
[sobre distribuição de uma aplicação através da App Store][on distributing an application through the App Store].
Você também deve ler a
seção de [suporte específico para macOS](#entitlements-and-the-app-sandbox)
abaixo para entender como os entitlements,
o App Sandbox e o Hardened Runtime
impactam sua aplicação distribuível.

[Build and release a macOS app][Build and release a macOS app] fornece um passo a passo
mais detalhado de como publicar um app Flutter na
App Store.

[distribute it through the macOS App Store]: {{site.apple-dev}}/macos/submit/
[documentation on notarizing macOS Applications]:{{site.apple-dev}}/documentation/xcode/notarizing_macos_software_before_distribution
[on distributing an application through the App Store]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[Build and release a macOS app]: /deployment/macos

## Entitlements e o App Sandbox

As builds macOS são configuradas por padrão para serem assinadas
e isoladas com App Sandbox.
Isso significa que se você quiser conceder capacidades
ou serviços específicos ao seu app macOS,
como os seguintes:

* Acessar a internet
* Capturar filmes e imagens da câmera integrada
* Acessar arquivos

Então você deve configurar _entitlements_ específicos no Xcode.
A seção a seguir mostra como fazer isso.

### Configurando entitlements

O gerenciamento das configurações de sandbox é feito nos
arquivos `macos/Runner/*.entitlements`. Ao editar
esses arquivos, você não deve remover as exceções
originais do `Runner-DebugProfile.entitlements`
(que suportam conexões de rede de entrada e JIT),
pois elas são necessárias para que os modos
`debug` e `profile` funcionem corretamente.

Se você está acostumado a gerenciar arquivos de entitlement através
da **UI de capabilities do Xcode**, saiba que o editor de capabilities
atualiza apenas um dos dois arquivos ou,
em alguns casos, cria um arquivo de entitlements
completamente novo e muda o projeto para usá-lo em todas as configurações.
Qualquer um dos cenários causa problemas. Recomendamos que você
edite os arquivos diretamente. A menos que você tenha um motivo
muito específico, você deve sempre fazer alterações idênticas em ambos os arquivos.

Se você mantiver o App Sandbox habilitado (o que é necessário se você
planeja distribuir sua aplicação na [App Store][App Store]),
você precisa gerenciar entitlements para sua aplicação
quando adicionar certos plugins ou outras funcionalidades nativas.
Por exemplo, usar o plugin [`file_chooser`][`file_chooser`]
requer adicionar o entitlement
`com.apple.security.files.user-selected.read-only` ou
`com.apple.security.files.user-selected.read-write`.
Outro entitlement comum é
`com.apple.security.network.client`,
que você deve adicionar se fizer qualquer solicitação de rede.

Sem o entitlement `com.apple.security.network.client`,
por exemplo, as solicitações de rede falham com uma mensagem como:

```console
flutter: SocketException: Connection failed
(OS Error: Operation not permitted, errno = 1),
address = example.com, port = 443
```

:::important
O entitlement `com.apple.security.network.server`,
que permite conexões de rede de entrada,
é habilitado por padrão apenas para builds `debug` e `profile`
para permitir comunicações entre as ferramentas Flutter
e um app em execução. Se você precisa permitir
solicitações de rede de entrada em sua aplicação,
você deve adicionar o entitlement `com.apple.security.network.server`
ao `Runner-Release.entitlements` também,
caso contrário sua aplicação funcionará corretamente para testes
de debug ou profile, mas falhará com builds de release.
:::

Para mais informações sobre esses tópicos,
veja [App Sandbox][App Sandbox] e [Entitlements][Entitlements]
no site Apple Developer.

[App Sandbox]: {{site.apple-dev}}/documentation/security/app_sandbox
[App Store]: {{site.apple-dev}}/app-store/submissions/
[Entitlements]: {{site.apple-dev}}/documentation/bundleresources/entitlements
[`file_chooser`]: {{site.github}}/google/flutter-desktop-embedding/tree/master/plugins/file_chooser

## Hardened Runtime

Se você escolher distribuir sua aplicação fora
da App Store, você precisa notarizar sua aplicação
para compatibilidade com macOS.
Isso requer habilitar a opção Hardened Runtime.
Uma vez que você a tenha habilitado, você precisa de um certificado
de assinatura válido para poder fazer build.

Por padrão, o arquivo de entitlements permite JIT para
builds de debug mas, assim como com o App Sandbox, você pode
precisar gerenciar outros entitlements.
Se você tiver tanto App Sandbox quanto Hardened
Runtime habilitados, você pode precisar adicionar múltiplos
entitlements para o mesmo recurso.
Por exemplo, acesso ao microfone exigiria tanto
`com.apple.security.device.audio-input` (para Hardened Runtime)
quanto `com.apple.security.device.microphone` (para App Sandbox).

Para mais informações sobre este tópico,
veja [Hardened Runtime][Hardened Runtime] no site Apple Developer.

[Hardened Runtime]: {{site.apple-dev}}/documentation/security/hardened_runtime
