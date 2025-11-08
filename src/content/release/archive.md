---
ia-translate: true
title: Arquivo do Flutter SDK
short-title: Arquivo
description: "Todas as versões atuais do Flutter SDK: stable, beta e main."
toc: false
---

O canal {{site.sdk.channel | capitalize }} contém as
compilações mais estáveis do Flutter.
Para saber mais, confira [Flutter's channels][].

{% render docs/china-notice.md %}

Para saber quais são as novidades nas principais versões do Flutter,
confira a página de [release notes][].


:::note Nota sobre proveniência
[provenance](https://slsa.dev/provenance)
descreve como os artefatos de software são construídos, incluindo
o que o download contém e quem o criou.
Para visualizar a proveniência em um formato mais legível
e onde nada é baixado, execute o seguinte
comando usando a URL do arquivo de proveniência de uma versão (você pode precisar
baixar [jq](https://stedolan.github.io/jq/) para analisar facilmente o JSON).

```console
curl [provenance URL] | jq -r .payload | base64 -d | jq
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

## Canal Main

Os pacotes de instalação não estão disponíveis para o canal `main`
(que anteriormente era conhecido como canal `master`).
No entanto, você pode obter o SDK diretamente do
[GitHub repo][] clonando o canal main
e então acionando um download das dependências do SDK:

```console
$ git clone -b main https://github.com/flutter/flutter.git
$ ./flutter/bin/flutter --version
```

Para detalhes adicionais sobre como nossos pacotes de instalação são estruturados,
consulte [Installation bundles][].

[Flutter's channels]: {{site.repo.flutter}}/blob/main/docs/releases/Flutter-build-release-channels.md
[release notes]: /release/release-notes
[GitHub repo]: {{site.repo.flutter}}
[Installation bundles]: {{site.repo.flutter}}/blob/main/docs/infra/Flutter-Installation-Bundles.md
