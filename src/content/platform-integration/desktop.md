---
ia-translate: true
title: Suporte Desktop para Flutter
description: Informações gerais sobre o suporte Flutter para apps desktop.
---

Flutter fornece suporte para compilar
um app desktop nativo para Windows, macOS ou Linux.
O suporte desktop do Flutter também se estende a plugins&mdash;você
pode instalar plugins existentes que suportam as plataformas Windows,
macOS ou Linux, ou você pode criar seus próprios.

:::note
Esta página cobre o desenvolvimento de apps para todas as plataformas
desktop. Depois de ler isso, você pode mergulhar em
informações específicas da plataforma nos seguintes links:

* [Building Windows apps with Flutter][]
* [Building macOS apps with Flutter][]
* [Building Linux apps with Flutter][]
:::

[Building Windows apps with Flutter]: /platform-integration/windows/building
[Building macOS apps with Flutter]: /platform-integration/macos/building
[Building Linux apps with Flutter]: /platform-integration/linux/building

## Criar um novo projeto

Você pode usar os seguintes passos
para criar um novo projeto com suporte desktop.

### Configurar ferramentas de desenvolvimento desktop

Consulte o guia para seu ambiente desktop de destino:

* [Install Linux desktop devtools][Linux-devtools]
* [Install macOS desktop devtools][macOS-devtools]
* [Install Windows desktop devtools][Windows-devtools]

[Linux-devtools]: /get-started/install/linux/desktop
[macOS-devtools]: /get-started/install/macos/desktop
[Windows-devtools]: /get-started/install/windows/desktop

Se `flutter doctor` encontrar problemas ou componentes faltando
para uma plataforma que você não quer desenvolver,
você pode ignorar esses avisos. Ou você pode desabilitar a
plataforma completamente usando o comando `flutter config`,
por exemplo:

```console
$ flutter config --no-enable-ios
```

Outras flags disponíveis:

* `--no-enable-windows-desktop`
* `--no-enable-linux-desktop`
* `--no-enable-macos-desktop`
* `--no-enable-web`
* `--no-enable-android`
* `--no-enable-ios`

Depois de habilitar o suporte desktop,
reinicie seu IDE para que ele possa detectar o novo dispositivo.

### Criar e executar

Criar um novo projeto com suporte desktop não é diferente
de [criar um novo projeto Flutter][creating a new Flutter project] para outras plataformas.

Uma vez que você tenha configurado seu ambiente para suporte
desktop, você pode criar e executar uma aplicação desktop
tanto no IDE quanto pela linha de comando.

[creating a new Flutter project]: /get-started/test-drive

#### Usando um IDE

Depois de configurar seu ambiente para suportar
desktop, certifique-se de reiniciar o IDE se ele já
estava em execução.

Crie uma nova aplicação no seu IDE e ele automaticamente
cria versões iOS, Android, web e desktop do seu app.
No menu suspenso de dispositivos, selecione **windows (desktop)**,
**macOS (desktop)** ou **linux (desktop)**
e execute sua aplicação para vê-la iniciar no desktop.

#### Pela linha de comando

Para criar uma nova aplicação que inclui suporte desktop
(além de suporte mobile e web), execute os seguintes comandos,
substituindo `my_app` pelo nome do seu projeto:

```console
$ flutter create my_app
$ cd my_app
```

Para iniciar sua aplicação pela linha de comando,
digite um dos seguintes comandos a partir do topo
do pacote:

```console
C:\> flutter run -d windows
$ flutter run -d macos
$ flutter run -d linux
```

:::note
Se você não fornecer a flag `-d`, `flutter run` lista
os destinos disponíveis para escolher.
:::

## Construir um app de release

Para gerar um build de release,
execute um dos seguintes comandos:

```console
PS C:\> flutter build windows
$ flutter build macos
$ flutter build linux
```

## Adicionar suporte desktop a um app Flutter existente

