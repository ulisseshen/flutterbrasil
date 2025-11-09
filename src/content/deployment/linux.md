---
ia-translate: true
title: Compilar e lançar um app Linux na Snap Store
description: Como preparar e lançar um app Linux na Snap Store.
shortTitle: Linux
---

Durante um ciclo típico de desenvolvimento,
você testa um app usando `flutter run` na linha de comando,
ou usando as opções **Run** e **Debug**
no seu IDE. Por padrão,
Flutter compila uma versão _debug_ do seu app.

Quando estiver pronto para preparar uma versão _release_ do seu app,
por exemplo para [publicar na Snap Store][snap] ou um
[canal alternativo](#additional-deployment-resources),
esta página pode ajudar.

## Pré-requisitos

Para compilar e publicar na Snap Store, você precisa dos
seguintes componentes:

* SO [Ubuntu][], 18.04 LTS (ou superior)
* Ferramenta de linha de comando [Snapcraft][]
* [Gerenciador de container LXD][LXD container manager]

## Configurar o ambiente de build

Use as seguintes instruções para configurar seu ambiente de build.

### Instalar snapcraft

Na linha de comando, execute o seguinte:

```console
$ sudo snap install snapcraft --classic
```

### Instalar LXD

Para instalar LXD, use o seguinte comando:

```console
$ sudo snap install lxd
```

LXD é necessário durante o processo de build do snap.
Uma vez instalado, LXD precisa ser configurado para uso.
As respostas padrão são adequadas para a maioria dos casos de uso.

```console
$ sudo lxd init
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty disk or partition? (yes/no) [default=no]:
Size in GB of the new loop device (1GB minimum) [default=5GB]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]:
Would you like LXD to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

Na primeira execução, LXD pode não conseguir conectar ao seu socket:

```console
An error occurred when trying to communicate with the 'LXD'
provider: cannot connect to the LXD socket
('/var/snap/lxd/common/lxd/unix.socket').
```

Isso significa que você precisa adicionar seu nome de usuário ao grupo LXD
(lxd), então saia da sua sessão e faça login novamente:

```console
$ sudo usermod -a -G lxd <your username>
```

## Visão geral do snapcraft

A ferramenta `snapcraft` compila snaps baseada nas instruções
listadas em um arquivo `snapcraft.yaml`.
Para obter uma compreensão básica do snapcraft e seus
conceitos principais, dê uma olhada na [documentação Snap][Snap documentation]
e na [Introdução ao snapcraft][Introduction to snapcraft].
Links e informações adicionais estão listados na
parte inferior desta página.

## Exemplo Flutter snapcraft.yaml

Coloque o arquivo YAML no seu projeto
Flutter em `<project root>/snap/snapcraft.yaml`.
(E lembre-se que arquivos YAML são sensíveis a espaço em branco!)
Por exemplo:

```yaml
name: super-cool-app
version: 0.1.0
summary: Super Cool App
description: Super Cool App that does everything!

confinement: strict
base: core22
grade: stable

slots:
  dbus-super-cool-app: # adjust accordingly to your app name
    interface: dbus
    bus: session
    name: org.bar.super_cool_app # adjust accordingly to your app name and

apps:
  super-cool-app:
    command: super_cool_app
    extensions: [gnome] # gnome includes the libraries required by flutter
    plugs:
    - network
    slots:
      - dbus-super-cool-app
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # The main entry-point file of the application
```

As seguintes seções explicam as várias partes do arquivo YAML.

### Metadados

Esta seção do arquivo `snapcraft.yaml` define e
descreve a aplicação. A versão snap é
derivada (adotada) da seção build.

```yaml
name: super-cool-app
version: 0.1.0
summary: Super Cool App
description: Super Cool App that does everything!
```

### Grade, confinement, e base

Esta seção define como o snap é compilado.

```yaml
confinement: strict
base: core22
grade: stable
```

**Grade**
: Especifica a qualidade do snap; isso é relevante para
  o passo de publicação posterior.

**Confinement**
: Especifica qual nível de acesso a recursos do sistema o snap
  terá uma vez instalado no sistema do usuário final.
  Confinamento estrito limita o acesso da aplicação a
  recursos específicos (definidos por plugs na seção `app`).

**Base**
: Snaps são projetados para serem aplicações auto-contidas,
  e portanto, eles requerem seu próprio sistema de arquivos raiz
  privado conhecido como `base`. A palavra-chave `base` especifica
  a versão usada para fornecer o conjunto mínimo de bibliotecas comuns,
  e montada como o sistema de arquivos raiz para a aplicação em runtime.

### Apps

Esta seção define a(s) aplicação(ões) que existe(m) dentro do snap.
Pode haver uma ou mais aplicações por snap. Este exemplo
tem uma única aplicação&mdash;super_cool_app.

```yaml
apps:
  super-cool-app:
    command: super_cool_app
    extensions: [gnome]
```

**Command**
: Aponta para o binário, relativo à raiz do snap,
  e executa quando o snap é invocado.

**Extensions**
: Uma lista de uma ou mais extensões. Extensões Snapcraft
  são componentes reutilizáveis que podem expor conjuntos de bibliotecas
  e ferramentas para um snap em tempo de build e runtime,
  sem que o desenvolvedor precise ter conhecimento específico
  de frameworks incluídos. A extensão `gnome` expõe
  as bibliotecas GTK 3 para o snap Flutter. Isso garante uma
  pegada menor e melhor integração com o sistema.


**Plugs**
: Uma lista de um ou mais plugs para interfaces do sistema.
  Estes são necessários para fornecer funcionalidade necessária
  quando snaps são estritamente confinados. Este snap Flutter precisa
  de acesso à rede.

**Interface DBus**
: A [interface DBus][DBus interface] fornece uma maneira para snaps se
  comunicarem via DBus. O snap que fornece o serviço DBus
  declara um slot com o nome DBus conhecido
  e qual barramento ele usa. Snaps que querem se comunicar
  com o serviço do snap provedor declaram um plug para
  o snap provedor. Note que uma declaração snap é
  necessária para que seu snap seja entregue via snap store
  e reivindique este nome DBus conhecido (simplesmente faça upload do
  snap para a store e solicite uma revisão manual e
  um revisor dará uma olhada).

  Quando um snap provedor é instalado, snapd irá
  gerar política de segurança que permitirá que ele
  escute no nome DBus conhecido no barramento
  especificado. Se o barramento do sistema for especificado, snapd também
  gerará política de barramento DBus que permite que 'root' possua
  o nome e qualquer usuário se comunique com o
  serviço. Processos não-snap têm permissão para
  se comunicar com o snap provedor seguindo
  verificações de permissão tradicionais. Outros snaps (consumidores)
  só podem se comunicar com o snap provedor
  conectando a interface dos snaps.

```plaintext
dbus-super-cool-app: # adjust accordingly to your app name
  interface: dbus
  bus: session
  name: dev.site.super_cool_app
```

### Parts

Esta seção define as fontes necessárias para
montar o snap.

Parts podem ser baixadas e compiladas automaticamente usando plugins.
Similar a extensões, snapcraft pode usar vários plugins
(como Python, C, Java, e Ruby) para auxiliar no
processo de compilação. Snapcraft também tem alguns plugins especiais.

**plugin nil**
: Não executa nenhuma ação e o processo de build real é
  tratado usando uma sobrescrita manual.

**plugin flutter**
: Fornece as ferramentas Flutter SDK necessárias para que você possa
  usá-las sem ter que baixar e configurar manualmente
  as ferramentas de build.

```yaml
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # The main entry-point file of the application
```


## Arquivo desktop e ícone


Arquivos de entrada desktop são usados para adicionar uma aplicação
ao menu desktop. Estes arquivos especificam o nome e
ícone da sua aplicação, as categorias a que pertence,
palavras-chave de busca relacionadas e mais. Estes arquivos têm a
extensão .desktop e seguem a XDG Desktop Entry
Specification versão 1.1.

### Exemplo Flutter super-cool-app.desktop

Coloque o arquivo .desktop no seu projeto Flutter
em `<project root>/snap/gui/super-cool-app.desktop`.

**Aviso**: ícone e nome do arquivo .desktop devem ser os mesmos que o nome do seu app no
arquivo yaml!

Por exemplo:

```yaml
[Desktop Entry]
Name=Super Cool App
Comment=Super Cool App that does everything
Exec=super-cool-app
Icon=${SNAP}/meta/gui/super-cool-app.png # Replace name with your app name.
Terminal=false
Type=Application
Categories=Education; # Adjust accordingly your snap category.
```

Coloque seu ícone com extensão .png no seu projeto
Flutter em `<project root>/snap/gui/super-cool-app.png`.


## Compilar o snap

Uma vez que o arquivo `snapcraft.yaml` está completo,
execute `snapcraft` da seguinte forma a partir do diretório raiz
do projeto.

Para usar o backend Multipass VM:

```console
$ snapcraft
```

Para usar o backend de container LXD:

```console
$ snapcraft --use-lxd
```

## Testar o snap

Uma vez que o snap é compilado, você terá um arquivo `<name>.snap`
no diretório raiz do seu projeto.

$ sudo snap install ./super-cool-app_0.1.0_amd64.snap --dangerous

## Publicar

Você pode agora publicar o snap.
O processo consiste do seguinte:

1. Crie uma conta de desenvolvedor em [snapcraft.io][], se você
   ainda não o fez.
1. Registre o nome do app. O registro pode ser feito
   usando o portal Web UI da Snap Store, ou da
   linha de comando, da seguinte forma:
   ```console
   $ snapcraft login
   $ snapcraft register
   ```
1. Lance o app. Depois de ler a próxima seção
   para aprender sobre selecionar um canal da Snap Store,
   envie o snap para a store:
   ```console
   $ snapcraft upload --release=<channel> <file>.snap
   ```

### Canais da Snap Store

A Snap Store usa canais para diferenciar entre
diferentes versões de snaps.

O comando `snapcraft upload` faz upload do arquivo snap para
a store. No entanto, antes de executar este comando,
você precisa aprender sobre os diferentes canais de lançamento.
Cada canal consiste de três componentes:

**Track**
: Todos os snaps devem ter uma track padrão chamada latest.
  Esta é a track implícita a menos que especificado de outra forma.

**Risk**
: Define a prontidão da aplicação.
  Os níveis de risco usados na snap store são:
  `stable`, `candidate`, `beta`, e `edge`.

**Branch**
: Permite criação de sequências snap
  de curta duração para testar correções de bugs.

### Revisão automática da Snap Store

A Snap Store executa várias verificações automatizadas contra
seu snap. Também pode haver uma revisão manual,
dependendo de como o snap foi compilado, e se há
quaisquer preocupações de segurança específicas. Se as verificações passarem
sem erros, o snap fica disponível na store.

## Recursos adicionais de snapcraft

Você pode aprender mais a partir dos seguintes links no
site [snapcraft.io][]:

* [Channels][]
* [Environment variables][]
* [Interface management][]
* [Parts environment variables][]
* [Releasing to the Snap Store][]
* [Snapcraft extensions][]
* [Supported plugins][]

## Recursos adicionais de deployment

### [fastforge][]

> Uma ferramenta de empacotamento e distribuição de aplicações Flutter tudo-em-um,
fornecendo uma solução única para atender várias necessidades de distribuição.

Suporta formatos de empacotamento populares como, appimage, deb, pacman, rpm, e mais.

### [flatpak-flutter][]

> Ferramentas de manifesto Flatpak para o build offline de apps Flutter.

Suporta preparação Flatpak para publicação no [Flathub][].


[Environment variables]: https://snapcraft.io/docs/environment-variables
[Flutter wiki]: {{site.repo.flutter}}/tree/main/docs
[Interface management]: https://snapcraft.io/docs/interface-management
[DBus interface]: https://snapcraft.io/docs/dbus-interface
[Introduction to snapcraft]: https://snapcraft.io/blog/introduction-to-snapcraft
[LXD container manager]: https://linuxcontainers.org/lxd/downloads/
[Multipass virtualization manager]: https://multipass.run/
[Parts environment variables]: https://snapcraft.io/docs/parts-environment-variables
[Releasing to the Snap Store]: https://snapcraft.io/docs/releasing-to-the-snap-store
[Channels]: https://docs.snapcraft.io/channels
[snap]: https://snapcraft.io/store
[Snap documentation]: https://snapcraft.io/docs
[Snapcraft]: https://snapcraft.io/snapcraft
[snapcraft.io]: https://snapcraft.io/
[Snapcraft extensions]: https://snapcraft.io/docs/snapcraft-extensions
[Supported plugins]: https://snapcraft.io/docs/supported-plugins
[Ubuntu]: https://ubuntu.com/download/desktop
[fastforge]: {{site.github}}/fastforgedev/fastforge
[flatpak-flutter]: {{site.github}}/TheAppgineer/flatpak-flutter
[Flathub]: https://flathub.org
