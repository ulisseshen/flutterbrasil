---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia da equipe do Flutter e dos processos de segurança.
show_breadcrumbs: false
---

A equipe do Flutter leva a segurança do Flutter e dos aplicativos
criados com ele a sério. Esta página descreve como relatar quaisquer
vulnerabilidades que você possa encontrar e lista as melhores práticas para minimizar
o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança

A estratégia de segurança do Flutter é baseada em cinco pilares principais:

* **Identificar**: Rastrear e priorizar os principais riscos de segurança,
  identificando ativos principais, ameaças principais e vulnerabilidades.
* **Detectar**: Detectar e identificar vulnerabilidades usando
  técnicas e ferramentas como escaneamento de vulnerabilidades,
  testes de segurança de aplicativos estáticos e fuzzing.
* **Proteger**: Eliminar riscos, mitigando
  vulnerabilidades conhecidas e proteger ativos críticos contra ameaças de origem.
* **Responder**: Definir processos para relatar, triar e
  responder a vulnerabilidades ou ataques.
* **Recuperar**: Construir capacidades para conter e recuperar
  de um incidente com impacto mínimo.

## Relatando vulnerabilidades

Antes de relatar uma vulnerabilidade de segurança encontrada
por uma ferramenta de análise estática,
considere verificar nossa lista de [falsos positivos conhecidos][].

Para relatar uma vulnerabilidade, envie um e-mail para `security@flutter.dev`
com uma descrição do problema,
as etapas que você seguiu para criar o problema,
versões afetadas e, se conhecido, mitigações para o problema.

Nós devemos responder dentro de três dias úteis.

Usamos o recurso de aviso de segurança do GitHub para rastrear
problemas de segurança em aberto. Você deve esperar uma estreita colaboração
enquanto trabalhamos para resolver o problema que você relatou.

Entre em contato com `security@flutter.dev` novamente se
você não receber atenção imediata e atualizações regulares.
Você também pode entrar em contato com a equipe usando nossos
[canais de chat do Discord][]; no entanto, ao relatar um problema,
envie um e-mail para `security@flutter.dev`.
Para evitar revelar informações sobre vulnerabilidades
em público que possam colocar os usuários em risco,
**não publique no Discord nem registre um problema no GitHub**.

Para mais detalhes sobre como lidamos com vulnerabilidades de segurança,
veja nossa [política de segurança][].

[canais de chat do Discord]: {{site.repo.flutter}}/blob/master/docs/contributing/Chat.md
[falsos positivos conhecidos]: /reference/security-false-positives
[política de segurança]: {{site.repo.flutter}}/security/policy

## Sinalizando problemas existentes como relacionados à segurança

Se você acredita que um problema existente é relacionado à segurança,
pedimos que você envie um e-mail para `security@flutter.dev`.
O e-mail deve incluir o ID do problema e uma pequena descrição
do porquê ele deve ser tratado de acordo com esta política de segurança.

## Versões suportadas

Nós nos comprometemos a publicar atualizações de segurança para a versão do
Flutter atualmente no branch `stable`.

## Expectativas

Tratamos problemas de segurança como equivalentes a um nível de prioridade P0
e lançamos uma versão beta ou hotfix para quaisquer grandes problemas de segurança
encontrados na versão estável mais recente do nosso SDK.

Qualquer vulnerabilidade relatada para sites do flutter como
docs.flutter.dev não requer um lançamento e será
corrigida no próprio site.

## Programas de Bug Bounty

As equipes contribuidoras podem incluir o Flutter no escopo
de seus programas de bug bounty. Para ter seu programa listado,
entre em contato com `security@flutter.dev`.

O Google considera que o Flutter está no escopo do
[Programa de Recompensa de Vulnerabilidade de Software de Código Aberto do Google][google-oss-vrp].
Para maior rapidez, os repórteres devem entrar em contato com `security@flutter.dev`
antes de usar o fluxo de relatório de vulnerabilidade do Google.

[google-oss-vrp]: https://bughunters.google.com/open-source-security

## Recebendo atualizações de segurança

A melhor maneira de receber atualizações de segurança é se inscrever na
lista de discussão [flutter-announce][] ou assistir às atualizações do
[canal do Discord][]. Também anunciamos atualizações de segurança no
post do blog de lançamento técnico.

[canal do Discord]: https://discord.gg/BS8KZyg
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce

## Melhores práticas

* **Mantenha-se atualizado com as últimas versões do Flutter SDK.**
  Nós atualizamos o Flutter regularmente, e essas atualizações podem corrigir
  defeitos de segurança descobertos em versões anteriores.

* **Mantenha as dependências do seu aplicativo atualizadas.**
  Certifique-se de [atualizar as dependências do seu pacote][]
  para manter as dependências atualizadas.
  Evite fixar versões específicas
  para suas dependências e, se o fizer, verifique
  periodicamente para ver se suas dependências tiveram atualizações de segurança,
  e atualize a fixação de acordo.

* **Mantenha sua cópia do Flutter atualizada.**
  Versões privadas e personalizadas do Flutter tendem
  a ficar para trás da versão atual e podem não
  incluir importantes correções e melhorias de segurança.
  Em vez disso, atualize rotineiramente sua cópia do Flutter.
  Se você estiver fazendo alterações para melhorar o Flutter,
  certifique-se de atualizar seu fork e considere compartilhar suas
  alterações com a comunidade.

[atualizar as dependências do seu pacote]: /release/upgrade