Para adicionar suporte desktop a um projeto Flutter existente,
execute o seguinte comando em um terminal a partir do
diretório raiz do projeto:

```console
$ flutter create --platforms=windows,macos,linux .
```

Isso adiciona os arquivos e diretórios desktop necessários
ao seu projeto Flutter existente.
Para adicionar apenas plataformas desktop específicas,
altere a lista `platforms` para incluir apenas
a(s) plataforma(s) que você deseja adicionar.

## Suporte a plugins

Flutter no desktop suporta uso e criação de plugins.
Para usar um plugin que suporta desktop,
siga os passos para plugins em [using packages][].
Flutter adiciona automaticamente o código nativo necessário
ao seu projeto, como em qualquer outra plataforma.

### Escrevendo um plugin

Quando você começar a construir seus próprios plugins,
você vai querer manter a federação em mente.
Federação é a habilidade de definir vários
pacotes diferentes, cada um direcionado a um
conjunto diferente de plataformas, reunidos
em um único plugin para facilitar o uso pelos desenvolvedores.
Por exemplo, a implementação Windows do
`url_launcher` é na verdade `url_launcher_windows`,
mas um desenvolvedor Flutter pode simplesmente adicionar o
pacote `url_launcher` ao seu `pubspec.yaml`
como uma dependência e o processo de build puxa
a implementação correta baseada na plataforma de destino.
Federação é útil porque diferentes equipes com
diferentes expertises podem construir implementações de plugins
para diferentes plataformas.
Você pode adicionar uma nova implementação de plataforma a qualquer
plugin federado endossado no pub.dev,
desde que você coordene este esforço com o
autor original do plugin.

Para mais informações, incluindo informações
sobre plugins endossados, veja os seguintes recursos:

* [Developing packages and plugins][], particularmente a
  seção [Federated plugins][].
* [How to write a Flutter web plugin, part 2][],
  cobre a estrutura de plugins federados e
  contém informações aplicáveis a plugins
  desktop.
* [Modern Flutter Plugin Development][] cobre
  melhorias recentes ao suporte de plugins do Flutter.

[using packages]: /packages-and-plugins/using-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[How to write a Flutter web plugin, part 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[Modern Flutter Plugin Development]: {{site.flutter-medium}}/modern-flutter-plugin-development-4c3ee015cf5a

## Exemplos e codelabs

[Write a Flutter desktop application][]
: Um codelab que o guia através da construção
de uma aplicação desktop que integra a API
GraphQL do GitHub com seu app Flutter.

Você pode executar os seguintes exemplos como apps desktop,
assim como baixar e inspecionar o código-fonte para
aprender mais sobre o suporte desktop do Flutter.

Wonderous app [running app][wonderous-app], [repo][wonderous-repo]
: Um app de showcase que usa Flutter para criar uma interface de usuário altamente expressiva.
  Wonderous foca em entregar uma experiência de usuário acessível e de alta qualidade
  enquanto inclui interações envolventes e animações inovadoras.
  Para executar Wonderous como um app desktop, clone o projeto e
  siga as instruções fornecidas no [README][wonderous-readme].

Flokk [announcement blogpost][gskinner-flokk-blogpost], [repo][gskinner-flokk-repo]
: Um gerenciador de contatos Google que integra com GitHub e Twitter.
  Ele sincroniza com sua conta Google, importa seus contatos
  e permite que você os gerencie.

[Photo Search app][]
: Uma aplicação de exemplo construída como uma aplicação desktop que
  usa plugins com suporte desktop.

[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[wonderous-readme]: {{site.repo.wonderous}}#wonderous
[Photo Search app]: {{site.repo.samples}}/tree/main/desktop_photo_search
[gskinner-flokk-repo]: {{site.github}}/gskinnerTeam/flokk
[gskinner-flokk-blogpost]: https://blog.gskinner.com/archives/2020/09/flokk-how-we-built-a-desktop-app-using-flutter.html
[Write a Flutter desktop application]: {{site.codelabs}}/codelabs/flutter-github-client
