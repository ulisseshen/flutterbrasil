---
ia-translate: true
title: Experiência do usuário
description: >
  Como o usuário experimentará o AI Toolkit em seu aplicativo.
prev:
  title: Visão geral do AI Toolkit
  path: /ai-toolkit/
next:
  title: Integração de recursos
  path: /ai-toolkit/feature-integration
revised: true
---

O widget [`LlmChatView`][] é o ponto de entrada para a
experiência de chat interativa que o AI Toolkit oferece.
Hospedar uma instância de `LlmChatView` habilita uma
série de recursos de experiência do usuário que não exigem
nenhum código adicional para usar:

*   **Entrada de texto em várias linhas**: Permite que os
    usuários colem textos longos ou insiram novas linhas em seu texto enquanto o digitam.
*   **Entrada de voz**: Permite que os usuários insiram
    prompts usando a fala para facilitar o uso.
*   **Entrada multimídia**: Permite que os usuários tirem
    fotos e enviem imagens e outros tipos de arquivo.
*   **Zoom de imagem**: Permite que os usuários ampliem as miniaturas de imagens.
*   **Copiar para a área de transferência**: Permite que o
    usuário copie o texto de uma mensagem ou uma resposta LLM para a área de transferência.
*   **Edição de mensagens**: Permite que o usuário edite a
    mensagem mais recente para reenvio ao LLM.
*   **Material e Cupertino**: Adapta-se às melhores práticas
    de ambas as linguagens de design.

[`LlmChatView`]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmChatView-class.html

## Entrada de texto em várias linhas

O usuário tem opções quando se trata de enviar
seu prompt depois de terminar de compô-lo,
o que novamente difere dependendo de sua plataforma:

*   **Mobile**: Toque no botão **Enviar**
*   **Web**: Pressione **Enter** ou toque no botão **Enviar**
*   **Desktop**: Pressione **Enter** ou toque no botão **Enviar**

Além disso, a visualização do chat oferece suporte a prompts
de texto com novas linhas incorporadas neles. Se o usuário
tiver um texto existente com novas linhas, ele poderá colá-lo
no campo de texto do prompt normalmente.

Se eles quiserem incorporar novas linhas em seu prompt
manualmente enquanto o digitam, eles podem fazê-lo.
O gesto para essa atividade difere com base na
plataforma que eles estão usando:

*   **Mobile**: Toque na tecla Return no teclado virtual
*   **Web**: Não suportado
*   **Desktop**: Pressione `Ctrl+Enter` ou `Opt/Alt+Enter`

Essas opções se parecem com o seguinte:

**Desktop**:

![Captura de tela da entrada de texto no desktop](/assets/images/docs/ai-toolkit/desktop-enter-text.png)

**Mobile**:

![Captura de tela da entrada de texto no mobile](/assets/images/docs/ai-toolkit/mobile-enter-text.png)

## Entrada de voz

Além da entrada de texto, a visualização do chat pode receber
uma gravação de áudio como entrada tocando no botão Mic,
que fica visível quando nenhum texto foi inserido.

Tocar no botão **Mic** inicia a gravação:

![Captura de tela da entrada de texto](/assets/images/docs/ai-toolkit/enter-textfield.png)

Pressionar o botão **Parar** traduz a entrada de voz do usuário em texto:

Este texto pode então ser editado, aumentado e enviado normalmente.

![Captura de tela da entrada de voz](/assets/images/docs/ai-toolkit/enter-voice-into-textfield.png)

## Entrada Multimídia

![Campo de texto contendo "Testando, testando, um, dois, três"](/assets/images/docs/ai-toolkit/multi-media-testing-testing.png)

A visualização do chat também pode receber imagens e arquivos como
entrada para passar para o LLM. O usuário pode pressionar
o botão **Mais** à esquerda da entrada de texto e escolher entre
os ícones **Tirar Foto**, **Galeria de Imagens** e **Anexar Arquivo**:

![Captura de tela dos 4 ícones](/assets/images/docs/ai-toolkit/multi-media-icons.png)

O botão **Tirar Foto** permite que o usuário use a câmera de seu dispositivo para tirar uma foto:

![Imagem de selfie](/assets/images/docs/ai-toolkit/selfie.png)

