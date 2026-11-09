---
ia-translate: true
title: Migrando projetos Android do Flutter para o Kotlin integrado
description: >-
  Atualize os arquivos Gradle do seu projeto Android Flutter para usar o suporte
  nativo ao Kotlin. Essencial para migrar projetos para o Android Gradle Plugin 9 ou superior.
---

{% render "docs/breaking-changes.md" %}

:::warning
Este guia se aplica apenas a apps e plugins que já usam o
Kotlin Gradle Plugin (KGP).
Se o seu projeto não aplica o KGP atualmente,
não migre para o Kotlin integrado.
:::

## Resumo {:#summary}

Para compilar um app Flutter para Android,
é preciso usar o Android Gradle Plugin (AGP).
Para usar o AGP 9 ou superior, as seguintes migrações são necessárias.

Primeiro, o Kotlin integrado é o padrão no AGP 9 e superiores.
Apps que usam o plugin `kotlin-android`,
também conhecido como Kotlin Gradle Plugin (KGP),
não compilam sem a migração ([Issue #181383][Issue #181383]).
O Flutter 3.44 adicionou suporte temporário ao KGP legado
no AGP 9 e superiores, com `android.builtInKotlin=false`
([Issue #183909][Issue #183909]).
Isso permite que desenvolvedores de apps e plugins compilem seus projetos
enquanto migram para longe do KGP.
O Flutter 3.47 adicionou suporte para ativar o Kotlin integrado
(`android.builtInKotlin=true`)
assim que o app e todos os seus plugins tiverem migrado.

Segundo, o AGP 9 e superiores usam apenas as novas interfaces de DSL do AGP.
Isso significa que os tipos antigos de DSL não serão reconhecidos.
A equipe do Flutter está trabalhando para migrar os tipos antigos de DSL
para o novo DSL: [Issue #180137][Issue #180137].
Enquanto isso, a equipe do Flutter configurou o DSL do AGP
para ser compatível com os tipos de DSL legados ([Issue #184838][Issue #184838]).
Isso garante que desenvolvedores de apps e plugins possam
atualizar com segurança para o AGP 9 e superiores.

Para garantir a compatibilidade,
migre manualmente todos os apps e plugins
do KGP legado para o Kotlin integrado.
O Flutter planeja remover o suporte à aplicação do KGP
em uma versão futura ([Issue #184837][Issue #184837]).

Para saber mais sobre o Android Gradle Plugin,
consulte a [documentação do Android Gradle Plugin][AGP block].

[AGP block]: {{site.android-dev}}/build/releases/gradle-plugin

## Migrar {:#migrate}

**Para desenvolvedores de apps:**
siga o [guia de migração para desenvolvedores de apps][app-migration-guide].

**Para autores de plugins:**
siga o [guia de migração para autores de plugins][plugin-migration-guide].

[app-migration-guide]: /release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers
[plugin-migration-guide]: /release/breaking-changes/migrate-to-built-in-kotlin/for-plugin-authors

## Próximos passos {:#next-steps}

- **Remover o suporte ao KGP:**
  Em uma versão futura do Flutter,
  o suporte à aplicação do KGP será removido ([Issue #184837][Issue #184837]).
  Migre apps, plugins e host apps para que continuem compilando.

- **Remover a propriedade Gradle do DSL:**
  Quando a equipe do Flutter concluir a migração para o novo DSL do AGP,
  o suporte ao DSL antigo será removido ([Issue #184839][Issue #184839]).

## Linha do tempo {:#timeline}

Incluído na versão: 3.44.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

Issues relevantes:

- [Issue #180137][Issue #180137]: Migrar do DSL antigo para o novo DSL do AGP
- [Issue #181383][Issue #181383]: Plugins Flutter devem oferecer suporte ao AGP 9.0.0
- [Issue #183909][Issue #183909]: Adicionar suporte ao KGP no AGP+
- [Issue #184837][Issue #184837]: Remover suporte ao KGP
- [Issue #184838][Issue #184838]: Desativar o novo flag de DSL do AGP por padrão
- [Issue #184839][Issue #184839]: Remover suporte aos tipos antigos de DSL do AGP

Os arquivos de build Gradle do seu app variam de acordo com a versão do Flutter
usada quando o app foi criado.
Considere manter os arquivos de build atualizados
executando periodicamente `flutter upgrade`
no diretório do seu app.

[Issue #180137]: {{site.repo.flutter}}/issues/180137
[Issue #181383]: {{site.repo.flutter}}/issues/181383
[Issue #183909]: {{site.repo.flutter}}/issues/183909
[Issue #184837]: {{site.repo.flutter}}/issues/184837
[Issue #184838]: {{site.repo.flutter}}/issues/184838
[Issue #184839]: {{site.repo.flutter}}/issues/184839
