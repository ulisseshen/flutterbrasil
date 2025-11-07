---
ia-translate: true
title: Construir apps Linux com Flutter
description: Considerações específicas da plataforma ao construir para Linux com Flutter.
toc: true
short-title: Desenvolvimento Linux
---

Esta página discute considerações únicas para construir
apps Linux com Flutter, incluindo integração com shell
e preparação de apps para distribuição.

## Integrar com Linux

A interface de programação Linux,
compreendendo funções de biblioteca e chamadas de sistema,
é projetada em torno da linguagem C e ABI.
Felizmente, Dart fornece o pacote `dart:ffi`,
que permite que programas Dart chamem bibliotecas C.

Foreign Function Interfaces (FFI) permitem que apps Flutter realizem o
seguinte com bibliotecas nativas:

* alocar memória nativa com `malloc` ou `calloc`
* suportar ponteiros, structs e callbacks
* suportar tipos Application Binary Interface (ABI) como `long` e `size_t`

Para saber mais sobre chamar bibliotecas C do Flutter,
consulte [C interop using `dart:ffi`][].

Muitos apps se beneficiam do uso de um pacote que encapsula as chamadas de biblioteca subjacentes
em uma API Dart mais conveniente e idiomática.
[A Canonical construiu uma série de pacotes][Canonical]
com foco em habilitar Dart e Flutter no Linux,
incluindo suporte para notificações desktop,
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

## Preparar apps Linux para distribuição

O binário executável pode ser encontrado no seu projeto em
`build/linux/x64/<build mode>/bundle/`.
Ao lado do seu binário executável no diretório `bundle`,
você pode encontrar dois diretórios:

* `lib` contém os arquivos de biblioteca `.so` necessários
* `data` contém os assets de dados da aplicação, como fontes ou imagens

Além desses arquivos, sua aplicação também depende de várias
bibliotecas do sistema operacional contra as quais foi compilada.
Para ver a lista completa de bibliotecas,
use o comando `ldd` no diretório da sua aplicação.

Por exemplo, suponha que você tenha uma aplicação Flutter desktop
chamada `linux_desktop_test`.
Para inspecionar suas dependências de biblioteca do sistema, use os seguintes comandos:

```console
$ flutter build linux --release
$ ldd build/linux/x64/release/bundle/linux_desktop_test
```

Para empacotar esta aplicação para distribuição,
inclua tudo no diretório `bundle`
e verifique se o sistema Linux de destino tem todas as bibliotecas do sistema necessárias.

Isso pode exigir apenas o uso do seguinte comando.

```console
$ sudo apt-get install libgtk-3-0 libblkid1 liblzma5
```

Para aprender como publicar uma aplicação Linux na [Snap Store],
consulte [Build and release a Linux application to the Snap Store][].

## Recursos adicionais

Para aprender como criar builds Debian (`.deb`) e RPM (`.rpm`) do Linux
do seu app Flutter desktop,
consulte o [guia de empacotamento Linux][linux_packaging_guide] passo a passo.

[Snap Store]: https://snapcraft.io/store
[Build and release a Linux application to the Snap Store]: /deployment/linux
[linux_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-3-linux-24ef8d30a5b4
