---
title: Mensagens localizadas são geradas no código fonte, não em um pacote sintético.
description: >-
  Ao usar `package:flutter_localizations`, o local gerado padrão
  (e eventualmente, único local possível) é dentro do seu diretório de código fonte (`lib/`),
  e não o pacote sintético `package:flutter_gen`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

A ferramenta `flutter` não gerará mais um `package:flutter_gen` sintético
ou modificará o `package_config.json` do aplicativo.

Aplicativos ou ferramentas que referenciavam `package:flutter_gen` devem, em vez disso,
referenciar arquivos de código fonte gerados diretamente no diretório de código fonte do aplicativo.

Além disso, a propriedade `generate: true` agora é obrigatória ao usar código fonte
l10n gerado.

## Contexto

`flutter_gen` é um pacote virtual (sintético) que é
criado pela ferramenta de linha de comando `flutter` para permitir que os desenvolvedores
importem esse pacote para acessar símbolos e funcionalidades gerados,
como para [internacionalização][internationalization].
Como o pacote não está listado no `pubspec.yaml` de um aplicativo, e
é criado via reescrita do arquivo `package_config.json` gerado,
muitos problemas foram criados.

## Guia de migração

Esta alteração afeta apenas aplicativos que têm a
seguinte entrada em seu `pubspec.yaml`:

```yaml
flutter:
  generate: true
```

Se seu aplicativo usava anteriormente `gen-l10n` sem esta propriedade, ela agora é
obrigatória.

Um pacote sintético (`package:flutter_gen`) é
criado e referenciado pelo aplicativo:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ...
const MaterialApp(
  title: 'Localizations Sample App',
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);
```

Existem duas maneiras de migrar da importação de `package:flutter_gen`:

 1. Especifique `synthetic-package: false` no arquivo [`l10n.yaml`][] correspondente:

    ```yaml title="l10n.yaml"
    synthetic-package: false

    # The files are generated into the path specified by `arb-dir`
    arb-dir: lib/i18n

    # Or, specifically provide an output path:
    output-dir: lib/src/generated/i18n
    ```

 2. Habilite a feature flag `explicit-package-dependencies`:

    ```sh
    flutter config --explicit-package-dependencies
    ```

## Linha do tempo

Disponibilizado na versão: 3.28.0-0.0.pre<br>
Versão estável: 3.32.0

**Na próxima versão estável após esta alteração,
o suporte a `package:flutter_gen` será removido.**

## Referências

Issues relevantes:

- [Issue 73870][], onde problemas de pub do `package:flutter_gen` são encontrados pela primeira vez.
- [Issue 102983][], onde os problemas do `package:flutter_gen` são delineados.
- [Issue 157819][], onde `--implicit-pubspec-resolution` é discutido.

Artigos relevantes:

- [Internationalizing Flutter apps][internationalization],
  a documentação canônica para o recurso.

[`l10n.yaml`]: /ui/internationalization#configuring-the-l10n-yaml-file
[Issue 73870]: {{site.repo.flutter}}/issues/73870
[Issue 102983]: {{site.repo.flutter}}/issues/102983
[Issue 157819]: {{site.repo.flutter}}/issues/157819
[internationalization]: /ui/internationalization#adding-your-own-localized-messages
