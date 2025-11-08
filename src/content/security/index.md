---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e processos da equipe Flutter para segurança.
show_breadcrumbs: false
---

A equipe Flutter leva a sério a segurança do Flutter e dos aplicativos
criados com ele. Esta página descreve como relatar quaisquer
vulnerabilidades que você possa encontrar e lista as melhores práticas para minimizar
o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança

A estratégia de segurança do Flutter é baseada em cinco pilares principais:

* **Identificar**: Rastrear e priorizar os principais riscos de segurança
  identificando ativos principais, ameaças chave e vulnerabilidades.
* **Detectar**: Detectar e identificar vulnerabilidades usando
  técnicas e ferramentas como varredura de vulnerabilidades,
  teste de segurança de aplicações estáticas e fuzzing.
* **Proteger**: Eliminar riscos mitigando vulnerabilidades conhecidas
  e proteger ativos críticos contra ameaças de origem.
* **Responder**: Definir processos para relatar, triar e
  responder a vulnerabilidades ou ataques.
* **Recuperar**: Construir capacidades para conter e recuperar
  de um incidente com impacto mínimo.

## Relatar vulnerabilidades

Antes de relatar uma vulnerabilidade de segurança encontrada
por uma ferramenta de análise estática,
considere verificar nossa lista de [falsos positivos conhecidos][known false positives].

Para relatar uma vulnerabilidade, envie um e-mail para `security@flutterbrasil.dev`
com uma descrição do problema,
as etapas que você seguiu para criar o problema,
versões afetadas e, se conhecido, mitigações para o problema.

Devemos responder dentro de três dias úteis.

Usamos o recurso de aviso de segurança do GitHub para rastrear
problemas de segurança abertos. Você deve esperar uma colaboração próxima
enquanto trabalhamos para resolver o problema que você relatou.

Entre em contato com `security@flutterbrasil.dev` novamente se
você não receber atenção rápida e atualizações regulares.
Você também pode entrar em contato com a equipe usando nossos
[canais de chat públicos do Discord][Discord chat channels]; no entanto, ao relatar um problema,
envie um e-mail para `security@flutterbrasil.dev`.
Para evitar revelar informações sobre vulnerabilidades
em público que possam colocar os usuários em risco,
**não poste no Discord ou abra uma issue no GitHub**.

Para mais detalhes sobre como lidamos com vulnerabilidades de segurança,
consulte nossa [política de segurança][security policy].

[Discord chat channels]: {{site.repo.flutter}}/blob/main/docs/contributing/Chat.md
[known false positives]: /reference/security-false-positives
[security policy]: {{site.repo.flutter}}/security/policy

## Sinalizar issues existentes como relacionadas à segurança

Se você acredita que uma issue existente está relacionada à segurança,
pedimos que você envie um e-mail para `security@flutterbrasil.dev`.
O e-mail deve incluir o ID da issue e uma breve descrição
de por que ela deve ser tratada de acordo com esta política de segurança.

## Versões suportadas

Comprometemo-nos a publicar atualizações de segurança para a versão do
Flutter atualmente na branch `stable`.

## Expectativas

Tratamos problemas de segurança equivalentes ao nível de prioridade P0
e lançamos uma versão beta ou hotfix para quaisquer problemas graves de segurança
encontrados na versão estável mais recente do nosso SDK.

Qualquer vulnerabilidade relatada para sites do Flutter como
docs.flutterbrasil.dev não requer um lançamento e será
corrigida no próprio site.

## Programas Bug Bounty

Equipes contribuidoras podem incluir o Flutter dentro do escopo
de seus programas de bug bounty. Para ter seu programa listado,
entre em contato com `security@flutterbrasil.dev`.

O Google considera o Flutter dentro do escopo do
[Google Open Source Software Vulnerability Reward Program][google-oss-vrp].
Para agilidade, os relatores devem entrar em contato com `security@flutterbrasil.dev`
antes de usar o fluxo de relatório de vulnerabilidades do Google.

[google-oss-vrp]: https://bughunters.google.com/open-source-security

## Receber atualizações de segurança

A melhor maneira de receber atualizações de segurança é assinar a
lista de e-mails [flutter-announce][] ou acompanhar atualizações no
[canal do Discord][Discord channel]. Também anunciamos atualizações de segurança no
post do blog de lançamento técnico.

[Discord channel]: https://discord.gg/BS8KZyg
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce

## Melhores práticas

* **Mantenha-se atualizado com os últimos lançamentos do Flutter SDK.**
  Atualizamos regularmente o Flutter, e essas atualizações podem corrigir defeitos
  de segurança descobertos em versões anteriores.

* **Mantenha as dependências da sua aplicação atualizadas.**
  Certifique-se de [atualizar as dependências dos seus packages][upgrade your package dependencies]
  para manter as dependências atualizadas.
  Evite fixar versões específicas
  para suas dependências e, se o fizer, certifique-se de verificar
  periodicamente se suas dependências tiveram atualizações de segurança
  e atualize a fixação de acordo.

* **Mantenha sua cópia do Flutter atualizada.**
  Versões privadas e personalizadas do Flutter tendem
  a ficar para trás da versão atual e podem não
  incluir correções e melhorias de segurança importantes.
  Em vez disso, atualize rotineiramente sua cópia do Flutter.
  Se você está fazendo alterações para melhorar o Flutter,
  certifique-se de atualizar seu fork e considere compartilhar suas
  alterações com a comunidade.

[upgrade your package dependencies]: /release/upgrade

