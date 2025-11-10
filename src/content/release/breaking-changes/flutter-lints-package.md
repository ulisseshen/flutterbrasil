---
title: Apresentando package:flutter_lints
description: >
  Migre para package:flutter_lints para obter o conjunto mais recente de
  lints recomendados, que incentivam boas práticas de programação.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O [`package:flutter_lints`][] define o conjunto mais recente de lints recomendados
que incentivam boas práticas de programação para apps, packages e plugins Flutter.
Projetos criados com `flutter create` usando Flutter versão 2.5 ou mais recente já
estão habilitados para usar o conjunto mais recente de lints recomendados. Projetos criados
antes dessa versão podem fazer upgrade para ela com as instruções neste guia.

## Context

Antes da introdução do `package:flutter_lints`, o framework Flutter
era distribuído com um conjunto de lints definidos em [`analysis_options_user.yaml`][] que era
usado pelo [dart analyzer][] para identificar problemas de código se um projeto Flutter
não definisse um arquivo `analysis_options.yaml` personalizado.
Como `analysis_options_user.yaml` estava vinculado a uma versão específica do framework,
era difícil evoluí-lo sem quebrar
apps, packages e plugins existentes. Como resultado disso, os lints
definidos em `analysis_options_user.yaml` estão muito desatualizados. Para corrigir isso,
`package:flutter_lints` foi criado. O package versiona o conjunto de lints para permitir
evoluí-lo sem quebrar projetos existentes. Como o package é construído sobre
o [`package:lints`][] do Dart, ele também alinha os lints recomendados para projetos
Flutter com o resto do ecossistema Dart.

## Migration guide

Siga estas etapas para migrar seu projeto Flutter para usar os lints recomendados
mais recentes do `package:flutter_lints`:

Adicione uma dev_dependency no `package:flutter_lints` ao `pubspec.yaml` do seu projeto
executando `flutter pub add --dev flutter_lints` no diretório raiz do
projeto.

Crie um arquivo `analysis_options.yaml` no diretório raiz do seu projeto
(ao lado do arquivo `pubspec.yaml`) com o seguinte conteúdo:

```yaml
include: package:flutter_lints/flutter.yaml
```

O conjunto de lints recém-ativado pode identificar alguns novos problemas no seu código. Para encontrá-los,
abra seu projeto em uma [IDE with Dart support][] ou execute `flutter analyze`
na linha de comando. Você pode ser capaz de corrigir alguns dos problemas relatados
automaticamente executando `dart fix --apply` no diretório raiz do seu
projeto.

### Existing custom analysis_options.yaml file

Se seu projeto já tem um arquivo `analysis_options.yaml` personalizado em sua raiz,
adicione `include: package:flutter_lints/flutter.yaml` a ele no topo para ativar
os lints do `package:flutter_lints`. Se seu `analysis_options.yaml` já
contém uma diretiva `include:` você tem que decidir se deseja manter
esses lints ou se deseja substituí-los pelos lints do
`package:flutter_lints` porque o Dart analyzer suporta apenas uma diretiva `include:`
por arquivo `analysis_options.yaml`.

## Customizing the lints

Os lints ativados para um determinado projeto podem ser personalizados ainda mais no
arquivo `analysis_options.yaml`. Isso é mostrado no arquivo de exemplo abaixo, que é
uma reprodução do arquivo `analysis_options.yaml` gerado pelo `flutter create`
para novos projetos.

```yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dartbrasil.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at
  # https://dart-lang.github.io/linter/lints/index.html.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dartbrasil.dev/guides/language/analysis-options
```

## Timeline

Adicionado na versão: 2.3.0-12.0.pre<br>
Na versão estável: 2.5

## References

Documentação:

* [`package:flutter_lints`][]
* [Package dependencies][]
* [Customizing static analysis][]

Issue relevante:

* [Issue 78432 - Update lint set for Flutter applications][]

PRs relevantes:

* [Add flutter_lints package][]
* [Integrate package:flutter_lints into templates][]

[Add flutter_lints package]: {{site.repo.packages}}/pull/343
[`analysis_options_user.yaml`]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/analysis_options_user.yaml
[Customizing static analysis]: {{site.dart-site}}/guides/language/analysis-options
[dart analyzer]: {{site.dart-site}}/guides/language/analysis-options
[IDE with Dart support]: {{site.dart-site}}/tools#ides-and-editors
[Integrate package:flutter_lints into templates]: {{site.repo.flutter}}/pull/81417
[Issue 78432 - Update lint set for Flutter applications]: {{site.repo.flutter}}/issues/78432
[`package:flutter_lints`]: {{site.pub-pkg}}/flutter_lints
[`package:lints`]: {{site.pub}}/packages/lints
[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies
