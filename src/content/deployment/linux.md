---
ia-translate: true
title: Construir e lançar um aplicativo Linux na Snap Store
description: Como se preparar e lançar um aplicativo Linux na Snap Store.
short-title: Linux
---

Durante um ciclo de desenvolvimento típico,
você testa um aplicativo usando `flutter run` na linha de comando,
ou usando as opções **Run** e **Debug**
em seu IDE. Por padrão,
o Flutter constrói uma versão _debug_ do seu aplicativo.

Quando você estiver pronto para preparar uma versão _release_ do seu aplicativo,
por exemplo, para [publicar na Snap Store][snap],
esta página pode ajudar.

## Pré-requisitos

Para construir e publicar na Snap Store, você precisa dos
seguintes componentes:

* Sistema operacional [Ubuntu][], 18.04 LTS (ou superior)
* Ferramenta de linha de comando [Snapcraft][]
* [Gerenciador de contêineres LXD][]

## Configurar o ambiente de construção

Use as instruções a seguir para configurar seu ambiente de construção.

### Instalar o snapcraft

Na linha de comando, execute o seguinte:

```console
$ sudo snap install snapcraft --classic
```

### Instalar o LXD

Para instalar o LXD, use o seguinte comando:

```console
$ sudo snap install lxd
```

O LXD é necessário durante o processo de construção do snap. Uma vez instalado, o LXD precisa ser
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

Na primeira execução, o LXD pode não conseguir se conectar ao seu socket:

```console
An error occurred when trying to communicate with the 'LXD'
provider: cannot connect to the LXD socket
('/var/snap/lxd/common/lxd/unix.socket').
```

Isso significa que você precisa adicionar seu nome de usuário ao grupo LXD
(lxd), então saia da sua sessão e entre novamente:

```console
$ sudo usermod -a -G lxd <seu nome de usuário>
```

## Visão geral do snapcraft

A ferramenta `snapcraft` constrói snaps com base nas instruções
listadas em um arquivo `snapcraft.yaml`.
Para obter uma compreensão básica do snapcraft e de seus
conceitos principais, dê uma olhada na [documentação do Snap][]
e na [Introdução ao snapcraft][].
Links e informações adicionais estão listados na
parte inferior desta página.

## Exemplo de snapcraft.yaml do Flutter

Coloque o arquivo YAML em seu projeto Flutter
em `<raiz do projeto>/snap/snapcraft.yaml`.
(E lembre-se de que os arquivos YAML são sensíveis a espaços em branco!)
Por exemplo:

```yaml
name: super-cool-app
version: 0.1.0
summary: Aplicativo Super Legal
description: Aplicativo Super Legal que faz tudo!

confinement: strict
base: core22
grade: stable

slots:
  dbus-super-cool-app: # ajuste de acordo com o nome do seu aplicativo
    interface: dbus
    bus: session
    name: org.bar.super_cool_app # ajuste de acordo com o nome do seu aplicativo e 
    
apps:
  super-cool-app:
    command: super_cool_app
    extensions: [gnome] # gnome inclui as bibliotecas exigidas pelo flutter
    plugs:
    - network
    slots:
      - dbus-super-cool-app
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # O arquivo principal de entrada do aplicativo
```

As seções a seguir explicam as várias partes do arquivo YAML.

### Metadados

Esta seção do arquivo `snapcraft.yaml` define e
descreve o aplicativo. A versão do snap é
derivada (adotada) da seção de construção.

```yaml
name: super-cool-app
version: 0.1.0
summary: Aplicativo Super Legal
description: Aplicativo Super Legal que faz tudo!
```

### Grade, confinamento e base

Esta seção define como o snap é construído.

```yaml
confinement: strict
base: core18
grade: stable
```

**Grade**
: Especifica a qualidade do snap; isso é relevante para
  a etapa de publicação posteriormente.

**Confinamento**
: Especifica qual nível de acesso aos recursos do sistema o snap
  terá uma vez instalado no sistema do usuário final.
  O confinamento estrito limita o acesso do aplicativo a
  recursos específicos (definidos por _plugs_ na seção `app`).

