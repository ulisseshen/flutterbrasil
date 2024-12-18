---
ia-translate: true
title: Flutter no iOS mais recente
description: >-
  Aprenda sobre o suporte e a compatibilidade do Flutter com as versões mais
  recentes do iOS.
---

Você pode desenvolver em Flutter na plataforma iOS, mesmo na versão
mais recente do iOS. O SDK Flutter mais recente já suporta vários
recursos na versão mais recente do iOS.

Claro, se você encontrar um bug no Flutter, por favor,
[abra uma issue][].

[abra uma issue]: {{site.github}}/flutter/flutter/issues

## Lançamento do iOS 18

A tabela a seguir mostra o status do suporte para o lançamento do
iOS 18 a partir do lançamento do Flutter 3.24.3.

| Recurso                                      | Status                                         |
|-----------------------------------------------|------------------------------------------------|
| Destinar e compilar para iOS 18                | Entregue, suportado                             |
| Widgets da Central de Controle (CC)           | Entregue, [suportado][cc] Requer escrever algum código Swift para criar um botão de alternância para o CC  |
| Cores de ícones claro/escuro/tingido            | Entregue, [suportado][icon]                    |
| Apps de senha funcionam/integram-se com Flutter | Entregue, suportado                            |
| Rastreamento ocular de um app Flutter         | Funciona parcialmente; [problemas conhecidos][eye] |
| Espelhamento do iPhone (ao visualizar um app Flutter)  | Funciona parcialmente; [problemas conhecidos][mirror] |
| Menu de formatação do iOS                     | Ainda não disponível; no roadmap               |
| Exibindo a opção Traduzir para o menu de edição de contexto | Ainda não disponível; no roadmap               |
| Apple Intelligence (AI), como Novas Ferramentas de Escrita | Ainda não disponível; no roadmap               |
| Transição de página de zoom estilo iOS          | Ainda não disponível; no roadmap               |
| Recurso de digitação por pairar                | Não disponível                                 |
| [Barra de abas estilo iPad][]                 | Não disponível                                 |
| Visualizador de conteúdo grande                | Não disponível                                 |
| Recurso de trackpad virtual                    | Não disponível                                 |
{% comment %}
{% endcomment %}
{:.table .table-striped}

[icon]: /deployment/ios#add-an-app-icon
[cc]: /platform-integration/ios/app-extensions
[eye]: {{site.github}}/flutter/flutter/issues/153573
[iPad-style tab bar]: {{site.apple-dev}}/documentation/uikit/app_and_environment/elevating_your_ipad_app_with_a_tab_bar_and_sidebar
[mirror]: {{site.github}}/flutter/flutter/issues/152711
