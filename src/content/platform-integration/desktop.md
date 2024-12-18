---
ia-translate: true
title: Suporte a Desktop para Flutter
description: Informações gerais sobre o suporte do Flutter para apps desktop.
---

O Flutter oferece suporte para compilar um app desktop nativo para Windows, macOS ou Linux. O suporte a desktop do Flutter também se estende a plugins&mdash;você pode instalar plugins existentes que suportam as plataformas Windows, macOS ou Linux, ou você pode criar os seus próprios.

:::note
Esta página aborda o desenvolvimento de aplicativos para todas as plataformas desktop. Depois de ler isto, você pode mergulhar em informações específicas da plataforma nos links a seguir:

* [Criando apps Windows com Flutter][]
* [Criando apps macOS com Flutter][]
* [Criando apps Linux com Flutter][]
:::

[Criando apps Windows com Flutter]: /platform-integration/windows/building
[Criando apps macOS com Flutter]: /platform-integration/macos/building
[Criando apps Linux com Flutter]: /platform-integration/linux/building

## Criar um novo projeto

Você pode usar os passos a seguir para criar um novo projeto com suporte a desktop.

### Configurar as devtools de desktop

Consulte o guia para o seu ambiente desktop de destino:

* [Instalar devtools Linux desktop][Linux-devtools]
* [Instalar devtools macOS desktop][macOS-devtools]
* [Instalar devtools Windows desktop][Windows-devtools]

[Linux-devtools]: /get-started/install/linux/desktop
[macOS-devtools]: /get-started/install/macos/desktop
[Windows-devtools]: /get-started/install/windows/desktop

Se o `flutter doctor` encontrar problemas ou componentes ausentes para uma plataforma para a qual você não deseja desenvolver, você pode ignorar esses avisos. Ou você pode desabilitar a plataforma por completo usando o comando `flutter config`, por exemplo:

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

Depois de ativar o suporte a desktop, reinicie sua IDE para que ela possa detectar o novo dispositivo.

### Criar e executar

Criar um novo projeto com suporte a desktop não é diferente de [criar um novo projeto Flutter][] para outras plataformas.

Depois de configurar seu ambiente para suporte a desktop, você pode criar e executar um aplicativo desktop na IDE ou na linha de comando.

[criar um novo projeto Flutter]: /get-started/test-drive

#### Usando uma IDE

Depois de configurar seu ambiente para suportar desktop, certifique-se de reiniciar a IDE se ela já estiver em execução.

Crie um novo aplicativo em sua IDE e ela criará automaticamente versões iOS, Android, web e desktop do seu aplicativo. No menu suspenso do dispositivo, selecione **windows (desktop)**, **macOS (desktop)** ou **linux (desktop)** e execute seu aplicativo para vê-lo iniciar no desktop.

#### Pela linha de comando

Para criar um novo aplicativo que inclua suporte a desktop (além de suporte para mobile e web), execute os seguintes comandos, substituindo `my_app` pelo nome do seu projeto:

```console
$ flutter create my_app
$ cd my_app
```

Para iniciar seu aplicativo pela linha de comando, digite um dos seguintes comandos na raiz do pacote:

```console
C:\> flutter run -d windows
$ flutter run -d macos
$ flutter run -d linux
```

:::note
Se você não fornecer a flag `-d`, `flutter run` lista os alvos disponíveis para escolher.
:::

## Construir um app de release

Para gerar uma build de release, execute um dos seguintes comandos:

```console
PS C:\> flutter build windows
$ flutter build macos
$ flutter build linux
```

## Adicionar suporte a desktop a um app Flutter existente

Para adicionar suporte a desktop a um projeto Flutter existente, execute o seguinte comando em um terminal no diretório raiz do projeto:

```console
$ flutter create --platforms=windows,macos,linux .
```

Isso adiciona os arquivos e diretórios desktop necessários ao seu projeto Flutter existente. Para adicionar apenas plataformas desktop específicas, altere a lista `platforms` para incluir apenas a(s) plataforma(s) que você deseja adicionar.

