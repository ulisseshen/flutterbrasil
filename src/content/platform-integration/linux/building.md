---
ia-translate: true
title: Criar aplicativos Linux com Flutter
description: Considerações específicas da plataforma ao criar para Linux com Flutter.
toc: true
short-title: Desenvolvimento Linux
---

Esta página discute considerações exclusivas para criar
aplicativos Linux com Flutter, incluindo integração com shell
e preparação de aplicativos para distribuição.

## Integrar com Linux

A interface de programação do Linux,
compreendendo funções de biblioteca e chamadas de sistema,
é projetada em torno da linguagem C e ABI.
Felizmente, o Dart fornece o pacote `dart:ffi`,
que permite que programas Dart chamem bibliotecas C.

Interfaces de Função Estrangeira (FFI) permitem que aplicativos Flutter
executem o seguinte com bibliotecas nativas:

* alocar memória nativa com `malloc` ou `calloc`
* suportar ponteiros, structs e callbacks
* suportar tipos de Interface Binária de Aplicação (ABI) como `long` e `size_t`

Para saber mais sobre como chamar bibliotecas C do Flutter,
consulte [Interoperação C usando `dart:ffi`][].

Muitos aplicativos se beneficiam ao usar um pacote que envolve as chamadas de biblioteca
subjacentes em uma API Dart mais conveniente e idiomática.
[A Canonical construiu uma série de pacotes][Canonical]
com foco em habilitar Dart e Flutter no Linux,
incluindo suporte para notificações de desktop,
dbus, gerenciamento de rede e Bluetooth.

Em geral, muitos outros [pacotes oferecem suporte à criação de aplicativos Linux][support-linux],
incluindo pacotes comuns como [`url_launcher`],
[`shared_preferences`], [`file_selector`] e [`path_provider`].

[C interop using `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[Canonical]: {{site.pub}}/publishers/canonical.com/packages
[support-linux]: {{site.pub}}/packages?q=platform%3Alinux
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## Preparar aplicativos Linux para distribuição

O binário executável pode ser encontrado em seu projeto em
`build/linux/x64/<modo de build>/bundle/`.
Junto com o binário executável no diretório `bundle`,
você pode encontrar dois diretórios:

* `lib` contém os arquivos de biblioteca `.so` necessários
* `data` contém os recursos de dados do aplicativo, como fontes ou imagens

Além desses arquivos, seu aplicativo também depende de várias
bibliotecas do sistema operacional contra as quais foi compilado.
Para ver a lista completa de bibliotecas,
use o comando `ldd` no diretório do seu aplicativo.

Por exemplo, suponha que você tenha um aplicativo de desktop Flutter
chamado `linux_desktop_test`.
Para inspecionar suas dependências de biblioteca do sistema, use os seguintes comandos:

```console
$ flutter build linux --release
$ ldd build/linux/x64/release/bundle/linux_desktop_test
```

Para empacotar este aplicativo para distribuição,
inclua tudo no diretório `bundle`
e verifique se o sistema Linux de destino possui todas as bibliotecas de sistema necessárias.

Isso pode exigir apenas o uso do seguinte comando.

```console
$ sudo apt-get install libgtk-3-0 libblkid1 liblzma5
```

Para saber como publicar um aplicativo Linux no [Snap Store],
consulte [Criar e lançar um aplicativo Linux para a Snap Store][].

## Recursos adicionais

Para saber como criar builds Linux Debian (`.deb`) e RPM (`.rpm`)
do seu aplicativo de desktop Flutter,
consulte o guia passo a passo [Guia de empacotamento Linux][linux_packaging_guide].

[Snap Store]: https://snapcraft.io/store
[Criar e lançar um aplicativo Linux para a Snap Store]: /deployment/linux
[linux_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-3-linux-24ef8d30a5b4
