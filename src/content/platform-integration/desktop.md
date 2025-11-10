---
title: Suporte a desktop para Flutter
description: Informações gerais sobre o suporte do Flutter para apps desktop.
ia-translate: true
---

O Flutter fornece suporte para compilar
um app desktop nativo para Windows, macOS ou Linux.
O suporte a desktop do Flutter também se estende a plugins&mdash;você
pode instalar plugins existentes que suportam as plataformas Windows,
macOS ou Linux, ou você pode criar os seus próprios.

:::note
Esta página cobre o desenvolvimento de apps para todas as plataformas
desktop. Depois de ler isso, você pode mergulhar nas
informações específicas da plataforma nos seguintes links:

* [Construindo apps Windows com Flutter][Building Windows apps with Flutter]
* [Construindo apps macOS com Flutter][Building macOS apps with Flutter]
* [Construindo apps Linux com Flutter][Building Linux apps with Flutter]
:::

[Building Windows apps with Flutter]: /platform-integration/windows/building
[Building macOS apps with Flutter]: /platform-integration/macos/building
[Building Linux apps with Flutter]: /platform-integration/linux/building

## Criar um novo projeto

Você pode usar as seguintes etapas
para criar um novo projeto com suporte a desktop.

### Configurar ferramentas de desenvolvimento desktop

Consulte o guia para seu ambiente desktop alvo:

* [Instalar ferramentas de desenvolvimento desktop Linux][Linux-devtools]
* [Instalar ferramentas de desenvolvimento desktop macOS][macOS-devtools]
* [Instalar ferramentas de desenvolvimento desktop Windows][Windows-devtools]

[Linux-devtools]: /platform-integration/linux/setup#set-up-tooling
[macOS-devtools]: /platform-integration/macos/setup#set-up-tooling
[Windows-devtools]: /platform-integration/windows/setup#set-up-tooling

Se o `flutter doctor` encontrar problemas ou componentes faltando
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

Após habilitar o suporte a desktop,
reinicie seu IDE para que ele possa detectar o novo dispositivo.

### Criar e executar

Criar um novo projeto com suporte a desktop não é diferente
de [criar um novo projeto Flutter][creating a new Flutter project] para outras plataformas.

Uma vez que você configurou seu ambiente para suporte a
desktop, você pode criar e executar um aplicativo desktop
tanto no IDE quanto na linha de comando.

[creating a new Flutter project]: /reference/create-new-app

#### Usando um IDE

Depois de ter configurado seu ambiente para suportar
desktop, certifique-se de reiniciar o IDE se ele já
estava em execução.

Crie uma nova aplicação no seu IDE e ele automaticamente
cria versões iOS, Android, web e desktop do seu app.
No menu suspenso de dispositivos, selecione **windows (desktop)**,
**macOS (desktop)** ou **linux (desktop)**
e execute sua aplicação para vê-la ser iniciada no desktop.

#### Da linha de comando

Para criar uma nova aplicação que inclui suporte a desktop
(além do suporte a mobile e web), execute os seguintes comandos,
substituindo `my_app` pelo nome do seu projeto:

```console
$ flutter create my_app
$ cd my_app
```

Para iniciar sua aplicação da linha de comando,
insira um dos seguintes comandos a partir do topo
do pacote:

```console
C:\> flutter run -d windows
$ flutter run -d macos
$ flutter run -d linux
```

:::note
Se você não fornecer a flag `-d`, `flutter run` lista
os alvos disponíveis para escolher.
:::

## Construir um app de release

Para gerar uma build de release,
execute um dos seguintes comandos:

```console
PS C:\> flutter build windows
$ flutter build macos
$ flutter build linux
```

## Adicionar suporte a desktop a um app Flutter existente

Para adicionar suporte a desktop a um projeto Flutter existente,
execute o seguinte comando em um terminal a partir do
diretório raiz do projeto:

```console
$ flutter create --platforms=windows,macos,linux .
```

