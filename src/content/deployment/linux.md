---
ia-translate: true
title: Compile e publique um app Linux na Snap Store
description: Como preparar e publicar um app Linux na Snap store.
short-title: Linux
---

Durante um ciclo de desenvolvimento típico,
você testa um app usando `flutter run` na linha de comando,
ou usando as opções **Run** e **Debug**
na sua IDE. Por padrão,
o Flutter compila uma versão _debug_ do seu app.

Quando estiver pronto para preparar uma versão _release_ do seu app,
por exemplo para [publicar na Snap Store][snap],
esta página pode ajudar.

## Pré-requisitos

Para compilar e publicar na Snap Store, você precisa dos
seguintes componentes:

* Sistema operacional [Ubuntu][], 18.04 LTS (ou superior)
* Ferramenta de linha de comando [Snapcraft][]
* [Gerenciador de contêiner LXD][LXD container manager]

## Configure o ambiente de build

Use as seguintes instruções para configurar seu ambiente de build.

### Instale o snapcraft

Na linha de comando, execute o seguinte:

```console
$ sudo snap install snapcraft --classic
```

### Instale o LXD

Para instalar o LXD, use o seguinte comando:

```console
$ sudo snap install lxd
```

O LXD é necessário durante o processo de build do snap. Uma vez instalado, o LXD precisa ser
configurado para uso. As respostas padrão são adequadas para a maioria dos casos de uso.

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

Na primeira execução, o LXD pode não conseguir conectar ao seu socket:

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

A ferramenta `snapcraft` compila snaps baseado nas instruções
listadas em um arquivo `snapcraft.yaml`.
Para obter uma compreensão básica do snapcraft e seus
conceitos principais, dê uma olhada na [documentação Snap][Snap documentation]
e na [Introdução ao snapcraft][Introduction to snapcraft].
Links e informações adicionais estão listados no
final desta página.

## Exemplo de snapcraft.yaml para Flutter

Coloque o arquivo YAML em seu projeto Flutter
em `<raiz do projeto>/snap/snapcraft.yaml`.
(E lembre-se de que arquivos YAML são sensíveis a espaços em branco!)
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

### Metadata

Esta seção do arquivo `snapcraft.yaml` define e
descreve a aplicação. A versão do snap é
derivada (adotada) da seção de build.

```yaml
name: super-cool-app
version: 0.1.0
summary: Super Cool App
description: Super Cool App that does everything!
```

### Grade, confinement e base

Esta seção define como o snap é compilado.

```yaml
confinement: strict
base: core18
grade: stable
```

**Grade**
: Especifica a qualidade do snap; isso é relevante para
  a etapa de publicação posterior.

**Confinement**
: Especifica qual nível de acesso aos recursos do sistema o snap
  terá uma vez instalado no sistema do usuário final.
  O confinamento estrito limita o acesso da aplicação a
  recursos específicos (definidos por plugs na seção `app`).

**Base**
: Snaps são projetados para serem aplicações autocontidas,
  e, portanto, eles requerem seu próprio sistema de arquivos raiz
  privado conhecido como `base`. A palavra-chave `base` especifica
  a versão usada para fornecer o conjunto mínimo de bibliotecas comuns,
  e montado como sistema de arquivos raiz para a aplicação em runtime.

### Apps

Esta seção define a(s) aplicação(ões) que existem dentro do snap.
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
: Uma lista de uma ou mais extensões. As extensões do Snapcraft
  são componentes reutilizáveis que podem expor conjuntos de bibliotecas
  e ferramentas para um snap em build e runtime,
  sem que o desenvolvedor precise ter conhecimento específico
  dos frameworks incluídos. A extensão `gnome` expõe
  as bibliotecas GTK 3 para o snap Flutter. Isso garante uma
  pegada menor e melhor integração com o sistema.


**Plugs**
: Uma lista de um ou mais plugs para interfaces do sistema.
  Estes são necessários para fornecer funcionalidade necessária
  quando os snaps estão estritamente confinados. Este snap Flutter precisa
  de acesso à rede.

