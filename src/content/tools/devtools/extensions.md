---
ia-translate: true
title: Extensões DevTools
description: Aprenda como usar e construir extensões DevTools.
---

## O que são extensões DevTools?

[Extensões DevTools][DevTools extensions]
são ferramentas de desenvolvedor fornecidas por pacotes de terceiros que são
fortemente integradas ao conjunto de ferramentas DevTools.
Extensões são distribuídas como parte de um pacote pub,
e são carregadas dinamicamente no DevTools quando
um usuário está depurando seu app.

[DevTools extensions]: {{site.pub-pkg}}/devtools_extensions

## Usar uma extensão DevTools

Se seu app depende de um pacote que fornece uma
extensão DevTools, a extensão automaticamente
aparece em uma nova aba quando você abre DevTools.

### Configurar estados de habilitação de extensão

Você precisa habilitar manualmente a extensão antes que ela seja carregada
pela primeira vez. Certifique-se de que a extensão é fornecida por
uma fonte confiável antes de habilitá-la.

![Screenshot of extension enablement prompt](/assets/images/docs/tools/devtools/extension_enable_prompt.png)

Estados de habilitação de extensão são armazenados em um arquivo `devtools_options.yaml`
na raiz do projeto do usuário
(similar a `analysis_options.yaml`).
Este arquivo armazena configurações por projeto
(ou opcionalmente, por usuário) para DevTools.

Se este arquivo estiver **incluído no controle de versão**,
as opções especificadas são configuradas para o projeto.
Isso significa que qualquer pessoa que baixe o código-fonte
de um projeto e trabalhe nele usa as mesmas configurações.

Se este arquivo for **omitido do controle de versão**,
por exemplo, adicionando `devtools_options.yaml`
como uma entrada no arquivo `.gitignore`, então as
opções especificadas são configuradas separadamente para cada usuário.
Como cada usuário ou colaborador do projeto
usa uma cópia local do arquivo `devtools_options.yaml`
neste caso, as opções especificadas podem
diferir entre colaboradores do projeto.

## Construir uma extensão DevTools

Para um guia detalhado sobre como construir uma extensão DevTools,
confira [Extensões Dart e Flutter DevTools][article],
um artigo gratuito no Medium.

Para aprender mais sobre escrever e usar extensões DevTools,
confira o seguinte vídeo:

{% ytEmbed 'gOrSc4s4RWY', 'Building DevTools extensions | Flutter Build Show' %}

[article]: {{site.flutter-medium}}/dart-flutter-devtools-extensions-c8bc1aaf8e5f