Isso adiciona os arquivos e diretórios desktop necessários
ao seu projeto Flutter existente.
Para adicionar apenas plataformas desktop específicas,
altere a lista `platforms` para incluir apenas
a(s) plataforma(s) que você quer adicionar.

## Suporte a plugins

O Flutter no desktop suporta usar e criar plugins.
Para usar um plugin que suporta desktop,
siga as etapas para plugins em [usando pacotes][using packages].
O Flutter adiciona automaticamente o código nativo necessário
ao seu projeto, como em qualquer outra plataforma.

### Escrevendo um plugin

Quando você começar a construir seus próprios plugins,
você vai querer manter a federação em mente.
Federação é a capacidade de definir vários
pacotes diferentes, cada um direcionado a um
conjunto diferente de plataformas, reunidos
em um único plugin para facilitar o uso pelos desenvolvedores.
Por exemplo, a implementação Windows do
`url_launcher` é na verdade `url_launcher_windows`,
mas um desenvolvedor Flutter pode simplesmente adicionar o
pacote `url_launcher` ao seu `pubspec.yaml`
como uma dependência e o processo de build puxa
a implementação correta com base na plataforma alvo.
A federação é útil porque diferentes equipes com
diferentes expertises podem construir implementações de plugins
para diferentes plataformas.
Você pode adicionar uma nova implementação de plataforma a qualquer
plugin federado endossado no pub.dev,
desde que você coordene esse esforço com o
autor original do plugin.

Para mais informações, incluindo informações
sobre plugins endossados, veja os seguintes recursos:

* [Desenvolvendo pacotes e plugins][Developing packages and plugins], particularmente a
  seção [Plugins federados][Federated plugins].
* [Como escrever um plugin Flutter web, parte 2][How to write a Flutter web plugin, part 2],
  cobre a estrutura de plugins federados e
  contém informações aplicáveis a plugins
  desktop.
* [Desenvolvimento Moderno de Plugin Flutter][Modern Flutter Plugin Development] cobre
  melhorias recentes ao suporte de plugins do Flutter.

[using packages]: /packages-and-plugins/using-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[How to write a Flutter web plugin, part 2]: {{site.flutter-blog}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[Modern Flutter Plugin Development]: {{site.flutter-blog}}/modern-flutter-plugin-development-4c3ee015cf5a

## Exemplos e codelabs

[Escreva um aplicativo Flutter desktop][Write a Flutter desktop application]
: Um codelab que o guia através da construção de
um aplicativo desktop que integra a
API GraphQL do GitHub com seu app Flutter.

Você pode executar os seguintes exemplos como apps desktop,
bem como baixar e inspecionar o código-fonte para
aprender mais sobre o suporte a desktop do Flutter.

App Wonderous [app em execução][wonderous-app], [repositório][wonderous-repo]
: Um app de demonstração que usa Flutter para criar uma interface de usuário altamente expressiva.
  O Wonderous foca em entregar uma experiência de usuário acessível e de alta qualidade
  enquanto inclui interações envolventes e animações inovadoras.
  Para executar o Wonderous como um app desktop, clone o projeto e
  siga as instruções fornecidas no [README][wonderous-readme].

Flokk [post de blog de anúncio][gskinner-flokk-blogpost], [repositório][gskinner-flokk-repo]
: Um gerenciador de contatos Google que se integra com GitHub e Twitter.
  Ele sincroniza com sua conta Google, importa seus contatos,
  e permite que você os gerencie.

[App Photo Search][Photo Search app]
: Um aplicativo de exemplo construído como um aplicativo desktop que
  usa plugins com suporte a desktop.

[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[wonderous-readme]: {{site.repo.wonderous}}#wonderous
[Photo Search app]: {{site.repo.samples}}/tree/main/desktop_photo_search
[gskinner-flokk-repo]: {{site.github}}/gskinnerTeam/flokk
[gskinner-flokk-blogpost]: https://blog.gskinner.com/archives/2020/09/flokk-how-we-built-a-desktop-app-using-flutter.html
[Write a Flutter desktop application]: {{site.codelabs}}/codelabs/flutter-github-client
