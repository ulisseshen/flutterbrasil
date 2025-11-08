---
ia-translate: true
title: Política de compatibilidade do Flutter
description: Como o Flutter aborda a questão de mudanças incompatíveis.
---

A equipe do Flutter tenta equilibrar a necessidade de estabilidade da API com a
necessidade de continuar evoluindo as APIs para corrigir bugs, melhorar a ergonomia da API
e fornecer novos recursos de maneira coerente.

Para este fim, criamos um registro de testes onde você pode fornecer
testes unitários para suas próprias aplicações ou bibliotecas que executamos
em cada mudança para nos ajudar a rastrear mudanças que quebrariam
aplicações existentes. Nosso compromisso é que não faremos nenhuma
mudança que quebre esses testes sem trabalhar com os desenvolvedores
desses testes para (a) determinar se a mudança é suficientemente valiosa,
e (b) fornecer correções para o código para que os testes continuem passando.

Se você gostaria de fornecer testes como parte deste programa, por favor
envie um PR para o [flutter/tests repository][].
O [README][flutter-tests-readme] naquele repositório descreve
o processo em detalhes.

[flutter/tests repository]: {{site.github}}/flutter/tests
[flutter-tests-readme]: {{site.github}}/flutter/tests#adding-more-tests

## Anúncios e guias de migração

Se fizermos uma mudança incompatível (definida como uma mudança que causou
um ou mais desses testes enviados a requererem mudanças), anunciaremos
a mudança em nossa lista de e-mails [flutter-announce][]
assim como em nossas notas de versão.

Fornecemos uma lista de [guides for migrating code][] afetado por
mudanças incompatíveis.

[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[guides for migrating code]: /release/breaking-changes

## Política de descontinuação {#deprecation-policy}

Iremos, ocasionalmente, descontinuar certas APIs ao invés de
quebrá-las abruptamente da noite para o dia. Isso é independente de nossa política de compatibilidade
que é exclusivamente baseada em se os testes enviados falham, como
descrito acima.

A equipe do Flutter não remove APIs descontinuadas em uma base agendada.
Se a equipe remove uma API descontinuada,
ela segue os mesmos procedimentos daqueles para mudanças incompatíveis.


## Dart e outras bibliotecas usadas pelo Flutter

A própria linguagem Dart tem uma [separate breaking-change policy][],
com anúncios em [Dart announce][].

Em geral, a equipe do Flutter atualmente não tem nenhum compromisso
em relação a mudanças incompatíveis para outras dependências.
Por exemplo, é possível que uma nova versão do
Flutter usando uma nova versão do Skia
(o motor gráfico usado por algumas plataformas no Flutter)
ou Harfbuzz (o motor de formatação de fontes usado pelo Flutter)
tivesse mudanças que afetassem testes contribuídos.
Tais mudanças não seriam necessariamente acompanhadas por um
guia de migração.

[separate breaking-change policy]: {{site.github}}/dart-lang/sdk/blob/main/docs/process/breaking-changes.md
[Dart announce]: {{site.groups}}/a/dartlang.org/g/announce
