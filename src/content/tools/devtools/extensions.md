---
title: Extensões do DevTools
description: Aprenda a usar e criar extensões do DevTools.
ia-translate: true
---

## O que são extensões do DevTools?

[Extensões do DevTools][]
são ferramentas de desenvolvedor fornecidas
por pacotes de terceiros que são firmemente integradas ao conjunto de
ferramentas do DevTools. As extensões são distribuídas como parte de um
pacote pub, e são carregadas dinamicamente no DevTools quando um usuário
está depurando seu aplicativo.

[Extensões do DevTools]: {{site.pub-pkg}}/devtools_extensions

## Usar uma extensão do DevTools

Se o seu aplicativo depende de um pacote que fornece uma extensão do DevTools, a extensão aparece automaticamente em uma nova aba quando você abre o DevTools.

### Configurar estados de habilitação da extensão

Você precisa habilitar manualmente a extensão antes que ela seja carregada pela primeira vez. Certifique-se de que a extensão seja fornecida por uma fonte confiável antes de habilitá-la.

![Captura de tela do prompt de habilitação de extensão](/assets/images/docs/tools/devtools/extension_enable_prompt.png)

Os estados de habilitação da extensão são armazenados em um arquivo `devtools_options.yaml` na raiz do projeto do usuário (semelhante a `analysis_options.yaml`). Este arquivo armazena configurações por projeto (ou opcionalmente, por usuário) para o DevTools.

Se este arquivo for **incluído no controle de versão**, as opções especificadas serão configuradas para o projeto. Isso significa que qualquer pessoa que extrair o código-fonte de um projeto e trabalhar no projeto usará as mesmas configurações.

Se este arquivo for **omitido do controle de versão**, por exemplo, adicionando `devtools_options.yaml` como uma entrada no arquivo `.gitignore`, então as opções especificadas serão configuradas separadamente para cada usuário. Como cada usuário ou colaborador do projeto usa uma cópia local do arquivo `devtools_options.yaml` neste caso, as opções especificadas podem diferir entre os colaboradores do projeto.

### Construir uma extensão do DevTools

Para um guia detalhado sobre como construir uma extensão do DevTools, confira [Dart and Flutter DevTools extensions][article], um artigo gratuito no Medium.

Para saber mais sobre como escrever e usar extensões do DevTools, confira o vídeo a seguir:

{% ytEmbed 'gOrSc4s4RWY', 'Building DevTools extensions | Flutter Build Show' %}

[article]: {{site.flutter-medium}}/dart-flutter-devtools-extensions-c8bc1aaf8e5f
