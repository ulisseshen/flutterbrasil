---
ia-translate: true
title: Construa apps Linux com Flutter
description: Considerações específicas de plataforma ao construir para Linux com Flutter.
shortTitle: Desenvolvimento Linux
---

Esta página discute considerações exclusivas para construir
apps Linux com Flutter, incluindo integração com o shell
e preparação de apps para distribuição.

## Integre com Linux

A interface de programação Linux,
composta por funções de biblioteca e chamadas de sistema,
é projetada em torno da linguagem C e ABI.
Felizmente, Dart fornece o pacote `dart:ffi`,
que permite que programas Dart chamem bibliotecas C.

Foreign Function Interfaces (FFI) permitem que apps Flutter realizem o
seguinte com bibliotecas nativas:

* alocar memória nativa com `malloc` ou `calloc`
* suportar ponteiros, structs e callbacks
* suportar tipos de Application Binary Interface (ABI) como `long` e `size_t`

Para aprender mais sobre chamar bibliotecas C do Flutter,
consulte [C interop using `dart:ffi`][C interop using `dart:ffi`].

Muitos apps se beneficiam do uso de um pacote que encapsula as chamadas de biblioteca subjacentes
em uma API Dart mais conveniente e idiomática.
[Canonical construiu uma série de pacotes][Canonical]
com foco em habilitar Dart e Flutter no Linux,
incluindo suporte para notificações de desktop,
dbus, gerenciamento de rede e Bluetooth.

Em geral, muitos outros [pacotes suportam a criação de apps Linux][support-linux],
incluindo pacotes comuns como [`url_launcher`],
[`shared_preferences`], [`file_selector`] e [`path_provider`].

[C interop using `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[Canonical]: {{site.pub}}/publishers/canonical.com/packages
[support-linux]: {{site.pub}}/packages?q=platform%3Alinux
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## Prepare apps Linux para distribuição

O binário executável pode ser encontrado em seu projeto em
`build/linux/x64/<build mode>/bundle/`.
Junto com seu binário executável no diretório `bundle`,
você pode encontrar dois diretórios:

* `lib` contém os arquivos de biblioteca `.so` necessários
* `data` contém os assets de dados da aplicação, como fontes ou imagens

Além desses arquivos, sua aplicação também depende de várias
bibliotecas do sistema operacional contra as quais ela foi compilada.
Para ver a lista completa de bibliotecas,
use o comando `ldd` no diretório da sua aplicação.

Por exemplo, suponha que você tenha uma aplicação desktop Flutter
chamada `linux_desktop_test`.
Para inspecionar suas dependências de biblioteca do sistema, use os seguintes comandos:

```console
$ flutter build linux --release
$ ldd build/linux/x64/release/bundle/linux_desktop_test
```

Para empacotar esta aplicação para distribuição,
inclua tudo no diretório `bundle`
e verifique se o sistema Linux de destino tem todas as bibliotecas de sistema necessárias.

Isso pode exigir apenas o uso do seguinte comando.

```console
$ sudo apt-get install libgtk-3-0 libblkid1 liblzma5
```

Para aprender como publicar uma aplicação Linux na [Snap Store],
consulte [Build and release a Linux application to the Snap Store][Build and release a Linux application to the Snap Store].

## Recursos adicionais

Para aprender como criar builds Linux Debian (`.deb`) e RPM (`.rpm`)
do seu app desktop Flutter,
consulte o [guia de empacotamento Linux][linux_packaging_guide] passo a passo.

[Snap Store]: https://snapcraft.io/store
[Build and release a Linux application to the Snap Store]: /deployment/linux
[linux_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-3-linux-24ef8d30a5b4