**Interface DBus**
: A [interface DBus][DBus interface] fornece uma maneira para snaps
  comunicarem através do DBus. O snap que fornece o serviço DBus
  declara um slot com o nome DBus bem conhecido
  e qual barramento ele usa. Snaps querendo comunicar
  com o serviço do snap fornecedor declaram um plug para
  o snap fornecedor. Note que uma declaração de snap é
  necessária para que seu snap seja entregue via snap store
  e reivindique este nome DBus bem conhecido (simplesmente faça upload do
  snap para a store e solicite uma revisão manual e
  um revisor dará uma olhada).

  Quando um snap fornecedor é instalado, o snapd irá
  gerar uma política de segurança que permitirá a ele
  ouvir no nome DBus bem conhecido no barramento
  especificado. Se o barramento do sistema for especificado, o snapd também
  gerará política de barramento DBus que permite 'root' possuir
  o nome e qualquer usuário comunicar com o
  serviço. Processos não-snap podem
  comunicar com o snap fornecedor seguindo
  verificações de permissões tradicionais. Outros snaps (consumidores)
  podem apenas comunicar com o snap fornecedor
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
Semelhante às extensões, o snapcraft pode usar vários plugins
(como Python, C, Java e Ruby) para auxiliar no
processo de build. O Snapcraft também tem alguns plugins especiais.

**plugin nil**
: Não executa nenhuma ação e o processo de build real é
  tratado usando uma sobrescrita manual.

**plugin flutter**
: Fornece as ferramentas necessárias do Flutter SDK para que você possa
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
ao menu desktop. Esses arquivos especificam o nome e
ícone da sua aplicação, as categorias a que pertence,
palavras-chave de busca relacionadas e muito mais. Esses arquivos têm a
extensão .desktop e seguem a XDG Desktop Entry
Specification versão 1.1.

### Exemplo de super-cool-app.desktop do Flutter

Coloque o arquivo .desktop em seu projeto Flutter
em `<raiz do projeto>/snap/gui/super-cool-app.desktop`.

**Aviso**: o ícone e o nome do arquivo .desktop devem ser os mesmos do nome do seu app no
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

Coloque seu ícone com extensão .png em seu projeto Flutter
em `<raiz do projeto>/snap/gui/super-cool-app.png`.


## Compile o snap

Uma vez que o arquivo `snapcraft.yaml` esteja completo,
execute `snapcraft` da seguinte forma a partir do diretório raiz
do projeto.

Para usar o backend VM Multipass:

```console
$ snapcraft
```

Para usar o backend de contêiner LXD:

```console
$ snapcraft --use-lxd
```

## Teste o snap

Uma vez que o snap seja compilado, você terá um arquivo `<name>.snap`
no diretório raiz do seu projeto.

$ sudo snap install ./super-cool-app_0.1.0_amd64.snap --dangerous

## Publique

Agora você pode publicar o snap.
O processo consiste no seguinte:

1. Crie uma conta de desenvolvedor em [snapcraft.io][], se você
   ainda não tiver feito isso.
1. Registre o nome do app. O registro pode ser feito
   tanto usando o portal Web UI da Snap Store, quanto pela
   linha de comando, da seguinte forma:
   ```console
   $ snapcraft login
   $ snapcraft register
   ```
1. Publique o app. Depois de ler a próxima seção
   para aprender sobre como selecionar um canal da Snap Store,
   envie o snap para a store:
   ```console
   $ snapcraft upload --release=<channel> <file>.snap
   ```

### Canais da Snap Store

A Snap Store usa canais para diferenciar entre
diferentes versões de snaps.

O comando `snapcraft upload` faz upload do arquivo snap para
a store. No entanto, antes de executar este comando,
você precisa aprender sobre os diferentes canais de release.
Cada canal consiste em três componentes:

**Track**
: Todos os snaps devem ter um track padrão chamado latest.
  Este é o track implícito, a menos que especificado de outra forma.

**Risk**
: Define a prontidão da aplicação.
  Os níveis de risco usados na snap store são:
  `stable`, `candidate`, `beta` e `edge`.

**Branch**
: Permite a criação de sequências de snap
  de curta duração para testar correções de bugs.

### Revisão automática da Snap Store

A Snap Store executa várias verificações automatizadas
contra seu snap. Também pode haver uma revisão manual,
dependendo de como o snap foi compilado e se há
questões de segurança específicas. Se as verificações passarem
sem erros, o snap fica disponível na store.

## Recursos adicionais

Você pode aprender mais a partir dos seguintes links no
site [snapcraft.io][]:

* [Channels][]
* [Environment variables][]
* [Interface management][]
* [Parts environment variables][]
* [Releasing to the Snap Store][]
* [Snapcraft extensions][]
* [Supported plugins][]



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