**Base**
: Os snaps são projetados para serem aplicativos autocontidos
  e, portanto, eles exigem seu próprio sistema de arquivos raiz
  privado conhecido como `base`. A palavra-chave `base` especifica
  a versão usada para fornecer o conjunto mínimo de bibliotecas comuns,
  e montada como o sistema de arquivos raiz para o aplicativo em tempo de execução.

### Apps

Esta seção define os aplicativos que existem dentro do snap.
Pode haver um ou mais aplicativos por snap. Este exemplo
tem um único aplicativo&mdash;super_cool_app.

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
  e ferramentas para um snap em tempo de construção e execução,
  sem que o desenvolvedor precise ter conhecimento específico
  das estruturas incluídas. A extensão `gnome` expõe
  as bibliotecas GTK 3 para o snap Flutter. Isso garante uma
  pegada menor e melhor integração com o sistema.

**Plugs**
: Uma lista de um ou mais _plugs_ para interfaces de sistema.
  Eles são necessários para fornecer a funcionalidade necessária
  quando os snaps são estritamente confinados. Este snap Flutter precisa
  de acesso à rede.

**Interface DBus**
: A [interface DBus][] fornece uma maneira para os snaps se
  comunicarem via DBus. O snap que fornece o serviço DBus
  declara um _slot_ com o nome DBus conhecido e qual _bus_ ele usa.
  Snaps que desejam se comunicar com o serviço do snap fornecedor
  declaram um _plug_ para o snap fornecedor. Observe que uma declaração de snap
  é necessária para que seu snap seja entregue através da snap store
  e reivindique este nome DBus conhecido (basta carregar o
  snap na loja e solicitar uma revisão manual e um
  revisor dará uma olhada).

  Quando um snap fornecedor é instalado, o snapd irá
  gerar uma política de segurança que permitirá que ele
  escutar o nome DBus conhecido no _bus_ especificado.
  Se o _bus_ do sistema for especificado, o snapd também irá
  gerar uma política de _bus_ DBus que permite que 'root' possua
  o nome e qualquer usuário se comunique com o
  serviço. Processos não-snap são permitidos para se
  comunicarem com o snap fornecedor seguindo as
  verificações de permissões tradicionais. Outros snaps
  (consumidores) podem se comunicar com o snap fornecedor
  apenas conectando a interface dos snaps.

```plaintext
dbus-super-cool-app: # ajuste de acordo com o nome do seu aplicativo
  interface: dbus
  bus: session
  name: dev.site.super_cool_app
```

### Parts

Esta seção define as fontes necessárias para
montar o snap.

As partes podem ser baixadas e construídas automaticamente usando _plugins_.
Semelhante às extensões, o snapcraft pode usar vários _plugins_
(como Python, C, Java e Ruby) para auxiliar no
processo de construção. O Snapcraft também possui alguns _plugins_ especiais.

**plugin nil**
: Não executa nenhuma ação e o processo de construção real é
  tratado usando uma substituição manual.

**plugin flutter**
: Fornece as ferramentas necessárias do Flutter SDK para que você possa
  usá-lo sem ter que baixar manualmente e configurar
  as ferramentas de construção.

```yaml
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # O arquivo principal de entrada do aplicativo
```

## Arquivo de desktop e ícone

Arquivos de entrada de desktop são usados para adicionar um aplicativo
ao menu da área de trabalho. Esses arquivos especificam o nome e
o ícone do seu aplicativo, as categorias às quais ele pertence,
palavras-chave de pesquisa relacionadas e muito mais. Esses arquivos têm a
extensão .desktop e seguem a XDG Desktop Entry
Specification versão 1.1.

### Exemplo de super-cool-app.desktop do Flutter

Coloque o arquivo .desktop em seu projeto Flutter
em `<raiz do projeto>/snap/gui/super-cool-app.desktop`.

**Aviso**: o ícone e o nome do arquivo .desktop devem ser os mesmos do nome do seu aplicativo no
arquivo yaml!

Por exemplo:

```yaml
[Desktop Entry]
Name=Aplicativo Super Legal
Comment=Aplicativo Super Legal que faz tudo
Exec=super-cool-app
Icon=${SNAP}/meta/gui/super-cool-app.png # Substitua o nome pelo nome do seu aplicativo.
Terminal=false
Type=Application
Categories=Education; # Ajuste de acordo com sua categoria de snap.
```

