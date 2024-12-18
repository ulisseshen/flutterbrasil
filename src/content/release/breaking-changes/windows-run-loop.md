---
ia-translate: true
title: Migrar um projeto Windows para o loop de execução idiomático
description: Como atualizar um projeto Windows para usar o loop de execução idiomático
---

O Flutter 2.5 substituiu o loop de execução de aplicativos Windows por um
*message pump* do Windows idiomático para reduzir o uso da CPU.

Projetos criados antes da versão 2.5 do Flutter precisam ser migrados para
obter essa melhoria. Você deve seguir as etapas de migração abaixo se o
arquivo `windows/runner/run_loop.h` existir em seu projeto.

## Etapas de migração

:::note
Como parte desta migração, você deve recriar seu projeto Windows,
o que sobrescreve quaisquer alterações personalizadas nos arquivos na
pasta `windows/runner`. As etapas a seguir incluem instruções para
este cenário.
:::

Seu projeto pode ser atualizado usando estas etapas:

1. Verifique se você está na versão 2.5 ou mais recente do Flutter usando `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do SDK do Flutter
3. Faça backup do seu projeto com git (ou seu sistema de controle de versão
   preferido), pois você precisa reaplicar quaisquer alterações locais que
   tenha feito (se houver) em seu projeto em uma etapa posterior
4. Exclua todos os arquivos na pasta `windows/runner`
5. Execute `flutter create --platforms=windows .` para recriar o projeto Windows
6. Revise as alterações nos arquivos na pasta `windows/runner`
7. Reaplicar quaisquer alterações personalizadas feitas nos arquivos na
`windows/runner` pasta antes desta migração
8. Verifique se seu aplicativo é compilado usando `flutter build windows`
