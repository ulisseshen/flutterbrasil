---
ia-translate: true
title: Migrar um projeto Windows para o run loop idiomático
description: Como atualizar um projeto Windows para usar o run loop idiomático
---

O Flutter 2.5 substituiu o run loop dos apps Windows por uma
message pump idiomática do Windows para reduzir o uso de CPU.

Projetos criados antes do Flutter versão 2.5 precisam ser
migrados para obter essa melhoria. Você deve seguir os
passos de migração abaixo se o arquivo `windows/runner/run_loop.h`
existir no seu projeto.

## Passos de migração

:::note
Como parte desta migração, você deve recriar seu projeto Windows,
o que sobrescreverá quaisquer alterações personalizadas nos
arquivos da pasta `windows/runner`. Os passos a seguir
incluem instruções para este cenário.
:::

Seu projeto pode ser atualizado usando estes passos:

1. Verifique que você está no Flutter versão 2.5 ou mais recente usando `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do
Flutter SDK
3. Faça backup do seu projeto com git (ou seu sistema de controle de versão preferido),
   pois você precisará reaplicar quaisquer alterações locais que fez (se houver) ao seu
   projeto em um passo posterior
4. Delete todos os arquivos na pasta `windows/runner`
5. Execute `flutter create --platforms=windows .` para recriar o projeto Windows
6. Revise as alterações nos arquivos da pasta `windows/runner`
7. Reaplique quaisquer alterações personalizadas feitas aos arquivos na
pasta `windows/runner` antes desta migração
8. Verifique que seu app compila usando `flutter build windows`