Coloque seu ícone com extensão .png em seu projeto Flutter
em `<raiz do projeto>/snap/gui/super-cool-app.png`.

## Construir o snap

Assim que o arquivo `snapcraft.yaml` estiver completo,
execute `snapcraft` da seguinte forma, a partir do diretório raiz
do projeto.

Para usar o backend Multipass VM:

```console
$ snapcraft
```

Para usar o backend do contêiner LXD:

```console
$ snapcraft --use-lxd
```

## Testar o snap

Assim que o snap for construído, você terá um arquivo `<nome>.snap`
em seu diretório raiz do projeto.

$ sudo snap install ./super-cool-app_0.1.0_amd64.snap --dangerous

## Publicar

Agora você pode publicar o snap.
O processo consiste no seguinte:

1. Crie uma conta de desenvolvedor em [snapcraft.io][], se você
   ainda não fez isso.
2. Registre o nome do aplicativo. O registro pode ser feito
   usando o portal da Web UI da Snap Store ou a partir da
   linha de comando, da seguinte forma:
   ```console
   $ snapcraft login
   $ snapcraft register
   ```
3. Libere o aplicativo. Depois de ler a próxima seção
   para aprender sobre como selecionar um canal da Snap Store,
   envie o snap para a loja:
   ```console
   $ snapcraft upload --release=<canal> <arquivo>.snap
   ```

### Canais da Snap Store

A Snap Store usa canais para diferenciar entre
diferentes versões de snaps.

O comando `snapcraft upload` envia o arquivo snap para
a loja. No entanto, antes de executar este comando,
você precisa aprender sobre os diferentes canais de lançamento.
Cada canal consiste em três componentes:

**Track**
: Todos os snaps devem ter uma _track_ padrão chamada latest.
  Esta é a _track_ implícita, a menos que especificado de outra forma.

**Risk**
: Define a prontidão do aplicativo.
  Os níveis de risco usados na Snap Store são:
  `stable`, `candidate`, `beta` e `edge`.

**Branch**
: Permite a criação de sequências de snap de curta duração
  para testar correções de bugs.

### Revisão automática da Snap Store

A Snap Store executa várias verificações automatizadas
em seu snap. Pode haver também uma revisão manual,
dependendo de como o snap foi construído e se houver
quaisquer preocupações específicas de segurança. Se as verificações passarem
sem erros, o snap fica disponível na loja.

## Recursos adicionais

Você pode aprender mais nos seguintes links no site
[snapcraft.io][]:

* [Canais][]
* [Variáveis de ambiente][]
* [Gerenciamento de interface][]
* [Variáveis de ambiente de _parts_][]
* [Lançando para a Snap Store][]
* [Extensões do Snapcraft][]
* [_Plugins_ suportados][]

[Variáveis de ambiente]: https://snapcraft.io/docs/environment-variables
[Flutter wiki]: {{site.repo.flutter}}/tree/master/docs
[Gerenciamento de interface]: https://snapcraft.io/docs/interface-management
[Interface DBus]: https://snapcraft.io/docs/dbus-interface
[Introdução ao snapcraft]: https://snapcraft.io/blog/introduction-to-snapcraft
[Gerenciador de contêineres LXD]: https://linuxcontainers.org/lxd/downloads/
[Gerenciador de virtualização Multipass]: https://multipass.run/
[Variáveis de ambiente de _parts_]: https://snapcraft.io/docs/parts-environment-variables
[Lançando para a Snap Store]: https://snapcraft.io/docs/releasing-to-the-snap-store
[Canais]: https://docs.snapcraft.io/channels
[snap]: https://snapcraft.io/store
[Documentação do Snap]: https://snapcraft.io/docs
[Snapcraft]: https://snapcraft.io/snapcraft
[snapcraft.io]: https://snapcraft.io/
[Extensões do Snapcraft]: https://snapcraft.io/docs/snapcraft-extensions
[_Plugins_ suportados]: https://snapcraft.io/docs/supported-plugins
[Ubuntu]: https://ubuntu.com/download/desktop
