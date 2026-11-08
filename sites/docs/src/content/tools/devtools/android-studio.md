---
ia-translate: true
title: Execute DevTools do Android Studio
description: Aprenda como iniciar e usar DevTools do Android Studio.
---

## Instale o plugin Flutter

Adicione o plugin Flutter se você ainda não o tiver instalado.
Isso pode ser feito usando a página normal de **Plugins** nas
configurações do IntelliJ e Android Studio. Uma vez que essa página esteja aberta,
você pode pesquisar no marketplace pelo plugin Flutter.

## Inicie um app para depurar {: #run-and-debug}

Para abrir DevTools, você primeiro precisa executar um app Flutter.
Isso pode ser realizado abrindo um projeto Flutter,
garantindo que você tenha um dispositivo conectado,
e clicando nos botões da barra de ferramentas **Run** ou **Debug**.

## Inicie DevTools da barra de ferramentas/menu

Uma vez que um app esteja em execução,
você pode iniciar DevTools usando uma das seguintes técnicas:

* Selecione a ação da barra de ferramentas **Open DevTools** na view Run.
* Selecione a ação da barra de ferramentas **Open DevTools** na view Debug.
  (se estiver depurando)
* Selecione a ação **Open DevTools** do menu **More Actions**
  na view Flutter Inspector.

![screenshot of Open DevTools button](/assets/images/docs/tools/devtools/android_studio_open_devtools.png){:width="100%"}

## Inicie DevTools de uma ação

Você também pode abrir DevTools de uma ação do IntelliJ.
Abra o diálogo **Find Action...**
(no macOS, pressione <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>),
e pesquise pela ação **Open DevTools**.
Quando você selecionar essa ação, o servidor DevTools
inicia e uma instância do navegador abre apontando para o app DevTools.

Quando aberto com uma ação do IntelliJ, DevTools não está conectado
a um app Flutter. Você precisará fornecer uma porta de protocolo de serviço
para um app atualmente em execução. Você pode fazer isso usando o
diálogo inline **Connect to a running app**.
