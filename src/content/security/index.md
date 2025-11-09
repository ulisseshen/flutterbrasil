---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e processos da equipe Flutter para segurança.
showBreadcrumbs: false
---

A equipe Flutter leva a segurança do Flutter e das aplicações
criadas com ele a sério. Esta página descreve como reportar quaisquer
vulnerabilidades que você possa encontrar, e lista melhores práticas para minimizar
o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança

A estratégia de segurança do Flutter é baseada em cinco pilares-chave:

* **Identificar**: Rastrear e priorizar riscos de segurança chave
  identificando ativos principais, ameaças-chave e vulnerabilidades.
* **Detectar**: Detectar e identificar vulnerabilidades usando
  técnicas e ferramentas como varredura de vulnerabilidades,
  teste de segurança de aplicação estática e fuzzing.
* **Proteger**: Eliminar riscos mitigando vulnerabilidades
  conhecidas e proteger ativos críticos contra ameaças de origem.
* **Responder**: Definir processos para reportar, triar e
  responder a vulnerabilidades ou ataques.
* **Recuperar**: Construir capacidades para conter e recuperar
  de um incidente com impacto mínimo.

## Reportando vulnerabilidades

Antes de reportar uma vulnerabilidade de segurança encontrada
por uma ferramenta de análise estática,
considere verificar nossa lista de [falsos positivos conhecidos][known false positives].

Reporte vulnerabilidades de segurança para
[https://g.co/vulnz](https://g.co/vulnz) e inclua
uma descrição do problema, os passos que você seguiu para criar
o problema, versões afetadas e, se conhecido, mitigações
para o problema. Usamos g.co/vulnz para nosso intake, e fazemos
coordenação e divulgação no GitHub (incluindo usando GitHub
Security Advisory). A Equipe de Segurança do Google responderá
dentro de 5 dias úteis do seu relatório no g.co/vulnz.

Você também pode entrar em contato com a equipe via nossos canais
públicos de chat no Discord; no entanto, por favor, certifique-se também de fazer
relatórios de vulnerabilidade para g.co/vulnz, e evite revelar
informações sobre vulnerabilidades em público se isso puder
colocar os usuários em risco.

Você deve esperar uma colaboração próxima conforme trabalhamos para resolver
a vulnerabilidade de segurança que você reportou. Por favor, entre em contato com
security@flutter.dev apenas se você não receber uma resposta
a um relatório g.co/vulnz dentro dos 5 dias úteis mencionados acima.

Para mais detalhes sobre como lidamos com vulnerabilidades de segurança,
veja nossa [política de segurança][security policy].

[Discord chat channels]: {{site.repo.flutter}}/blob/main/docs/contributing/Chat.md
[known false positives]: /reference/security-false-positives
[security policy]: {{site.repo.flutter}}/security/policy

## Sinalizando issues existentes como relacionados à segurança

Se você acredita que um issue existente do GitHub está relacionado à segurança,
pedimos que você reporte o issue para g.co/vulnz e envie um
email para security@flutter.dev. O email deve incluir o
ID do issue do GitHub e uma breve descrição de por que ele deve ser
tratado de acordo com esta política de segurança.

Relatórios de segurança não são rastreados explicitamente no banco de dados
de issues do GitHub. Usamos o recurso de security advisory do GitHub para rastrear
relatórios de segurança abertos.

## Versões suportadas

Nos comprometemos a publicar atualizações de segurança para a versão do
Flutter atualmente no branch `stable`.

## Expectativas

Tratamos relatórios de segurança como equivalentes a um nível de prioridade P0.
Isso significa que tentamos corrigi-los o mais rápido possível.
Dependendo do nosso cronograma de lançamento, lançaremos um
novo beta ou um hotfix stable para qualquer relatório de segurança importante
encontrado na versão stable mais recente do nosso SDK, o que for
mais conveniente.

Qualquer vulnerabilidade reportada para sites flutter como
docs.flutter.dev não requer um lançamento e será
corrigida no próprio site.

## Programas de Bug Bounty

Equipes não-Google que usam ou contribuem para o Flutter também são
bem-vindas a incluir Flutter no escopo de seus programas de bug
bounty. Para ter seu programa listado, por favor,
contate `security@flutter.dev`.

O Google considera o Flutter dentro do escopo do
[Google Open Source Software Vulnerability Reward Program][google-oss-vrp].

[google-oss-vrp]: https://bughunters.google.com/open-source-security

## Recebendo atualizações de segurança

A melhor maneira de receber atualizações de segurança é se inscrever na
lista de discussão [flutter-announce][flutter-announce] ou assistir atualizações no
[canal Discord][Discord channel]. Também anunciamos atualizações de segurança no
post do blog de lançamento técnico.

[Discord channel]: https://discord.gg/BS8KZyg
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce

## Melhores práticas

* **Mantenha-se atualizado com os últimos lançamentos do Flutter SDK.**
  Atualizamos regularmente o Flutter, e essas atualizações podem corrigir defeitos de
  segurança descobertos em versões anteriores.

* **Mantenha as dependências da sua aplicação atualizadas.**
  Certifique-se de [atualizar as dependências do seu package][upgrade your package dependencies]
  para manter as dependências atualizadas.
  Evite fixar em versões específicas
  para suas dependências e, se você fizer isso, certifique-se de verificar
  periodicamente se suas dependências tiveram atualizações de segurança,
  e atualize a fixação de acordo.

* **Mantenha sua cópia do Flutter atualizada.**
  Versões privadas e personalizadas do Flutter tendem
  a ficar para trás da versão atual e podem não
  incluir correções e aprimoramentos de segurança importantes.
  Em vez disso, atualize rotineiramente sua cópia do Flutter.
  Se você está fazendo mudanças para melhorar o Flutter,
  certifique-se de atualizar seu fork e considere compartilhar suas
  mudanças com a comunidade.

[upgrade your package dependencies]: /install/upgrade
