---
ia-translate: true
title: Componentes principais e conceitos do SDK GenUI
breadcrumb: Componentes principais e conceitos
description: >-
  Familiarize-se com os principais componentes e conceitos do
  Flutter para o SDK GenUI.
prev:
  title: GenUI SDK overview
  path: /ai/genui
next:
  title: Get started with the GenUI SDK
  path: /ai/genui/get-started
---

:::experimental
O pacote `genui` está em
alfa e provavelmente vai mudar.
:::

## Componentes principais {:#main-components}

O pacote [`genui`][`genui`] é construído em torno dos seguintes componentes principais:

`Conversation`
: A fachada principal e o ponto de entrada do pacote.
  Ela inclui a classe `SurfaceController`,
  gerencia o histórico da conversa
  e orquestra todo o processo de UI generativa.

`Catalog`
: Uma coleção de objetos `CatalogItem` que define
  o conjunto de widgets que a IA pode usar.
  O `SurfaceController` oferece suporte a vários catálogos,
  permitindo organizar seus widgets em grupos lógicos.
  Cada `CatalogItem` especifica o nome de um widget (para que a IA
  possa referenciá-lo), um esquema de dados para as propriedades dele e uma
  função builder que renderiza o widget Flutter.

`DataModel`
: Um armazenamento centralizado e observável para todo o estado dinâmico da UI.
  Os widgets são _vinculados_ aos dados desse modelo. Quando os dados mudam,
  somente os widgets que dependem daquele dado específico são reconstruídos.

`A2uiTransportAdapter`
: Uma ponte que analisa os fluxos de texto brutos vindos do seu LLM e os
  transforma em comandos `A2uiMessage` para o `SurfaceController`.

`A2uiMessage`
: Uma mensagem enviada pela IA
  (analisada pelo `A2uiTransportAdapter`) para a UI,
  instruindo-a a executar ações como `createSurface`,
  `surfaceUpdate`, `dataModelUpdate` ou `deleteSurface`.

`SurfaceController`
: Cuida do processamento das `A2uiMessage`s,
  gerencia o `DataModel` e mantém o estado das superfícies da UI.


## Como funciona {:#how-it-works}

O `Conversation` gerencia o ciclo de interação:

 1. **Entrada do usuário**

    O usuário fornece um prompt (por exemplo, por meio de um campo de texto).
    O app chama `conversation.sendMessage()`.

 2. **Invocação da IA**

    O `Conversation` envia a mensagem do usuário para o SDK do LLM.

 3. **Resposta da IA**

    O LLM, guiado pelos esquemas dos widgets fornecidos no seu prompt de sistema,
    envia respostas de volta.

 4. **Tratamento do stream**

    O stream de texto do SDK do LLM é alimentado no `A2uiTransportAdapter`.

 5. **Atualização do estado da UI**

    As `A2uiMessage`s analisadas pelo adaptador são passadas para
    `SurfaceController.handleMessage()`, que atualiza
    o estado da UI e o `DataModel`.

 6. **Renderização da UI**

    O `SurfaceController` transmite uma atualização,
    e qualquer widget `Surface` que escute esse ID de superfície é reconstruído.
    Os widgets estão vinculados ao `DataModel`, então se atualizam automaticamente
    quando os dados mudam.

 7. **Callbacks**

    Respostas de texto e erros disparam callbacks no `Conversation` ou
    são tratados pelo fluxo de integração específico do seu LLM.

 8. **Interação do usuário**

    O usuário interage com a UI recém-gerada
    (por exemplo, digitando em um campo de texto). Essa interação atualiza
    diretamente o `DataModel`. Se a interação for uma ação (como um clique em
    botão), o `Surface` captura o evento e o encaminha para o
    `SurfaceController`, que cria automaticamente uma nova `UserMessage` com o
    estado atual dos dados do modelo e reinicia o ciclo.

{:.steps}

Para informações mais detalhadas sobre a implementação do SDK GenUI para Flutter,
confira o [documento de design][design doc].

A próxima seção mostra como adicionar o `genui` ao seu app.

[design doc]: {{site.repo.organization}}/genui/blob/main/packages/genui/DESIGN.md
[`genui`]: {{site.pub-pkg}}/genui
