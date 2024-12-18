---
ia-translate: true
title: Mensagens localizadas são geradas no código-fonte, não em um pacote sintético.
description: >-
  Ao usar `package:flutter_localizations`, o local gerado padrão (e,
  eventualmente, o único local possível) está dentro do seu diretório de
  código-fonte (`lib/`) e não no pacote sintético `package:flutter_gen`.
---

## Resumo

A ferramenta `flutter` não gerará mais um `package:flutter_gen` sintético
nem modificará o `package_config.json` do aplicativo. Aplicativos ou
ferramentas que antes faziam referência a `package:flutter_gen` agora farão
referência a arquivos de código-fonte gerados diretamente no aplicativo.

## Contexto

`flutter_gen` é um pacote virtual (sintético) que é criado pela ferramenta de
linha de comando `flutter` para permitir que desenvolvedores importem esse
pacote para acessar símbolos e funcionalidades gerados, como para
[internacionalização][Internationalizing Flutter apps]. Como o pacote não está
listado no `pubspec.yaml` de um aplicativo e é criado por meio da reescrita
do `package_config.json` (gerado), vários problemas foram criados.

## Guia de Migração

Essa alteração afeta apenas os usuários que têm o seguinte em seu
`pubspec.yaml`:

```yaml
flutter:
  generate: true
```

Um pacote sintético (`package:flutter_gen`) é criado e referenciado pelo
aplicativo:

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

1.  Especifique `synthetic-package: false` no arquivo [l10n.yaml][] que o
    acompanha:

    ```yaml
    synthetic-package: false

    # Os arquivos são gerados no caminho especificado por `arb-dir`
    arb-dir: lib/i18n

    # Ou, forneça especificamente um caminho de saída:
    output-dir: lib/src/generated/i18n
    ```

2.  Ative o _feature flag_ `explicit-package-dependencies`:

    ```sh
    flutter config explicit-package-dependencies
    ```

## Cronograma

Não lançado

Não lançado + 1, o suporte a `package:flutter_gen` será removido.

## Referências

Problemas relevantes:

- [Issue 73870][], onde os problemas do `package:flutter_gen` com o pub são
  encontrados pela primeira vez.
- [Issue 102983][], onde os problemas do `package:flutter_gen` são descritos.
- [Issue 157819][], onde `--implicit-pubspec-resolution` é discutido.

Artigos relevantes:

- [Internationalizing Flutter apps][], a documentação canônica para o recurso.

[l10n.yaml]: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#configuring-the-l10n-yaml-file
[Issue 73870]: https://github.com/flutter/flutter/issues/73870
[Issue 102983]: https://github.com/flutter/flutter/issues/102983
[Issue 157819]: https://github.com/flutter/flutter/issues/157819
[Internationalizing Flutter apps]: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages
