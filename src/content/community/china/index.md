---
ia-translate: true
title: Usando Flutter na China
description: Como usar, acessar e aprender sobre Flutter na China.
toc: true
os-list: [Windows, macOS, Linux, ChromeOS]
---

{% assign flutter-sdk = 'flutter_opsys_v3.13.0-stable.' %}
{% capture sdk-path -%}flutter_infra_release/releases/stable/opsys/{{flutter-sdk}}{%- endcapture %}

{% render docs/china-notice-cn.md %}

Para acelerar o download e a instalação do Flutter na China,
considere usar um [site espelho][mirror site] ou _mirror_.

:::important
Use sites espelho _apenas_ se você _confia_ no provedor.
A equipe Flutter não pode verificar sua confiabilidade ou segurança.
:::

[mirror site]: https://en.wikipedia.org/wiki/Mirror_site

## Use um site espelho Flutter

O [China Flutter User Group][] (CFUG) mantém um site Flutter
em Chinês Simplificado [https://flutter.cn](https://flutter.cn) e um mirror.
Outros mirrors podem ser encontrados no [final deste guia](#known-trusted-community-run-mirror-sites).

### Configure sua máquina para usar um site espelho

Para instalar ou usar Flutter na China, use um mirror Flutter confiável.
Isso requer configurar duas variáveis de ambiente em sua máquina.

_Todos os exemplos a seguir presumem que você está usando o mirror CFUG._

Para configurar sua máquina para usar um site espelho:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/os-settings.md ref-os=os sdk=flutter-sdk %}

{% endtab %}
{% endfor -%}

{% endtabs %}

### Baixe arquivos Flutter baseados em um site espelho

Para baixar Flutter do [arquivo SDK][SDK archive] de um mirror,
substitua `storage.googleapis.com` pela URL do seu mirror confiável.
Use seu site espelho no navegador ou em outros aplicativos
como IDM ou Thunder.
Isso deve melhorar a velocidade de download.

[SDK archive]: /release/archive

O exemplo a seguir mostra como mudar a URL do site de download do Flutter
do arquivo do Google para o mirror CFUG.

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/download-urls.md ref-os=os filepath=sdk-path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

:::note
Nem todo mirror suporta download de artefatos usando sua URL direta.
:::

## Configure sua máquina para publicar seu package

Para publicar seus packages em `pub.dev`,
você precisa conseguir acessar tanto o Google Auth quanto o site `pub.dev`.

{% comment %}
From <https://github.com/flutter/website/pull/9338#discussion_r1328077020>
{% endcomment %}

Para habilitar acesso a `pub.dev`:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/pub-settings.md os=os filepath=path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

Para aprender mais sobre publicação de packages, confira a
[documentação Dart sobre publicação de packages][Dart documentation on publishing packages].

[Dart documentation on publishing packages]: {{site.dart-site}}/tools/pub/publishing

## Sites espelho conhecidos e confiáveis mantidos pela comunidade

A equipe Flutter não pode garantir disponibilidade de longo prazo de nenhum mirror.
Você pode usar outros mirrors se eles se tornarem disponíveis.

{% for mirror in mirrors %}

<hr>

### {{mirror.group}}

[{{mirror.group}}][] mantém o mirror `{{mirror.mirror}}`.
Ele inclui o Flutter SDK e packages pub.

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

Se você está enfrentando problemas que ocorrem apenas ao
usar o mirror `{{mirror.mirror}}`, reporte o problema no
[issue tracker]({{mirror.urls.issues}}) deles.

{% endfor %}

{% for mirror in mirrors %}
[{{mirror.group}}]: {{mirror.urls.group}}
{% endfor %}

## Ofereça-se para hospedar um novo site espelho

Se você está interessado em configurar seu próprio mirror,
entre em contato com [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com)
para obter assistência.

