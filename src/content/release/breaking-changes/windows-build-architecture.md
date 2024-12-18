---
ia-translate: true
title: Caminho de build do Windows alterado para adicionar a arquitetura de destino
description: >-
  Em preparação para o suporte ao Windows no Arm64, o caminho de build do
  Windows foi atualizado para incluir a arquitetura de destino.
---

## Sumário

Os executáveis construídos para aplicativos Flutter no Windows agora estão
localizados em pastas dependentes da arquitetura.

## Contexto

Em preparação para o suporte ao Windows no Arm64, o caminho de build do
Windows foi atualizado para adicionar a arquitetura de destino do build.

Anteriormente, os builds do Flutter para Windows assumiam uma arquitetura de
destino x64.

## Guia de migração

Pode ser necessário atualizar sua infraestrutura para usar o novo caminho de
build do Flutter no Windows.

Exemplo de caminho de build antes da migração:

```plaintext
build\windows\runner\Release\hello_world.exe
```

Exemplo de caminho de build após a migração se o destino for x64:

```plaintext
build\windows\x64\runner\Release\hello_world.exe
```

Exemplo de caminho de build após a migração se o destino for Arm64:

```plaintext
build\windows\arm64\runner\Release\hello_world.exe
```

Se você usa o [`package:msix`][], atualize para a versão 3.16.7 ou mais
recente.

[`package:msix`]: {{site.pub-pkg}}/msix

## Linha do tempo

Implementado na versão: 3.15.0-0.0.pre<br>
Na versão estável: 3.16

## Referências

Documento de design:

*  [flutter.dev/go/windows-arm64][]

Pull requests relevantes:

* [Introduce architecture subdirectory for Windows build][]

[flutter.dev/go/windows-arm64]: {{site.main-url}}/go/windows-arm64
[Introduce architecture subdirectory for Windows build]: {{site.repo.flutter}}/pull/131843