## Suporte a plugins

O Flutter no desktop oferece suporte ao uso e criação de plugins. Para usar um plugin que oferece suporte a desktop, siga os passos para plugins em [usando pacotes][]. O Flutter adiciona automaticamente o código nativo necessário ao seu projeto, como em qualquer outra plataforma.

### Escrevendo um plugin

Ao começar a construir seus próprios plugins, você vai querer ter em mente a federação. Federação é a capacidade de definir vários pacotes diferentes, cada um direcionado a um conjunto diferente de plataformas, reunidos em um único plugin para facilitar o uso pelos desenvolvedores. Por exemplo, a implementação do Windows do `url_launcher` é realmente `url_launcher_windows`, mas um desenvolvedor Flutter pode simplesmente adicionar o pacote `url_launcher` ao seu `pubspec.yaml` como uma dependência e o processo de build inclui a implementação correta com base na plataforma de destino. A federação é útil porque diferentes equipes com diferentes conhecimentos podem construir implementações de plugin para diferentes plataformas. Você pode adicionar uma nova implementação de plataforma a qualquer plugin federado endossado em pub.dev, desde que coordene esse esforço com o autor original do plugin.

Para obter mais informações, incluindo informações sobre plugins endossados, consulte os seguintes recursos:

* [Desenvolvendo pacotes e plugins][], particularmente a seção de [Plugins federados][].
* [Como escrever um plugin Flutter web, parte 2][], aborda a estrutura de plugins federados e contém informações aplicáveis a plugins desktop.
* [Desenvolvimento moderno de plugins Flutter][] aborda aprimoramentos recentes ao suporte a plugins do Flutter.

[usando pacotes]: /packages-and-plugins/using-packages
[Desenvolvendo pacotes e plugins]: /packages-and-plugins/developing-packages
[Plugins federados]: /packages-and-plugins/developing-packages#federated-plugins
[Como escrever um plugin Flutter web, parte 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[Desenvolvimento moderno de plugins Flutter]: {{site.flutter-medium}}/modern-flutter-plugin-development-4c3ee015cf5a

## Amostras e codelabs

[Escreva um aplicativo Flutter desktop][]
: Um codelab que orienta você na construção de um aplicativo desktop que integra a API GitHub GraphQL com seu aplicativo Flutter.

Você pode executar os seguintes exemplos como aplicativos desktop, bem como baixar e inspecionar o código-fonte para saber mais sobre o suporte a desktop do Flutter.

Aplicativo Wonderous [aplicativo em execução][wonderous-app], [repositório][wonderous-repo]
: Um aplicativo de demonstração que usa Flutter para criar uma interface de usuário altamente expressiva. Wonderous se concentra em oferecer uma experiência de usuário acessível e de alta qualidade, incluindo interações envolventes e animações inovadoras. Para executar o Wonderous como um aplicativo desktop, clone o projeto e siga as instruções fornecidas no [README][wonderous-readme].

Flokk [anúncio do blog][gskinner-flokk-blogpost], [repositório][gskinner-flokk-repo]
: Um gerenciador de contatos do Google que se integra com o GitHub e o Twitter. Ele sincroniza com sua conta do Google, importa seus contatos e permite que você os gerencie.

[Aplicativo Photo Search][]
: Um aplicativo de amostra construído como um aplicativo desktop que usa plugins compatíveis com desktop.

[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[wonderous-readme]: {{site.repo.wonderous}}#wonderous
[Aplicativo Photo Search]: {{site.repo.samples}}/tree/main/desktop_photo_search
[gskinner-flokk-repo]: {{site.github}}/gskinnerTeam/flokk
[gskinner-flokk-blogpost]: https://blog.gskinner.com/archives/2020/09/flokk-how-we-built-a-desktop-app-using-flutter.html
[Escreva um aplicativo Flutter desktop]: {{site.codelabs}}/codelabs/flutter-github-client
