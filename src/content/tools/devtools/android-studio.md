---
ia-translate: true
title: Executar DevTools do Android Studio
description: Aprenda como executar e usar DevTools do Android Studio.
---

## Instalar o plugin Flutter

Adicione o plugin Flutter se você ainda não o tiver instalado.
Isso pode ser feito usando a página **Plugins** normal nas
configurações do IntelliJ e Android Studio. Quando essa página estiver aberta,
você pode pesquisar no marketplace pelo plugin Flutter.

## Iniciar um app para depurar

Para abrir DevTools, você primeiro precisa executar um app Flutter.
Isso pode ser feito abrindo um projeto Flutter,
garantindo que você tenha um dispositivo conectado
e clicando nos botões **Run** ou **Debug** da barra de ferramentas.

## Executar DevTools pela barra de ferramentas/menu

Quando um app estiver em execução,
você pode iniciar DevTools usando uma das seguintes técnicas:

* Selecione a ação de barra de ferramentas **Open DevTools** na visualização Run.
* Selecione a ação de barra de ferramentas **Open DevTools** na visualização Debug.
  (se estiver depurando)
* Selecione a ação **Open DevTools** do menu **More Actions**
  na visualização Flutter Inspector.

![screenshot of Open DevTools button](/assets/images/docs/tools/devtools/android_studio_open_devtools.png){:width="100%"}

## Executar DevTools de uma ação

Você também pode abrir DevTools de uma ação do IntelliJ.
Abra o diálogo **Find Action...**
(no macOS, pressione <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>)
e pesquise pela ação **Open DevTools**.
Quando você selecionar essa ação, o servidor DevTools
inicia e uma instância do navegador abre apontando para o app DevTools.

Quando aberto com uma ação do IntelliJ, DevTools não está conectado
a um app Flutter. Você precisará fornecer uma porta de protocolo de serviço
para um app atualmente em execução. Você pode fazer isso usando o
diálogo inline **Connect to a running app**.
