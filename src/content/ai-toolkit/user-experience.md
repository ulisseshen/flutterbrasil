---
ia-translate: true
title: Experiência do usuário
description: >
  Como o usuário experimentará o AI Toolkit em seu app.
prev:
  title: AI Toolkit overview
  path: /ai-toolkit/
next:
  title: Feature integration
  path: /ai-toolkit/feature-integration
---

O widget [`LlmChatView`][] é o ponto de entrada para a
experiência de chat interativo que o AI Toolkit fornece.
Hospedar uma instância do `LlmChatView` habilita uma série
de recursos de experiência do usuário que não requerem
nenhum código adicional para usar:

* **Entrada de texto multilinha**: Permite aos usuários colar textos longos
  ou inserir novas linhas no texto conforme digitam.
* **Entrada por voz**: Permite aos usuários inserir prompts usando fala
  para facilidade de uso.
* **Entrada multimídia**: Permite aos usuários tirar fotos e
  enviar imagens e outros tipos de arquivo.
* **Zoom de imagem**: Permite aos usuários ampliar miniaturas de imagem.
* **Copiar para a área de transferência**: Permite ao usuário copiar o texto de
  uma mensagem ou resposta LLM para a área de transferência.
* **Edição de mensagem**: Permite ao usuário editar a mensagem
  mais recente para reenviar ao LLM.
* **Material e Cupertino**: Adapta-se às melhores práticas de
  ambas as linguagens de design.

[`LlmChatView`]: {{site.pub-api}}/flutter_ai_toolkit/latest/flutter_ai_toolkit/LlmChatView-class.html

## Entrada de texto multilinha

O usuário tem opções quando se trata de enviar
seu prompt depois de terminá-lo,
que novamente difere dependendo de sua plataforma:

* **Mobile**: Toque no botão **Submit**
* **Web**: Pressione **Enter** ou toque no botão **Submit**
* **Desktop**: Pressione **Enter** ou toque no botão **Submit**

Além disso, a visualização de chat suporta prompts de texto
com novas linhas incorporadas neles. Se o usuário tiver texto existente
com novas linhas, eles podem colá-lo no
campo de texto do prompt normalmente.

Se eles quiserem incorporar novas linhas em seu prompt
manualmente conforme digitam, podem fazê-lo.
O gesto para essa atividade difere baseado na
plataforma que estão usando:

* **Mobile**: Toque na tecla Return no teclado virtual
* **Web**: Não suportado
* **Desktop**: Pressione `Ctrl+Enter` ou `Opt/Alt+Enter`

Essas opções se parecem com o seguinte:

**Desktop**:

![Screenshot of entering text on desktop](/assets/images/docs/ai-toolkit/desktop-enter-text.png)

**Mobile**:

![Screenshot of entering text on mobile](/assets/images/docs/ai-toolkit/mobile-enter-text.png)

## Entrada por voz

Além da entrada de texto, a visualização de chat pode receber uma
gravação de áudio como entrada tocando no botão Mic,
que fica visível quando nenhum texto foi inserido ainda.

Tocar no botão **Mic** inicia a gravação:

![Screenshot of entering text](/assets/images/docs/ai-toolkit/enter-textfield.png)

Pressionar o botão **Stop** traduz a entrada de voz do usuário em texto:

Este texto pode então ser editado, aumentado e enviado normalmente.

![Screenshot of entered voice](/assets/images/docs/ai-toolkit/enter-voice-into-textfield.png)

## Entrada multimídia

![Textfield containing "Testing, testing, one, two, three"](/assets/images/docs/ai-toolkit/multi-media-testing-testing.png)

A visualização de chat também pode receber imagens e arquivos como entrada para passar
ao LLM subjacente. O usuário pode pressionar o botão **Plus** à
esquerda da entrada de texto e escolher entre os ícones **Take Photo**, **Image Gallery**
e **Attach File**:

![Screenshot of the 4 icons](/assets/images/docs/ai-toolkit/multi-media-icons.png)

O botão **Take Photo** permite ao usuário usar a câmera de seu dispositivo para tirar uma foto:

