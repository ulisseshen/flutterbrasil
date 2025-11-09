---
ia-translate: true
title: Extensões DevTools
description: Aprenda como usar e construir extensões DevTools.
---

## O que são extensões DevTools?

[Extensões DevTools][DevTools extensions]
são ferramentas de desenvolvedor fornecidas por packages de terceiros que são
fortemente integradas ao conjunto de ferramentas DevTools.
As extensões são distribuídas como parte de um package pub,
e elas são carregadas dinamicamente no DevTools quando
um usuário está depurando seu app.

[DevTools extensions]: {{site.pub-pkg}}/devtools_extensions

## Use uma extensão DevTools

Se seu app depende de um package que fornece uma
extensão DevTools, a extensão aparece automaticamente
em uma nova aba quando você abre DevTools.

### Configure estados de habilitação de extensões

Você precisa habilitar manualmente a extensão antes dela carregar
pela primeira vez. Certifique-se de que a extensão é fornecida por
uma fonte confiável antes de habilitá-la.

Quando você abre a extensão pela primeira vez, verá um prompt para habilitar
a extensão:

![Screenshot of extension enablement prompt](/assets/images/docs/tools/devtools/extension_enable_prompt.png)

Você pode modificar a configuração a qualquer momento no diálogo DevTools Extensions:

![Screenshot of DevTools Extensions dialog button](/assets/images/docs/tools/devtools/extension_dialog_button.png)

![Screenshot of extension enablement dialog](/assets/images/docs/tools/devtools/extension_dialog.png)

> Nota: se a extensão requer uma conexão em execução para uma
aplicação em execução, você não verá o prompt de habilitação ou configurações de habilitação até que
DevTools esteja conectado a um app em execução.

Os estados de habilitação de extensões são armazenados em um arquivo `devtools_options.yaml`
na raiz do projeto do usuário
(similar a `analysis_options.yaml`).

```yaml
description: This file stores settings for Dart & Flutter DevTools.
documentation: https://docs.flutterbrasil.dev/tools/devtools/extensions#configure-extension-enablement-states
extensions:
  - provider: true
  - shared_preferences: true
  - foo: false
```

Este arquivo armazena configurações por projeto
(ou opcionalmente, por usuário) para DevTools.

Se este arquivo for **incluído no controle de versão**,
as opções especificadas são configuradas para o projeto.
Isso significa que qualquer um que obtenha o
código-fonte de um projeto e trabalhe no projeto usa as mesmas configurações.

Se este arquivo for **omitido do controle de versão**,
por exemplo adicionando `devtools_options.yaml`
como uma entrada no arquivo `.gitignore`, então as
opções especificadas são configuradas separadamente para cada usuário.
Uma vez que cada usuário ou colaborador do projeto
usa uma cópia local do arquivo `devtools_options.yaml`
neste caso, as opções especificadas podem
diferir entre os colaboradores do projeto.

## Construa uma extensão DevTools

Para um guia detalhado sobre como construir uma extensão DevTools,
confira [Dart and Flutter DevTools extensions][article],
um artigo gratuito no Medium.

Para aprender mais sobre escrever e usar extensões DevTools,
confira o seguinte vídeo:

<YouTubeEmbed id="gOrSc4s4RWY" title="Building DevTools extensions | Flutter Build Show"></YouTubeEmbed>

[article]: {{site.flutter-blog}}/dart-flutter-devtools-extensions-c8bc1aaf8e5f
