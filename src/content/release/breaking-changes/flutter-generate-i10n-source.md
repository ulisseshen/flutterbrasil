---
title: Mensagens localizadas são geradas no código-fonte, não em um pacote sintético.
description: >-
  Ao usar `package:flutter_localizations`, a localização gerada padrão
  (e eventualmente, única localização possível) está dentro do seu diretório de código-fonte (`lib/`),
  e não no pacote sintético `package:flutter_gen`.
ia-translate: true
---

## Resumo

A ferramenta `flutter` não gerará mais um `package:flutter_gen` sintético
ou modificará o `package_config.json` do aplicativo.

Aplicativos ou ferramentas que referenciavam `package:flutter_gen` devem em vez disso
referenciar arquivos de código-fonte gerados no diretório de código-fonte do aplicativo diretamente.

## Contexto

`flutter_gen` é um pacote virtual (sintético) que é
criado pela ferramenta de linha de comando `flutter` para permitir que desenvolvedores
importem esse pacote para acessar símbolos e funcionalidades geradas,
como para [internacionalização][internationalization].
Como o pacote não está listado no `pubspec.yaml` de um aplicativo, e
é criado via reescrita do arquivo `package_config.json` gerado,
muitos problemas foram criados.

## Guia de migração

Esta mudança afeta apenas aplicativos que têm a
seguinte entrada em seu `pubspec.yaml`:

```yaml
flutter:
  generate: true
```

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

Existem duas maneiras de migrar do import de `package:flutter_gen`:

 1. Especifique `synthetic-package: false` no arquivo [`l10n.yaml`][] acompanhante:

    ```yaml title="l10n.yaml"
    synthetic-package: false

    # Os arquivos são gerados no caminho especificado por `arb-dir`
    arb-dir: lib/i18n

    # Ou, especificamente forneça um caminho de saída:
    output-dir: lib/src/generated/i18n
    ```

 2. Habilite a feature flag `explicit-package-dependencies`:

    ```sh
    flutter config explicit-package-dependencies
    ```

## Linha do tempo

Implementado na versão: Ainda não<br>
Versão estável: Ainda não

Uma versão estável após esta mudança ser implementada,
o suporte ao `package:flutter_gen` será removido.

## Referências

Issues relevantes:

- [Issue 73870][], onde problemas do pub com `package:flutter_gen` são encontrados primeiro.
- [Issue 102983][], onde problemas do `package:flutter_gen` são descritos.
- [Issue 157819][], onde `--implicit-pubspec-resolution` é discutido.

Artigos relevantes:

- [Internationalizing Flutter apps][internationalization],
  a documentação canônica para o recurso.

[`l10n.yaml`]: /ui/accessibility-and-internationalization/internationalization#configuring-the-l10n-yaml-file
[Issue 73870]: {{site.repo.flutter}}/issues/73870
[Issue 102983]: {{site.repo.flutter}}/issues/102983
[Issue 157819]: {{site.repo.flutter}}/issues/157819
[internationalization]: /ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages
