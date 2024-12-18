---
ia-translate: true
title: Política de compatibilidade do Flutter
description: Como o Flutter aborda a questão de mudanças que quebram a compatibilidade.
---

A equipe do Flutter tenta equilibrar a necessidade de estabilidade da API com a necessidade de continuar evoluindo as APIs para corrigir bugs, melhorar a ergonomia da API e fornecer novos recursos de forma coerente.

Para este fim, criamos um registro de testes onde você pode fornecer testes unitários para seus próprios aplicativos ou bibliotecas que executamos em cada alteração para nos ajudar a rastrear alterações que quebram aplicativos existentes. Nosso compromisso é que não faremos nenhuma alteração que quebre esses testes sem trabalhar com os desenvolvedores desses testes para (a) determinar se a alteração é suficientemente valiosa e (b) fornecer correções para o código para que os testes continuem sendo aprovados.

Se você quiser fornecer testes como parte deste programa, envie um PR para o [repositório flutter/tests][]. O [README][flutter-tests-readme] nesse repositório descreve o processo em detalhes.

[repositório flutter/tests]: {{site.github}}/flutter/tests
[flutter-tests-readme]: {{site.github}}/flutter/tests#adding-more-tests

## Anúncios e guias de migração

Se fizermos uma alteração que quebra a compatibilidade (definida como uma alteração que fez com que um ou mais desses testes enviados exigissem alterações), anunciaremos a alteração em nossa lista de discussão [flutter-announce][] , bem como em nossas notas de versão.

Fornecemos uma lista de [guias para migração de código][] afetados por alterações que quebram a compatibilidade.

[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[guias para migração de código]: /release/breaking-changes

## Política de descontinuação

Ocasionalmente, iremos descontinuar certas APIs em vez de quebrá-las completamente da noite para o dia. Isso é independente de nossa política de compatibilidade, que se baseia exclusivamente em se os testes enviados falham, conforme descrito acima.

A equipe do Flutter não remove APIs descontinuadas de forma programada. Se a equipe remover uma API descontinuada, ela segue os mesmos procedimentos que aqueles para mudanças que quebram a compatibilidade.

## Dart e outras bibliotecas usadas pelo Flutter

A própria linguagem Dart tem uma [política separada de mudanças que quebram a compatibilidade][], com anúncios em [Dart announce][].

Em geral, a equipe do Flutter não tem atualmente nenhum compromisso com relação a mudanças que quebram a compatibilidade para outras dependências. Por exemplo, é possível que uma nova versão do Flutter usando uma nova versão do Skia (o mecanismo de gráficos usado por algumas plataformas no Flutter) ou Harfbuzz (o mecanismo de modelagem de fontes usado pelo Flutter) tenha alterações que afetem os testes contribuidos. Tais mudanças não seriam necessariamente acompanhadas por um guia de migração.

[política separada de mudanças que quebram a compatibilidade]: {{site.github}}/dart-lang/sdk/blob/main/docs/process/breaking-changes.md
[Dart announce]: {{site.groups}}/a/dartlang.org/g/announce