![Selfie image](/assets/images/docs/ai-toolkit/selfie.png)

Pressionar o botão **Image Gallery** permite ao usuário fazer upload
da galeria de imagens de seu dispositivo:

![Download image from gallery](/assets/images/docs/ai-toolkit/download-from-gallery.png)

Pressionar o botão **Attach File** permite ao usuário selecionar
um arquivo de qualquer tipo disponível em seu dispositivo, como um arquivo PDF ou TXT.

Uma vez que uma foto, imagem ou arquivo foi selecionado, torna-se um anexo e aparece como uma miniatura associada ao prompt atualmente ativo:

![Thumbnails of images](/assets/images/docs/ai-toolkit/image-thumbnails.png)

O usuário pode remover um anexo clicando no
botão **X** na miniatura.

## Zoom de imagem

O usuário pode ampliar uma miniatura de imagem tocando nela:

![Zoomed image](/assets/images/docs/ai-toolkit/image-zoom.png)

Pressionar a tecla **ESC** ou tocar em qualquer lugar fora da
imagem dispensa a imagem ampliada.

## Copiar para a área de transferência

O usuário pode copiar qualquer prompt de texto ou resposta LLM
em seu chat atual de várias maneiras.
No desktop ou na web, o usuário pode passar o mouse
para selecionar o texto em sua tela e
copiá-lo para a área de transferência normalmente:

![Copy to clipboard](/assets/images/docs/ai-toolkit/copy-to-clipboard.png)

Além disso, na parte inferior de cada prompt ou resposta,
o usuário pode pressionar o botão **Copy** que aparece
quando passa o mouse:

![Press the copy button](/assets/images/docs/ai-toolkit/chatbot-prompt.png)

Em plataformas mobile, o usuário pode tocar longamente um prompt ou resposta e escolher a opção Copy:

![Long tap to see the copy button](/assets/images/docs/ai-toolkit/long-tap-choose-copy.png)

## Edição de mensagem

Se o usuário quiser editar seu último prompt
e fazer com que o LLM tente novamente,
pode fazê-lo. No desktop,
o usuário pode tocar no botão **Edit** ao lado do
botão **Copy** para seu prompt mais recente:

![How to edit prompt](/assets/images/docs/ai-toolkit/how-to-edit-prompt.png)

Em um dispositivo mobile, o usuário pode tocar longamente e ter acesso
à opção **Edit** em seu prompt mais recente:

![How to access edit menu](/assets/images/docs/ai-toolkit/accessing-edit-menu.png)

Uma vez que o usuário toca no botão **Edit**, entra em modo de Edição,
que remove tanto o último prompt do usuário quanto a última
resposta do LLM do histórico de chat,
coloca o texto do prompt no campo de texto e
fornece um indicador de Edição:

![How to exit editing mode](/assets/images/docs/ai-toolkit/how-to-exit-editing-mode.png)

No modo de Edição, o usuário pode editar o prompt como desejar
e enviá-lo para que o LLM produza uma resposta normalmente.
Ou, se mudarem de ideia, podem tocar no **X**
perto do indicador de Edição para cancelar sua edição e restaurar
sua resposta LLM anterior.

## Material e Cupertino

Quando o widget `LlmChatView` é hospedado em um [Material app][],
ele usa facilidades fornecidas pela linguagem de design Material,
como o [`TextField`][] do Material.
Da mesma forma, quando hospedado em um [Cupertino app][],
ele usa essas facilidades, como [`CupertinoTextField`][].

![Cupertino example app](/assets/images/docs/ai-toolkit/cupertino-chat-app.png)

No entanto, enquanto a visualização de chat suporta ambos os tipos de app Material e
Cupertino, ela não adota automaticamente os temas associados.
Em vez disso, isso é definido pela propriedade `style` do `LlmChatView`
conforme descrito na documentação [Custom styling][].

[Cupertino app]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`CupertinoTextField`]: {{site.api}}/flutter/cupertino/CupertinoTextField-class.html
[Custom styling]: /ai-toolkit/feature-integration#custom-styling
[Material app]: {{site.api}}/flutter/material/MaterialApp-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
