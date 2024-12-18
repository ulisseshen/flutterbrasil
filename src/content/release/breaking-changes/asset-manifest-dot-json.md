---
ia-translate: true
title: Remoção do AssetManifest.json
description: >-
    Aplicativos Flutter compilados não incluirão mais um arquivo de ativo AssetManifest.json.
---

## Resumo

Aplicativos Flutter atualmente incluem um arquivo de ativo chamado `AssetManifest.json`.
Este arquivo contém efetivamente uma lista de ativos.
O código do aplicativo pode lê-lo usando a API [`AssetBundle`][] para
determinar quais ativos estão disponíveis em tempo de execução.

O arquivo `AssetManifest.json` é um detalhe de implementação não documentado.
Ele não é mais usado pelo framework, portanto, não será mais
gerado em uma versão futura do Flutter.
Se o código do seu aplicativo precisar obter uma lista de ativos disponíveis, use
a API [`AssetManifest`][] em vez disso.

## Guia de migração

### Lendo o manifesto de ativos do código do aplicativo Flutter

Antes:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

final String assetManifestContent = await rootBundle.loadString('AssetManifest.json');
final Map<Object?, Object?> decodedAssetManifest = 
    json.decode(assetManifestContent) as Map<String, Object?>;
final List<String> assets = decodedAssetManifest.keys.toList().cast<String>();
```

Depois:

```dart
import 'package:flutter/services.dart';

final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
final List<String> assets = assetManifest.listAssets();
```

### Lendo informações do manifesto de ativos de código Dart fora de um aplicativo Flutter

A ferramenta CLI `flutter` gera um novo arquivo, `AssetManifest.bin`.
Isso substitui `AssetManifest.json`.
Este arquivo contém as mesmas informações que `AssetManifest.json`,
mas em um formato diferente.
Se você precisar ler este arquivo de código que não faz parte de um
aplicativo Flutter e, portanto, não pode usar a API [`AssetManifest`][],
você ainda pode analisar o arquivo você mesmo.

O pacote [standard_message_codec][] pode ser usado para analisar o conteúdo.

```dart
import 'dart:io';
import 'dart:typed_data';

import 'package:standard_message_codec/standard_message_codec.dart';

void main() {
  // O caminho para AssetManifest.bin depende da plataforma de destino.
  final String pathToAssetManifest = './build/web/assets/AssetManifest.bin';
  final Uint8List manifest = File(pathToAssetManifest).readAsBytesSync();
  final Map<Object?, Object?> decoded = const StandardMessageCodec()
      .decodeMessage(ByteData.sublistView(manifest));
  final List<String> assets = decoded.keys.cast<String>().toList();
}
```

Tenha em mente que `AssetManifest.bin` é um detalhe de implementação do Flutter.
A leitura deste arquivo não é um fluxo de trabalho oficialmente suportado. O conteúdo ou
formato do arquivo pode mudar em uma versão futura sem aviso prévio.

## Linha do tempo

`AssetManifest.json` não será mais gerado a partir da quarta versão estável
após a 3.19 ou um ano após o lançamento da 3.19, o que ocorrer por último.

## Referências

Problemas relevantes:

* Ao construir um aplicativo Flutter, a ferramenta flutter gera um
  arquivo AssetManifest.json que não é usado pelo framework [(Issue #143577)][]

[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[`AssetManifest`]: {{site.api}}/flutter/services/AssetManifest-class.html
[(Issue #143577)]: {{site.repo.flutter}}/issues/143577
[standard_message_codec]: {{site.pub-pkg}}/standard_message_codec
