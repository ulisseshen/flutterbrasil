---
ia-translate: true
title: Usando Flutter na China
description: Como usar, acessar e aprender sobre o Flutter na China.
toc: true
os-list: [Windows, macOS, Linux, ChromeOS]
---

{% assign flutter-sdk = 'flutter_opsys_v3.13.0-stable.' %}
{% capture sdk-path -%}flutter_infra_release/releases/stable/opsys/{{flutter-sdk}}{%- endcapture %}

{% render docs/china-notice-cn.md %}

Para acelerar o download e a instalação do Flutter na China,
considere usar um [site espelho][] ou _mirror_.

:::important
Use sites espelho _somente_ se você _confiar_ no provedor.
A equipe do Flutter não pode verificar sua confiabilidade ou segurança.
:::

[site espelho]: https://en.wikipedia.org/wiki/Mirror_site

## Use um site espelho do Flutter

O [Grupo de Usuários Flutter da China][] (CFUG) mantém um site
Flutter em chinês simplificado [https://flutter.cn](https://flutter.cn) e um mirror.
Outros mirrors podem ser encontrados no [final deste guia](#known-trusted-community-run-mirror-sites).

### Configure sua máquina para usar um site espelho

Para instalar ou usar o Flutter na China, use um mirror Flutter confiável.
Isso requer a definição de duas variáveis de ambiente em sua máquina.

_Todos os exemplos a seguir pressupõem que você está usando o mirror do CFUG._

Para configurar sua máquina para usar um site espelho:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/os-settings.md ref-os=os sdk=flutter-sdk %}

{% endtab %}
{% endfor -%}

{% endtabs %}

### Baixe arquivos do Flutter com base em um site espelho

Para baixar o Flutter do [arquivo SDK][] de um mirror,
substitua `storage.googleapis.com` pelo URL do seu mirror confiável.
Use seu site espelho no navegador ou em outros aplicativos
como IDM ou Thunder.
Isso deve melhorar a velocidade de download.

[arquivo SDK]: /release/archive

O exemplo a seguir mostra como alterar o URL do site de download do Flutter
do arquivo do Google para o mirror do CFUG.

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/download-urls.md ref-os=os filepath=sdk-path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

:::note
Nem todos os mirrors suportam o download de artefatos usando seu URL direto.
:::

## Configure sua máquina para publicar seu pacote

Para publicar seus pacotes no `pub.dev`,
você precisa ser capaz de acessar tanto o Google Auth quanto o site `pub.dev`.

{% comment %}
From <https://github.com/flutter/website/pull/9338#discussion_r1328077020>
{% endcomment %}

Para habilitar o acesso ao `pub.dev`:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/pub-settings.md os=os filepath=path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

Para saber mais sobre a publicação de pacotes, consulte a
[documentação Dart sobre publicação de pacotes][].

[documentação Dart sobre publicação de pacotes]: {{site.dart-site}}/tools/pub/publishing

## Sites espelho conhecidos e confiáveis mantidos pela comunidade

A equipe do Flutter não pode garantir a disponibilidade de longo prazo de nenhum mirror.
Você pode usar outros mirrors se eles se tornarem disponíveis.

{% for mirror in mirrors %}

<hr>

### {{mirror.group}}

[{{mirror.group}}][] mantém o mirror `{{mirror.mirror}}`.
Ele inclui o Flutter SDK e pacotes pub.

#### Configure sua máquina para usar este mirror

Para configurar sua máquina para usar este mirror, use estes comandos.

No macOS, Linux ou ChromeOS:

```console
export PUB_HOSTED_URL={{mirror.urls.pubhosted}};
export FLUTTER_STORAGE_BASE_URL={{mirror.urls.flutterstorage}}
```

No Windows:

```console
$env:PUB_HOSTED_URL="{{mirror.urls.pubhosted}}";
$env:FLUTTER_STORAGE_BASE_URL="{{mirror.urls.flutterstorage}}"
```

#### Obtenha suporte para este mirror

Se você estiver enfrentando problemas que ocorrem apenas quando
usando o mirror `{{mirror.mirror}}`, relate o problema ao
[rastreador de problemas]({{mirror.urls.issues}}).

{% endfor %}

{% for mirror in mirrors %}
[{{mirror.group}}]: {{mirror.urls.group}}
{% endfor %}

## Ofereça-se para hospedar um novo site espelho

Se você estiver interessado em configurar seu próprio mirror,
entre em contato com [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com)
para obter assistência.
