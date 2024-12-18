---
ia-translate: true
title: Arquivo do SDK Flutter
short-title: Arquivo
description: "Todas as versões atuais do SDK Flutter: estável, beta e principal."
toc: false
---

O canal {{site.sdk.channel | capitalize }} contém as builds mais estáveis do Flutter.
Para saber mais, confira os [canais do Flutter][].

{% render docs/china-notice.md %}

Para saber as novidades das principais versões do Flutter, confira a página de
[notas de versão][].

:::note Nota sobre procedência
[procedência](https://slsa.dev/provenance)
descreve como os artefatos de software são construídos, incluindo
o que o download contém e quem o criou. Para visualizar a procedência em um formato mais
legível e onde nada é baixado, execute o seguinte comando usando o URL do
arquivo de procedência de uma versão (pode ser necessário baixar o
[jq](https://stedolan.github.io/jq/) para analisar facilmente o JSON).

```console
curl [URL da procedência] | jq -r .payload | base64 -d | jq
```
:::

{% tabs "os-archive-tabs" %}
{% tab "Windows" %}

{% include docs/release/archive-release_os.md os="Windows" %}

{% endtab %}
{% tab "macOS" %}

{% include docs/release/archive-release_os.md os="macOS" %}

{% endtab %}
{% tab "Linux" %}

{% include docs/release/archive-release_os.md os="Linux" %}

{% endtab %}
{% endtabs %}

<a id="master-channel" aria-hidden="true"></a>

## Canal Principal

Os pacotes de instalação não estão disponíveis para o canal `main`
(anteriormente conhecido como canal `master`).
No entanto, você pode obter o SDK diretamente do [repositório do GitHub][] clonando o canal principal e, em seguida,
acionando um download das dependências do SDK:

```console
$ git clone -b main https://github.com/flutter/flutter.git
$ ./flutter/bin/flutter --version
```

Para obter detalhes adicionais sobre como nossos pacotes de instalação são
estruturados, consulte [Pacotes de instalação][].

[canais do Flutter]: {{site.repo.flutter}}/blob/main/docs/releases/Flutter-build-release-channels.md
[notas de versão]: /release/release-notes
[repositório do GitHub]: {{site.repo.flutter}}
[Pacotes de instalação]: {{site.repo.flutter}}/blob/main/docs/infra/Flutter-Installation-Bundles.md
