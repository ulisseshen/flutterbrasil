---
ia-translate: true
title: Flutter no iOS mais recente
description: >-
  Aprenda sobre o suporte e compatibilidade do Flutter com
  as versões mais recentes do iOS.
---

Você pode desenvolver Flutter na plataforma iOS, mesmo na
versão mais recente do iOS. O Flutter SDK mais recente
já suporta vários dos recursos na
versão mais recente do iOS.

Claro, se você encontrar um bug no Flutter,
por favor [registre um issue][file an issue].

[file an issue]: {{site.github}}/flutter/flutter/issues

## Versão iOS 18

A tabela a seguir mostra o status de suporte para
a versão iOS 18 a partir da versão Flutter 3.24.3.

| Recurso | Status |
|---------|--------|
| Direcionar e construir para iOS 18 | Entregue, suportado |
| Widgets do Control Center (CC) | Entregue, [suportado][cc] Requer escrever algum código Swift para criar um controle para o CC |
| Cores de ícone claro/escuro/tingido | Entregue, [suportado][icon] |
| Apps de senha funcionam/integram trabalho com Flutter | Entregue, suportado |
| Rastreamento ocular de um app Flutter | Funciona parcialmente; [problemas conhecidos][eye] |
| Espelhamento de iPhone (ao visualizar um app Flutter) | Funciona parcialmente; [problemas conhecidos][mirror] |
| Menu de formatação do iOS | Ainda não disponível; no roadmap |
| Mostrar opção Translate para o menu de edição de contexto | Ainda não disponível; no roadmap |
| Apple Intelligence (AI), como New Writing Tools | Ainda não disponível; no roadmap |
| Transição de página com zoom estilo iOS | Ainda não disponível; no roadmap |
| Recurso de digitação por hover | Não disponível |
| [Barra de abas estilo iPad][iPad-style tab bar] | Não disponível |
| Visualizador de conteúdo grande | Não disponível |
| Recurso de trackpad virtual | Não disponível |
{% comment %}
{% endcomment %}
{:.table .table-striped}

[icon]: /deployment/ios#add-an-app-icon
[cc]: /platform-integration/ios/app-extensions
[eye]: {{site.github}}/flutter/flutter/issues/153573
[iPad-style tab bar]: {{site.apple-dev}}/documentation/uikit/app_and_environment/elevating_your_ipad_app_with_a_tab_bar_and_sidebar
[mirror]: {{site.github}}/flutter/flutter/issues/152711
