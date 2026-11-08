---
title: Remoção do AssetManifest.json
description: >-
    Apps Flutter compilados não incluirão mais um arquivo de asset AssetManifest.json.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Apps Flutter incluíam um arquivo de asset chamado `AssetManifest.json`.
Este arquivo efetivamente contém uma lista de assets.
O código da aplicação pode lê-lo usando a API [`AssetBundle`][] para
determinar quais assets estão disponíveis em tempo de execução.

O arquivo `AssetManifest.json` é um detalhe de implementação não documentado.
Ele não é mais usado pelo framework, e está planejado
não gerá-lo mais em uma versão futura do Flutter.
Se o código do seu app precisa obter uma lista de assets disponíveis,
use a API [`AssetManifest`][] em vez disso.

## Migration guide

### Reading asset manifest from Flutter application code

Antes:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

void readAssetList() async {
  final assetManifestContent = await rootBundle.loadString('AssetManifest.json');
  final decodedAssetManifest =
      json.decode(assetManifestContent) as Map<String, Object?>;
  final assets = decodedAssetManifest.keys.toList().cast<String>();
}
```

Depois:

```dart
import 'package:flutter/services.dart';

void readAssetList() async {
  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final assets = assetManifest.listAssets();
}
```

### Reading asset manifest information from Dart code outside of a Flutter app

A ferramenta CLI `flutter` gera um novo arquivo, `AssetManifest.bin`.
Este substitui `AssetManifest.json`.
Este arquivo contém a mesma informação que `AssetManifest.json`,
mas em um formato diferente.
Se você precisa ler este arquivo de código que não faz parte de um app Flutter, e
portanto não pode usar a API [`AssetManifest`][],
você ainda pode analisar o arquivo você mesmo.

O package [`standard_message_codec`][] pode ser usado para analisar o conteúdo.

```dart
import 'dart:io';
import 'dart:typed_data';

import 'package:standard_message_codec/standard_message_codec.dart';

void main() {
  // The path to AssetManifest.bin depends on the target platform.
  final pathToAssetManifest = './build/web/assets/AssetManifest.bin';
  final manifest = File(pathToAssetManifest).readAsBytesSync();
  final decoded = const StandardMessageCodec()
      .decodeMessage(ByteData.sublistView(manifest));
  final assets = decoded.keys.cast<String>().toList();
}
```

Tenha em mente que `AssetManifest.bin` é um detalhe de implementação do Flutter.
Ler este arquivo não é um fluxo de trabalho oficialmente suportado.
O conteúdo ou formato do arquivo pode mudar em
uma versão futura do Flutter sem um anúncio.

## Timeline

`AssetManifest.json` não será mais gerado a partir da
quarta versão estável após 3.19 ou um ano após o lançamento da 3.19,
o que vier depois.

## References

Issues relevantes:

* When building a Flutter app, the flutter tool generates an
  `AssetManifest.json` file that's unused by the framework [(Issue #143577)][]

PR relevante:

* [Remove deprecated `AssetManifest.json` file][PR 172594]

[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[`AssetManifest`]: {{site.api}}/flutter/services/AssetManifest-class.html
[(Issue #143577)]: {{site.repo.flutter}}/issues/143577
[`standard_message_codec`]: {{site.pub-pkg}}/standard_message_codec
[PR 172594]: {{site.repo.flutter}}/pull/172594
