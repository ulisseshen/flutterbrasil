---
ia-translate: true
title: $FLUTTER_ROOT/bin/cache/flutter.version.json substitui $FLUTTER_ROOT/version
description: >-
  A saída depreciada do arquivo da ferramenta '$FLUTTER_ROOT/version' foi substituída por
  '$FLUTTER_ROOT/bin/cache/flutter.version.json', e quaisquer scripts de build ou
  referências a ele também devem ser atualizados.
---

{% render "docs/breaking-changes.md" %}

## Resumo

A ferramenta `flutter` não irá mais
gerar o arquivo de metadados `$FLUTTER_ROOT/version`, e
apenas gerará `$FLUTTER_ROOT/bin/cache/flutter.version.json`.

Ferramentas e scripts de build que dependem da presença de `$FLUTTER_ROOT/version`
precisam ser atualizados.

## Contexto

[Em 2023][PR 124558], `$FLUTTER_ROOT/bin/cache/fluttter.version.json` foi adicionado
como um novo formato de arquivo que substitui `$FLUTTER_ROOT/version`.

Então um arquivo que parecia algo assim:

```plaintext title="version"
3.33.0-1.0.pre-1070
```

Foi substituído por algo assim:

```json title="flutter.version.json"
{
  "frameworkVersion": "3.33.0-1.0.pre-1070",
  "channel": "master",
  "repositoryUrl": "unknown source",
  "frameworkRevision": "be9526fbaaaab9474e95d196b70c41297eeda2d0",
  "frameworkCommitDate": "2025-07-22 11:34:11 -0700",
  "engineRevision": "be9526fbaaaab9474e95d196b70c41297eeda2d0",
  "engineCommitDate": "2025-07-22 18:34:11.000Z",
  "engineContentHash": "70fb28dde094789120421d4e807a9c37a0131296",
  "engineBuildDate": "2025-07-22 11:47:42.829",
  "dartSdkVersion": "3.10.0 (build 3.10.0-15.0.dev)",
  "devToolsVersion": "2.48.0",
  "flutterVersion": "3.33.0-1.0.pre-1070"
}
```

Gerar ambos os arquivos é uma fonte de débito técnico.

## Guia de migração

A maioria dos desenvolvedores Flutter não faz parse ou usa este arquivo, mas
ferramentas customizadas ou configurações de CI podem fazê-lo.

Por exemplo, o próprio script de geração da equipe Flutter `api.flutterbrasil.dev`:

```dart title="post_processe_docs.dart"
final File versionFile = File('version');
final String version = versionFile.readAsStringSync();
```

Foi atualizado em [172601][PR 172601] para:

```dart
final File versionFile = File(path.join(checkoutPath, 'bin', 'cache', 'flutter.version.json'));
final String version = () {
  final Map<String, Object?> json =
      jsonDecode(versionFile.readAsStringSync()) as Map<String, Object?>;
  return json['flutterVersion']! as String;
}();
```

Para temporariamente optar por não ter `$FLUTTER_ROOT/version` mais sendo emitido:

```sh
flutter config --no-enable-omit-legacy-version-file
```

## Cronograma

Aterrissou na versão: 3.33.0-1.0.pre-1416<br>
Lançamento estável: _Ainda não publicado_

Um lançamento estável após esta mudança ser implementada,
`--no-enable-omit-legacy-version-file` será removido.

## Referências

Issues relevantes:

- [Issue 171900][], onde `FLUTTER_ROOT/version` foi marcado para remoção

PRs relevantes:

- [PR 124558][], onde `flutter.version.json` foi adicionado como o novo formato
- [PR 172601][], um exemplo de migração de um script para usar `flutter.version.json`

[Issue 171900]: {{site.repo.flutter}}/issues/171900
[PR 124558]: {{site.repo.flutter}}/pull/124558
[PR 172601]: {{site.repo.flutter}}/pull/172601
