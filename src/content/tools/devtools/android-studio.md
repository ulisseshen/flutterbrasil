---
ia-translate: true
title: Executar o DevTools do Android Studio
description: Aprenda como iniciar e usar o DevTools no Android Studio.
---

## Instalar o plugin do Flutter

Adicione o plugin do Flutter caso ainda não o tenha instalado.
Isso pode ser feito usando a página normal **Plugins** nas
configurações do IntelliJ e Android Studio. Assim que essa
página estiver aberta, você pode pesquisar o plugin do Flutter
no marketplace.

## Iniciar um app para depurar

Para abrir o DevTools, você primeiro precisa executar um app
Flutter. Isso pode ser feito abrindo um projeto Flutter,
garantindo que você tenha um dispositivo conectado e clicando
nos botões da barra de ferramentas **Run** ou **Debug**.

## Iniciar o DevTools pela barra de ferramentas/menu

Assim que um app estiver em execução, você pode iniciar o
DevTools usando uma das seguintes técnicas:

* Selecione a ação da barra de ferramentas **Open DevTools** na
  visualização Run.
* Selecione a ação da barra de ferramentas **Open DevTools** na
  visualização Debug (se estiver depurando).
* Selecione a ação **Open DevTools** no menu **More Actions** na
  visualização Flutter Inspector.

![Captura de tela do botão Open DevTools](/assets/images/docs/tools/devtools/android_studio_open_devtools.png){:width="100%"}

## Iniciar o DevTools por uma ação

Você também pode abrir o DevTools por uma ação do IntelliJ.
Abra o diálogo **Find Action...** (no macOS, pressione <kbd>Cmd</kbd> +
<kbd>Shift</kbd> + <kbd>A</kbd>) e procure pela ação **Open
DevTools**. Quando você selecionar essa ação, o servidor do
DevTools é iniciado e uma instância do navegador é aberta
apontando para o app DevTools.

Quando aberto com uma ação do IntelliJ, o DevTools não está
conectado a um app Flutter. Você precisará fornecer uma porta
de protocolo de serviço para um app em execução. Você pode
fazer isso usando o diálogo inline **Connect to a running app**.
