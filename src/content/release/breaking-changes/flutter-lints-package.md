---
ia-translate: true
title: Apresentando o package:flutter_lints
description: >
  Migre para package:flutter_lints para obter o conjunto mais recente de
  lints recomendados, que incentivam boas práticas de codificação.
---

## Resumo

O [`package:flutter_lints`][] define o conjunto mais recente de lints recomendados
que incentivam boas práticas de codificação para aplicativos, packages e plugins
Flutter. Projetos criados com `flutter create` usando o Flutter versão 2.5 ou
mais recente já estão habilitados para usar o conjunto mais recente de lints
recomendados. Projetos criados antes dessa versão podem ser atualizados seguindo
as instruções neste guia.

## Contexto

Antes da introdução do `package:flutter_lints`, o framework Flutter era
distribuído com um conjunto de lints definidos em [`analysis_options_user.yaml`][]
que era usado pelo [analisador Dart][] para identificar problemas de código se
um projeto Flutter não definisse um arquivo `analysis_options.yaml` personalizado.
Como o `analysis_options_user.yaml` estava vinculado a uma versão específica do
framework, era difícil evoluir sem quebrar aplicativos, packages e plugins
existentes. Como resultado disso, os lints definidos em
`analysis_options_user.yaml` estão bastante desatualizados. Para corrigir isso,
`package:flutter_lints` foi criado. O package versiona o conjunto de lints para
permitir que ele evolua sem quebrar projetos existentes. Como o package se baseia
no [`package:lints`][] do Dart, ele também alinha os lints recomendados para
projetos Flutter com o restante do ecossistema Dart.

## Guia de migração

Siga estes passos para migrar seu projeto Flutter para usar os lints
recomendados mais recentes do `package:flutter_lints`:

Adicione uma dev_dependency em `package:flutter_lints` ao `pubspec.yaml` do seu
projeto executando `flutter pub add --dev flutter_lints` no diretório raiz do
projeto.

Crie um arquivo `analysis_options.yaml` no diretório raiz do seu projeto (ao
lado do arquivo `pubspec.yaml`) com o seguinte conteúdo:

```yaml
include: package:flutter_lints/flutter.yaml
```

O conjunto de lints recém-ativado pode identificar alguns novos problemas em seu
código. Para encontrá-los, abra seu projeto em uma [IDE com suporte a Dart][] ou
execute `flutter analyze` na linha de comando. Você pode conseguir corrigir
automaticamente alguns dos problemas relatados executando `dart fix --apply` no
diretório raiz do seu projeto.

### Arquivo analysis_options.yaml personalizado existente

Se o seu projeto já tiver um arquivo `analysis_options.yaml` personalizado em
sua raiz, adicione `include: package:flutter_lints/flutter.yaml` a ele no topo
para ativar os lints de `package:flutter_lints`. Se o seu `analysis_options.yaml`
já contiver uma diretiva `include:`, você deve decidir se deseja manter esses
lints ou se deseja substituí-los pelos lints do `package:flutter_lints`, porque o
analisador Dart suporta apenas uma diretiva `include:` por arquivo
`analysis_options.yaml`.

## Personalizando os lints

Os lints ativados para um determinado projeto podem ser ainda mais personalizados
no arquivo `analysis_options.yaml`. Isso é mostrado no arquivo de exemplo abaixo,
que é uma reprodução do arquivo `analysis_options.yaml` gerado por `flutter create`
para novos projetos.

```yaml
# Este arquivo configura o analisador, que analisa estaticamente o código Dart para
# verificar erros, avisos e lints.
#
# Os problemas identificados pelo analisador são exibidos na IU de IDEs habilitadas
# para Dart (https://dart.dev/tools#ides-and-editors). O analisador também pode ser
# invocado a partir da linha de comando executando `flutter analyze`.

# A linha a seguir ativa um conjunto de lints recomendados para aplicativos,
# packages e plugins Flutter projetados para incentivar boas práticas de codificação.
include: package:flutter_lints/flutter.yaml

linter:
  # As regras de lint aplicadas a este projeto podem ser personalizadas na
  # seção abaixo para desativar regras do `package:flutter_lints/flutter.yaml`
  # incluído acima ou para ativar regras adicionais. Uma lista de todos os lints
  # disponíveis e sua documentação é publicada em
  # https://dart-lang.github.io/linter/lints/index.html.
  #
  # Em vez de desativar uma regra de lint para todo o projeto na
  # seção abaixo, ela também pode ser suprimida para uma única linha de código
  # ou um arquivo dart específico usando a sintaxe `// ignore: nome_do_lint` e
  # `// ignore_for_file: nome_do_lint` na linha ou no arquivo
  # produzindo o lint.
  rules:
    # avoid_print: false  # Descomente para desativar a regra `avoid_print`
    # prefer_single_quotes: true  # Descomente para ativar a regra `prefer_single_quotes`

# Informações adicionais sobre este arquivo podem ser encontradas em
# https://dart.dev/guides/language/analysis-options
```

## Linha do tempo

Implementado na versão: 2.3.0-12.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação:

* [`package:flutter_lints`][]
* [Dependências de package][]
* [Personalizando a análise estática][]

Issue relevante:

* [Issue 78432 - Atualizar o conjunto de lints para aplicações Flutter][]

PRs relevantes:

* [Adicionar package flutter_lints][]
* [Integrar package:flutter_lints em templates][]

[Adicionar package flutter_lints]: {{site.repo.packages}}/pull/343
[`analysis_options_user.yaml`]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/analysis_options_user.yaml
[Personalizando a análise estática]: {{site.dart-site}}/guides/language/analysis-options
[analisador Dart]: {{site.dart-site}}/guides/language/analysis-options
[IDE com suporte a Dart]: {{site.dart-site}}/tools#ides-and-editors
[Integrar package:flutter_lints em templates]: {{site.repo.flutter}}/pull/81417
[Issue 78432 - Atualizar o conjunto de lints para aplicações Flutter]: {{site.repo.flutter}}/issues/78432
[`package:flutter_lints`]: {{site.pub-pkg}}/flutter_lints
[`package:lints`]: {{site.pub}}/packages/lints
[Dependências de package]: {{site.dart-site}}/tools/pub/dependencies
