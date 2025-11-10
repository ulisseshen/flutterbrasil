---
title: Usando Flutter na China
description: Como usar, acessar e aprender sobre Flutter na China.
ia-translate: true
---

{% render "docs/china-notice-cn.md" %}

Para acelerar o download e a instalação do Flutter na China,
considere usar um [mirror site][] ou _espelho_.

:::important
Use sites espelho _apenas_ se você _confiar_ no provedor.
A equipe do Flutter não pode verificar sua confiabilidade ou segurança.
:::

[mirror site]: https://en.wikipedia.org/wiki/Mirror_site

## Use um site espelho do Flutter

O [China Flutter User Group][] (CFUG) mantém um site do Flutter em chinês simplificado
[https://flutter.cn](https://flutter.cn) e um espelho.
Outros espelhos podem ser encontrados no [final deste guia](#known-trusted-community-run-mirror-sites).

### Configure sua máquina para usar um site espelho

Para instalar ou usar o Flutter na China, use um espelho confiável do Flutter.
Isso requer definir duas variáveis de ambiente em sua máquina.

_Todos os exemplos a seguir presumem que você está usando o espelho do CFUG._

Para configurar sua máquina para usar um site espelho:

<Tabs key="china-setup-os">

<Tab name="Windows">

Estas etapas requerem o uso do PowerShell.

 1. Abra uma nova janela no PowerShell para preparar para executar comandos do shell.

 1. Defina `PUB_HOSTED_URL` para o seu site espelho.

    ```ps
    $ $env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
    ```

 1. Defina `FLUTTER_STORAGE_BASE_URL` para o seu site espelho.

    ```ps
    $ $env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
    ```

 1. Baixe o arquivo do Flutter do seu site espelho preferido.

    Para o CFUG, visite o [Flutter SDK archive][],
    e baixe o SDK para sua plataforma e arquitetura.

 1. Crie uma pasta onde você possa instalar o Flutter. Em seguida, entre nela.
    Considere um caminho como `$env:USERPROFILE\dev`.

    ```ps
    $ New-Item -Path "$env:USERPROFILE\dev" -ItemType Directory; cd "$env:USERPROFILE\dev"
    ```
 1. Extraia o SDK do arquivo zip.

    Este exemplo assume que você baixou a versão Windows do Flutter SDK.
    Você precisará substituir o caminho para o arquivo pelo
    caminho do arquivo e versão que você baixou.

    ```ps
    $ Expand-Archive .\flutter_windows_3.35.5-stable.zip
    ```

 1. Adicione o Flutter à sua variável de ambiente `PATH`.

    ```ps
    $ $env:PATH = $pwd.PATH + "\flutter\bin",$env:PATH -join ";"
    ```

 1. Comece a desenvolver com Flutter.

    Após seguir essas etapas,
    o Flutter busca pacotes e artefatos de `flutter-io.cn`
    na janela do terminal atual.

    Para definir esses valores permanentemente entre terminais,
    siga as instruções para adicionar [Flutter to your PATH][windows-path],
    adicionando também as variáveis `PUB_HOSTED_URL` e `FLUTTER_STORAGE_BASE_URL`.

{:.steps}

[windows-path]: /install/add-to-path#windows

</Tab>

<Tab name="macOS">

 1. Abra uma nova janela no seu terminal para preparar para executar comandos do shell.

 1. Defina `PUB_HOSTED_URL` para o seu site espelho.

    ```console
    $ export PUB_HOSTED_URL="https://pub.flutter-io.cn"
    ```

 1. Defina `FLUTTER_STORAGE_BASE_URL` para o seu site espelho.

    ```console
    $ export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
    ```

 1. Baixe o arquivo do Flutter do seu site espelho preferido.

    Para o CFUG, visite o [Flutter SDK archive][],
    e baixe o SDK para sua plataforma e arquitetura.

 1. Crie uma pasta onde você possa instalar o Flutter. Em seguida, entre nela.
    Considere um caminho como `~/dev`.

    ```console
    $ mkdir ~/dev; cd ~/dev
    ```

 1. Extraia o SDK do arquivo zip.

    Este exemplo assume que você baixou a versão macOS do Flutter SDK.
    Você precisará substituir o caminho para o arquivo pelo
    caminho do arquivo e versão que você baixou.

    ```console
    $ unzip flutter_macos_3.35.5-stable.zip
    ```

 1. Adicione o Flutter à sua variável de ambiente `PATH`.

    ```console
    $ export PATH="$PWD/flutter/bin:$PATH"
    ```

 1. Comece a desenvolver com Flutter.

    Após seguir essas etapas,
    o Flutter busca pacotes e artefatos de `flutter-io.cn`
    na janela do terminal atual.

    Para definir esses valores permanentemente entre terminais,
    siga as instruções para adicionar [Flutter to your PATH][macos-path],
    adicionando também as variáveis `PUB_HOSTED_URL` e `FLUTTER_STORAGE_BASE_URL`.

{:.steps}

[macos-path]: /install/add-to-path#macos

</Tab>

<Tab name="Linux">

 1. Abra uma nova janela no seu terminal para preparar para executar comandos do shell.

 1. Defina `PUB_HOSTED_URL` para o seu site espelho.

    ```console
    $ export PUB_HOSTED_URL="https://pub.flutter-io.cn"
    ```

 1. Defina `FLUTTER_STORAGE_BASE_URL` para o seu site espelho.

    ```console
    $ export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
    ```

 1. Baixe o arquivo do Flutter do seu site espelho preferido.

    Para o CFUG, visite o [Flutter SDK archive][],
    e baixe o SDK para sua plataforma e arquitetura.

 1. Crie uma pasta onde você possa instalar o Flutter. Em seguida, entre nela.
    Considere um caminho como `~/dev`.

    ```console
    $ mkdir ~/dev; cd ~/dev
    ```

 1. Extraia o SDK do arquivo tar.

    Este exemplo assume que você baixou a versão Linux do Flutter SDK.
    Você precisará substituir o caminho para o arquivo pelo
    caminho do arquivo e versão que você baixou.

    ```console
    $ tar -xf flutter_linux_3.35.5-stable.tar.xz
    ```

 1. Adicione o Flutter à sua variável de ambiente `PATH`.

    ```console
    $ export PATH="$PWD/flutter/bin:$PATH"
    ```

 1. Comece a desenvolver com Flutter.

    Após seguir essas etapas,
    o Flutter busca pacotes e artefatos de `flutter-io.cn`
    na janela do terminal atual.

    Para definir esses valores permanentemente entre terminais,
    siga as instruções para adicionar [Flutter to your PATH][linux-path],
    adicionando também as variáveis `PUB_HOSTED_URL` e `FLUTTER_STORAGE_BASE_URL`.

{:.steps}

[linux-path]: /install/add-to-path#linux

</Tab>

</Tabs>

[Flutter SDK archive]: https://docs.flutter.cn/install/archive/

### Baixe arquivos do Flutter baseado em um site espelho

Para baixar o Flutter do [SDK archive][] de um espelho,
substitua `storage.googleapis.com` pela URL do seu espelho confiável.
Use seu site espelho no navegador ou em outros aplicativos
como IDM ou Thunder.
Isso deve melhorar a velocidade de download.

[SDK archive]: /install/archive

O exemplo a seguir mostra como alterar a URL do site de download do Flutter
do arquivo do Google para o espelho do CFUG.

<Tabs key="china-setup-os">

<Tab name="Windows">

Para baixar a versão x64, Windows do Flutter SDK,
você alteraria a URL original de:

```plaintext
[!https://storage.googleapis.com!]/flutter_infra_release/releases/stable/windows/flutter_windows_3.35.5-stable.zip
```

para a URL do espelho:

```plaintext
[!https://storage.flutter-io.cn!]/flutter_infra_release/releases/stable/windows/flutter_windows_3.35.5-stable.zip
```

</Tab>

<Tab name="macOS">

Para baixar a versão arm64, macOS do Flutter SDK,
você alteraria a URL original de:

```plaintext
[!https://storage.googleapis.com!]/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.35.5-stable.zip
```

para a URL do espelho:

```plaintext
[!https://storage.flutter-io.cn!]/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.35.5-stable.zip
```

</Tab>

<Tab name="Linux">

Para baixar a versão Linux do Flutter SDK,
você alteraria a URL original de:

```plaintext
[!https://storage.googleapis.com!]/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.5-stable.tar.xz
```

para a URL do espelho:

```plaintext
[!https://storage.flutter-io.cn!]/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.5-stable.tar.xz
```

</Tab>

</Tabs>

:::note
Nem todo espelho suporta o download de artefatos usando sua URL direta.
:::

## Configure sua máquina para publicar seu pacote

Para publicar seus pacotes no `pub.dev`,
você precisa ser capaz de acessar tanto o Google Auth quanto o site `pub.dev`.

{% comment %}
From <https://github.com/flutter/website/pull/9338#discussion_r1328077020>
{% endcomment %}

Para habilitar o acesso ao `pub.dev`:

<Tabs key="china-setup-os">

<Tab name="Windows">

 1. Configure um proxy.
    Para configurar um proxy, confira a
    [Dart documentation on proxies][].

 1. Verifique se sua variável de ambiente `PUB_HOSTED_URL` está não definida
    ou vazia.

    ```ps
    $ echo $env:PUB_HOSTED_URL
    ```

    Se este comando retornar algum valor, remova-o.

    ```ps
    $ Remove-Item $env:PUB_HOSTED_URL
    ```

</Tab>
<Tab name="macOS">

 1. Configure um proxy.
    Para configurar um proxy, confira a
    [Dart documentation on proxies][].

 1. Verifique se sua variável de ambiente `PUB_HOSTED_URL` está
    não definida ou vazia.

    ```console
    $ echo $PUB_HOSTED_URL
    ```

    Se este comando retornar algum valor, remova-o.

    ```console
    $ unset $PUB_HOSTED_URL
    ```

</Tab>
<Tab name="Linux">

 1. Configure um proxy.
    Para configurar um proxy, confira a
    [Dart documentation on proxies][].

 1. Verifique se sua variável de ambiente `PUB_HOSTED_URL` está
    não definida ou vazia.

    ```console
    $ echo $PUB_HOSTED_URL
    ```

    Se este comando retornar algum valor, remova-o.

    ```console
    $ unset $PUB_HOSTED_URL
    ```

</Tab>

</Tabs>

Para saber mais sobre publicação de pacotes, confira a
[Dart documentation on publishing packages][].

[Dart documentation on proxies]: {{site.dart-site}}/tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall
[Dart documentation on publishing packages]: {{site.dart-site}}/tools/pub/publishing

## Sites espelho conhecidos e confiáveis executados pela comunidade {:#known-trusted-community-run-mirror-sites}

A equipe do Flutter não pode garantir a disponibilidade a longo prazo de nenhum espelho.
Você pode usar outros espelhos se eles ficarem disponíveis.

{% for mirror in mirrors %}

<hr>

### {{mirror.group}}

[{{mirror.group}}][] mantém o espelho `{{mirror.mirror}}`.
Inclui o Flutter SDK e pacotes pub.

#### Configure sua máquina para usar este espelho

Para configurar sua máquina para usar este espelho, use estes comandos.

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

#### Obtenha suporte para este espelho

Se você está tendo problemas que ocorrem apenas ao
usar o espelho `{{mirror.mirror}}`, relate o problema no
[issue tracker]({{mirror.urls.issues}}) deles.

{% endfor %}

{% for mirror in mirrors %}
[{{mirror.group}}]: {{mirror.urls.group}}
{% endfor %}

## Ofereça-se para hospedar um novo site espelho

Se você está interessado em configurar seu próprio espelho,
entre em contato com [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com)
para obter assistência.
