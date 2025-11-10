---
title: Migrar um projeto Windows para o run loop idiomático
description: Como atualizar um projeto Windows para usar o run loop idiomático
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

O Flutter 2.5 substituiu o run loop dos apps Windows por uma
message pump do Windows idiomática para reduzir o uso de CPU.

Projetos criados antes da versão 2.5 do Flutter precisam ser
migrados para obter essa melhoria. Você deve seguir os
passos de migração abaixo se o arquivo `windows/runner/run_loop.h`
existir no seu projeto.

## Migration steps

:::note
Como parte desta migração, você deve recriar seu projeto Windows,
o que sobrescreve quaisquer mudanças personalizadas nos
arquivos da pasta `windows/runner`. Os passos a seguir
incluem instruções para este cenário.
:::

Seu projeto pode ser atualizado usando estes passos:

1. Verifique que você está no Flutter versão 2.5 ou superior usando `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do
Flutter SDK
3. Faça backup do seu projeto com git (ou seu sistema de controle de versão preferido),
   já que você precisará reaplicar quaisquer mudanças locais que você fez (se houver) ao seu
   projeto em um passo posterior
4. Delete todos os arquivos na pasta `windows/runner`
5. Execute `flutter create --platforms=windows .` para recriar o projeto Windows
6. Revise as mudanças nos arquivos da pasta `windows/runner`
7. Reaplique quaisquer mudanças personalizadas feitas aos arquivos na
pasta `windows/runner` antes desta migração
8. Verifique que seu app compila usando `flutter build windows`
