---
title: Política de compatibilidade do Flutter
description: Como o Flutter aborda a questão de mudanças incompatíveis.
ia-translate: true
---

A equipe do Flutter tenta equilibrar a necessidade de estabilidade de API com a
necessidade de continuar evoluindo APIs para corrigir bugs, melhorar ergonomia de API,
e fornecer novos recursos de maneira coerente.

Para este fim, criamos um registro de testes onde você pode fornecer
testes unitários para suas próprias aplicações ou bibliotecas que executamos
em cada mudança para nos ajudar a rastrear mudanças que quebrariam
aplicações existentes. Nosso compromisso é que não faremos nenhuma
mudança que quebre esses testes sem trabalhar com os desenvolvedores
desses testes para (a) determinar se a mudança é suficientemente valiosa,
e (b) fornecer correções para o código para que os testes continuem a passar.

Se você quiser fornecer testes como parte deste programa, por favor
envie um PR para o [repositório flutter/tests][flutter/tests repository].
O [README][flutter-tests-readme] nesse repositório descreve
o processo em detalhes.

[flutter/tests repository]: {{site.github}}/flutter/tests
[flutter-tests-readme]: {{site.github}}/flutter/tests#adding-more-tests

## Anúncios e guias de migração {:#announcements-and-migration-guides}

Se fizermos uma mudança incompatível (definida como uma mudança que causou
um ou mais desses testes enviados a exigir mudanças), anunciaremos
a mudança em nossa lista de discussão [flutter-announce][]
bem como em nossas notas de lançamento.

Fornecemos uma lista de [guias para migração de código][guides for migrating code] afetado por
mudanças incompatíveis.

[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[guides for migrating code]: /release/breaking-changes

## Política de descontinuação {:#deprecation-policy}

Ocasionalmente, descontinuaremos certas APIs em vez de quebrá-las
completamente da noite para o dia. Isso é independente de nossa política de compatibilidade
que é exclusivamente baseada em se os testes enviados falham, como
descrito acima.

A equipe do Flutter não remove APIs descontinuadas com base em uma programação.
Se a equipe remover uma API descontinuada,
ela segue os mesmos procedimentos para mudanças incompatíveis.


## Dart e outras bibliotecas usadas pelo Flutter {:#dart-and-other-libraries-used-by-flutter}

A linguagem Dart em si tem uma [política de mudanças incompatíveis separada][separate breaking-change policy],
com anúncios no [Dart announce][].

Em geral, a equipe do Flutter atualmente não tem nenhum compromisso
em relação a mudanças incompatíveis para outras dependências.
Por exemplo, é possível que uma nova versão do
Flutter usando uma nova versão do Skia
(o mecanismo gráfico usado por algumas plataformas no Flutter)
ou Harfbuzz (o mecanismo de formatação de fonte usado pelo Flutter)
tenha mudanças que afetem testes contribuídos.
Tais mudanças não seriam necessariamente acompanhadas por um
guia de migração.

[separate breaking-change policy]: {{site.github}}/dart-lang/sdk/blob/main/docs/process/breaking-changes.md
[Dart announce]: {{site.groups}}/a/dartlang.org/g/announce
