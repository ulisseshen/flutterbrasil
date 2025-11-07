---
ia-translate: true
title: Construindo apps macOS com Flutter
description: Considerações específicas da plataforma para construir para macOS com Flutter.
toc: true
short-title: Desenvolvimento macOS
---

Esta página discute considerações únicas para construir
apps macOS com Flutter, incluindo integração com shell
e distribuição de apps macOS através da Apple Store.

## Integrando com o visual e estilo do macOS

Embora você possa usar qualquer estilo visual ou tema que escolher
para construir um app macOS, você pode querer adaptar seu app
para alinhar mais completamente com o visual e estilo do macOS.
Flutter inclui o conjunto de widgets [Cupertino][],
que fornece um conjunto de widgets para
a linguagem de design atual do iOS.
Muitos desses widgets, incluindo sliders,
switches e controles segmentados,
também são apropriados para uso no macOS.

Alternativamente, você pode achar que o pacote [macos_ui][]
atende bem às suas necessidades.
Este pacote fornece widgets e temas que
implementam a linguagem de design do macOS,
incluindo um frame e scaffold `MacosWindow`,
toolbars, botões pulldown e
pop-up, e diálogos modais.

[Cupertino]: /ui/widgets/cupertino
[macos_ui]: {{site.pub}}/packages/macos_ui

## Construindo apps macOS

Para distribuir sua aplicação macOS, você pode
[distribuí-la através da macOS App Store][distribute it through the macOS App Store],
ou você pode distribuir o `.app` em si,
talvez do seu próprio site.
A partir do macOS 10.14.5, você precisa notarizar
sua aplicação macOS antes de distribuí-la
fora da macOS App Store.

O primeiro passo em ambos os processos acima
envolve trabalhar com sua aplicação dentro do Xcode.
Para poder compilar sua aplicação de dentro do
Xcode, você primeiro precisa construir a aplicação para release
usando o comando `flutter build`, então abrir a
aplicação Flutter macOS Runner.

```bash
flutter build macos
open macos/Runner.xcworkspace
```

Uma vez dentro do Xcode, siga a
[documentação da Apple sobre notarizar aplicações macOS][documentation on notarizing macOS Applications], ou
[sobre distribuir uma aplicação através da App Store][on distributing an application through the App Store].
Você também deve ler a
seção [suporte específico do macOS](#entitlements-and-the-app-sandbox)
abaixo para entender como entitlements,
o App Sandbox e o Hardened Runtime
impactam sua aplicação distribuível.

[Build and release a macOS app][] fornece um passo a passo
mais detalhado de lançar um app Flutter na
App Store.

[distribute it through the macOS App Store]: {{site.apple-dev}}/macos/submit/
[documentation on notarizing macOS Applications]:{{site.apple-dev}}/documentation/xcode/notarizing_macos_software_before_distribution
[on distributing an application through the App Store]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[Build and release a macOS app]: /deployment/macos

## Entitlements e o App Sandbox

Builds do macOS são configurados por padrão para serem assinados,
e em sandbox com App Sandbox.
Isso significa que se você quiser conferir capacidades ou serviços
específicos ao seu app macOS,
tais como:

* Acessar a internet
* Capturar filmes e imagens da câmera integrada
* Acessar arquivos

Então você deve configurar _entitlements_ específicos no Xcode.
A seção a seguir mostra como fazer isso.

### Configurando entitlements

Gerenciar configurações de sandbox é feito nos
arquivos `macos/Runner/*.entitlements`. Ao editar
estes arquivos, você não deve remover as exceções
originais do `Runner-DebugProfile.entitlements`
(que suportam conexões de rede de entrada e JIT),
pois elas são necessárias para que os modos `debug` e `profile`
funcionem corretamente.

Se você está acostumado a gerenciar arquivos de entitlement através da
**UI de capabilities do Xcode**, esteja ciente de que o editor de capabilities
atualiza apenas um dos dois arquivos ou,
em alguns casos, cria um arquivo de entitlements totalmente novo
e muda o projeto para usá-lo para todas as configurações.
Qualquer um dos cenários causa problemas. Recomendamos que você
edite os arquivos diretamente. A menos que você tenha uma razão muito específica,
você deve sempre fazer mudanças idênticas em ambos os arquivos.

Se você mantiver o App Sandbox habilitado (o que é necessário se você
planeja distribuir sua aplicação na [App Store][]),
você precisa gerenciar entitlements para sua aplicação
quando adicionar certos plugins ou outra funcionalidade nativa.
Por exemplo, usar o plugin [`file_chooser`][]
requer adicionar o entitlement
`com.apple.security.files.user-selected.read-only` ou
`com.apple.security.files.user-selected.read-write`.
Outro entitlement comum é
`com.apple.security.network.client`,
que você deve adicionar se fizer qualquer requisição de rede.

Sem o entitlement `com.apple.security.network.client`,
por exemplo, requisições de rede falham com uma mensagem como:

```console
flutter: SocketException: Connection failed
(OS Error: Operation not permitted, errno = 1),
address = example.com, port = 443
```

:::important
O entitlement `com.apple.security.network.server`,
que permite conexões de rede de entrada,
está habilitado por padrão apenas para builds `debug` e `profile`
para permitir comunicações entre ferramentas Flutter
e um app em execução. Se você precisa permitir
requisições de rede de entrada em sua aplicação,
você deve adicionar o entitlement `com.apple.security.network.server`
ao `Runner-Release.entitlements` também,
caso contrário sua aplicação funcionará corretamente para testes debug ou
profile, mas falhará com builds release.
:::

Para mais informações sobre estes tópicos,
veja [App Sandbox][] e [Entitlements][]
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
de assinatura válido para poder construir.

Por padrão, o arquivo entitlements permite JIT para
builds debug mas, como com App Sandbox, você pode
precisar gerenciar outros entitlements.
Se você tiver tanto App Sandbox quanto Hardened
Runtime habilitados, você pode precisar adicionar múltiplos
entitlements para o mesmo recurso.
Por exemplo, acesso ao microfone requereria tanto
`com.apple.security.device.audio-input` (para Hardened Runtime)
quanto `com.apple.security.device.microphone` (para App Sandbox).

Para mais informações sobre este tópico,
veja [Hardened Runtime][] no site Apple Developer.

[Hardened Runtime]: {{site.apple-dev}}/documentation/security/hardened_runtime