Pressionar o botão **Galeria de Imagens** permite que o
usuário faça upload da galeria de imagens de seu dispositivo:

![Download de imagem da galeria](/assets/images/docs/ai-toolkit/download-from-gallery.png)

Pressionar o botão **Anexar Arquivo** permite que o usuário selecione um
arquivo de qualquer tipo disponível em seu dispositivo, como um arquivo PDF ou TXT.

Depois que uma foto, imagem ou arquivo é selecionado, ele se torna um anexo e aparece como uma miniatura associada ao prompt atualmente ativo:

![Miniaturas de imagens](/assets/images/docs/ai-toolkit/image-thumbnails.png)

O usuário pode remover um anexo clicando no botão
**X** na miniatura.

## Zoom de imagem

O usuário pode ampliar uma miniatura de imagem tocando nela:

![Imagem ampliada](/assets/images/docs/ai-toolkit/image-zoom.png)

Pressionar a tecla **ESC** ou tocar em qualquer lugar
fora da imagem dispensa a imagem ampliada.

## Copiar para a área de transferência

O usuário pode copiar qualquer prompt de texto ou resposta LLM
em seu chat atual de várias maneiras. No desktop ou na
web, o usuário pode usar o mouse para selecionar o texto em
sua tela e copiá-lo para a área de transferência
normalmente:

![Copiar para a área de transferência](/assets/images/docs/ai-toolkit/copy-to-clipboard.png)

Além disso, na parte inferior de cada prompt ou resposta,
o usuário pode pressionar o botão **Copiar** que aparece
quando passa o mouse:

![Pressione o botão copiar](/assets/images/docs/ai-toolkit/chatbot-prompt.png)

Em plataformas móveis, o usuário pode tocar e segurar um prompt ou resposta e escolher a opção Copiar:

![Toque longo para ver o botão de cópia](/assets/images/docs/ai-toolkit/long-tap-choose-copy.png)

## Edição de mensagem

Se o usuário quiser editar seu último prompt
e fazer com que o LLM o execute novamente,
ele pode fazê-lo. No desktop,
o usuário pode tocar no botão **Editar** ao lado do
botão **Copiar** para seu prompt mais recente:

![Como editar o prompt](/assets/images/docs/ai-toolkit/how-to-edit-prompt.png)

Em um dispositivo móvel, o usuário pode tocar e segurar
para obter acesso à opção **Editar** em seu prompt mais recente:

![Como acessar o menu de edição](/assets/images/docs/ai-toolkit/accessing-edit-menu.png)

Depois que o usuário toca no botão **Editar**, ele entra
no modo de edição, que remove o último prompt do usuário
e a última resposta do LLM do histórico de chat,
coloca o texto do prompt no campo de texto e fornece
um indicador de Edição:

![Como sair do modo de edição](/assets/images/docs/ai-toolkit/how-to-exit-editing-mode.png)

No modo de Edição, o usuário pode editar o prompt como
quiser e enviá-lo para que o LLM produza uma resposta
normalmente. Ou, se ele mudar de ideia, ele pode tocar no
**X** perto do indicador de edição para cancelar sua edição
e restaurar sua resposta anterior do LLM.

## Material e Cupertino

Quando o widget `LlmChatView` é hospedado em um
[aplicativo Material][], ele usa recursos fornecidos
pela linguagem de design Material, como o [`TextField`][]
do Material. Da mesma forma, quando hospedado em um
[aplicativo Cupertino][], ele usa esses recursos, como [`CupertinoTextField`][].

![Exemplo de aplicativo Cupertino](/assets/images/docs/ai-toolkit/cupertino-chat-app.png)

No entanto, embora a visualização do chat ofereça suporte aos tipos de
aplicativos Material e Cupertino, ela não adota automaticamente os temas associados.
Em vez disso, isso é definido pela propriedade `style`
de `LlmChatView` conforme descrito na documentação [Estilo personalizado][].

[aplicativo Cupertino]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`CupertinoTextField`]: {{site.api}}/flutter/cupertino/CupertinoTextField-class.html
[Estilo personalizado]: /ai-toolkit/feature-integration#estilo-personalizado
[aplicativo Material]: {{site.api}}/flutter/material/MaterialApp-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
